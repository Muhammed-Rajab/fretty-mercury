local fmtcolor = require("fmtcolor")

local Note = require("fretboard.note")
local Fret = require("fretboard.fret")
local Tunings = require("fretboard.tunings")

-- [[ STATE ]]
---@class Fretboard
---@field tuning string[]
---@field fret_count integer
---@field hide_disabled boolean
---@field frets Fret[][]
local Fretboard = {}
Fretboard.__index = Fretboard

--[[ CONSTRUCTOR ]]
---@param tuning string[]?
---@param fret_count integer?
---@return Fretboard
function Fretboard.new(tuning, fret_count)
	local obj = {
		tuning = tuning or Tunings.standard,
		fret_count = fret_count or 12,
		---@type Fret[][]
		frets = {},
		hide_disabled = true,
	}

	-- Create Fret for every fret in each string
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
	return string_index >= 1 and string_index <= #self.tuning
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
	self.frets[string_index][fret]:toggle()
end

---@param string_index integer
---@param fret integer
---@param role string|nil
---@param label string|nil
function Fretboard:enable(string_index, fret, role, label)
	-- validate string index
	self:assert_is_valid_string_index(string_index)

	-- validate fret index
	self:assert_is_valid_fret_index(fret)

	self.frets[string_index][fret]:enable(role, label)
end

---@param string_index integer
---@param fret integer
---@param clear_metadata boolean?
function Fretboard:disable(string_index, fret, clear_metadata)
	-- validate string index
	self:assert_is_valid_string_index(string_index)

	-- validate fret index
	self:assert_is_valid_fret_index(fret)

	self.frets[string_index][fret]:disable(clear_metadata)
end

---@param notes {name: string, role: string?, label: string?}[]
function Fretboard:highlight_notes(notes)
	-- every string
	for _, str in ipairs(self.frets) do
		-- every fret (starts at 0, cause open strings)
		for fret_index = 0, self.fret_count do
			local fret = str[fret_index]
			-- every chord note
			for _, n_note in ipairs(notes) do
				if n_note.name == fret.name then
					fret:enable(n_note.role, n_note.label)
					break
				end
			end
		end
	end
end

---@param notes {name: string, role: string?, label: string?}[]
---@param clear_metadata boolean
function Fretboard:unhighlight_notes(notes, clear_metadata)
	-- every string
	for _, str in ipairs(self.frets) do
		-- every fret (starts at 0, cause open strings)
		for fret_index = 0, self.fret_count do
			local fret = str[fret_index]
			-- every chord note
			for _, n_note in ipairs(notes) do
				if n_note.name == fret.name then
					fret:disable(clear_metadata)
					break
				end
			end
		end
	end
end

function Fretboard:clear()
	for _, string_notes in ipairs(self.frets) do
		for fret = 0, self.fret_count do
			string_notes[fret]:disable(true)
		end
	end
end

return Fretboard
