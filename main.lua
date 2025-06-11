-- HERE WE GO AGAIN! I HAVE NO FREAKING IDEA WHAT I'M DOING HERE, BUT HERE WE ARE ON A WEDNESDAY,
-- LEARNING LUA :)

-- Note Related
local Note = {}
Note.sharp = { "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B" }
Note.flat = { "C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B" }

function Note.index_of(name, use_flats)
	local chromatic_scale = use_flats and Note.flat or Note.sharp
	for i, n in ipairs(chromatic_scale) do
		if n == name then
			return i
		end
	end
end

function Note.name_at(index, use_flats)
	local chromatic_scale = use_flats and Note.flat or Note.sharp
	return chromatic_scale[(index - 1) % #chromatic_scale + 1]
end

-- Tuning Related
local tunings = {
	standard = { "E", "B", "G", "D", "A", "E" },
}

-- Fretboard Related
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
		print(string.format("warning: must be 1 <= string index <= 6 (%s given)", string_index))
		return
	end

	if fret < 0 or fret > self.frets then
		print(string.format("warning: must be 0 <= fret <= %d (%d given)", self.frets, fret))
		return
	end

	self.notes[string_index][fret].enabled = not self.notes[string_index][fret].enabled
end

function Fretboard:render()
	for string_index, str in ipairs(self.notes) do
		local open_note = self.tuning[string_index]

		io.write(open_note .. "|| ")

		for fret = 1, self.frets do
			local note = str[fret]
			local display = note.enabled and "[" .. note.name .. "]" or note.name
			display = #note.name == 2 and display or display .. " "
			io.write(string.format("%-5s", display .. "|"))
		end

		io.write("\n")
	end
end

local fb = Fretboard:new(tunings.standard, 17)
fb:toggle(1, 0)
fb:render()
