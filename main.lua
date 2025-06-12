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

	enabled_note = Color.colorize({
		fg = { 183, 248, 70 },
		style = "bold",
	}),

	muted_note = Color.colorize({
		fg = { 224, 17, 95 },
		style = "bold",
	}),
}

-- Tuning Related
local tunings = {
	standard = { "E", "B", "G", "D", "A", "E" },
}

-- Roles
local RoleColors = {
	-- Core intervals
	root = Color.colorize({ fg = { 255, 255, 255 } }), -- White
	m2 = Color.colorize({ fg = { 255, 204, 204 } }), -- Light Red
	M2 = Color.colorize({ fg = { 255, 100, 100 } }), -- Red
	m3 = Color.colorize({ fg = { 255, 165, 0 } }), -- Orange
	M3 = Color.colorize({ fg = { 255, 140, 0 } }), -- Dark Orange
	["4"] = Color.colorize({ fg = { 173, 216, 230 } }), -- Light Blue
	["#4"] = Color.colorize({ fg = { 135, 206, 235 } }), -- Sky Blue
	b5 = Color.colorize({ fg = { 128, 0, 128 } }), -- Purple
	["5"] = Color.colorize({ fg = { 0, 255, 0 } }), -- Green
	["#5"] = Color.colorize({ fg = { 0, 128, 0 } }), -- Dark Green
	b6 = Color.colorize({ fg = { 255, 192, 203 } }), -- Pink
	["6"] = Color.colorize({ fg = { 255, 105, 180 } }), -- Hot Pink
	b7 = Color.colorize({ fg = { 173, 255, 47 } }), -- Green-Yellow
	["7"] = Color.colorize({ fg = { 255, 215, 0 } }), -- Gold

	-- Extensions
	["9"] = Color.colorize({ fg = { 0, 191, 255 } }), -- Deep Sky Blue
	["b9"] = Color.colorize({ fg = { 199, 21, 133 } }), -- Medium Violet Red
	["#9"] = Color.colorize({ fg = { 255, 20, 147 } }), -- Deep Pink
	["11"] = Color.colorize({ fg = { 106, 90, 205 } }), -- Slate Blue
	["#11"] = Color.colorize({ fg = { 147, 112, 219 } }), -- Medium Purple
	["13"] = Color.colorize({ fg = { 255, 160, 122 } }), -- Light Salmon

	-- Modal / Suspended / Add / Omitted
	add9 = Color.colorize({ fg = { 60, 179, 113 } }), -- Medium Sea Green
	sus2 = Color.colorize({ fg = { 244, 164, 96 } }), -- Sandy Brown
	sus4 = Color.colorize({ fg = { 218, 112, 214 } }), -- Orchid
	no3 = Color.colorize({ fg = { 169, 169, 169 } }), -- Dark Gray
	no5 = Color.colorize({ fg = { 112, 128, 144 } }), -- Slate Gray
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
				role = nil,
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

function Fretboard:clear()
	for _, string_notes in ipairs(self.notes) do
		for fret = 0, self.frets do
			string_notes[fret].enabled = false
		end
	end
end

function Fretboard:render()
	for string_index, str in ipairs(self.notes) do
		local open_note = str[0]

		-- TODO: Render open note
		local open_note_display = open_note.enabled and fmt.enabled_note(open_note.name)
			or fmt.disabled_note(open_note.name)
		io.write("[" .. open_note_display .. "] || ")

		for fret = 1, self.frets do
			local note = str[fret]
			local display = note.enabled and fmt.enabled_note(note.name) or fmt.disabled_note(note.name)
			display = #note.name == 2 and display or display .. " "
			io.write(string.format(" %-5s", display .. " | "))
		end

		io.write("\n")
	end
end

local fb = Fretboard:new(tunings.standard, 17)

local interval = 0
local major_scale = { 2, 2, 1, 2, 2, 2, 1, 2 }

for _, step in ipairs(major_scale) do
	fb:toggle(1, interval)
	interval = interval + step
end

fb:render()
