local Color = {}

-- Predefined ANSI color maps
Color.fg = {
	black = 30,
	red = 31,
	green = 32,
	yellow = 33,
	blue = 34,
	magenta = 35,
	cyan = 36,
	white = 37,
	default = 39,
}

Color.bg = {
	black = 40,
	red = 41,
	green = 42,
	yellow = 43,
	blue = 44,
	magenta = 45,
	cyan = 46,
	white = 47,
	default = 49,
}

Color.style = {
	bold = 1,
	dim = 2,
	italic = 3,
	underline = 4,
	blink = 5,
	reverse = 7,
	hidden = 8,
	strikethrough = 9,
	reset = 0,
}

-- Formatter to build the ANSI escape string
function Color.format(codes, text)
	return string.format("\27[%sm%s\27[0m", table.concat(codes, ";"), text)
end

-- Accepts named colors, RGB tables, and styles
function Color.colorize(opts)
	local codes = {}

	-- Foreground
	if opts.fg then
		if type(opts.fg) == "string" then
			table.insert(codes, Color.fg[opts.fg] or Color.fg.default)
		elseif type(opts.fg) == "table" then
			local r, g, b = table.unpack(opts.fg)
			table.insert(codes, string.format("38;2;%d;%d;%d", r, g, b))
		end
	end

	-- Background
	if opts.bg then
		if type(opts.bg) == "string" then
			table.insert(codes, Color.bg[opts.bg] or Color.bg.default)
		elseif type(opts.bg) == "table" then
			local r, g, b = table.unpack(opts.bg)
			table.insert(codes, string.format("48;2;%d;%d;%d", r, g, b))
		end
	end

	-- Styles
	if opts.style then
		if type(opts.style) == "table" then
			for _, s in ipairs(opts.style) do
				table.insert(codes, Color.style[s])
			end
		else
			table.insert(codes, Color.style[opts.style])
		end
	end

	return function(text)
		return Color.format(codes, text)
	end
end

return Color
