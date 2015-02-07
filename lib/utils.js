
function $(selector) {
    var doms = document.querySelectorAll(selector)
    if (doms.length === 1) return doms[0]
    return doms
}

function extend(constructor, prototype) {
    var Super = this
    function Sub() {constructor.apply(this, arguments)}
    function F() {}
    F.prototype = Super.prototype
    Sub.prototype = new F()
    for (var prop in prototype) {
        Sub.prototype[prop] = prototype[prop]
    }
    Sub.prototype.constructor = constructor.name
    Sub.name = constructor.name
    Sub.extend = extend
    return Sub
}

function sendAjax(method, url, obj, callback) {
    var xhr = new XMLHttpRequest()
    xhr.open(method, url, true)
    if (!obj)
        obj = null
    xhr.setRequestHeader("Content-Type" ,"application/x-www-form-urlencoded")
    xhr.send(obj)
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4) {
            if (typeof(callback) === "function") {
                responseText = JSON.stringify(xhr.responseText)
                callback(JSON.parse(responseText))
            }
        }
    }
}

module.exports = {
    extend: extend,
    $: $,
    sendAjax: sendAjax
}