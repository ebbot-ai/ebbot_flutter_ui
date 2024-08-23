# SharePoint API

### Create an app

Ebbot utilizes the Microsoft Graph API to fetch SharePoint content and convert it to Ebbot documents for EbbotGPT to generate responses from. In order to keep the content secure, our SharePoint scraper must be granted permissions to read the content of sites and pages. Each client therefore needs to create an app in their Microsoft Entra environment which has Full Control permissions to the SharePoint sites and pages in question. Ebbot has no control over this app, it will only be used to grant Ebbot read permissions to the selected sites.

&#x20;[Follow these steps to set up such an app.](create-app-with-sites.fullcontrol.all-permission-in-azure.md)

### Give Ebbot permission to read

When a FullControl app is in place, the app needs to grant the Ebbot app \`read\` permissons to each individual site that should be scraped. This process involves several steps to get everything working, and to help with this, we have created a Postman Collection that contains all the necessary API calls needed.&#x20;

[Follow this guide to import and use the Postman Collection](ebbot-sharepoint-postman-guide.md)

### Authenticate in Ebbot

When all steps above are complete, you should be able to create a new source in Ebbot using your content from SharePoint. To do this, first log in to Ebbot&#x20;

Then, in the left sidebar, navigate to EbbotGPT -> Knowledge

Click the "Sources" tab and the "Create new" button in the top left.&#x20;

Select SharePoint API as type, then click "Authenticate with SharePoint". This opens a dialog box where you need to log in to the Microsoft Azure portal with an account that has permissions to your FullControl app.

Done! After Ebbot completes its run, you should see documents in Ebbot corresponding to your SharePoint sites!

<figure><img src="../../../../.gitbook/assets/image (4).png" alt=""><figcaption></figcaption></figure>



{% content-ref url="create-app-with-sites.fullcontrol.all-permission-in-azure.md" %}
[create-app-with-sites.fullcontrol.all-permission-in-azure.md](create-app-with-sites.fullcontrol.all-permission-in-azure.md)
{% endcontent-ref %}

{% content-ref url="ebbot-sharepoint-postman-guide.md" %}
[ebbot-sharepoint-postman-guide.md](ebbot-sharepoint-postman-guide.md)
{% endcontent-ref %}
