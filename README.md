# pdShared
A small library to make working with the Shared folder in playdate easier

## Quick Start

```lua
import "pdShared"

local shared <const> = playdate.file.shared

shared.init("Data")
-- Create a json file at /Shared/com.example.mygame/Data/test.json
shared.datastore.write({foo="bar"}, "test")
printTable(shared.listFiles("."))
```

## Functions

Most of the functions match the playdate [file/datastore API](https://sdk.play.date/Inside%20Playdate.html#file) but operate relative to the Shared folder configured with `init`.

#### playdate.file.shared.getBundleId()

Returns the sanitized bundle id of the game, which removes any `user.1234.` prefix in the case of sideloaded games.

#### playdate.file.shared.gameExists(id, [prefix])

Checks if a game's data is present in the Shared folder. The prefix is optional and defaults to nothing.

```lua
local shared <const> = playdate.file.shared

-- Checks for the existence of /Shared/com.example.mygame
if shared.gameExists("com.example.mygame") then
    print("Game data exists")
end
-- Checks for the existence of /Shared/Achievements/com.example.mygame
if shared.gameExists("com.example.mygame", "/Achievements") then
    print("Game data exists")
end
```

#### playdate.file.shared.init([id], [prefix])

* `id` (string) - The optional id of the game. Defaults to a sanitized bundle id of the game.
* `prefix` (string) - The optional path to the Shared folder. Defaults to nothing and places your game's folder in the root of `/Shared`.

#### playdate.file.shared

The following functions match their [signatures from the SDK](https://sdk.play.date/Inside%20Playdate.html#M-file), but operate on files in the configured Shared folder:

* `shared.open(path, [mode])`
* `shared.listFiles(path, [showhidden])`
* `shared.exists(path)`
* `shared.isdir(path)`
* `shared.mkdir(path)`
* `shared.delete(path, [recursive])`
* `shared.getSize(path)`
* `shared.getType(path)`
* `shared.modTime(path)`
* `shared.rename(path, newPath)`

#### playdate.file.shared.datastore

All functions match the [signatures from the SDK](https://sdk.play.date/Inside%20Playdate.html#M-datastore), but operate on files in the configured Shared folder:

* `datastore.write(table, [filename], [pretty_print])`
* `datastore.read([filename])`
* `datastore.delete([filename])`
* `datastore.writeImage(image, path)`
* `datastore.readImage(path)`
