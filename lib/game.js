require("./init")
var emitter = require("./event")

var Game = function() {
    this.isStart = false
    this.isStop = true
    this.isResume = false
    this.isPause = true
    this.timer = null
    this.sprits = []
}

var gameMethods = {
    init: function() {
        this.emit("init")
    },
    start: function() {
        this.isStart = true
        this.isStop = false
        this.resume()
        this.render()
        this.emit("start")
    },
    stop: function() {
        this.isStart = false
        this.isStop = true
        this.pause()
        this.emit("stop")
    },
    pause: function() {
        this.isPause = true
        this.isResume = false
        this.cancel()
        this.emit("pause")
    },
    resume: function() {
        this.isResume = true
        this.isPause = false
        this.emit("resume")
    },
    render: function() {
        var rate = 1000 / 60
        var that = this
        function _run() {
            var sprits = that.sprits
            that.sprits = []
            for (var i = 0, len = sprits.length; i < len; i++) {
                var sprit = sprits[i]
                if (!sprit.isToRemove) {
                    var sprit = sprits[i]
                    that.sprits.push(sprit)
                    sprit.move()
                } else {
                    that.emit("sprit removed", sprit)
                    if (typeof sprit._after_remove === "function") {
                        sprit._after_remove();
                        delete sprit._after_remove
                    }
                }
            }
            if (!that.isStop)
                that.timer = requestAnimationFrame(_run)
        }
        _run()
    },
    cancel: function() {
        cancelAnimationFrame(this.timer)
    },
    add: function(sprit) {
        if (!(typeof sprit.move === 'function')) {
            throw "Sprit should have a `move` function."
        }
        sprit.isToRemove = false
        this.sprits.push(sprit)
        this.emit("sprit added", sprit)
    },
    remove: function(sprit, callback) {
        sprit.isToRemove = true
        sprit._after_remove= callback
    }
}

module.exports = emitter.extend(Game, gameMethods)
