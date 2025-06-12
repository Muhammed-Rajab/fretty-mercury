-- HERE WE GO AGAIN! I HAVE NO FREAKING IDEA WHAT I'M DOING HERE, BUT HERE WE ARE ON A WEDNESDAY,
-- LEARNING LUA :)

-- Modules
local Color = require("color")
local Note = require("note")

-- Formatter for outputs
local fmt = {
	error = Color.colorize({
		fg = "red",
		style = "bold",
	}),

	disabled_note = Color.colorize({
		fg = { 128, 128, 128 },
	}),
}

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
		print(fmt.error(string.format("warning: must be 1 <= string index <= 6 (got %s)", string_index)))
		return
	end

	if fret < 0 or fret > self.frets then
		print(fmt.error(string.format("warning: must be 0 <= fret <= %d (got %d)", self.frets, fret)))
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
			local display = note.enabled and note.name or fmt.disabled_note(note.name)
			display = #note.name == 2 and display or display .. " "
			io.write(string.format(" %-5s", display .. " | "))
		end

		io.write("\n")
	end
end

local fb = Fretboard:new(tunings.standard, 17)
fb:render()
