function Vector(vx, vy, ax, ay) {
    this.vx = vx || 0
    this.vy = vy || 0
    this.ax = ax || 0
    this.ay = ay || 0
}

Vector.prototype.update = function() {
    this.vx += this.ax
    this.vy += this.ay
}

module.exports = Vector
