class HotConfig
    constructor: (@files = {})->
        @cnf = {}
        for name, file of @files
            @cnf[name] = require file
    reload: (name) ->
        delete require.cache require.resolve @files[name]
        @cnf[name] = require @files[name]
    get: (name) ->
        @cnf[name]

exports.create = (files) ->
    cnf = new HotConfig
    httpHandle = (req, res) ->
        if req.path is '__reload_config__'
            cnf.reload req.query.name
            res.send 200
    {cnf, httpHandle}