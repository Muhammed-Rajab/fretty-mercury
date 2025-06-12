-- HERE WE GO AGAIN! I HAVE NO FREAKING IDEA WHAT I'M DOING HERE, BUT HERE WE ARE ON A WEDNESDAY,
-- LEARNING LUA :)

-- Modules
local tunings = require("tunings")
local Fretboard = require("fretboard")

-- Fretboard Related
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

local c_major_scale = {
	{ name = "C", role = "root", label = "I" },
	{ name = "D", role = "M2", label = "ii" },
	{ name = "E", role = "M3", label = "iii" },
	{ name = "F", role = "4", label = "IV" },
	{ name = "G", role = "5", label = "V" },
	{ name = "A", role = "6", label = "vi" },
	{ name = "B", role = "7", label = "vii" },
}

fb:highlight_notes(c_maj7)
fb:render()
