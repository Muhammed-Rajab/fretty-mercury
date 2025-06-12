local fmtcolor = require("fmtcolor")
local Note = require("note")
local tunings = require("tunings")

local Fretboard = {}
local intervals = {
	"root",
	"m2",
	"M2",
	"m3",
	"M3",
	"4",
	"#4",
	"b5",
	"5",
	"#5",
	"b6",
	"6",
	"b7",
	"7",
	"9",
	"b9",
	"#9",
	"11",
	"#11",
	"13",
	"add9",
	"sus2",
	"sus4",
	"no3",
	"no5",
}

function Fretboard:new(tuning, frets)
	local obj = {
		tuning = tuning or tunings.standard,
		frets = frets or 12,
		notes = {},
		hide_disabled = false,
	}

	-- Generate State for every Note
	-- NOTE: here obj.property is used because self is not set yet!
	for string_index, start_note in ipairs(obj.tuning) do
		local start_index = Note.index_of(start_note)
		obj.notes[string_index] = {}
		for fret = 0, obj.frets do
			local note_name = Note.name_at(start_index + fret, false)
			obj.notes[string_index][fret] = {
				name = note_name,
				enabled = false,
				role = nil,
				label = nil,
			}
		end
	end

	-- Setup OOP
	self.__index = self
	setmetatable(obj, self)
	return obj
end

function Fretboard:toggle(string_index, fret)
	if string_index < 1 or string_index > 6 then
		print(fmtcolor.error(string.format("warning: must be 1 <= string index <= 6 (got %s)", string_index)))
		return
	end

	if fret < 0 or fret > self.frets then
		print(fmtcolor.error(string.format("warning: must be 0 <= fret <= %d (got %d)", self.frets, fret)))
		return
	end

	self.notes[string_index][fret].enabled = not self.notes[string_index][fret].enabled
end

function Fretboard:enable(string_index, fret, role, label)
	if string_index < 1 or string_index > 6 then
		print(fmtcolor.error(string.format("warning: must be 1 <= string index <= 6 (got %s)", string_index)))
		return
	end

	if fret < 0 or fret > self.frets then
		print(fmtcolor.error(string.format("warning: must be 0 <= fret <= %d (got %d)", self.frets, fret)))
		return
	end

	self.notes[string_index][fret].enabled = true
	self.notes[string_index][fret].role = role
	self.notes[string_index][fret].label = label
end

function Fretboard:disable(string_index, fret)
	if string_index < 1 or string_index > 6 then
		print(fmtcolor.error(string.format("warning: must be 1 <= string index <= 6 (got %s)", string_index)))
		return
	end

	if fret < 0 or fret > self.frets then
		print(fmtcolor.error(string.format("warning: must be 0 <= fret <= %d (got %d)", self.frets, fret)))
		return
	end

	self.notes[string_index][fret].enabled = false
	self.notes[string_index][fret].role = nil
	self.notes[string_index][fret].label = nil
end

function Fretboard:highlight_notes(notes)
	-- every string
	for _, str in ipairs(self.notes) do
		-- every fret
		for fret = 0, self.frets do
			local note = str[fret] -- NOTE: it can also be an OPEN note
			-- every chord note
			for _, n_note in ipairs(notes) do
				if n_note.name == note.name then
					note.enabled = true
					note.role = n_note.role
					note.label = n_note.label
					break
				end
			end
		end
	end
end

function Fretboard:clear()
	for _, string_notes in ipairs(self.notes) do
		for fret = 0, self.frets do
			string_notes[fret].enabled = false
			string_notes[fret].role = nil
			string_notes[fret].label = nil
		end
	end
end

-- TODO: render the fret numbers for easy navigation
local function render_fret_numbers(fb) end

-- TODO: render the fret markings for easier navigation
local function render_fret_marking(fb) end

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

render_interval_hints()

return Fretboard
