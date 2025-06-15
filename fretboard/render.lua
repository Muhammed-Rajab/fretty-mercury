local fmt = require("fmt")
local Color = require("color")
local fmtcolor = require("fmtcolor")
local intervals = require("fretboard.intervals")

local function render_fret_numbers(fb, fret_width)
	local frets = fb.frets

	local offset_x = 3

	local display = string.rep(" ", offset_x)

	for fret = 1, frets do
		local text = fmt.center(fret .. "", fret_width + 1, " ")
		display = display .. text
	end

	return display
end

local function render_fret_markers(fb, fret_width)
	local frets = fb.frets

	local offset_x = 2

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
	local calculated_width = fret_width + 3

	for fret = 1, frets do
		if marked_frets[fret] then
			local text = fmt.center("✦", calculated_width, " ")
			display = display .. text
		else
			display = display .. string.rep(" ", fret_width)
		end
	end

	return display
end

local function render_interval_hints()
	for _, interval in ipairs(intervals) do
		io.write(fmtcolor.roles[interval](interval) .. " ")
	end
	io.write("\n")
end

local function render_highlighted_notes(fb)
	local set = {}
	for _, str in ipairs(fb.notes) do
		for fret = 0, fb.frets do
			local note = str[fret]
			if note.enabled then
				local role_func = fmtcolor.roles[note.role]
				set[note.name] = role_func and role_func(note.name) or note.name
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

	return string.format("" .. fmt.pad_ansi_left(open_note_display, 2) .. "║")
end

local function render_note(note, fb, str_no, fret_no, fret_width)
	local display
	local note_text = note.label or note.name
	-- local width = math.floor(math.max(8, ((fb.frets - fret_no) / fb.frets) * 16))
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

return function(Fretboard)
	function Fretboard:render()
		local fret_width = 7

		io.write(render_highlighted_notes(self))
		io.write("\n")
		io.write(render_fret_numbers(self, fret_width))
		io.write("\n")
		io.write("\n")

		for str_no, str in ipairs(self.notes) do
			local open_note = str[0]
			local open_note_display = render_open_note(open_note, self, str_no)

			io.write(open_note_display)

			for fret = 1, self.frets do
				local note = str[fret]
				local display = render_note(note, self, str_no, fret, fret_width)

				io.write(display)
			end

			io.write("\n")
		end

		io.write("\n")
		io.write(render_fret_markers(self, fret_width))

		io.write("\n")
		io.write("\n")
		io.write(render_interval_hints())
	end
end
