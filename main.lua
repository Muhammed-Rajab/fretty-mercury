-- Modules
local Note = require("note")
local tunings = require("tunings")
local Fretboard = require("fretboard")

-- MAJOR SCALE
local function render_major_scale(root)
	local fb = Fretboard:new(tunings.standard, 17)

	local root_index = Note.index_of(root, false)

	local major_scale_steps = { 2, 2, 1, 2, 2, 2, 1 }
	local major_notes_roles = { "R", "M2", "M3", "4", "5", "M6", "M7" }

	local pos = root_index
	for index = 1, #major_scale_steps do
		local name = Note.name_at(pos, false)
		local role = major_notes_roles[index]
		fb:highlight_notes({ { name = name, role = role, enabled = true } })
		pos = pos + major_scale_steps[index]
	end

	fb:render({ title = string.upper(root) .. " Major Scale 🎸" })
end

local function render_minor_scale(root)
	local fb = Fretboard:new(tunings.standard, 17)

	local root_index = Note.index_of(root, false)

	local minor_scale_steps = { 2, 1, 2, 2, 1, 2, 2 }
	local minor_notes_roles = { "R", "M2", "m3", "4", "5", "m6", "m7" }
	local pos = root_index

	for index = 1, #minor_scale_steps do
		local name = Note.name_at(pos, false)
		local role = minor_notes_roles[index]
		fb:highlight_notes({ { name = name, role = role, enabled = true, label = role } })
		pos = pos + minor_scale_steps[index]
	end

	fb:render({ title = string.upper(root) .. " Minor Scale 🎸" })
end

-- clears screen
io.write("\27[2J\27[H")

-- render_major_scale("C")
-- render_minor_scale("A")
