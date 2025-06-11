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
	standard = { "E", "A", "D", "G", "B", "E" },
}

-- Fretboard Related
local Fretboard = {}

function Fretboard:new(tuning, frets)
	local obj = {
		tuning = tuning or tunings.standard,
		frets = frets or 12,
	}
	self.__index = self
	setmetatable(obj, self)
	return obj
end

function Fretboard:render()
	for _, start_note in ipairs(self.tuning) do
		local start_index = Note.index_of(start_note)

		io.write(string.format("%-2s||  ", start_note))
		for index = 1, self.frets do
			local note = Note.name_at(start_index + index, false)
			io.write(string.format("%-4s|", note))
		end

		io.write("\n")
	end
end

local fb = Fretboard:new(tunings.standard, 12)
fb:render()
