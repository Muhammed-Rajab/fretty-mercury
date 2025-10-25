<h1>
  <img src="images/freddy.jpg" width="50" height="50" />
fretty mercury
</h1>

_A silly guitar fretboard visualizer written in Lua_ 🎸💖


## Table of Contents

1. [Project Structure](#project-structure)  
2. [Installation](#installation)  
3. [Usage](#usage)  
4. [Core Modules](#core-modules)  
   - [`fretboard.board`](#fretboardboard)  
   - [`fretboard.fret`](#fretboardfret)  
   - [`fretboard.note`](#fretboardnote)  
   - [`fretboard.tunings`](#fretboardtunings)  
   - [`fretboard.intervals`](#fretboardintervals)  
   - [`fretboard.render.tty_renderer`](#fretboardrendertty_renderer)  
5. [Utilities](#utilities)  
6. [Examples](#examples)  
7. [Customization](#customization)  
8. [Future Goals](#future-goals)  



## Project Structure
```
.
├── .gitignore
├── README.md
├── fretboard
│   ├── board.lua           # Fretboard class
│   ├── fret.lua            # Fret class
│   ├── intervals.lua       # Musical interval definitions
│   ├── note.lua            # Note utilities
│   ├── render
│   │   └── tty_renderer.lua # Terminal renderer
│   ├── tunings.lua         # Predefined string tunings
│   └── utils
│       ├── color.lua       # ANSI color support
│       ├── fmt.lua         # String formatting helpers
│       └── fmtcolor.lua    # Colored formatting for notes and roles
├── main.lua                # Example render scripts and animations
└── utils.lua               # General utility functions
```


## Installation

1. Clone the repository:  
```bash
git clone https://github.com/Muhammed-Rajab/fretty-mercury
cd fretty-mercury
```
2. Ensure Lua 5.3+ is installed.

3. Run examples via:
```bash
lua main.lua
```


## Usage

1. **Create a fretboard instance:**
```lua
local Fretboard = require("fretboard.board")
local fb = Fretboard.new({"E", "B", "G", "D", "A", "E"}, 12) -- standard 12-fret guitar
```

2. **Highlight notes:**
```lua
fb:highlight_notes({ { name = "C", role = "R" } })
```

3. **Render to terminal:**
```lua
local TTYRenderer = require("fretboard.render.tty_renderer")
local renderer = TTYRenderer.new()
print(renderer:render(fb, { title = "C Major" }))
```

## Core Modules

### `fretboard.board`

**Class:** `Fretboard`  
Represents a guitar fretboard with frets, notes, and highlighting support.

**Constructor:**
```
Fretboard.new(tuning: string[]?, fret_count: integer?) -> Fretboard
```

**Key Methods:**

- `toggle(string_index, fret)`: Toggle note enabled/disabled.  
- `enable(string_index, fret, role?, label?)`: Enable a note with optional role/label.  
- `disable(string_index, fret, clear_metadata?)`: Disable a note, optionally clearing metadata.  
- `highlight_notes(notes)`: Enable multiple notes at once.  
- `unhighlight_notes(notes, clear_metadata)`: Disable multiple notes.  
- `clear()`: Reset all frets.

---

### `fretboard.fret`

**Class:** `Fret`  
Represents a single fret on a string.

**Constructor:**
```
Fret.new(name: string) -> Fret
```

**Key Methods:**

- `toggle()`: Toggle enabled state.  
- `enable(role?, label?)`: Enable with optional role/label.  
- `disable(clear_metadata?)`: Disable and optionally clear metadata.


### `fretboard.note`

Utilities for note indexing and naming.

**Functions:**

- `Note.index_of(name: string, use_flats?: boolean) -> integer`  
- `Note.name_at(index: integer, use_flats?: boolean) -> string`



### `fretboard.tunings`

Predefined tunings:
```lua
Tunings = {
    standard = {"E","B","G","D","A","E"},
    drop_d = {"E","B","G","D","A","D"},
    all_four = {"F","C","G","D","A","E"},
}
```


### `fretboard.intervals`

Defines interval names:

```lua
{"R", "m2", "M2", "m3", "M3", "4", "#4", "b5", "5", "#5", "m6", "M6", "m7", "M7"}
```

### `fretboard.render.tty_renderer`

Terminal-based renderer for fretboard visualization.

**Class:** `TTYRenderer`

**Methods:**

- `render(fb: Fretboard, opts: table?) -> string`  

**Options:**
- `title` - Optional header  
- `highlighted_notes` - Show highlighted notes (default true)  
- `fret_numbers` - Show fret numbers (default true)  
- `fret_markers` - Show standard fret markers (default true)  
- `interval_hints` - Show interval hints (default true)  
- `fret_width` - Width of each fret column (default 7)



## Utilities

- **`fretboard/utils/color.lua`**
  - ANSI color and style support.

- **`fretboard/utils/fmt.lua`**
  - String formatting helpers (center, padding, strip ANSI codes).

- **`fretboard/utils/fmtcolor.lua`**
  - Predefined colors for roles, enabled/disabled notes, and error messages.

## Examples

```lua
-- Modules: Importing required modules for notes, tunings, fretboard, and rendering
local Note = require("fretboard.note")          -- Provides note-related utilities
local tunings = require("fretboard.tunings")    -- Provides standard and alternate tunings
local Fretboard = require("fretboard.board")    -- Represents the guitar fretboard
local TTYRenderer = require("fretboard.render.tty_renderer")  -- Renders fretboard in terminal

-- FUNCTION: Render a major scale starting from a given root note
local function render_major_scale(root)
    -- Create a new fretboard with standard tuning and 17 frets
	local fb = Fretboard.new(tunings.standard, 17)

    -- Get the index of the root note
	local root_index = Note.index_of(root, false)

    -- Intervals (in semitones) for a major scale: W-W-H-W-W-W-H
	local major_scale_steps = { 2, 2, 1, 2, 2, 2, 1 }
    -- Labels for scale degrees
	local major_notes_roles = { "R", "M2", "M3", "4", "5", "M6", "M7" }

	local pos = root_index
	for index = 1, #major_scale_steps do
		local name = Note.name_at(pos, false)     -- Get the note name at current position
		local role = major_notes_roles[index]    -- Get scale degree/role

        -- Highlight this note on the fretboard with its scale degree
		fb:highlight_notes({ { name = name, role = role, enabled = true, label = "" .. index } })

        -- Move to the next note in the scale using the step interval
		pos = pos + major_scale_steps[index]
	end

    -- Render the fretboard in terminal with a title
	io.write(TTYRenderer:render(fb, {
		title = string.upper(root) .. " Major Scale 🎸",
	}))
end

-- FUNCTION: Render a minor pentatonic scale starting from a given root note
local function render_minor_pentatonic_scale(root)
    -- Create a new fretboard with "all_four" tuning and 17 frets
	local fb = Fretboard.new(tunings.all_four, 17)

	local root_index = Note.index_of(root, false)

    -- Intervals for minor pentatonic scale (simplified for display)
	local minor_scale_steps = { 2, 1, 2, 2, 1, 2, 2 }
    -- Scale degrees/roles
	local minor_notes_roles = { "R", "M2", "m3", "4", "5", "m6", "m7" }
	local pos = root_index

	for index = 1, #minor_scale_steps do
		local name = Note.name_at(pos, false)
		local role = minor_notes_roles[index]

        -- Skip certain notes (M2 and m6) to highlight pentatonic pattern
		if index ~= 2 and index ~= 6 then
			fb:highlight_notes({ { name = name, role = role, enabled = true, label = index .. "" } })
		end

        -- Move to the next note in the scale
		pos = pos + minor_scale_steps[index]
	end

    -- Render the fretboard in terminal with a title
	io.write(TTYRenderer:render(fb, {
		title = string.upper(root) .. " Minor Scale 🎸",
	}))
end

-- EXAMPLES: Render scales starting from the note "A"
render_major_scale("A")
render_minor_pentatonic_scale("A")
```


## Customization

- Modify `tunings.lua` to add custom string tunings.
- Adjust `fmtcolor.roles` to customize interval colors.
- Adjust `TTYRenderer` options to change fret width, display options, or hide disabled notes.

## Future Goals 
- **SVG Renderer:** Imagine your fretboards in full color on the web! [❌ not added yet]
