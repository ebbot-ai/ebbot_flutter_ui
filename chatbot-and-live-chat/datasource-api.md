# Datasource API

## Get Tables

<mark style="color:blue;">`GET`</mark> `https://<env>.ebbot.app/v3/api/services/data-sources/:connectionId/tables`

This endpoint allows you to get free cakes.

#### Path Parameters

| Name         | Type   | Description                                                    |
| ------------ | ------ | -------------------------------------------------------------- |
| connectionId | string | ID of the connection for which to return the parameter tables. |

#### Headers

| Name           | Type   | Description          |
| -------------- | ------ | -------------------- |
| Authentication | string | Authentication token |

{% tabs %}
{% tab title="200 The array of tables related to the given connection." %}
```javascript
{
    success: true,
    data: [
        {
            _id: "string",
            name: "string",
            description: "string",
            bot_id: "string",
            connection_id: "string",
            created_at: "string",
            updated_at: "string"
        }
    ]
}
```
{% endtab %}

{% tab title="500 Something went wrong" %}
```javascript
{
    success: false,
    message: "string"
}
```
{% endtab %}
{% endtabs %}

## Get data

<mark style="color:blue;">`GET`</mark> `https://<env>.ebbot.app/v3/api/services/data-sources/:connectionId/tables/:tableId`

#### Path Parameters

| Name         | Type   | Description          |
| ------------ | ------ | -------------------- |
| tableId      | string | ID of the data table |
| connectionId | string | ID of the connection |

#### Query Parameters

| Name     | Type    | Description                                                                                                    |
| -------- | ------- | -------------------------------------------------------------------------------------------------------------- |
| \<field> | string  | Any field from the table structure can be passed as a parameter to reduce the search scope.                    |
| strict   | boolean | Specifies the operator used in the query. AND for strict true, OR for false. If not specified defaults to true |
| page     | integer | Returns the results with an offset of page x limit                                                             |
| limit    | integer | Limits the number of results returned. If not specified defaults to 10.                                        |

#### Headers

| Name           | Type   | Description          |
| -------------- | ------ | -------------------- |
| Authentication | string | Authentication token |

{% tabs %}
{% tab title="200 " %}
```javascript
{
    success: true,
    data: {
        data: [
            {
                _id: "string",
                name: "string",
                keys: "object",
                data: "array",
                description: "string",
                bot_id: "string",
                connection_id: "string",
                created_at: "string",
                updated_at: "string"
            }
        ],
        meta: {
            count: "number",
            page: "number",
            limit: "number"
        }
    }
        
}
```
{% endtab %}

{% tab title="500 Something went wrong." %}
```javascript
{
    success: false,
    message: "string"
}
```
{% endtab %}
{% endtabs %}
