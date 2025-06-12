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

	roles = {
		-- Core intervals
		root = Color.colorize({ fg = { 255, 255, 255 }, style = "bold" }), -- White
		m2 = Color.colorize({ fg = { 255, 204, 204 }, style = "bold" }), -- Light Red
		M2 = Color.colorize({ fg = { 255, 100, 100 }, style = "bold" }), -- Red
		m3 = Color.colorize({ fg = { 255, 165, 0 }, style = "bold" }), -- Orange
		M3 = Color.colorize({ fg = { 255, 140, 0 }, style = "bold" }), -- Dark Orange
		["4"] = Color.colorize({ fg = { 173, 216, 230 }, style = "bold" }), -- Light Blue
		["#4"] = Color.colorize({ fg = { 135, 206, 235 }, style = "bold" }), -- Sky Blue
		b5 = Color.colorize({ fg = { 128, 0, 128 }, style = "bold" }), -- Purple
		["5"] = Color.colorize({ fg = { 0, 255, 0 }, style = "bold" }), -- Green
		["#5"] = Color.colorize({ fg = { 0, 128, 0 }, style = "bold" }), -- Dark Green
		b6 = Color.colorize({ fg = { 255, 192, 203 }, style = "bold" }), -- Pink
		["6"] = Color.colorize({ fg = { 255, 105, 180 }, style = "bold" }), -- Hot Pink
		b7 = Color.colorize({ fg = { 173, 255, 47 }, style = "bold" }), -- Green-Yellow
		["7"] = Color.colorize({ fg = { 255, 215, 0 }, style = "bold" }), -- Gold

		-- Extensions
		["9"] = Color.colorize({ fg = { 0, 191, 255 }, style = "bold" }), -- Deep Sky Blue
		["b9"] = Color.colorize({ fg = { 199, 21, 133 }, style = "bold" }), -- Medium Violet Red
		["#9"] = Color.colorize({ fg = { 255, 20, 147 }, style = "bold" }), -- Deep Pink
		["11"] = Color.colorize({ fg = { 106, 90, 205 }, style = "bold" }), -- Slate Blue
		["#11"] = Color.colorize({ fg = { 147, 112, 219 }, style = "bold" }), -- Medium Purple
		["13"] = Color.colorize({ fg = { 255, 160, 122 }, style = "bold" }), -- Light Salmon

		-- Modal / Suspended / Add / Omitted
		add9 = Color.colorize({ fg = { 60, 179, 113 }, style = "bold" }), -- Medium Sea Green
		sus2 = Color.colorize({ fg = { 244, 164, 96 }, style = "bold" }), -- Sandy Brown
		sus4 = Color.colorize({ fg = { 218, 112, 214 }, style = "bold" }), -- Orchid
		no3 = Color.colorize({ fg = { 169, 169, 169 }, style = "bold" }), -- Dark Gray
		no5 = Color.colorize({ fg = { 112, 128, 144 }, style = "bold" }), -- Slate Gray
	},
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

function Fretboard:highlight_chord(chord_notes)
	-- every string
	for string_index, str in ipairs(self.notes) do
		-- every fret
		for fret = 0, self.frets do
			local note = str[fret] -- NOTE: it can also be an OPEN note
			-- every chord note
			for _, chord_note in ipairs(chord_notes) do
				if chord_note.name == note.name then
					note.enabled = true
					note.role = chord_note.role
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
				open_note_display = fmt.roles[open_note.role](open_note.name)
			else
				open_note_display = fmt.enabled_note(open_note.name)
			end
		else
			open_note_display = fmt.disabled_note(open_note.name)
		end

		io.write(string.format(" %-5s ", open_note_display .. " | "))

		for fret = 1, self.frets do
			local note = str[fret]

			-- TODO: Render note
			local display
			if note.enabled then
				if note.role and fmt.roles[note.role] then
					display = fmt.roles[note.role](note.name)
				else
					display = fmt.enabled_note(note.name)
				end
			else
				display = fmt.disabled_note(note.name)
			end

			display = #note.name == 2 and display or display .. " "
			io.write(string.format(" %-5s", display .. " | "))
		end

		io.write("\n")
	end
end

local fb = Fretboard:new(tunings.standard, 17)

local interval = 0
local major_scale = { 2, 2, 1, 2, 2, 2, 1, 2 }
local major_scale_role = { "root", "M2", "M3", "4", "5", "6", "7", "root" }

for i, step in ipairs(major_scale) do
	fb:enable(1, interval, major_scale_role[i])
	interval = interval + step
end

fb:render()
fb:clear()
print("\n\n===========================================\n\n")

local a_minor = {
	{ name = "A", role = "root" },
	{ name = "C", role = "m3" },
	{ name = "E", role = "5" },
}

local c_maj7 = {
	{ name = "C", role = "root" },
	{ name = "E", role = "M3" },
	{ name = "G", role = "5" },
	{ name = "B", role = "7" },
}

fb:highlight_chord(c_maj7)
fb:render()
