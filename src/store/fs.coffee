fs = require('fs')
path = require('path')

class FileSystemStore
    constructor: (@path) ->

    get: (key, callback) =>
        # using nodejs' require cache
        callback?(require(path.join(@path, key)))

    set: (key, value, callback) =>
        data = "module.exports=#{value};"
        fs.writeFile path.join(@path, key + ".js"), data, (err) ->
            callback?(err, true)

# exports

module.exports = FileSystemStore
