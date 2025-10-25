local Color = require("fretboard.utils.color")

local fmtcolor = {
	error = Color.colorize({
		fg = "red",
		style = "bold",
	}),

	disabled_note = Color.colorize({
		fg = { 128, 128, 128 },
	}),

	enabled_note = Color.colorize({
		fg = { 255, 0, 255 },
		style = "bold",
	}),

	roles = {
		-- Core intervals
		["R"] = Color.colorize({ fg = { 255, 255, 255 }, bg = { 255, 0, 79 }, style = "bold" }), -- White
		m2 = Color.colorize({ fg = { 255, 204, 204 }, style = "bold" }), -- Light Red
		M2 = Color.colorize({ fg = { 255, 100, 100 }, style = "bold" }), -- Red
		m3 = Color.colorize({ fg = { 255, 165, 0 }, style = "bold" }), -- Orange
		M3 = Color.colorize({ fg = { 255, 140, 0 }, style = "bold" }), -- Dark Orange
		["4"] = Color.colorize({ fg = { 173, 216, 230 }, style = "bold" }), -- Light Blue
		["#4"] = Color.colorize({ fg = { 135, 206, 235 }, style = "bold" }), -- Sky Blue
		b5 = Color.colorize({ fg = { 128, 0, 128 }, style = "bold" }), -- Purple
		["5"] = Color.colorize({ fg = { 0, 255, 0 }, style = "bold" }), -- Green
		["#5"] = Color.colorize({ fg = { 0, 128, 0 }, style = "bold" }), -- Dark Green
		m6 = Color.colorize({ fg = { 255, 192, 203 }, style = "bold" }), -- Pink
		M6 = Color.colorize({ fg = { 255, 105, 180 }, style = "bold" }), -- Hot Pink
		m7 = Color.colorize({ fg = { 173, 255, 47 }, style = "bold" }), -- Green-Yellow
		M7 = Color.colorize({ fg = { 255, 215, 0 }, style = "bold" }), -- Gold
	},
}

return fmtcolor
