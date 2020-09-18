/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import { ThunderbirdProductDetails } from './product-details.js'

function Landing() {
    function capitalizeFirstLetter(val) {
        return val.charAt(0).toUpperCase() + val.slice(1)
    }

    function updateUI(released_versions) {
        for (let [channel, version] of Object.entries(released_versions)) {
            const div = document.getElementById(channel)
            let inner = new DocumentFragment()
            let h2 = document.createElement("h2")
            h2.innerHTML = capitalizeFirstLetter(channel)

            let a = document.createElement("a")
            a.href = "release-dashboard/#pollbot/thunderbird/beta"
            a.innerHTML = version.toString()

            inner.appendChild(h2)
            inner.appendChild(a)
            div.appendChild(inner)
        }
    }

    const versions = new ThunderbirdProductDetails()

    versions.productVersions()
        .then((v) => {
            updateUI(v)
        })
        .catch((err) => {
            alert(err)
        })
}

window.addEventListener('DOMContentLoaded', () => Landing(), {once: true});
