-- Modules
local Note = require("note")
local utils = require("utils")
local tunings = require("tunings")
local Fretboard = require("fretboard")

-- MAJOR SCALE
local function render_major_scale(root)
	local fb = Fretboard:new(tunings.all_four, 17)

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

	fb:render({ title = string.upper(root) .. " Major Scale 🎸" })
end

local function render_minor_scale(root)
	local fb = Fretboard:new(tunings.all_four, 17)

	local root_index = Note.index_of(root, false)

	local minor_scale_steps = { 2, 1, 2, 2, 1, 2, 2 }
	local minor_notes_roles = { "R", "M2", "m3", "4", "5", "m6", "m7" }
	local pos = root_index

	for index = 1, #minor_scale_steps do
		local name = Note.name_at(pos, false)
		local role = minor_notes_roles[index]

		if index ~= 2 and index ~= 6 then
			print("not  2 or 6" .. index)
			fb:highlight_notes({ { name = name, role = role, enabled = true, label = index .. "" } })
		end

		pos = pos + minor_scale_steps[index]
	end

	fb:render({ title = string.upper(root) .. " Minor Pentatonic Scale 🎸" })
end

-- clears screen
-- io.write("\27[2J\27[H")

-- render_major_scale("C")
-- render_minor_scale("A")

local function render_major_scale_animated(root, title, highlighted_intervals)
	local fb = Fretboard:new(tunings.standard, 17)

	local root_index = Note.index_of(root, false)

	local major_scale_steps = { 2, 2, 1, 2, 2, 2, 1 }
	local major_notes_roles = { "R", "M2", "M3", "4", "5", "M6", "M7" }

	-- by default highlight every interval
	highlighted_intervals = highlighted_intervals or {}
	if next(highlighted_intervals) == nil then
		for _, interval in ipairs(major_notes_roles) do
			highlighted_intervals[interval] = true
		end
	end

	-- Animation setup
	local FPS = 1
	local delay = 1 / FPS

	-- Rendering logic
	local pos = root_index
	io.write("\27[2J\27[H")

	for index = 1, #major_scale_steps + 1 do
		io.write("\27[H")

		-- Render
		fb:render({ title = title })

		if index == #major_scale_steps + 1 then
			break
		end

		local name = Note.name_at(pos, false)
		local role = major_notes_roles[index]

		pos = pos + major_scale_steps[index]

		-- Only render highlighted_intervals (useful for chords)
		if not highlighted_intervals[role] then
			goto continue
		end

		-- Animation delay
		fb:highlight_notes({ { name = name, role = role, enabled = true } })

		utils.sleep(delay)

		::continue::
	end
end
