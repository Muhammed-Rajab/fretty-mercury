local Fretboard = {}
Fretboard.__index = Fretboard

require("fretboard.core")(Fretboard)
require("fretboard.render")(Fretboard)

return Fretboard
