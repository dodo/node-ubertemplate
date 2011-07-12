
class MemoryStore
    constructor: () ->
        @cache = {}

    get: (key, callback) =>
        callback?(null, @cache[key])

    set: (key, value, callback) =>
        @cache[key] = value
        callback?(null, true)

# exports

module.exports = MemoryStore
