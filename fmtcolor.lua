local Color = require("color")

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

		-- Extensions
		["9"] = Color.colorize({ fg = { 0, 191, 255 }, style = "bold" }), -- Deep Sky Blue
		["b9"] = Color.colorize({ fg = { 199, 21, 133 }, style = "bold" }), -- Medium Violet Red
		["#9"] = Color.colorize({ fg = { 255, 20, 147 }, style = "bold" }), -- Deep Pink
		["11"] = Color.colorize({ fg = { 106, 90, 205 }, style = "bold" }), -- Slate Blue
		["#11"] = Color.colorize({ fg = { 147, 112, 219 }, style = "bold" }), -- Medium Purple
		["13"] = Color.colorize({ fg = { 255, 160, 122 }, style = "bold" }), -- Light Salmon

		-- Modal / Suspended / Add / Omitted
		add9 = Color.colorize({ fg = { 60, 179, 113 }, style = "bold" }), -- Medium Sea Green
		sus2 = Color.colorize({ fg = { 244, 164, 96 }, style = "bold" }), -- Sandy Brown
		sus4 = Color.colorize({ fg = { 218, 112, 214 }, style = "bold" }), -- Orchid
		no3 = Color.colorize({ fg = { 169, 169, 169 }, style = "bold" }), -- Dark Gray
		no5 = Color.colorize({ fg = { 112, 128, 144 }, style = "bold" }), -- Slate Gray
	},
}

return fmtcolor
