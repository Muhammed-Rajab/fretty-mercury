local fmtcolor = require("fmtcolor")
local intervals = require("fretboard.intervals")

-- TODO: render the interval hints for easier understanding
local function render_interval_hints()
	for _, interval in ipairs(intervals) do
		io.write(fmtcolor.roles[interval](interval) .. " ")
	end
	io.write("\n")
end

local function render_open_note(open_note, fb)
	local open_note_text = open_note.label or open_note.name

	-- TODO: Render open note
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

	-- display = #note_text == 3 and display or display .. " "

	return string.format(" %-5s", display .. " | ")
end

return function(Fretboard)
	function Fretboard:render()
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
	end
end
