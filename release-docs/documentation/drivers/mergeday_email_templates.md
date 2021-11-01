title: Merge Day Emails
slug: mergeday_email_templates
date: 2021-11-01 14:24:25 UTC
type: text
template: emails.tmpl

# Announcement Email

_Send this email the morning of the merge. Be sure to check whether the
Mozilla merges have finished and adjust the first paragraph accordingly._

---

**Subject:** Thunderbird beta merge for {{% today %}} (c-c -> {{% milestone nightly %}} / c-b -> {{% milestone beta %}})

Hello!

I’ll be doing the beta merge today. The Firefox merges **have/have not** completed.

comm-central is going to version {{% milestone nightly %}}, and comm-beta to {{% milestone beta %}}.

The merge will be performed via automation.

I’ll keep people up to date by replying to this email:

  * Email before merge begins
  * Close the trees
  * Perform the merge
  * Email after the merge
  * Re-open comm-central, set comm-beta to approval needed

Please let me know if you have any questions or comments.

Thanks,

---

# Conclusion Email

_Send this email after you've completed the work._

---

**Merges are finished.**

Thunderbird {{% milestone beta %}}beta1 will be built once the Firefox build has
been tagged in Mercurial.

comm-beta:

  * **TREEHERDER LINK**

comm-central:

  * **TREEHERDER LINKS (3)**

shipit:

  * **SHIPIT PULL REQUEST LINK**

documentation:

  * No changes

current tree status:

  * comm-beta: <span style="weight:900; color:#f0ad4e">APPROVAL REQUIRED</span>
  * comm-central: <span style="weight:900; color:#5cb85c">OPEN</span>

---
