# inifile API Reference

`inifile` is a simple, complete INI parser for Lua. It supports reading and writing INI files with support for comments, section ordering, and automatic type conversion.

## General Information

- **Version:** 1.1
- **License:** Simplified BSD License
- **URL:** https://github.com/bartbes/inifile

## Core Functions

### `inifile.parse(input, backend)`
Reads an INI structure and converts it into a Lua table.

*   **Parameters:**
    *   `input` (string): The filename to read or the raw INI string (if using `memory` backend).
    *   `backend` (string, optional): Specify the backend to use (`"io"`, `"memory"`, or `"love"`). Defaults to `"io"` (or `"love"` if detected).
*   **Returns:**
    1.  `t` (table): A table containing the parsed sections and keys.
    2.  `errors` (table): A list of strings for every line that could not be parsed correctly.
*   **Behavior:** 
    *   Converts numeric values to Lua numbers.
    *   Converts `"true"`/`"false"` strings to booleans.
    *   Stores metadata (comments and section order) in the table's metatable under the `__inifile` field.

### `inifile.save(target, t, backend)`
Serializes a Lua table and writes it to a file or returns it as a string.

*   **Parameters:**
    *   `target` (string): The filename to write to (ignored in `memory` backend).
    *   `t` (table): The Lua table to serialize.
    *   `backend` (string, optional): The backend to use.
*   **Returns:**
    *   The result of the backend's write function (e.g., the full INI string when using the `"memory"` backend).

---

## Backends

The library supports different environments through backends:

| Backend  | Method `lines` | Method `write` | Note |
| :--- | :--- | :--- | :--- |
| **`io`** | `io.open(name):lines()` | Writes to disk using `io.open` | Standard Lua environment. |
| **`memory`** | `gmatch` over string | Returns the content as a string | Ideal for raw strings/tests. |
| **`love`** | `love.filesystem.lines` | `love.filesystem.write` | Used automatically in LÖVE. |

---

## Data Structure & Metadata

The parser preserves the structure of your INI file using a custom metatable.

### Metadata Field: `__inifile`
When a table is returned by `parse`, its metatable contains:
- `comments`: Stores comments associated with specific sections or the global scope.
- `sectionorder`: An array-like table tracking the order in which sections appeared.

### Example
```lua
local inifile = require "inifile"

-- Load from a string
local raw = "[System]\nVersion=1.0\n; A comment\nUser=Admin"
local data, errors = inifile.parse(raw, "memory")

-- Access data
print(data.System.Version) -- Output: 1.0 (as number)

-- Save to a string
local output = inifile.save("dummy", data, "memory")
print(output)

```

## Internal Logic & Formatting

- **Section Headers:** Recognized by `[section]` syntax.
- **Comments:** Recognized by `;` prefix.
- **Key-Value Pairs:** Split by the first `=` sign.
- **Order Preservation:** When saving, the library checks for the `sectionorder` metadata. If found, it writes sections and keys in their original order. New keys are appended to the end of their respective sections.
- **Error Handling:** If a line does not match any valid INI pattern, it is added to the `errors` table with the line number.
