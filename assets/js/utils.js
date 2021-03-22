/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* Based on https://www.sitepoint.com/cache-fetched-ajax-requests/ */

export const cachedFetch = (url, options) => {
    let expiry = 5 * 60 // 5 min default
    if (typeof options === "number") {
        expiry = options
        options = undefined
    } else if (typeof options === "object") {
        expiry = options.seconds || expiry
    }

    const fetchUrl = new URL(url, import.meta.url)

    const cacheKey = fetchUrl.href
    const cacheTS = `${cacheKey}:ts`
    let cached = localStorage.getItem(cacheKey)
    let whenCached = localStorage.getItem(cacheTS)
    if (cached !== null && whenCached !== null) {
        let age = (Date.now() - whenCached) / 1000
        if (age < expiry) {
            console.log(`Using cache for ${cacheKey}`)
            let response = new Response(new Blob([cached]))
            return Promise.resolve(response)
        } else {
            // We need to clean up this old key
            console.log(`Clearing cache for ${cacheKey}`)
            localStorage.removeItem(cacheKey)
            localStorage.removeItem(cacheTS)
        }
    }

    return fetch(fetchUrl, options).then((response) => {
        // let's only store in cache if the content-type is
        // JSON or something non-binary
        if (response.status === 200) {
            let ct = response.headers.get("Content-Type")
            if (ct && (ct.match(/application\/json/i) || ct.match(/text\//i))) {
                response
                    .clone()
                    .text()
                    .then((content) => {
                        localStorage.setItem(cacheKey, content)
                        localStorage.setItem(cacheTS, Date.now().toString())
                    })
            }
        }
        return response
    })
}

export const cacheClearKey = (cacheKey) => {
    const cacheTS = `${cacheKey}:ts`
    localStorage.removeItem(cacheKey)
    localStorage.removeItem(cacheTS)
}

/**
 * It's deep enough copy to work for our purposes
 */
export const paramsCopy = (obj) => {
    let newObject = {}
    const keys = Object.keys(obj)
    for (let i = 0; i < keys.length; i++) {
        const key = keys[i]
        if (Array.isArray(obj[key])) {
            newObject[key] = Array.from(obj[key])
        } else {
            newObject[key] = obj[key]
        }
    }
    return newObject
}

export default { cachedFetch, cacheClearKey, paramsCopy }