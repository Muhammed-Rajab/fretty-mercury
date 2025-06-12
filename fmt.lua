local fmt = {}

function fmt.center(text, width, pad_char)
	local total_pad = math.max(0, width - #text)
	local left = math.floor(total_pad / 2)
	local right = total_pad - left

	return string.rep(pad_char or " ", left) .. text .. string.rep(pad_char or " ", right)
end

return fmt
