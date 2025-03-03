# pdShared
A small library to make working with the Shared folder in playdate easier

### Cross-Game Data

There's a `pdShared` global that has tools for checking for cross-game ownership and sharing data between games:

```lua
-- Creates a shared data file at /Shared/.meta/com.example.mygame.json
pdShared.shareData({foo="bar"})
-- Check if another game has any shared data:
pdShared.gameExists("com.example.yourgame")
-- Get the shared data of another game:
pdShared.loadData("com.example.yourgame")
-- Get a list of all shared games:
pdShared.getGames()
```

## Custom Directories

If you want to save more complicated data, like themes, music, etc. you can use custom directories in the Shared folder:

```lua
import "pdShared"

-- Creates /Shared/Data/com.example.mygame/ (if it doesn't exist)
local shared = playdate.file.shared("Data")
print("Shared path: " .. shared:getPath())

-- Create a json file at /Shared/Data/com.example.mygame/test.json
shared.datastore.write({foo="bar"}, "test")
-- Print out the file
printTable(shared:listFiles("."))

-- Creates /Shared/Data/My Game/ (if it doesn't exist)
local shared_custom = playdate.file.shared("Data", "My Game")
-- Create a json file at /Shared/Data/My Game/test.json
shared_custom.datastore.write({foo="bar"}, "test")
```

To add saved data to another game, create the shared directory with the game's bundle id:

```lua
local your_shared = playdate.file.shared("Data", "com.example.yourgame")
your_shared.datastore.write({foo="bar"}, "test")
```

## Functions

Most of the functions match the playdate [file/datastore API](https://sdk.play.date/Inside%20Playdate.html#file) but operate relative to the Shared folder.

#### `pdShared.getBundleId([id])`

Returns the sanitized bundle id of the game, which removes any `user.1234.` prefix in the case of sideloaded games. If id is not provided `playdate.metadata.bundleID` is used.

#### `pdShared.gameExists([id])`

Checks if a game (or this game)'s data is present in the `/Shared/.meta` folder. 

```lua
if pdShared.gameExists("com.example.yourgame") then
    print("Game data exists")
end
```

#### `pdShared.getGames()`

Returns a list of all games that have shared data in the `/Shared/.meta` folder.

```lua
printTable(pdShared.getGames())
```

##### Supported games
* Pomo Post - `com.gammagames.pomodoro`
* What the Taiji?! - `net.marquiskurt.what-the-taiji`
* [XTRIS](https://play.date/games/xtris) - `com.fletchmakes.xtris`
	* [XTRIS for Developers](https://fletchmakesstuff.com/blog/xtris-for-devs)

### `pdShared.shareData([data])`

Shares data with other games. The data is saved in the `/Shared/.meta` folder with the current project's bundle id as the filename. The function saves the game's metadata (from `pd.metadata`) with a `data` key if the optional data argument is provided. An easy way to use it is to share your data when the game terminates:

```lua
function playdate.gameWillTerminate()
    pdShared.shareData()
end
```

An example `com.gammagames.pomodoro.json` that has shared data:

```json
{
	"buildNumber":"150",
	"bundleID":"com.gammagames.pomodoro",
	"data": {
		"delivered":225,
		"special_delivered":33
	},
	"description":"Delivery in 25 minutes or less!",
	"name":"Pomo Post",
	"version":"1.3"
}
```

#### `pdShared.loadData([id])`

Loads the shared data of another game, or this game if not used. Returns the shared `data` key as the first value and the entire table as the second.

```lua
local shared_data, shared_metadata = pdShared.loadData("com.example.yourgame")
```

#### `playdate.file.shared([id], [prefix])`

* `id` (string) - The optional id of the game. Defaults to a sanitized bundle id of the game.
* `prefix` (string) - The optional path to the Shared folder. Defaults to nothing and places your game's folder in the root of `/Shared`.

#### `playdate.file.shared.gameExists(id, [prefix])`

Checks if a game's data is present in the Shared folder. The prefix is optional and defaults to nothing.

```lua
-- Checks for the existence of /Shared/com.example.mygame
if shared.gameExists("com.example.mygame") then
    print("Game data exists")
end
-- Checks for the existence of /Shared/Achievements/com.example.mygame
if playdate.file.shared.gameExists("com.example.mygame", "Achievements") then
    print("Game data exists")
end
```

#### `playdate.file.shared:getPath()`

Returns the path to the Shared folder.

#### `playdate.file.shared`

The following functions match their [signatures from the SDK](https://sdk.play.date/Inside%20Playdate.html#M-file), but operate on files in the Shared folder:

* `shared:open(path, [mode])`
* `shared:listFiles(path, [showhidden])`
* `shared:exists(path)`
* `shared:isdir(path)`
* `shared:mkdir(path)`
* `shared:delete(path, [recursive])`
* `shared:getSize(path)`
* `shared:getType(path)`
* `shared:modTime(path)`
* `shared:rename(path, newPath)`

#### `playdate.file.shared.datastore`

All functions match the [signatures from the SDK](https://sdk.play.date/Inside%20Playdate.html#M-datastore), but operate on files in the Shared folder:

* `shared.datastore.write(table, [filename], [pretty_print])`
* `shared.datastore.read([filename])`
* `shared.datastore.delete([filename])`
* `shared.datastore.writeImage(image, path)`
* `shared.datastore.readImage(path)`
