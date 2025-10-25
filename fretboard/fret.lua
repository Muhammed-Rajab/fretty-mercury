---@class Fret
---@field name string
---@field enabled boolean
---@field role string|nil
---@field label string|nil
local Fret = {}
Fret.__index = Fret

---@param name string
---@return Fret
function Fret.new(name)
	local obj = {
		name = name,
		enabled = false,
		role = nil,
		label = nil,
	}
	setmetatable(obj, Fret)
	return obj
end

function Fret:toggle()
	self.enabled = not self.enabled
end

---@param role string|nil
---@param label string|nil
function Fret:enable(role, label)
	self.enabled = true
	if role then
		self.role = role
	end

	if label then
		self.label = label
	end
end

---@param clear_metadata boolean?
function Fret:disable(clear_metadata)
	--- NOTE: don't reset by default
	clear_metadata = clear_metadata or false
	self.enabled = false

	if clear_metadata then
		self.role = nil
		self.label = nil
	end
end

return Fret
