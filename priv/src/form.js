// Copyright 2017 Christian Schmitz
// SPDX-License-Identifier: AGPL-3.0-or-later

π = (lib, host, loadingSrc) => {
    function getPageTitle(lib) {
        let title = "Android SDK API level"
        return lib ? title + " - " + lib : title
    }

    history.replaceState(lib, getPageTitle(lib), "")

    function updateImgAlt(img, path) {
        let xhr = new XMLHttpRequest()
        xhr.onload = () => {
            let api = xhr.status == 200 ? xhr.responseText : "unknown"
            img.alt = "API level " + api
            img.src = path + "@svg"
        }
        xhr.open("GET", path + "@txt", true)
        xhr.send()
    }

    function updatePage(lib) {
        document.title = getPageTitle(lib)
        let path = lib.replace(/:/g, "/")
        if (path.endsWith("/")) path = path.substring(0, path.length - 1)
        if (path.endsWith("/+")) path = path.substring(0, path.length - 2)
        if (!path.startsWith("/")) path = "/" + path
        let a = document.getElementById("url")
        a.innerText = host + path + "@svg"
        a.href = path + "@svg"
        a = document.getElementById("badge")
        a.href = path
        let img = a.firstElementChild
        img.src = loadingSrc
        img.alt = "API level loading"
        updateImgAlt(img, path)
        return path
    }

    window.onpopstate = e => updatePage(e.state)
    document.forms[0].onsubmit = e => {
        let library = document.forms[0][0].value
        history.pushState(library, document.title, updatePage(library))
        return false
    }
}
