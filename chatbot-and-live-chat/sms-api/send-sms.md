---
description: >-
  The send messages feature can be used to send one or more text messages
  immediately or at a specified date and time. You can combine most of the
  features described here to your liking.
---

# Send SMS

## Get Cakes

<mark style="color:blue;">`GET`</mark> `https://api.cakes.com/v1/cakes/:id`

This endpoint allows you to get free cakes.

#### Path Parameters

| Name | Type   | Description                                |
| ---- | ------ | ------------------------------------------ |
| id   | string | ID of the cake to get, for free of course. |

#### Query Parameters

| Name   | Type    | Description                                                           |
| ------ | ------- | --------------------------------------------------------------------- |
| recipe | string  | The API will do its best to find a cake matching the provided recipe. |
| gluten | boolean | Whether the cake should be gluten-free or not.                        |

#### Headers

| Name           | Type   | Description                                                    |
| -------------- | ------ | -------------------------------------------------------------- |
| Authentication | string | Authentication token to track down who is emptying our stocks. |

{% tabs %}
{% tab title="200 Cake successfully retrieved." %}
```
{    "name": "Cake's name",    "recipe": "Cake's recipe name",    "cake": "Binary cake"}
```
{% endtab %}

{% tab title="404 Could not find a cake matching this query." %}
```
{    "message": "Ain't no cake like that."}
```
{% endtab %}
{% endtabs %}

