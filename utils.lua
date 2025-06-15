local M = {}

function M.sleep(seconds)
	local t0 = os.clock()
	while os.clock() - t0 < seconds do
	end
end

return M
