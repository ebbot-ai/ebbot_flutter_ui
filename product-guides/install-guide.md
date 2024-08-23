# Install guide

### Install Guides on your website <a href="#install-guides-on-your-website" id="install-guides-on-your-website"></a>

For both **Modal** and **Embedded** guides you need to install the script below on the webpage the guide should appear. Replace `YOUR_COMPANY_ID` with your company UUID. You can find the script with your ID under company settings in the platform.

```html
<script type="text/javascript" src="https://headless.dialogtrail.com/static/sdk.js?id=YOUR_COMPANY_ID"></script>
```

If your guide is **Embedded** you also need to use the code below to set where you want the guide to be placed on the webpage. (You do not need this for Modal guides)

```html
<div id="dt-product-guide"></div>
```

#### Localization <a href="#localization" id="localization"></a>

To utilize localized product guides, add a `locale` query parameter to the SDK script source.

Example:

```javascript
&locale=en_US
```

_Note: If no locale is provided, the SDK will search for a suitable locale by looking at the html-tag lang property or the OpenGraph meta-tag._

### Tracking <a href="#tracking" id="tracking"></a>

#### Sales tracking <a href="#sales-tracking" id="sales-tracking"></a>

We need you to set up our sales tracking events to get the most out of ebbot. They look like this:

```typescript
/*
  items is a list of the products added to cart / purchased.
  id/groupId is the product id / group id that your transformer specifies.
  quantity is the amount of the product, this is optional.
  value is the sale price of the product.
  currency is the currency the user paid in, use the same one to group the sales up and get an overview in our dashboard, this is optional.
  ext is the external source, this is optional. When using the default head this is the placementId.
*/

// Add to cart event
window.DT.event(
  'add_to_cart',
  {
    items: [
      {
        id: string,
        groupId?: string,
        quantity: number,
        value: string | number
      }
    ],
    currency: string
  },
  ext?: { [key: string]: value}
);

// Purchase event
window.DT.event(
  'purchase',
  {
    items: [
      {
        id: string,
        groupId?: string,
        quantity: number,
        value: string | number
      }
    ],
    currency: string
  },
  ext?: { [key: string]: value}
);
```

**Important:** Make sure that you send the same **id** and **groupId** that you have connected to ebbot through the feed.

These events will send data to us so that you can view your sales in our dashboard, from there you will be able to compare the sales from different guides or placements.

You should install these events where you have set up your purchase events for Google Tag Manager or similar services.

* Still not sure how to do it? You can contact us at helpme@ebbot.ai for assistance.

### Ecommerce store integrations <a href="#ecommerce-store-integrations" id="ecommerce-store-integrations"></a>

#### Add to cart <a href="#add-to-cart" id="add-to-cart"></a>

If “Add to cart” is enabled, a button will be displayed with each product allowing users to add items directly to cart. When the button is clicked, an event of type `dt_add_to_cart` is dispatched on `window`.

Event type:

```typescript
CustomEvent<{ items: { id: string; quantity: number }[] }>
```

Listen to this event:

```typescript
window.addEventListener('dt_add_to_cart', (event) => {
  const { items } = event.detail;
  ...
});
```

#### Initiate guide with properties <a href="#initiate-guide-with-properties" id="initiate-guide-with-properties"></a>

Initiate a product guide with values from your own data layer by assigning `window.dtProductGuideInitProps` _before_ loading the SDK.

_Example:_

```typescript
window.dtProductGuideInitProps = {
  reset: false,
  args: {
    entryTags: [
      {
      weight: 1,
      inclusivity: 'INCL',
      required: true,
      condition: {
        operator: 'EQ',
        name: 'category',
        value: 'clothes'
        }
      }
    ],
    entryActions: [
      {
        type: 'set',
        id: 'ce000ed7-56a0-4d59-86cd-d085b5a1488c',
        value: 'started_guide_clothes'
      },
      {
        type: 'set',
        id: '5db36a9c-5e78-4bd6-b8af-65b92474e516',
        value: false
      }
    ]
  }
}
```

_Types:_

```typescript
{
  reset?: boolean;
  args?: {
    entryTags?: TagCondition[];
    entryActions?: Action[];
  }
}

type TagCondition = {
  // Conditions may be group with a AND/OR group as below
  condition: {
    op: 'AND' | 'OR';
    values: { op: 'EQ' | 'NEQ' | 'EXISTS'; name: string; value: string | number | boolean }[];
  };
  // 0 - 1
  weight?: number;
  inclusivity?: 'INCL' | 'EXCL';
  required?: boolean;
};

type Action = { type: 'set' | 'incr' | 'decr'; id: string } & (
  | { type: 'set'; value: string | number | boolean }
  | { type: 'incr' | 'decr'; value: number }
);
```

| Internal name | Name in builder | Description                                                                                    |
| ------------- | --------------- | ---------------------------------------------------------------------------------------------- |
| entryTags     | Attributes      | These are the attributes that we get from your product feed(s).                                |
| entryActions  | Tags            | These are internal tags used for gathering data and skipping steps without setting attributes. |

### How to install a script and/or a div on your website <a href="#how-to-install-a-script-andor-a-div-on-your-website" id="how-to-install-a-script-andor-a-div-on-your-website"></a>

_Each website and company has its own way of installing scripts and code. Therefore, these instructions are general but will hopefully help you. You will most likely find more specific instructions with your e-commerce provider._

#### Installing a script <a href="#installing-a-script" id="installing-a-script"></a>

Most websites use a third-party tool to manage their scripts, e.g. Google Tag Manager. If so, install ebbot in there, the same way you do for other scripts.

If you prefer you can instead install the script in your website’s header or footer.

#### Installing a div <a href="#installing-a-div" id="installing-a-div"></a>

Put the div where you want the embedded CTA or guide to appear on your website. Most websites allow for creating custom html elements. Create a customer html element, or similar, in the position on your website where you want the guide to appear.

#### Styling tips <a href="#styling-tips" id="styling-tips"></a>

You can change some main colors under placement defaults, these will be the same for all placements. If you want to have specific colors for a certain placement you can accomplish this by using the css editor for that placement.

We have a bunch css vars that you can change how you like, here’s a list:

```scss
--primary-color: #645ffc;
--disabled-color: #e8e8e8;
--border-color: #e3e3e3;
--background-color: white;
--text-color: #000;
--desc-color: var(--text-color);
--root-z-index: 10;

/* Spacing - Used with gap, padding and margin */
--spacing: 6px;
--spacing-x2: calc(var(--spacing) * 2);
--spacing-x3: calc(var(--spacing) * 3);
--spacing-x4: calc(var(--spacing) * 4);
--spacing-x5: calc(var(--spacing) * 5);
--spacing-x6: calc(var(--spacing) * 6);
--spacing-x7: calc(var(--spacing) * 7);
--spacing-x8: calc(var(--spacing) * 8);
--spacing-x9: calc(var(--spacing) * 9);
--spacing-x10: calc(var(--spacing) * 10);
--spacing-x11: calc(var(--spacing) * 11);
--spacing-x12: calc(var(--spacing) * 12);

/* Buttons - Options, skip, submit and restart */
--button-text-color: var(--text-color);
--button-subtitle-color: var(--desc-color);
--button-filled-color: #fff;
--button-filled-subtitle-color: var(--button-filled-color);
--button-border-radius: 4px;
--button-border-color: var(--border-color);
--button-primary-color: var(--primary-color);
--button-disabled-color: var(--disabled-color);

/* Crossroad (split) */
--crossroad-btn-border-color: var(--button-border-color);
--crossroad-btn-border-radius: var(--button-border-radius);

/* Inputs - User inputs in form steps */
--input-border-radius: 4px;
--input-title-color: var(--text-color);
--input-subtitle-color: #808080;
--input-border-color: var(--border-color);
--input-primary-color: var(--primary-color);
--input-disabled-color: var(--disabled-color);
--input-bg-color: #fcfcfc;
--input-focus-bg-color: #fff;
--input-focus-color: var(--input-primary-color);

/* Products */
--price-color: #fc4f44;
--info-container-color: #f6f6f6;
--info-container-text-color: #585858;
--product-title-color: var(--text-color);
--product-desc-color: var(--desc-color);
--product-brand-color: var(--text-color);
--product-border-color: var(--border-color);
--sale-price-color: var(--price-color);
--original-price-color: grey;
--distinct-text-color: #444;
--product-background-color: var(--background-color);
--scroll-to-product-button-box-shadow-color: var(--button-border-color);
--scroll-to-product-button-border-color: var(--button-border-color);
--scroll-to-product-button-bg-color: var(--product-background-color);

/* Modal */
--flag-color: var(--primary-color);
--flag-text-color: var(--button-filled-color);
```

When entering your css we recommend that the css structure should look something like this:

```scss
& {
  /* Put css vars here */
  --primary-color: black;
  
  /* Style the guide components under '&#dt-pg-root' to avoid using !important */
  &#dt-pg-root {
    background: white;
    & .dt-option {
      background: blue;
    }
  }
  
  /* Style the modal components under '&#dt-cta' to avoid using !important */
  &#dt-cta {
    z-index: 100;
    & .dt-cta-content {
      background: grey;
    }
  }
}
```

If these instructions were not enough, try searching for the solution through your e-commerce provider’s documentation.
