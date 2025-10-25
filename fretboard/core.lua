local Note = require("note")
local tunings = require("tunings")
local fmtcolor = require("fmtcolor")
local Fret = require("fretboard.fret")

--[[
-- State
--]]
---@class Fretboard
---@field tuning string[]
---@field fret_count integer
---@field hide_disabled boolean
---@field frets Fret[][]
local Fretboard = {}
Fretboard.__index = Fretboard

--[[
--Constructor
--]]
---@param tuning string[]?
---@param fret_count integer?
---@return Fretboard
function Fretboard.new(tuning, fret_count)
	local obj = {
		tuning = tuning or tunings.standard,
		fret_count = fret_count or 12,
		---@type Fret[][]
		frets = {},
		hide_disabled = true,
	}

	-- Generate State for every Note
	for string_index, start_note in ipairs(obj.tuning) do
		local start_index = Note.index_of(start_note)
		obj.frets[string_index] = {}
		for fret = 0, obj.fret_count do
			local note_name = Note.name_at(start_index + fret, false)
			obj.frets[string_index][fret] = Fret.new(note_name)
		end
	end

	-- Setup OOP
	setmetatable(obj, Fretboard)
	return obj
end

--[[ HELPER METHODS ]]

--  [[ VALIDATORS ]]

---@param fret_index integer
---@return boolean
function Fretboard:is_valid_fret_index(fret_index)
	return fret_index >= 0 and fret_index <= self.fret_count
end

---@param string_index integer
---@return boolean
function Fretboard:is_valid_string_index(string_index)
	return string_index >= 1 and string_index <= 6
end

--  [[ VALIDATOR ASSERTORS ]]

---@param string_index integer
function Fretboard:assert_is_valid_string_index(string_index)
	assert(
		self:is_valid_string_index(string_index),
		fmtcolor.error(string.format("warning: must be 1 <= string index <= 6 (got %s)", string_index))
	)
end

---@param fret_index integer
function Fretboard:assert_is_valid_fret_index(fret_index)
	assert(
		self:is_valid_fret_index(fret_index),
		fmtcolor.error(string.format("warning: must be 0 <= fret <= %d (got %d)", self.fret_count, fret_index))
	)
end

--[[ MAIN METHODS ]]

---@param string_index integer
---@param fret integer
function Fretboard:toggle(string_index, fret)
	-- validate string index
	self:assert_is_valid_string_index(string_index)

	-- validate fret index
	self:assert_is_valid_fret_index(fret)

	-- toggle note
	self.frets[string_index][fret].enabled = not self.frets[string_index][fret].enabled
end

function Fretboard:enable(string_index, fret, role, label)
	-- validate string index
	self:assert_is_valid_string_index(string_index)

	-- validate fret index
	self:assert_is_valid_fret_index(fret)

	self.frets[string_index][fret].enabled = true
	self.frets[string_index][fret].role = role
	self.frets[string_index][fret].label = label
end

function Fretboard:disable(string_index, fret)
	-- validate string index
	self:assert_is_valid_string_index(string_index)

	-- validate fret index
	self:assert_is_valid_fret_index(fret)

	self.frets[string_index][fret].enabled = false
	self.frets[string_index][fret].role = nil
	self.frets[string_index][fret].label = nil
end

function Fretboard:highlight_notes(notes)
	-- every string
	for _, str in ipairs(self.frets) do
		-- every fret
		for fret = 0, self.fret_count do
			local note = str[fret] -- NOTE: it can also be an OPEN note
			-- every chord note
			for _, n_note in ipairs(notes) do
				if n_note.name == note.name then
					note.enabled = true
					note.role = n_note.role
					note.label = n_note.label
					break
				end
			end
		end
	end
end

function Fretboard:clear()
	for _, string_notes in ipairs(self.frets) do
		for fret = 0, self.fret_count do
			string_notes[fret].enabled = false
			string_notes[fret].role = nil
			string_notes[fret].label = nil
		end
	end
end

return Fretboard
