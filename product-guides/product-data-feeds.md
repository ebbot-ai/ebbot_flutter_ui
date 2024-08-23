# Product data feeds

## Introduction <a href="#introduction" id="introduction"></a>

This document is meant to serve as a guideline for what data a product feed should contain for it to seamlessly integrate with the ebbot platform as well as enable utilization of all features that the product data system offers.

The following product feeds formats are accepted. Which one you choose to export your feed in is up to you.

* **JSON** (with an array of all products)
* **NDJSON**/**JSONL** (new line-delimited JSON, one product per line)
* **XML** (preferably an RSS och Atom stream)
* **CSV** (separated by any common separators, including TSV)

### Data import types

Data can be imported in several ways depending on your preference and data source.

* Upload a file
* Data feed URL
* Import file through ftp-server
* Shopify integration

### Feed data <a href="#feed-data" id="feed-data"></a>

The fields in a product feed customized for ebbot can be divided into two parts:

* Common fields (fields with special meaning such as id, name, link, or price)
* Other attributes (any other fields serving as attributes for creating product guides, such as color, size or flavor)

#### Common fields <a href="#common-fields" id="common-fields"></a>

Make sure that your feed contains at least the required fields. The field names can be changed during the import to ebbot.

| Field name    | Required | Description                                                                                                                                                                                                                                                                                                                |
| ------------- | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `id`          | **Yes**  | A unique identifier for a product. Two products can not have the same id! In some cases, your product feed may contain multiple unique identifiers. We recommend to select the identifier provided by your e-commerce platform.                                                                                            |
| `group_id`    | No       | An id used to group products of the same kind (such as the same model) together. For example, a single shoe model in different sizes should have the same `group_id` even if each size is present in the product feed with a unique `id`. This field is important for us to not recommend the same product multiple times. |
| `name`        | **Yes**  | The product name.                                                                                                                                                                                                                                                                                                          |
| `description` | No       | The product description.                                                                                                                                                                                                                                                                                                   |
| `image_link`  | **Yes**  | A direct link to an appropriately sized product image.                                                                                                                                                                                                                                                                     |
| `link`        | **Yes**  | A direct link to the product on your website.                                                                                                                                                                                                                                                                              |
| `price`       | **Yes**  | The product price. Decimals should be separated by a dot. Examples: `199`, `199.00`, `$19`, `199 SEK`, `EUR 199.00`.                                                                                                                                                                                                       |
| `sale_price`  | No       | The product sale price. This price can be automatically presented instead of or besides the regular price, optionally with the original price crossed out.                                                                                                                                                                 |
| `brand`       | No       | The product brand. This can be used to automatically display the brand of the product.                                                                                                                                                                                                                                     |

#### Attributes <a href="#attributes" id="attributes"></a>

Any other fields present in your product feed can be imported and used as attributes when building product guides. **It’s usually preferable to include as much data as possible** - as this will make building easier and most likely lead to better product guides. In some cases, not enough data may lead to building any decent product guide being simply impossible.

Ebbot has a powerful feed importing tool that lets you rename fields, split values, extract attributes from product descriptions and much more. Yet, some tasks may be simpler to perform on your side than on ours. Therefore, here are some tips you can have in mind when exporting your product feed.

**FORMAT NUMBERS ACCORDING TO THE FOLLOWING**

There are two basic rules to follow:

* Use dot (`.`) as the decimal separator
* Don’t include spaces or any other separators as part of the number itself

Examples of correctly formatted numbers:

* `199`
* `1999.99`
* `SEK 199`
* `2000mm`
* `weight: 14.2 kg`

Examples of incorrectly formatted numbers:

* `1 999`
* `199,99`
* `1,999.99`

**DON’T MIX VALUE FORMATS/UNITS**

Mixing value formats or units will make it difficult to select the correct attribute values when building your guide, especially when there are a lot of values:

| size   |
| ------ |
| 37     |
| 38     |
| M      |
| XL     |
| 1300mm |
| 5m     |
| 6      |
| 7      |
| …      |

If possible, try separating such fields based on product category, value format or unit:

| Shoe size (EU) | Shoe size (UK) | Shirt size | … |
| -------------- | -------------- | ---------- | - |
| 37             | 4              | M          | … |
| 38             | 5              | L          | … |
| 39             | 6              | XL         | … |
| …              | …              | …          | … |

This will also simplify guide building as number attributes (such as shoe size) will be detected as such and become filterable by range.

**SEPARATE FIELDS AND VALUES**

Instead of providing a massive attribute field such as:

| attributes                                        |
| ------------------------------------------------- |
| “size: 42, color: brown, material: leather, etc.” |

Try separating all attributes and their values into their own fields, such as:

| size | color | material | … |
| ---- | ----- | -------- | - |
| 42   | brown | leather  | … |

### Full and partial feeds <a href="#full-and-partial-feeds" id="full-and-partial-feeds"></a>

Ebbot support what we call _full_ and _partial_ feeds. A general use case for these is:

* _Full_ product feeds contain the full data set (all product attributes) but are updated less frequently
* _Partial_ product feeds contain only a subset of attributes (such as price and availability) and are updated more frequently

By default, the first product feed you upload becomes a full feed. Usage of partial feeds is not required but may be required by the service providing of your feed for frequent updates.

The previous section describes the required fields for a full feed. A partial feed however, only requires the `id` field (which must match the `id` in the full feed), along with the fields you want to update more frequently.

An example of a simple partial feed updating the availability and pricing of all products. Note that the attribute names and values must match with the full feed, eg. if you want to update the `availability` attribute using a partial feed, both the full and partial feeds need to have the same `availability` field in terms of name and values.

| **id** | **availability** | **price** |
| ------ | ---------------- | --------- |
| 10001  | in stock         | 199       |
| 10002  | in stock         | 159       |
| 10003  | out of stock     | 229       |
| 10004  | in stock         | 69        |
| …      | …                | …         |

### Localization <a href="#localization" id="localization"></a>

Ebbot supports, alongside building product guides in multiple languages, localized product feeds. This allows your guide to display product information such as name, price (in the correct currency) or any attribute, in the product guide’s language - all without you having to rebuild your guides for each language. In order for this to work correctly however, the localized feeds need to be correctly structured.

When creating a product collection, the first product feed you import becomes the _“primary”_ language feed. This is the feed your guides are going to be based upon, e.g. product filtering/searching will occur on this feed. Other _“secondary”_ language feeds connected to the same product collection are used solely for displaying localized information for your customer.

If you decide to use a localized product feed, you need to think about the following:

* Our locale system assumes that secondary feeds only contain products that are present in the primary feed. Products in secondary feeds that are not present in the primary feed will never be displayed.
* Secondary feeds should ideally be exact copies of their primary feed, only with translated field **values**. This is not a requirement as secondary only needs to contain the fields you want to display for your customers and that differ between locales. This usually includes price and description but may also include other attributes such as category, flavor or size if you want to display these attributes.
* The secondary feed’s `id` fields must match the primary feed’s `id` field.

For example, given the following primary product feed in English:

| **id** | **group\_id** | **name**     | **description**        | **price** | …**other fields**… | **size** | **category**             | **color** |
| ------ | ------------- | ------------ | ---------------------- | --------- | ------------------ | -------- | ------------------------ | --------- |
| 10001  | g1            | Red t-shirt  | A nice t-shirt in red  | 29        | …                  | M        | Clothes > Men > T-shirts | Red       |
| 10002  | g1            | Red t-shirt  | A nice t-shirt in red  | 29        | …                  | L        | Clothes > Men > T-shirts | Red       |
| 10003  | g1            | Blue t-shirt | A nice t-shirt in blue | 29        | …                  | S        | Clothes > Men > T-shirts | Blue      |
| 10004  | g1            | Blue t-shirt | A nice t-shirt in blue | 29        | …                  | L        | Clothes > Men > T-shirts | Blue      |
| …      | …             | …            |                        |           | …                  |          |                          |           |

A localized product feed in Swedish may look like the following:

| **id** | **group\_id** | **name**    | **description**        | **price** | …**other fields**… | **size** | **category**            | **color** |
| ------ | ------------- | ----------- | ---------------------- | --------- | ------------------ | -------- | ----------------------- | --------- |
| 10001  | g1            | Röd t-shirt | En fin t-shirt i rött  | 319       | …                  | M        | Kläder > Herr > T-shirt | Röd       |
| 10002  | g1            | Röd t-shirt | En fin t-shirt i rött  | 319       | …                  | L        | Kläder > Herr > T-shirt | Röd       |
| 10003  | g1            | Blå t-shirt | En fin t-shirt i blått | 319       | …                  | S        | Kläder > Herr > T-shirt | Blå       |
| 10004  | g1            | Blå t-shirt | En fin t-shirt i blått | 319       | …                  | L        | Kläder > Herr > T-shirt | Blå       |
| …      | …             | …           |                        |           | …                  |          |                         |           |

Note that the `id` field in the secondary feed matches the `id` field in the primary feed and that both feeds have the same field names but with translated values (name, description, price, category and color). Technically, the `size` field could be omitted from the secondary feed since the sizes are identical in both locales. The `category` field could also be omitted from the secondary feed if you know that you never want to display this field localized for your customers.

### Ebbot's feed import tool <a href="#dialogtrails-feed-import-tool" id="dialogtrails-feed-import-tool"></a>

Ebbot features a powerful feed import tool allowing you to rename field names and transform their values in many different ways, along with creating entirely new fields out of other fields. We recommend you familiarize yourself with the tool in order to understand what it is capable of doing. A few common possible operations are:

* Changing field names, for example from `Product title` to `name`.
* Splitting text values, for example `Clothes > Men > T-shirts` split on the character `>` becomes `Clothes`, `Men` and `T-shirts`.
* Replacing text values, such as replacing the values `yes` and `no` in the field `in stock` with `In stock` and `Out of stock`, making them customer displayable, or replacing commas with dots and removing spaces in the `price` field.
* Extracting field values from other field values into completely new fields, such as creating a new field `environment` based on whether the product description contains the text `indoor` or `outdoor`, etc. A different example is creating a new field `energy class` by extracting which letters that come after `Energy class:` in the product description.
