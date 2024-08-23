# Received events

### Difference between this and [Product guide user events](product-guide-user-events.md)

This page describes how to use our general event stream that does not send what a user does in the guide or placement.\
The primary use cases for this solution are:

* When using our script as a headless solution.
* When you want an in-depth look at what recommendations a user received.

### Subscribe to events

To receive events, you must subscribe to our event stream using our SDK.

```javascript
window.DT.subscribe('product_guide', (e) => {
    switch (e.type) {
      case 'product_guide_step':
        /* -- handle the event -- */
        break;
      case 'product_guide_products':
        /* -- handle the event -- */
        break;
    }
  });
```

When receiving the event `product_guide_step` the event type looks like this:

{% code overflow="wrap" %}
```typescript
type EventValue = {
  type: 'product_guide_step';
  /* -- This is translations that get auto-filled with the default language if you are missing translations for something in the selected language -- */
  generalLocalizations: {
    /* -- These are labels for the products, you need to calculate where to show them  -- */
    bestDeal?: string;
    bestMatch?: string;
    lowestPrice?: string;

    /* -- This has to do with the products -- */
    loadMore?: string;
    productCta?: string;
    secondaryTitle?: string;

    /* -- Some buttons --*/
    restartButton?: string;
    skipButton?: string;
    submitButton?: string;
  };

  /* -- Some general settings */
  setting: {
    /* -- The default language -- */
    fallbackLang: string;

    /* -- Should show load more products -- */
    loadMore: boolean;

    /* -- Should show progress bar -- */
    progressbar: boolean;

    /* -- Settings that are for the products -- */
    products: {
      productLayout: 'focus' | 'full' | 'grid';
      productDisplayVariant: 'single' | 'bundle' | 'grid' | 'best_match' | 'advanced';
    };
  };

  /* -- Some status of where you are in the guide -- */
  status: {
    /* -- The index for where you are in the guide -- */
    currentStep: number;
    /* -- The total number of steps in the guide -- */
    totalSteps: number;

    /* -- An array of all the steps containing if they are visited or not. -- */
    steps: {id: string; name?: string; visited: boolean}[];
  };

  /* -- The information inside the step -- */
  step: DtProductGuideStep;

  /* -- The products, you won't get it every time depending on your settings in the builder -- */
  products?: {
    productItems: DtProductGuideProduct[];
    secondary?: Omit<DtProductGuideProduct, 'secondary'>[];

    canLoadMore: boolean;

    currencyExpr: string;
  };
  
};

type DtProductGuideOption = {
  disabled: boolean;
  subtitle: string;
  title: string;
  uuid: string;
  metaData: Record<string, any>;
  image?: {
    name: string;
    source: string;
    thumbnail?: string;
  };
};
type DtStepType = 'options' | 'form' | 'result';
type DtFormInputType = 'string' | 'number';
type DtFormInput<T extends DtFormInputType = DtFormInputType> = {
  uuid: string;
  placeholder: string;
  title: string;
  subtitle: string;
  settings: {
    inputType: T;
  };
} & (
  | { settings: { 
        inputType: 'string';
        variant: 'field' | 'textarea'; 
        validation?: 'phone' | 'email' | 'none';
        allowedValues?: string[];
      } 
    }
  | { settings: { inputType: 'number' } }
);
type DtProductGuideStep<T extends DtStepType = DtStepType> = {
  uuid: string;
  type: 'step';
  disabled?: boolean;

  /* -- -- */
  name: string;
  image?: {
    name: string;
    source: string;
    thumbnail?: string;
  };
  title: string;
  subtitle: string;

  /* -- The type of step (form or options) -- */
  variant: T;

  required: boolean;

  /* -- How the image should look inside the options -- */
  imageType: 'image' | 'icon';

  last: boolean;

  /* -- This tells you if this step should show products or not -- */
  displayProducts: boolean;

  /* -- Some metadata that you can enter inside the builder, this can be whatever you want -- */
  metaData?: { [key: string]: string | number | boolean };

} & (T extends 'form'
  ? { variant: 'form'; userInputs: DtFormInput[] }
  : T extends 'result'
  ? { variant: 'result' }
  : {
      variant: 'options';
      options: DtProductGuideOption[];
      choice: 'single' | 'multiple';
      layout: 'two-columns' | 'three-columns' | 'four-columns' | 'compact';
    });

type DtProductGuideProduct = {
  name: string;
  id: string;
  image: string;
  url: string;
  price: number;
  salePrice?: number;
  description?: string;
  groupId?: string;
  brand?: string;
  
  [key: string]: string | boolean | unknown[];

  /* -- Secondary products that match with the primary product. -- */
  secondary?: Omit<DtProductGuideProduct, 'secondary'>[];

  /* -- What it matched on. Name is the translation for the key in the feed - matching is all the values it matched on for that key - values are all the values for that key -- */
  matchingTags?: { matching: string[]; name: string; values: string[] }[];

  distinct?: string;
}
```
{% endcode %}

When the event is `product_guide_products` the event type looks like this:

{% code overflow="wrap" %}
```typescript
type EventValue = {
  type: 'product_guide_products';
  
  products: {
    productItems: DtProductGuideProduct[];
    canLoadMore: boolean;
    currencyExpr: string;
  };
  
};

type DtProductGuideProduct = {
  name: string;
  id: string;
  image: string;
  url: string;
  price: number;
  salePrice?: number;
  description?: string;
  groupId?: string;
  brand?: string;
  
  [key: string]: string | boolean | unknown[];

  /* -- Secondary products that match with the products. -- */
  secondary?: Omit<DtProductGuideProduct, 'secondary'>[];

  /* -- What it matched on. Name is the translation for the key in the feed - matching is all the values it matched on for that key - values are all the values for that key -- */
  matchingTags?: { matching: string[]; name: string; values: string[] }[];

  distinct?: string;
}
```
{% endcode %}

Note:\
The `product_guide_products` only triggers when the user clicks the 'Load more' button.
