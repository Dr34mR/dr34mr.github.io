---
layout: post
categories: thinintegration
title: Thin Office Integration BUT Cross Domain for CM23.4!
---

So ... you want to enable the Content Manager ThinOffice Integration but you are trying to have it used Cross-Domain?

Bad News: It needs a few extra steps (which i found out weren't greatly documented)
Good News: The steps are below and can be done using AzureAD! 😁

## Step 1 - Enable the Web Client to use AzureAD for Authentication

Follow the steps [here](https://content-manager-sdk.github.io/Community/233/oidc.html#oidc_azuread ) to configure your 23.4 Content Manager WebClient to use AzureAd for authentication.

![Image]({{ site.url }}assets/2024-10-25-Image1.png)

## Step 2 - portal.azure.com App Registration Updates

Jump into the AzureAD App Registration you spun up for the WebClient

### Double check the Redirect URIs

For my own application registration, there are 2x Redirect URIs for the WebClient (one with www and one without) but both go to /contentmanager/serviceapi/auth/openid

And since I'm also using this for my dekstop app, I've got urn:ietf:wg:oauth:2.0:oob added as a Desktop redirect as well

![Image]({{ site.url }}assets/2024-10-25-Image2.png)

### API Permissions

Make sure the following Delegated permissions are present: email, offline_access, openid, profile, User.Read

Make sure the status shows as Granted for your domain. If not, there is a button to 'Grant admin consent' next to the 'Add Permission' button

![Image]({{ site.url }}assets/2024-10-25-Image3.png)

### Expose an API

In the Expose an API tab, up the top, where there is an Application ID URI, press 'Add'. This should auto fill in an api:// URI based on the client ID of the application registration (we will need this later).

![Image]({{ site.url }}assets/2024-10-25-Image4.png)

## Step 3 - adfs_config.xml

We need to make sure that in the ThinOffice Roaming Directory (C:\Users\Scotty\AppData\Roaming\Micro Focus\Content Manager\OfficeIntegration) we create an adfs_config.xml with the following details (NB. A 'blank' one of these can be found in your WebClients ADFS directory C:\Program Files\Micro Focus\Content Manager\Web Client\ADFS) 

How you deploy this out to end users is up to yourself.

![Image]({{ site.url }}assets/2024-10-25-Image5.png)

![Image]({{ site.url }}assets/2024-10-25-Image6.png)

The **clientAuthority** is the AuthorityURL found from your Application Registrations Endpoint for this organizational directory only (App Registraion -> Overview -> Endpoint Button up the top)

![Image]({{ site.url }}assets/2024-10-25-Image7.png)

![Image]({{ site.url }}assets/2024-10-25-Image8.png)

The **clientResourceUri** and **clientID** is your Azure App Registraion Client ID (same value for both)

The **clientReturnUri** is **urn:ietf:wg:oauth:2.0:oob**

## Step 4 - preferences

In the same directory as the adfs_config.xml open up the preferences file in your favourite notepad editor.

![Image]({{ site.url }}assets/2024-10-25-Image9.png)

Fill in the RMClientURL property. It needs to point to the landing page for your CM Web Client (note, no ending slash)

![Image]({{ site.url }}assets/2024-10-25-Image10.png)

## Step 5 - Update the WebClient hprmServiceAPI.config

Now back onto the WebClient server, open up the mprmServiceAPI.config file. Find the existing 'openIdConnect add' stubb and add an additional value entry for appIdURI (CASE SENSITIVE) as per below

![Image]({{ site.url }}assets/2024-10-25-Image11.png)

This is the same value in the 'Exponse an API' in AzureAD with the Application ID URI

## Step 6 - PRAY 🙏 and give it a go

Now, when I open Word and click on 'New Document' I'm now presented with a login screen. Once logged in, the Integration should light up.

![Image]({{ site.url }}assets/2024-10-25-Image12.png)

When Word is next launched, it should now also auto-log-in remembering your previous credentials. 

If you ever need to remove the saved credentials from the machine they are saved in the same Roaming directory as ToekCache.dat. Deleting this will clear the saved credentials.

![Image]({{ site.url }}assets/2024-10-25-Image13.png)
