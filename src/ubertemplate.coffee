path = require('path')
fs = require('fs')

class UberTemplate
    constructor: (opts = {}) ->
        @engine = {}
        @store = new UberTemplate.storage[opts.store ? 'memory']

    register: (ext, exports) =>
        ext = ext.substr(1) if ext[0] is '.'
        @engine[ext] = exports

    render: (templatepath, opts, callback) =>
        @store.get templatepath, (err, template) ->
            return callback?(err) if err
            callback?(null, template(opts))

    compile: (templatepath, opts, callback) =>
        fs.stat templatepath, (err, stat) =>
            return callback?(err) if err
            compile = (_..., callback) ->
                callback?(new Error("path isnt file or directory."))
            compile = @compileDirectory if stat.isDirectory()
            compile = @compileFile      if stat.isFile()
            compile(templatepath, opts, callback)

    compileFile: (filepath, opts, callback) =>
        fs.readFile filepath, (err, data) =>
            return callback?(err) if err
            ext = path.extname(filepath).substr(1)
            unless engine = @engine[ext]
                return callback?(new Error("no template engine found."))
            template = engine.compile(data.toString(), opts)
            @store.set(filepath, template, callback)

    compileDirectory: (dirpath, opts, callback) =>
        fs.readdir dirpath, (err, files) =>
            return callback?(err) if err
            [done, error, res] = [0, {}, {}]
            for filename in files
                filepath = path.join(dirpath, filename)
                do (filepath) =>
                    @compile filepath, opts, (err, ok) -> # recursive !
                        error[filepath] = err if err
                        res[filepath] = ok
                        done++
                        if files.length is done
                            error = null unless Object.keys(error).length
                            callback?(error, res)


# load some default storages
# store should be a class with
#   get(key, callback) and
#   set(key, value, callback) as methods
UberTemplate.storage =
    memory: require('./store/memory')
    fs:     require('./store/fs')


# exports

module.exports = UberTemplate
