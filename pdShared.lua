local pd <const> = playdate
local file <const> = pd.file

local shared = {}

function shared.getBundleId()
    return string.gsub(pd.metadata.bundleID, "^user%.%d+%.", "")
end

function shared.gameExists(prefix, id)
    if prefix ~= nil then
        if string.sub(prefix, -1) ~= "/" then
            prefix = prefix .. "/"
        end
        id = prefix .. id
    end
    return pd.file.exists(id)
end

local _prefix = ""
local _id = shared.getBundleId()
local _path = "/Shared/" .. _prefix .. _id

function shared.init(prefix, id)
    if prefix ~= nil then
        if string.sub(prefix, -1) ~= "/" then
            prefix = prefix .. "/"
        end
        _prefix = prefix
    end
    if id ~= nil then
        _id = id
    end

    _path = "/Shared/" .. _prefix .. _id .. "/"
    if not file.isdir(_path) then
        file.mkdir(_path)
    end
end

function shared.getPath()
    return _path
end

function shared.open(path, mode)
    return file.open(_path .. path, mode)
end

function shared.listFiles(path, showhidden)
    return file.listFiles(_path .. path, showhidden)
end

function shared.exists(path)
    return file.exists(_path .. path)
end

function shared.isdir(path)
    return file.isdir(_path .. path)
end

function shared.mkdir(path)
    return shared.mkdir(_path .. path)
end

function shared.delete(path, recursive)
    return file.delete(_path .. path, recursive)
end

function shared.getSize(path)
    return file.getSize(_path .. path)
end

function shared.getType(path)
    return file.getType(_path .. path)
end

function shared.modTime(path)
    return file.modTime(_path .. path)
end

function shared.rename(path, newPath)
    return file.rename(_path .. path, _path .. newPath)
end

local datastore = {}
shared.datastore = datastore

function datastore.write(table, filename, pretty_print)
    return pd.datastore.write(table, _path .. filename, pretty_print)
end

function datastore.read(filename)
    return pd.datastore.read(_path .. filename)
end

function datastore.delete(filename)
    return pd.datastore.delete(_path .. filename)
end

function datastore.writeImage(image, path)
    return pd.datastore.writeImage(image, _path .. path)
end

function datastore.readImage(path)
    return pd.datastore.readImage(_path .. path)
end

file._shared = file.shared  -- Just in case
file.shared = shared
