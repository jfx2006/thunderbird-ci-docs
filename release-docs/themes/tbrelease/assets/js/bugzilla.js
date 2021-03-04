/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* global $ */

import { cachedFetch, paramsCopy } from './utils.js'

const ColumnMap = {
  id: {
    title: "Bug #",
    formatter: function (bugid) {
      return `<a href="http://bugzil.la/${bugid}" target="_blank">${bugid}</a>`
    },
  },
  target_milestone: {
    title: "Milestone",
  },
  bug_severity: {
    title: "Severity",
  },
  cf_last_resolved: {
    title: "Resolved",
  },
}


// eslint-disable-next-line no-unused-vars
export default class BZQueryRunner {
  constructor(tableId) {
    this._validInputs = {
      channel_name: ["release", "beta", "nightly"],
      query_name: ["uplifts-requested", "uplifts-approved", "beta-1-fixed"],
    }
    this.channel_name = null
    this.query_name = null
    this.config = {}
    this._tableId = tableId
    this.$table = null;
    this.loadParams()
  }

  /**
   * Checks that user-provided input is valid
   * @param {String} field
   * @param {String} value
   * @returns {boolean}
   */
  validInput(field, value) {
    if (value !== null) {
      return this._validInputs[field].includes(value) || false
    }
    return false
  }

  /**
   * Get the URL parameters and populate the channel name and query name
   */
  loadParams() {
    const params = new URLSearchParams(location.search)
    const channel_name = params.get("channel")
    const query_name = params.get("query")
    if (
      this.validInput("channel_name", channel_name) &&
      this.validInput("query_name", query_name)
    ) {
      // @ts-ignore
      this.channel_name = channel_name
      // @ts-ignore
      this.query_name = query_name
      return this.loadConfig()
    } else {
      alert("Invalid page parameters given.")
      return null
    }
  }

  /**
   * Get development version for the current channel
   * @returns {Object} versions.
   */
  async getCurrentVersion() {
    if ("channels" in this.config) {
      const display_version = await this.getText(
        // @ts-ignore
        this.config.channels[this.channel_name]["next_version_url"]
      )
      if (display_version !== null) {
        const match = display_version.match(/^\d+/)
        if (match !== null) {
          return {
            display_version: display_version,
            major_version: match[0],
          }
        }
      }
    }
  }

  /**
   * Get development version for the nightly channel
   * @returns {Object} versions.
   */
  async getNightlyMajor() {
    if ("channels" in this.config) {
      const display_version = await this.getText(
        this.config.channels["nightly"]["next_version_url"]
      )
      if (display_version !== null) {
        const match = display_version.match(/^\d+/)
        if (match !== null) {
          return match[0]
        }
      }
    }
  }

  /**
   * Fetch a remote JSON file and return the results.
   * @param {String} url URL to fetch.
   * @returns {Promise.<Object>} Decoded JSON.
   */
  async getJSON(url) {
    return cachedFetch(url, 3600)
      .then((response) => response.json())
      .catch((error) => {
        console.error("Error:", error)
      })
  }

  /**
   * Fetch a remote text file and return the contents.
   * @param {String} url URL to fetch.
   * @returns {Promise.<Object>} Text.
   */
  async getText(url) {
    return cachedFetch(url, 3600)
      .then((response) => response.text())
      .catch((error) => {
        console.error("Error:", error)
      })
  }

  /**
   * Generate tracking and status flag names for a version
   * @param {String} bugzilla_version
   * @param {String} nightly_version
   */
  fixQueryVersions(bugzilla_version, nightly_version) {
    const old_beta = (Number(bugzilla_version) - 1).toString(10)
    let fc = this.fetchColumns
    let qp = this.queryParams
    const ignore_params = ["include_fields", "classification", "product"]
    for (let [index, value] of fc.entries()) {
      fc[index] = value.replace("%CHANNEL%", bugzilla_version)
    }
    for (const param in qp) {
      if (qp.hasOwnProperty(param)) {
        if (ignore_params.indexOf(param) >= 0) {
          continue
        }
        let value = qp[param]
        if (value.includes("%CHANNEL%")) {
          this.setQueryParam(param, value.replace("%CHANNEL%", bugzilla_version))
        }
        if (value.includes("%NIGHTLY%")) {
          this.setQueryParam(param, value.replace("%NIGHTLY%", nightly_version))
        }
        if (value.includes("%OLDBETA%")) {
          this.setQueryParam(param, value.replace("%OLDBETA%", old_beta))
        }
      }
    }
  }

  /**
   * Set a query parameter
   * @param {string} param Query parameter name
   * @param {string} value New value
   * @returns {boolean}
   */
  setQueryParam(param, value) {
    let channel = this.getChannel
    let qp = channel.queries[this.query_name].queryparams

    if (Object.keys(qp).includes(param)) {
      qp[param] = value
      return true
    }
    return false
  }

  /**
   * Helper to get current query parameters
   * @returns {Object} queryparams.
   */
  get queryParams() {
    if (this.query_name !== null) {
      return this.getChannel.queries[this.query_name].queryparams
    }
  }

  /**
   * Helper to get current query parameters
   * @returns {String} query title.
   */
  get queryTitle() {
    if (this.query_name !== null) {
      return this.getChannel.queries[this.query_name].description
    }
  }

  /**
   * Helper to get current query column data
   * @returns {Object} fetch_cols.
   */
  get fetchColumns() {
    if (this.query_name !== null) {
      return this.getChannel.queries[this.query_name].fetch_cols
    }
  }

  /**
   * Generate columns for the table
   * @returns {Object} columns.
   */
  get queryColumns() {
    let self = this
    let cols = this.fetchColumns

    function capitalizeFirstLetter(val) {
      return val.charAt(0).toUpperCase() + val.slice(1)
    }

    return cols.map(function (i) {
      let rv = {
        field: i,
        title: capitalizeFirstLetter(i),
        sortable: true,
      }
      if (ColumnMap[i] !== undefined) {
        for (let [key, val] of Object.entries(ColumnMap[i])) {
          rv[key] = val
        }
      }
      if (i.startsWith("cf_status_thunderbird")) {
        rv.title = `Status ${self.bugzilla_version}`
      } else if (i.startsWith("cf_tracking_thunderbird")) {
        rv.title = `Tracking ${self.bugzilla_version}`
      }
      return rv
    })
  }

  get getChannel() {
    if ("channels" in this.config) {
      if (this.validInput("channel_name", this.channel_name)) {
        // @ts-ignore
        return this.config.channels[this.channel_name]
      }
    }
  }

  /**
   * Load the configuration file as well as product details.
   */
  async loadConfig() {
    let bugzilla_version = null
    this.config = await this.getJSON("../bug_queries.json")
    const current_version = await this.getCurrentVersion()
    const nightly_major = await this.getNightlyMajor()
    if (current_version !== undefined && nightly_major !== undefined) {
      if (this.channel_name === "release") {
        bugzilla_version = `esr${current_version.major_version}`
      } else if (this.channel_name === "beta") {
        bugzilla_version = current_version.major_version.toString()
      }
      if (bugzilla_version !== null) {
        this.bugzilla_version = bugzilla_version
        this.fixQueryVersions(bugzilla_version, nightly_major)
        let query_params = this.queryParams
        query_params.include_fields = this.fetchColumns.join(",")
        this.renderFetchData()
      }
    }
  }

  /**
   * Fetch the bug list
   */
  renderFetchData() {
    if ("BUGZILLA_REST_URL" in this.config) {
      const qp = this.queryParams
      const query_params = $.param(qp, true)
      const query_url = new URL(this.config.BUGZILLA_REST_URL)
      query_url.search = query_params
      this.renderTable(query_url)
    }
  }

  /**
   * Generate a link to Bugzilla for the current query
   * @returns {URL} Link to bugzilla query
   */
  getBugzillaURL() {
    if ("BUGZILLA_URL" in this.config) {
      let qp = paramsCopy(this.queryParams)
      qp["query_format"] = "advanced"
      qp["columnlist"] = qp["include_fields"]
      delete qp["include_fields"]

      const query_params = $.param(qp, true)
      const query_url = new URL(this.config.BUGZILLA_URL)
      query_url.search = query_params
      return query_url
    }
  }

  /**
   * Render the table
   * @param {URL} query_url URL to fetch.
   */
  renderTable(query_url) {
    const bugzilla_link = this.getBugzillaURL().href
    this.$table = $(this._tableId).bootstrapTable({
      columns: this.queryColumns,
      url: query_url.href,
      idField: "id",
      toolbar: "#toolbar",
      showRefresh: true,
      showButtonIcons: false,
      showButtonText: true,
      responseHandler: function (res) {
        return res["bugs"]
      },
      onLoadSuccess: function (data, status, xhr) {
        $("#open_bugzilla").data("href", bugzilla_link)
        $("#get_data").data("href", query_url.href)
        $("#bug_count").text(`Bug count: ${data.length}`)
        $("#toolbar").removeAttr("hidden")
      }
    })
    $(`${this._tableId}-title`).text(this.queryTitle)
    $(".bug-toolbar").on("click", function() {
      const href = $(this).data("href")
      if (href)
        window.open(href)
    })
  }
}
