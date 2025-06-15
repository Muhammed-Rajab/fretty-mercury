-- Modules
local tunings = require("tunings")
local Fretboard = require("fretboard")

-- Fretboard

local a_minor = {
	{ name = "A", role = "root" },
	{ name = "C", role = "m3" },
	{ name = "E", role = "5" },
}

local c_maj7 = {
	{ name = "C", role = "root" },
	{ name = "E", role = "M3" },
	{ name = "G", role = "5" },
	{ name = "B", role = "M7" },
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

local Note = require("note")

-- MAJOR SCALE
local function render_major_scale(root)
	local fb = Fretboard:new(tunings.standard, 17)

	local root_index = Note.index_of(root, false)

	local major_scale_steps = { 2, 2, 1, 2, 2, 2, 1 }
	local major_notes_roles = { "root", "M2", "M3", "4", "5", "M6", "M7" }

	local pos = root_index
	for index = 1, #major_scale_steps do
		local name = Note.name_at(pos, false)
		local role = major_notes_roles[index]
		fb:highlight_notes({ { name = name, role = role, enabled = true } })
		pos = pos + major_scale_steps[index]
	end

	fb:render()
end

local function render_minor_scale(root)
	local fb = Fretboard:new(tunings.standard, 17)

	local root_index = Note.index_of(root, false)

	local minor_scale_steps = { 2, 1, 2, 2, 1, 2, 2 }
	local minor_notes_roles = { "root", "M2", "m3", "4", "5", "m6", "m7" }
	local pos = root_index

	for index = 1, #minor_scale_steps do
		local name = Note.name_at(pos, false)
		local role = minor_notes_roles[index]
		fb:highlight_notes({ { name = name, role = role, enabled = true } })
		pos = pos + minor_scale_steps[index]
	end

	fb:render()
end

render_major_scale("C")
render_minor_scale("A")
