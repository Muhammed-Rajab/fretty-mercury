local fmt = require("fretboard.utils.fmt")
local Color = require("fretboard.utils.color")
local fmtcolor = require("fretboard.utils.fmtcolor")
local intervals = require("fretboard.intervals")

---@param title string
---@return string
local function render_title(title)
	local styled = Color.colorize({ style = { "bold" } })
	local title_styled = Color.colorize({ style = { "italic" } })
	local line_length = math.max(3, math.floor(#title / 2))
	local line = string.rep("─", line_length)
	-- return styled("◉───[ " .. title .. " ]───◉")
	return styled("◉" .. line .. "[ " .. title_styled(title) .. " ]" .. line .. "◉")
end

---@param fb Fretboard
---@param fret_width integer
local function render_fret_numbers(fb, fret_width)
	local offset_x = 4

	local display = string.rep(" ", offset_x)

	for fret_index = 1, fb.fret_count do
		local text = fmt.center(fret_index .. "", fret_width + 1, " ")
		text = Color.colorize({ fg = { 100, 100, 100 } })(text)
		display = display .. text
	end

	return display
end

---@param fb Fretboard
---@param fret_width integer
---@return string
local function render_fret_markers(fb, fret_width)
	local offset_x = 4

	local marked_frets = {
		[3] = true,
		[5] = true,
		[7] = true,
		[9] = true,
		[12] = true,
		[15] = true,
		[17] = true,
		[19] = true,
		[21] = true,
		[24] = true,
	}

	local display = string.rep(" ", offset_x)
	local calculated_width = fret_width + 3 -- 1 for the fret bar and 2 for unicode

	for fret_index = 1, fb.fret_count do
		if marked_frets[fret_index] then
			local text = fmt.center("●", calculated_width, " ")
			display = display .. text
		else
			display = display .. string.rep(" ", fret_width + 1)
		end
	end

	return display
end

---@return string
local function render_interval_hints()
	local display = Color.colorize({ style = { "bold", "underline" } })("Hints") .. ": "
	for _, interval in ipairs(intervals) do
		display = display .. fmtcolor.roles[interval](interval) .. " "
	end

	return display .. fmtcolor.enabled_note("enabled") .. "\n"
end

---@param fb Fretboard
---@return string
local function render_highlighted_notes(fb)
	local set = {}
	for _, str in ipairs(fb.frets) do
		for fret_index = 0, fb.fret_count do
			local fret = str[fret_index]
			if fret.enabled then
				local role_func = fmtcolor.roles[fret.role]
				set[fret.name] = role_func and role_func(fret.name) or fret.name
			end
		end
	end

	local highlights = {}
	for _, display_note in pairs(set) do
		table.insert(highlights, display_note)
	end

	return Color.colorize({ style = { "bold", "underline" } })("Highlighted Notes")
		.. ": "
		.. table.concat(highlights, ", ")
		.. "\n"
end

---@param open_note Fret
---@param fb Fretboard
---@param str_no integer
---@return string
local function render_open_note(open_note, fb, str_no)
	local open_note_text = open_note.label or (str_no == 1 and string.lower(open_note.name) or open_note.name)

	local open_note_display
	if open_note.enabled then
		if open_note.role and fmtcolor.roles[open_note.role] then
			open_note_display = fmtcolor.roles[open_note.role](open_note_text)
		else
			open_note_display = fmtcolor.enabled_note(open_note_text)
		end
	else
		-- if fb.hide_disabled then
		-- 	open_note_display = string.rep(" ", #open_note_text)
		-- else
		-- 	open_note_display = fmtcolor.disabled_note(open_note_text)
		-- end
		open_note_display = fmtcolor.disabled_note(open_note_text)
	end

	return string.format(" " .. fmt.pad_ansi_left(open_note_display, 2) .. "║")
end

---@param note Fret
---@param fb Fretboard
---@param str_no integer
---@param fret_no integer
---@param fret_width integer
---@return string
local function render_note(note, fb, str_no, fret_no, fret_width)
	local display
	local note_text = note.label or note.name
	note_text = fmt.center(note_text, fret_width, "─")

	if note.enabled then
		if note.role and fmtcolor.roles[note.role] then
			display = fmtcolor.roles[note.role](note_text)
		else
			display = fmtcolor.enabled_note(note_text)
		end
	else
		if fb.hide_disabled then
			display = string.rep("─", fret_width)
		else
			display = fmtcolor.disabled_note(note_text)
		end
	end

	return "" .. display .. "┃"
end

---@class TTYRendererOpts
---@field title string|nil
---@field highlighted_notes boolean?
---@field fret_numbers boolean?
---@field fret_markers boolean?
---@field interval_hints boolean?
---@field fret_width integer?

---@class TTYRenderer
local TTYRenderer = {}
TTYRenderer.__index = TTYRenderer

---@return TTYRenderer
function TTYRenderer.new()
	return setmetatable({}, TTYRenderer)
end

---@param fb Fretboard
---@param opts TTYRendererOpts?
---@return string
function TTYRenderer:render(fb, opts)
	opts = opts or {}
	opts = {
		title = opts.title,
		highlighted_notes = opts.highlighted_notes ~= false,
		fret_numbers = opts.fret_numbers ~= false,
		fret_markers = opts.fret_markers ~= false,
		interval_hints = opts.interval_hints ~= false,
		fret_width = opts.fret_width or 7,
	}

	-- buffer to write to instead of terminal
	local buffer = {}

	-- title
	if opts.title then
		table.insert(buffer, "\n")
		table.insert(buffer, render_title(opts.title))
		table.insert(buffer, "\n")
	end

	table.insert(buffer, "\n")

	-- highlighted notes
	if opts.highlighted_notes then
		table.insert(buffer, render_highlighted_notes(fb))
		table.insert(buffer, "\n")
	end

	-- fret numbers
	if opts.fret_numbers then
		table.insert(buffer, render_fret_numbers(fb, opts.fret_width))
		table.insert(buffer, "\n\n")
	end

	-- notes
	for str_no, str in ipairs(fb.frets) do
		local open_note = str[0]
		local open_note_display = render_open_note(open_note, fb, str_no)

		table.insert(buffer, open_note_display)

		for fret_index = 1, fb.fret_count do
			local note = str[fret_index]
			local display = render_note(note, fb, str_no, fret_index, opts.fret_width)
			table.insert(buffer, display)
		end

		table.insert(buffer, "\n")
	end

	-- fret markers
	if opts.fret_markers then
		table.insert(buffer, "\n")
		table.insert(buffer, render_fret_markers(fb, opts.fret_width))
	end

	-- interval hints
	if opts.interval_hints then
		table.insert(buffer, "\n\n")
		table.insert(buffer, render_interval_hints())
	end

	return table.concat(buffer)
end

return TTYRenderer
