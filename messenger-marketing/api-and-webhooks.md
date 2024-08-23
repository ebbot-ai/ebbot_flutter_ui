---
description: These instructions are only for Messenger customers
---

# API & webhooks

## Webhooks <a href="#webhooks" id="webhooks"></a>

Webhooks allow you to receive emails and/or HTTP requests when triggered by events on the Ebbot platform.

The triggers include:

* `SUBSCRIBE` is triggered when a Facebook Messenger user subscribes to your page.
* `UNSUBSCRIBE` is triggered when a Facebook Messenger user unsubscribes from your page.
* `VARIABLE_UPDATED` is triggered when a user sets or updates a variable, you also need to specify which variable(s) you want to listen to.
* `DATA_RECEIVED` is triggered when a messenger user enters their email or phone number.

You may select one or more of the following data as requirements for a webhook to be triggered.

* `EMAIL` is the user’s email address.
* `TEL` is the user’s phone number.

For example, you may create a webhook triggered by the `VARIABLE_UPDATED` trigger but you only want it to be triggered if Ebbot has the user’s email address. In order to achieve this, you can set `EMAIL` as a requirement.

![image](https://user-images.githubusercontent.com/5666717/153161294-dcc30f7a-ee03-4be7-af78-73d86b86ced3.png)

### Email <a href="#email" id="email"></a>

Enter the target email addresses that the email should be sent to. You may set the subject and content to anything you want including placeholders (see below) or leave them blank for an automatically generated email.

![image](https://user-images.githubusercontent.com/5666717/153161525-fc352969-dde4-4840-ac44-11fadc8f9292.png)

### Request <a href="#request" id="request"></a>

Specify the URL, method and body you want to use, optionally along with authentication. Both the URL and body may include placeholders (see below).

![image](https://user-images.githubusercontent.com/5666717/153161465-8de83566-fc22-421c-bc71-2e86a1da3dcb.png)

You can test your request by clicking on **Done**. The request will be sent according to your specification with example placeholder values.

Example URL: `https://app.dialogtrail.com/users/{{user_external_email}}/tags`

Example Body:

```
{
  "tag_name": "{{variable.name}}",
  "tag_value": "{{variable.value}}"
}
```

### Placeholders <a href="#placeholders" id="placeholders"></a>

Placeholders can be used for both emails (subject and body) and HTTP requests (URL and body).

Which placeholders that are available depend on the trigger type.

#### `SUBSCRIBE`, `UNSUBSCRIBE` and `DATA_RECEIVED` <a href="#subscribe-unsubscribe-and-data_received" id="subscribe-unsubscribe-and-data_received"></a>

* `{{user_external_email}}` the user’s email
* `{{user_external_phone}}` the user’s phone number
* `{{user_card_url}}` link to the user’s card on Ebbot
* `{{variable_uuid}}` (where variable\_uuid is replaced with a tag UUID, for example `{{c733b87e-8ad4-4a41-91f7-ac8d56e69515}}`) - the string value of the tag for the user.

#### `VARIABLE_UPDATED` <a href="#variable_updated" id="variable_updated"></a>

* All above and additionally:
* `{{variable.name}}` the variable name
* `{{variable.name.no_spaces}}` the variable name without spaces
* `{{variable.value}}` the variable value
* `{{variable.value.no_spaces}}` the variable value without spaces
* `{{variable.value.boolean}}` the variable value as a boolean
* `{{variable.value.integer}}` the variable value as an integer

#### `PRODUCT_RECOMMENDATION` <a href="#product_recommendation" id="product_recommendation"></a>

* The three first and additionally:
* `{{product_ids}}` a JSON array with the product ids (suitable for HTTP request JSON bodies)
* `{{product_ids_string}}` a comma-separated list of the product ids
* `{{product_guide_id}}` the product guide id
* `{{product_guide_name}}` the product guide name

***

1. Currently, product recommendation webhooks are sent on every recommendation in the **last step** for **every guide**. If your guides receive a lot of traffic, it may be unsuitable to use the email webhook type. [↩](https://docs.dialogtrail.com/pages/sdk/webhooks\_api/webhooks\_api.html#fnref:1)
