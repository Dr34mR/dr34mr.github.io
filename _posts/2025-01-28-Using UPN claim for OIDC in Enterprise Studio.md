---
layout: post
categories: admin
title: Using UPN Claim instead of Email for Azure OpenID
---

Got asked today about if it was possible to swap from using the email as their login to instead use the UPN in Azure.

Reason for this is the email address often goes through changes when staff change names or staff move to different areas within the organisation (due to different domains).

Outside of changing the logins of the users in Content Manager to use the UPN address instead, the updates in Azure to the Application Registration and the changes in Enterprise Studio to ensure the UPN comes back are straight forward.

### Azure App Registration Changes

Underneath the application registrations 'Token configuration' menu, add the following optional claim. Make sure the Token Type is ID (not Access or SAML).

![Image]({{ site.url }}assets/2025-01-28-Image1.png)

Within the API permissions, make sure the Delegated Profile permission has been added.

![Image]({{ site.url }}assets/2025-01-28-Image2.png)

### TRIM Enterprise Studio

Within Enterprise Studio, jump into the OpenID Authentication tab (may be under right click ➡ properties, or may be under right click ➡ authentication)

Update the Identity scopes to include 'profile' as per the screenshot

![Image]({{ site.url }}assets/2025-01-28-Image3.png)

Update the Identity claim from 'email' to 'upn' as per the screenshot

![Image]({{ site.url }}assets/2025-01-28-Image4.png)

Hit the Test Authentication button and try logging in. Note, for the login to the provider, you may still require to use the primary email for autentication, then the UPN will be what is returned from the provider to Content Manager.

![Image]({{ site.url }}assets/2025-01-28-Image5.png)

If the new claim comes back OK you will see a success message returned with the UPN claim value for this test user.

![Image]({{ site.url }}assets/2025-01-28-Image6.png)

When ready, Save + Deploy to commit the changes to the workgroup pool.

> ⚠ Warning - As always, changes should be first tested in a non-production environment to verify it works as expected
