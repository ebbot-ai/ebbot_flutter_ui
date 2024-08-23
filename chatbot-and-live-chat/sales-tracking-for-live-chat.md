---
description: >-
  This sales tracking is for chatbot and live chat. Tracking related to product
  guides can be found under the Product guides tab.
---

# Sales tracking for live chat

In order to track sales and add-to-cart events on products that have been recommended in the chat you need to set up your website to send purchase and add-to-cart events to the Ebbot script.

First, you need to add a row of code to the Ebbot script in order to activate the tracking. The following script is the ebbot script with an added row: tracking: true. Don't replace your current script with the one below as it's missing your botId and setting for storage on ovh. &#x20;

<pre data-overflow="wrap"><code>&#x3C;script>
<strong>  window.Ebbot = {
</strong>   botId: '&#x3C;BOT ID>',
    ovh: true / false,
    tracking: true,
    };
   &#x3C;/script>
   &#x3C;script>!function(t){var e="init-js-widget";if(!t.getElementById(e)){var i=t.createElement("script");i.id=e,i.src="https://ebbot-v2.storage.googleapis.com/ebbot-web/init.js?t="+Math.random(),t.querySelector("body").appendChild(i)}}(document);&#x3C;/script>
</code></pre>

These are the available event types: `'ecom-atc' | 'ecom-purchase' | 'ecom-visit'`

The type looks like this:

```
type EventType = 'ecom-atc' | 'ecom-purchase' | 'ecom-visit';
export type EventItem = {
  id: string;
  groupId?: string;
  quantity?: number;
  value: number | string;
};
export type Event<T extends EventType = EventType> = {
  type: T;
} & (T extends 'ecom-atc'
  ? {
      type: 'ecom-atc';
      items: EventItem | EventItem[];
      currency: string;
    }
  : T extends 'ecom-visit'
  ? {
      type: 'ecom-visit';
      items: EventItem | EventItem[];
    }
  : T extends 'ecom-purchase'
  ? {
      type: 'ecom-purchase';
      items: EventItem[];
      currency: string;
    }
  : never);
```

Once that has been added on your end you can use the following to push the events to the ebbot script:

{% code overflow="wrap" %}
```
window.eb_tr.push({type: '<TYPE YOU WANT>', items: [...<LIST OF PRODUCTS>], currency: '<CURRENCY, not required for 'ecom-visit'>'})
```
{% endcode %}
