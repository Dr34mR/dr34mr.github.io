---
layout: post
categories: powershell
title: PS1 to remove RecRelationships based on CSV
---

Every now and then I get asked to whip up a quick script which I'm more than happy to do. Especially when doing things in bulk isn't always possible through the desktop client.

Now for the script, my main go-to's are either VBA, which I write in the back of an excel spreadsheet, or PowerShell. 

The choice between the two usually depends on if a client site allow Excel VBA macros to be run, or allows powershell scripts to be run. This is as each client site typically has a different security policy.

For most of my powershell scripts, they tend to be along the lines of connect to a dataset, loop through a CSV, and then do something to either records or locations based on the values in the CSV.

Below you will find my some sample powershell to remove record relationships from a CSV.

This powershell contains my current boilerplate of loading the SDK, connecting to a DB, loading the CSV file, looping through the entries, and writing out values both to console and to a log file.

Sample CSV layout:

![Image]({{ site.url }}assets/2024-10-31-Image1.png)

Sample Record Prior to Change:

![Image]({{ site.url }}assets/2024-10-31-Image2.png)

Sample Output:

![Image]({{ site.url }}assets/2024-10-31-Image3.png)

Sample Log File that gets created:

![Image]({{ site.url }}assets/2024-10-31-Image4.png)

Sample PS1 script can be found [here]({{ site.url }}assets/2024-10-31-RemoveRelationships.ps1)

Sample CSV that this script used can be found [here]({{ site.url }}assets/2024-10-31-RemoveRelationships.csv)

> ⚠ Warning - As always, scripts should first be run in a non-production environment to verify they work as intended
