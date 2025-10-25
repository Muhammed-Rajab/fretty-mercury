-- Modules
local Note = require("fretboard.note")
local utils = require("utils")
local tunings = require("fretboard.tunings")
local Fretboard = require("fretboard.board")
local TTYRenderer = require("fretboard.render.tty_renderer")

-- MAJOR SCALE
local function render_major_scale(root)
	local fb = Fretboard.new(tunings.all_four, 17)

	local root_index = Note.index_of(root, false)

	local major_scale_steps = { 2, 2, 1, 2, 2, 2, 1 }
	local major_notes_roles = { "R", "M2", "M3", "4", "5", "M6", "M7" }

	local pos = root_index
	for index = 1, #major_scale_steps do
		local name = Note.name_at(pos, false)
		local role = major_notes_roles[index]
		fb:highlight_notes({ { name = name, role = role, enabled = true, label = "" .. index } })
		pos = pos + major_scale_steps[index]
	end

	io.write(TTYRenderer:render(fb, {
		title = string.upper(root) .. " Major Scale 🎸",
	}))
end

local function render_minor_pentatonic_scale(root)
	local fb = Fretboard.new(tunings.all_four, 17)

	local root_index = Note.index_of(root, false)

	local minor_scale_steps = { 2, 1, 2, 2, 1, 2, 2 }
	local minor_notes_roles = { "R", "M2", "m3", "4", "5", "m6", "m7" }
	local pos = root_index

	for index = 1, #minor_scale_steps do
		local name = Note.name_at(pos, false)
		local role = minor_notes_roles[index]

		if index ~= 2 and index ~= 6 then
			fb:highlight_notes({ { name = name, role = role, enabled = true, label = index .. "" } })
		end

		pos = pos + minor_scale_steps[index]
	end

	io.write(TTYRenderer:render(fb, {
		title = string.upper(root) .. " Minor Scale 🎸",
	}))
end

render_major_scale("A")

render_minor_pentatonic_scale("A")
