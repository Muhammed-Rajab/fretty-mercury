local Note = {}
Note.sharp = { "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B" }
Note.flat = { "C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B" }

function Note.index_of(name, use_flats)
	local chromatic_scale = use_flats and Note.flat or Note.sharp
	for i, n in ipairs(chromatic_scale) do
		if n == name then
			return i
		end
	end
end

function Note.name_at(index, use_flats)
	local chromatic_scale = use_flats and Note.flat or Note.sharp
	return chromatic_scale[(index - 1) % #chromatic_scale + 1]
end

return Note
