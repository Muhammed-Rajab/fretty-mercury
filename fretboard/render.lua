local fmtcolor = require("fmtcolor")
local Color = require("color")
local intervals = require("fretboard.intervals")

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

local function render_open_note(open_note, fb)
	local open_note_text = open_note.label or open_note.name

	local open_note_display
	if open_note.enabled then
		if open_note.role and fmtcolor.roles[open_note.role] then
			open_note_display = fmtcolor.roles[open_note.role](open_note_text)
		else
			open_note_display = fmtcolor.enabled_note(open_note_text)
		end
	else
		if fb.hide_disabled then
			open_note_display = string.rep(" ", #open_note_text)
		else
			open_note_display = fmtcolor.disabled_note(open_note_text)
		end
	end

	return string.format(" %-5s ", open_note_display .. "| ")
end

local function render_note(note, fb)
	local display
	local note_text = note.label or note.name

	if note.enabled then
		if note.role and fmtcolor.roles[note.role] then
			display = fmtcolor.roles[note.role](note_text)
		else
			display = fmtcolor.enabled_note(note_text)
		end
	else
		if fb.hide_disabled then
			display = string.rep("-", #note_text)
		else
			display = fmtcolor.disabled_note(note_text)
		end
	end

	return string.format(" %-5s", display .. " | ")
end

return function(Fretboard)
	function Fretboard:render()
		io.write(render_highlighted_notes(self))
		io.write("\n")

		for _, str in ipairs(self.notes) do
			local open_note = str[0]
			local open_note_display = render_open_note(open_note, self)

			io.write(open_note_display)

			for fret = 1, self.frets do
				local note = str[fret]
				local display = render_note(note, self)

				io.write(display)
			end

			io.write("\n")
		end

		io.write("\n")
		io.write(render_interval_hints())
	end
end
