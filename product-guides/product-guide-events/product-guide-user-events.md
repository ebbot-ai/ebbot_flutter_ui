# Product guide user events

### Prerequisites

You need to have our SDK installed on your site.\
\
You need to enable 'Send events to the page window' in the app:\
![](<../../.gitbook/assets/image (61).png>)\
You can enable it under 'Product guides' -> 'Placements' -> 'Edit default'.

### Event type

We send a custom event to the window object, it looks like this:

```typescript
typescript
type CustomEventType =
  | 'init'
  | 'load_more_products'
  | 'restart'
  | 'skip'
  | 'undo'
  | 'option'
  | 'form'
  | 'form_email'
  | 'form_phone'
  | 'form_other'
  | 'prod_click'
  | 'recommendation_receive'
  | 'view'
  | 'placement_load'
  | 'placement_view'
  | 'modal_cta_click'
  | 'flag_click'
  | 'split_click';

type CustomEvent<T extends CustomEventType = CustomEventType> = { type: T;
  stepId?: string;
  productGuideId?: string;
  placementId?: string } & (
  T extends 'skip'
  ? { type: 'skip'; value: { from: string } }
  : T extends 'undo'
  ? { type: 'undo'; value: { to: string } }
  : T extends 'option'
  ? { type: 'option'; value: { options: { uuid: string; title: string }[]; clicked: string[] } }
  : T extends 'prod_click'
  ? { type: 'prod_click'; value: { name: string; pid: string; resultName: string; suuid: string } }
  : T extends 'recommendation_receive'
  ? { type: 'recommendation_receive'; value: { prodCount: number; name: string; productIds: string[] } }
  : T extends 'view'
  ? { type: 'view'; value: { name: string } }
  : T extends 'form_email'
  ? { type: 'form_email'; value: string }
  : T extends 'form_phone'
  ? { type: 'form_phone'; value: string }
  : T extends 'form_other'
  ? { type: 'form_other'; value: Record<string, string | number | boolean> }
  : T extends 'form'
  ? { type: 'form'; value: Record<string, string | number | boolean> & { email?: string; phone?: string } }
  : { type: T });
```

### How to use

We send a custom event to the window object called `ebbot_widget_event`.\
You need to add an event listener to your window object to use the event.\
It should look something like this:

```javascript
const ebbotEventHandler = (event) => {
  // Extract "detail" from the "event"
  // "detail" is the type specified above
  const { detail } = event;
  
  /* Your logic here */
};

window.addEventListener("ebbot_widget_event", ebbotEventHandler);

window.addEventListener("beforeunload", () => {
  window.removeEventListener("ebbot_widget_event", ebbotEventHandler);
});
```

### Note

The `recommendation_receive` event will not send the complete products, but only the IDs.\
If you want more information on the product it's recommended to use the event stream described on [Received events](received-events.md) page.

The name variable is generally the name of the step or option given in the guide builder.
