local fmt = {}

function fmt.center(text, width, pad_char)
	local total_pad = math.max(0, width - #text)
	local left = math.floor(total_pad / 2)
	local right = total_pad - left

	return string.rep(pad_char or " ", left) .. text .. string.rep(pad_char or " ", right)
end

function fmt.strip_ansi(str)
	return str:gsub("\27%[[%d;]*m", "")
end

function fmt.pad_ansi_left(str, width)
	local visible = fmt.strip_ansi(str)
	local pad = width - #visible
	if pad > 0 then
		return str .. string.rep(" ", pad)
	else
		return str
	end
end

return fmt
