local fmt = require("fmt")
local Note = require("note")
local tunings = require("tunings")

local Fretboard = {}

function Fretboard:new(tuning, frets)
	local obj = {
		tuning = tuning or tunings.standard,
		frets = frets or 12,
		notes = {},
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
		print(fmt.error(string.format("warning: must be 1 <= string index <= 6 (got %s)", string_index)))
		return
	end

	if fret < 0 or fret > self.frets then
		print(fmt.error(string.format("warning: must be 0 <= fret <= %d (got %d)", self.frets, fret)))
		return
	end

	self.notes[string_index][fret].enabled = not self.notes[string_index][fret].enabled
end

function Fretboard:enable(string_index, fret, role)
	if string_index < 1 or string_index > 6 then
		print(fmt.error(string.format("warning: must be 1 <= string index <= 6 (got %s)", string_index)))
		return
	end

	if fret < 0 or fret > self.frets then
		print(fmt.error(string.format("warning: must be 0 <= fret <= %d (got %d)", self.frets, fret)))
		return
	end

	self.notes[string_index][fret].enabled = true
	self.notes[string_index][fret].role = role
end

function Fretboard:disable(string_index, fret)
	if string_index < 1 or string_index > 6 then
		print(fmt.error(string.format("warning: must be 1 <= string index <= 6 (got %s)", string_index)))
		return
	end

	if fret < 0 or fret > self.frets then
		print(fmt.error(string.format("warning: must be 0 <= fret <= %d (got %d)", self.frets, fret)))
		return
	end

	self.notes[string_index][fret].enabled = false
	self.notes[string_index][fret].role = nil
end

function Fretboard:highlight_notes(notes)
	-- every string
	for string_index, str in ipairs(self.notes) do
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

function Fretboard:render()
	for string_index, str in ipairs(self.notes) do
		local open_note = str[0]

		-- TODO: Render open note
		local open_note_display
		if open_note.enabled then
			if open_note.role and fmt.roles[open_note.role] then
				open_note_display = fmt.roles[open_note.role](open_note.label or open_note.name)
			else
				open_note_display = fmt.enabled_note(open_note.label or open_note.name)
			end
		else
			open_note_display = fmt.disabled_note(open_note.label or open_note.name)
		end

		io.write(string.format(" %-5s ", open_note_display .. " | "))

		for fret = 1, self.frets do
			local note = str[fret]

			-- TODO: Render note
			local display
			if note.enabled then
				if note.role and fmt.roles[note.role] then
					display = fmt.roles[note.role](note.label or note.name)
				else
					display = fmt.enabled_note(note.label or note.name)
				end
			else
				display = fmt.disabled_note(note.label or note.name)
			end

			display = #(note.label or note.name) == 3 and display or display .. " "
			io.write(string.format(" %-5s", display .. " | "))
		end

		io.write("\n")
	end
end

return Fretboard
