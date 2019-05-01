/*
 *  asapi/lv
 *  Copyright (C) 2017  tynn
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
function π(lib, host, loadingSrc) {
  history.replaceState(lib, "Android SDK API level - " + lib, "")
  function updateImgAlt(img, path) {
    var xhttp = new XMLHttpRequest()
    xhttp.onreadystatechange = () => {
      if (xhttp.readyState != 4) return
      let api = xhttp.status == 200 ? xhttp.responseText : "unknown"
      img.alt = "API level " + api
      img.src = path + "@svg"
    }
    xhttp.open("GET", path + "@txt", true)
    xhttp.send()
  }
  function updatePage(library) {
    document.title = "Android API level - " + library
    var path = library.replace(/:/g, "/")
    if (path.endsWith("/")) path = path.substring(0, path.length-1)
    if (path.endsWith("/+")) path = path.substring(0, path.length-2)
    if (!path.startsWith("/")) path = "/" + path
    var a = document.getElementById("url")
    a.innerText = host + path + "@svg"
    a.href = path + "@svg"
    a = document.getElementById("badge")
    a.href = path
    var img = a.firstElementChild
    img.src = loadingSrc
    img.alt = "API level loading"
    updateImgAlt(img, path)
    return path
  }
  window.onpopstate = e => updatePage(e.state)
  document.forms[0].onsubmit = e => {
    var library = document.forms[0][0].value
    history.pushState(library, document.title, updatePage(library))
    return false
  }
}
