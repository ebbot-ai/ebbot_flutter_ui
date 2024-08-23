---
description: >-
  This guide explains how to set up a Klaviyo integration which sends a product
  recommendation email when a customer who has provided ebbot with their email
  address completes a product guide.
---

# Klaviyo integration

> Note: Currently, the above functionality applies to every product guide on your account and to every product recommendation, even if it’s on a intermediate step.

### Webhook <a href="#webhook" id="webhook"></a>

Log in to the ebbot platform and click on your profile picture and _company settings_. Under webhooks, create a new webhook. Select _product recommendation_ as the trigger and _email_ as the required user value.

Paste `https://a.klaviyo.com/api/track` in the request URL field, and select `POST` as the method. Authorization type should remain none.

Paste the following code into the webhook _body_ field and replace `YOUR_PUBLIC_API_KEY_HERE` with your Klaviyo public API key. You can find your Klaviyo public API key by going to Klaviyo, clicking on your profile picture, selecting _account_, _settings_ and then _API keys_.

```
{
    "token": "YOUR_PUBLIC_API_KEY_HERE",
    "event": "ebbot_products",
    "customer_properties": {
        "$email": "{{user_external_email}}",
        "source": "ebbot"
    },
    "properties": {
        "items": {{product_ids}}
    }
}
```

Now, complete a product guide (on your website or in a preview) where you enter your email address and receive a product recommendation. This needs to be done in order for Klaviyo to receive at least one `dt_products` event.

### Email template <a href="#email-template" id="email-template"></a>

In Klaviyo, go to _Email Templates_ and create a new template. Design your email template however you want. Create a text block and place it where you want the product recommendation to display. Select the text block, switch to _source code_ and **replace** the content with the code below. Make sure to click the _source code_ toggle again to save your changes.

```
<div>
<div class="container">{% raw %}
{% for id in event.items %} {% catalog id %}
<div class="product"><img src="{{ catalog_item.featured_image.full.src }}" />
<p>{{ catalog_item.title }}</p>
<p>{% currency_format catalog_item.metadata|lookup:"price" %}</p>
<a href="{{ catalog_item.url }}" class="btn">Buy</a></div>
{% endcatalog %} {% endfor %}
{% endraw %}</div>
<style>
  .container {
    display: grid;
    grid-template-columns: repeat(2, minmax(auto, 1fr));
    gap: 8px;
  }
  a.btn {
    background: #197bbd;
    color: white;
    padding: 4px 8px;
    border-radius: 2px;
    width: fit-content;
    margin: 0 auto;
    text-decoration: none;
  }
  .product {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 8px;
    gap: 8px;
  }
  .product p {
    padding: 0;
  }
  @media only screen and (max-width: 660px) {
    .container {
      grid-template-columns: minmax(auto, 1fr);
    }
  }
</style>
</div>
```

### Flow <a href="#flow" id="flow"></a>

Go to _flows_, click on _create flow_ and then _create from scratch_. After naming your flow, select _metric_ as the trigger and then `dt_products` as the trigger action. Click on _done_, connect the _email_ action to the newly created trigger and then click on _configure content_. Click on _select template_, then _my templates_ and then choose the email template you created. Configure the sender name, subject and sender email address. Click on _done_, then _review and turn on_ to enable the flow.

> Note: If you can’t select the `dt_products` event as the trigger action, make sure you’ve set up the webhook correctly and completed a guide at least once as described under Webhooks.
