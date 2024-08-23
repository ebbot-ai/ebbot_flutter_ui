---
description: >-
  These instructions are exclusively for the Product Guide platform and do not
  apply to the chatbot or live chat platform.
---

# GA4 integration

### Prerequisites

Before using our Google Analytics 4 (GA4) integration, make sure the following two requirements have been installed and are actively running on your website.

1. Your GA4 needs to have an active data stream for the web setup. If you don't have a data stream, you can follow [<mark style="color:blue;">this guide</mark>](https://support.google.com/analytics/answer/9304153#stream\&zippy=%2Cweb) to create one.
2. All GA4-related code have to be installed on your website. If you're unsure whether it has been added, you can perform a quick inspection by following these steps:
   1. Right-click anywhere on the page and choose "Inspect."
   2. In the newly opened view, click on the "Console" tab located at the top.
   3. Type 'gtag' in the console and press Enter.
   4. If the console returns an error, it means the code is missing, and you'll need to follow the instructions in [this guide](https://support.google.com/analytics/answer/9304153#add-tag\&zippy=%2Cadd-the-google-tag-directly-to-your-web-pages) to add it to your site.

### What do we send?

We send all kinds of events, such as loading a placement, user responses to questions, receiving product recommendations, and numerous others.\
\
When you enable GA4 in the placement defaults, found [<mark style="color:blue;">here</mark>](https://app.dialogtrail.com/product\_guides/placements/defaults/), you should start seeing events called `ebbot_product_guide` in your real-time data report. To prevent your reports from being cluttered with events, all our events are sent under a single designated name.

### How can I see specific events?

This will require some work inside your GA4 admin dashboard. After 24h you can start seeing our events in your reports. To get a good view of what is going on inside the guides, you will have to create [<mark style="color:blue;">Custom dimensions</mark>](https://support.google.com/analytics/answer/10075209?hl=en) for our parameters. We send 3 custom parameters that can be turned into dimensions:

1. 'ebbot\_event\_action'. This is what action was made, for example: 'Restarted guide' and 'Undid from: \<question id>'
2. 'ebbot\_event\_label'. This is the label for the event, for example: 'Ebbot Placement CTA Click' and 'Ebbot product guide - Step: \<question id> - Placement: \<placement id>'
3. 'ebbot\_non\_interaction'. This is if the event is a user interaction (false or not defined) or an automated event (true)

After creating these custom dimensions you can start using the events. It can take up to 48h before you start seeing events after creating the dimensions. But don't worry, no data will be lost.

### Tips and tricks

Choose names that accurately represent the custom dimensions, we recommend using the same name but starting each word with a capitalized letter and using spaces instead of '\_'. \
Eg. 'ebbot\_event\_action' becomes 'Ebbot Event Action'.\
\
If you're unsure how to use the Ebbot events to visualize data from the guide in your GA4 you can start by going into one of the tabs in GA4 and then clicking on 'Add comparison'.

<figure><img src="../.gitbook/assets/image (110).png" alt=""><figcaption></figcaption></figure>

Add the custom dimension 'Ebbot Event Action':

<img src="../.gitbook/assets/image (111).png" alt="" data-size="original">\
\
Here are a couple of events that you can use:

* **Received Recommendation** - When a user reaches the result step in a guide
* **Click Option** - When a user clicks an option button in a guide
* **DT click product** - When a user clicks on a product in a guide
* **Restarted guide** - When a user clicks on the 'restart guide'-button in the guide
* **Init product guide** - When a guide has been loaded  &#x20;

Use these comparisons/filters on any tab in GA4 to see how the guide performs.

Other:

* Event name 'contains' 'ebbot\_product\_guide'. This will ensure that only our events are being counted in this.
* The new custom dimensions should exclude 'does not contain' '(not set)', this will exclude faulty data that might have sneaked its way into your GA4. (It's worth noting that '(not set)' on 'ebbot\_non\_interaction' is the same as false, so a filter on that could be unnecessary.)
