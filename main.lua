-- Modules
local tunings = require("tunings")
local Fretboard = require("fretboard")

-- Fretboard
local fb = Fretboard:new(tunings.standard, 17)

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

-- local c_major_scale = {
-- 	{ name = "C", role = "root", label = "I" },
-- 	{ name = "D", role = "M2", label = "ii" },
-- 	{ name = "E", role = "M3", label = "iii" },
-- 	{ name = "F", role = "4", label = "IV" },
-- 	{ name = "G", role = "5", label = "V" },
-- 	{ name = "A", role = "6", label = "vi" },
-- 	{ name = "B", role = "7", label = "vii" },
-- }

local c_major_scale = {
	{ name = "C", role = "root" },
	{ name = "D", role = "M2" },
	{ name = "E", role = "M3" },
	{ name = "F", role = "4" },
	{ name = "G", role = "5" },
	{ name = "A", role = "M6" },
	{ name = "B", role = "M7" },
}

local notes = {
	{ name = "C", role = "root" },
	{ name = "E", role = "M3" },
	{ name = "G", role = "5" },
}

fb:highlight_notes(c_major_scale)
fb:render()
