# Send events

### Socket events <a href="#socket-events" id="socket-events"></a>

You send events using `window.DT.productGuide.emit(EVENT_TYPE, DATA)`.

These are the events:

{% code overflow="wrap" %}
```javascript
/* -- This is used to initiate the product guide, productGuideId is the ID of the guide and lang is the preferred language -- */
window.DT.initProductGuide('productGuideId', { lang: 'en' });

/* -- Options is an array of UUIDs of the buttons that were pressed. -- */
window.DT.productGuide.emit('options', { options: ['uuid'] });

/* -- Inputs are an array of objects that contain the ID and value from the input. -- */
window.DT.productGuide.emit('user_input', { inputs: [{ id: 'uuid', input: 'Some value' }] });

/* -- This is used when loading more products - From is the amount you have now - To is the previous amount + the amount you want to fetch. -- */
window.DT.productGuide.emit('products', { from: 3, to: 6 });

/* -- From is the UUID of the step you want to skip from -- */
window.DT.productGuide.emit('skip', { from: 'uuid' });

/* -- To is the UUID of the step you want to undo to -- */
window.DT.productGuide.emit('undo', { to: 'uuid' });

/* -- Used to restart the guide. -- */
window.DT.productGuide.emit('init');
```
{% endcode %}

These events will send a response back, you can see them [here](received-events.md).

* The only event that will send `product_guide_products` is `products`.

### E-com tracking events

You can view the e-com tracking events [here](../install-guide.md#sales-tracking).
