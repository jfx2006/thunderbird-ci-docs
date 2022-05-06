/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import { ThunderbirdProductDetails } from './product-details.js'


function Landing() {
    const calId = "jgarvd0cmlt3599e7gthhk01a8@group.calendar.google.com"
    const calKey = "AIzaSyD03H3uW38Q1GGtWADDy0lsJxxJN7luRBU"
    const RELEASE_URL = `https://www.googleapis.com/calendar/v3/calendars/${calId}/events?key=${calKey}&orderBy=startTime&singleEvents=true&timeZone=UTC`

    function capitalizeFirstLetter(val) {
        return val.charAt(0).toUpperCase() + val.slice(1)
    }

    function channel2ReleaseName(channel) {
        if (channel === "nightly") {
            return "Daily"
        } else {
            return capitalizeFirstLetter(channel)
        }
    }

    function getDateRange() {
        let start = new Date()
        let start_str = start.toISOString()
        start.setMonth(start.getMonth() + 1)
        let end_str = start.toISOString()
        return {timeMin: start_str, timeMax: end_str}
    }

    function updateUI(released_versions) {
        for (let [channel, version] of Object.entries(released_versions)) {
            const div = document.getElementById(channel)
            let inner = new DocumentFragment()
            let span = document.createElement("span")
            span.classList.add("release")
            span.textContent = channel2ReleaseName(channel)

            let a = document.createElement("a")
            a.href = `dashboard/#pollbot/thunderbird/${channel}`
            a.textContent = version.toString()

            inner.appendChild(span)
            inner.appendChild(a)
            div.appendChild(inner)
        }
    }

    function buildEventURL() {
        const range = getDateRange()
        let api_url = new URL(RELEASE_URL)
        api_url.searchParams.append("timeMin", range.timeMin)
        api_url.searchParams.append("timeMax", range.timeMax)
        return api_url
    }

    function buildUpcoming(eventData) {
        let upcomingReleases = {}
        let event
        for (event of eventData.items) {
            if (event.summary === "Thunderbird Status Meeting") {
                continue
            } else if (event.summary.startsWith("Thunderbird ")) {
                if (event.start.date !== undefined) {
                  upcomingReleases[event.summary] = event.start.date
                }
            }
        }
        return upcomingReleases
    }

    /**
     * @param {Object.<string, string>} releases
     */
    function setUpcoming(releases) {
        /* <table id="upcoming-body">
          <tr class="upcoming-release">
            <td class="upcoming-version">98.0b3</td>
            <td class="upcoming-date">February 28, 2022</td>
          </tr>
        </table> */
        let table = document.getElementById("upcoming-body")
        const fmt_options = {year: 'numeric', month: 'long', day: 'numeric', timeZone: "UTC"}
        for (let [desc, date] of Object.entries(releases)) {
            let row = document.createElement("tr")
            row.classList.add("upcoming-release")
            let version = document.createElement("td")
            version.classList.add("upcoming-version")
            version.textContent = desc
            let rel_date = new Intl.DateTimeFormat(
              navigator.language,
              fmt_options
            ).format(new Date(date))
            let date_elem = document.createElement("td")
            date_elem.classList.add("upcoming-date")
            date_elem.textContent = rel_date
            row.appendChild(version)
            row.appendChild(date_elem)
            table.appendChild(row)
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

    let api_url = buildEventURL()
    fetch(api_url.href)
        .then(async function(result)  {
            let upcomingReleases = buildUpcoming(await result.json())
            setUpcoming(upcomingReleases)
        })
        .catch((err) => {
            throw(err)
        })
}

window.addEventListener('DOMContentLoaded', () => Landing(), {once: true});
