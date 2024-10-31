-- https://github.com/PlaydateSquad/pdShared/tree/main
-- MIT License

-- Copyright (c) 2024 Jesse

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

import "CoreLibs/object"

local pd <const> = playdate
local file <const> = pd.file

local ROOT = "/Shared/"
pdShared = {}

function pdShared.getBundleId(id)
    return string.gsub(id or pd.metadata.bundleID, "^user%.%d+%.", "")
end

function pdShared.shareData(data)
    if not file.isdir(ROOT .. ".meta") then
        file.mkdir(ROOT .. ".meta")
    end
    local bundle = pdShared.getBundleId()
    pd.datastore.write({
        name = pd.metadata.name,
        description = pd.metadata.description,
        bundleID = bundle,
        version = pd.metadata.version,
        buildNumber = pd.metadata.buildNumber,
        data = data
    }, ROOT .. ".meta/" .. bundle)
end

function pdShared.gameExists(id)
    return file.exists(ROOT .. ".meta/" .. pdShared.getBundleId(id) .. ".json")
end

function pdShared.getGames()
    local games = file.listFiles(ROOT .. ".meta")
    for index = 1, #games do
        games[index] = string.gsub(games[index], "%.json$", "")
    end
    return games
end

function pdShared.loadData(id)
    if pdShared.gameExists(id) then
        local data = pd.datastore.read(ROOT .. ".meta/" .. pdShared.getBundleId(id))
        return data.data, data
    end
end

class("shared", nil, pd.file).extends()
local shared = pd.file.shared

function shared:init(prefix, id)
    self._prefix = ""
    self._id = pdShared.getBundleId()

    if prefix ~= nil then
        if string.sub(prefix, -1) ~= "/" then
            prefix = prefix .. "/"
        end
        self._prefix = prefix
    end
    if id ~= nil then
        self._id = id
    end

    self._path = ROOT .. self._prefix .. self._id .. "/"
    if not file.isdir(self._path) then
        file.mkdir(self._path)
    end

    local datastore = {}
    self.datastore = datastore
    function datastore.write(table, filename, pretty_print)
        return pd.datastore.write(table, self._path .. filename, pretty_print)
    end
    function datastore.read(filename)
        return pd.datastore.read(self._path .. filename)
    end
    function datastore.delete(filename)
        return pd.datastore.delete(self._path .. filename)
    end
    function datastore.writeImage(image, path)
        return pd.datastore.writeImage(image, self._path .. path)
    end
    function datastore.readImage(path)
        return pd.datastore.readImage(self._path .. path)
    end
end

function shared.gameExists(prefix, id)
    local path = id
    if prefix ~= nil then
        if string.sub(prefix, -1) ~= "/" then
            prefix = prefix .. "/"
        end
        path = prefix .. id
    end
    return pd.file.exists(ROOT..path)
end

function shared:getPath()
    return self._path
end

function shared:open(path, mode)
    return file.open(self._path .. path, mode)
end

function shared:listFiles(path, showhidden)
    return file.listFiles(self._path .. path, showhidden)
end

function shared:exists(path)
    return file.exists(self._path .. path)
end

function shared:isdir(path)
    return file.isdir(self._path .. path)
end

function shared:mkdir(path)
    return shared.mkdir(self._path .. path)
end

function shared:delete(path, recursive)
    return file.delete(self._path .. path, recursive)
end

function shared:getSize(path)
    return file.getSize(self._path .. path)
end

function shared:getType(path)
    return file.getType(self._path .. path)
end

function shared:modTime(path)
    return file.modTime(self._path .. path)
end

function shared:rename(path, newPath)
    return file.rename(self._path .. path, self._path .. newPath)
end

file._shared = file.shared  -- Just in case
file.shared = shared