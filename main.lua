-- Modules
local Note = require("fretboard.note")
local tunings = require("fretboard.tunings")
local Fretboard = require("fretboard.board")
local TTYRenderer = require("fretboard.render.tty_renderer")

-- [[OPTIONS FOR RENDERING TO TERMINAL]]
---@class RenderOpts
---@field title boolean?
---@field tuning string[]?
---@field fret_count integer?
---@field highlighted_notes boolean?
---@field fret_numbers boolean?
---@field fret_markers boolean?
---@field interval_hints boolean?
---@field fret_width integer?

---@param opts RenderOpts?
---@return RenderOpts
local function make_opts(opts)
	opts = opts or {}
	return {
		title = opts.title or false,
		tuning = opts.tuning or tunings.standard,
		fret_count = opts.fret_count or 12,
		highlighted_notes = opts.highlighted_notes or false,
		fret_numbers = opts.fret_numbers or true,
		fret_markers = opts.fret_markers or true,
		interval_hints = opts.interval_hints or true,
		fret_width = opts.fret_width or 7,
	}
end

-- MAJOR SCALE
---@param root string
---@param scale_degree boolean?
---@param opts RenderOpts?
local function major_scale(root, scale_degree, opts)
	opts = make_opts(opts)

	local fb = Fretboard.new(opts.tuning, opts.fret_count)

	local root_index = Note.index_of(root, false)

	local major_scale_steps = { 2, 2, 1, 2, 2, 2, 1 }
	local major_notes_roles = { "R", "M2", "M3", "4", "5", "M6", "M7" }

	local pos = root_index
	for index = 1, #major_scale_steps do
		local name = Note.name_at(pos, false)
		local role = major_notes_roles[index]
		fb:highlight_notes({ { name = name, role = role, enabled = true, label = scale_degree and "" .. index or nil } })
		pos = pos + major_scale_steps[index]
	end

	local title = opts.title and (string.upper(root) .. " Major Scale 🎸") or nil

	io.write(TTYRenderer:render(fb, {
		title = title,
		fret_markers = opts.fret_markers,
		fret_numbers = opts.fret_numbers,
		highlighted_notes = opts.highlighted_notes,
		interval_hints = opts.interval_hints,
		fret_width = opts.fret_width,
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

major_scale("A")
