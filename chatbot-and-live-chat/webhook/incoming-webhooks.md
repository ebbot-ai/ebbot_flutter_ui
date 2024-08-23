# Incoming webhooks

An incoming webhook lets you use the conversational AI and intent detection in a platform of your choice. You can start conversations and Ebbot will try to match the phrase with a scenario and respond with a proper answer.&#x20;

Follow the instructions below to add an incoming webhook

1. Head to the webhook page in the integrations section in the left sided menu.
2. Click on add and then choose incoming as the type
3. Give the webhook a name&#x20;
4. Click on save

![](<../../.gitbook/assets/image (100).png>)

### Send a request

Once you have the webhook URL you only need to make a post request to that URL to start the conversation. You can run the conversation in sandbox mode which means that it will not be created in the conversations table. The bot will still respond as in a regular conversation.&#x20;

On the first request that isn't in sandbox mode you will receive a chat id that should be use if you like to continue the conversation with the same id. It's required if you would like to use context and be able to answer on follow-up questions.  If you don't pass the chat id a new conversation will be started for each request.&#x20;

<mark style="color:green;">`POST`</mark> `https://v2.ebbot.app/api/webhooks/:webhookid`

#### Request Body

| Name   | Type   | Description                             |
| ------ | ------ | --------------------------------------- |
| chatId | string | To continue on an existing conversation |
| type   | string | The type of the message                 |
| value  | string | The message to be sent                  |

{% tabs %}
{% tab title="200 " %}
```javascript
{
    "request_id": "197d7397-bf87-4740-a829-ea7251bff534",
    "data": {
        "chatId": "1613384238.420.50c9b6c7-96b6-4794-b09f-3ac7ae27c598",
        "sandbox": false,
        "scenario": {
            "id": "e67494b0-6c9c-11eb-aed8-d37ca2e276ae_e881fbe7-792a-479b-8cfd-848f91120e9c",
            "name": "generalcatchall"
        },
        "answers": [
            {
                "id": "c780c560-c191-4368-924c-57a491dc1748",
                "name": "generalcatchallask",
                "bot_id": "ebmjx2zgfh06t4sxtxko6dcst66w4q",
                "botId": "ebmjx2zgfh06t4sxtxko6dcst66w4q",
                "companyId": "eb8ag1gmiktma952j949arkwu6l93v",
                "parameters": {},
                "db": {},
                "conversation": {},
                "customer_info": {
                    "first_name": "Reluctant",
                    "last_name": "Snake"
                },
                "chatId": "1613384238.420.50c9b6c7-96b6-4794-b09f-3ac7ae27c598",
                "sender": "user",
                "type": "url",
                "value": {
                    "description": "Would you like to talk with a human agent?",
                    "urls": [
                        {
                            "id": "1652c631-a7f5-45a2-a84f-072809631208",
                            "label": "Yes",
                            "type": "scenario",
                            "next": {
                                "scenario": "e656fa90-6c9c-11eb-aed8-d37ca2e276ae_29029c56-4b82-454e-ad75-12445beae6c4"
                            }
                        },
                        {
                            "id": "ae5f4cd7-9734-4369-b8c9-dd5ca476e5af",
                            "label": "No",
                            "type": "scenario"
                        }
                    ]
                }
            }
        ]
    },
    "success": true
}
```
{% endtab %}
{% endtabs %}

#### Example request

```javascript
{
    "type": "text",
    "sandbox": false,
    "value": "Hello there"
}
```

#### Example response

```javascript
{
    "request_id": "197d7397-bf87-4740-a829-ea7251bff534",
    "data": {
        "chatId": "1613384238.420.50c9b6c7-96b6-4794-b09f-3ac7ae27c598",
        "sandbox": false,
        "scenario": {
            "id": "e67494b0-6c9c-11eb-aed8-d37ca2e276ae_e881fbe7-792a-479b-8cfd-848f91120e9c",
            "name": "generalcatchall"
        },
        "answers": [
            {
                "id": "c780c560-c191-4368-924c-57a491dc1748",
                "name": "generalcatchallask",
                "bot_id": "ebmjx2zgfh06t4sxtxko6dcst66w4q",
                "botId": "ebmjx2zgfh06t4sxtxko6dcst66w4q",
                "companyId": "eb8ag1gmiktma952j949arkwu6l93v",
                "parameters": {},
                "db": {},
                "conversation": {},
                "customer_info": {
                    "first_name": "Reluctant",
                    "last_name": "Snake"
                },
                "chatId": "1613384238.420.50c9b6c7-96b6-4794-b09f-3ac7ae27c598",
                "sender": "user",
                "type": "url",
                "value": {
                    "description": "Would you like to talk with a human agent?",
                    "urls": [
                        {
                            "id": "1652c631-a7f5-45a2-a84f-072809631208",
                            "label": "Yes",
                            "type": "scenario",
                            "next": {
                                "scenario": "e656fa90-6c9c-11eb-aed8-d37ca2e276ae_29029c56-4b82-454e-ad75-12445beae6c4"
                            }
                        },
                        {
                            "id": "ae5f4cd7-9734-4369-b8c9-dd5ca476e5af",
                            "label": "No",
                            "type": "scenario"
                        }
                    ]
                }
            }
        ]
    },
    "success": true
}
```

### Set a variable

If you have triggered a scenario that contains buttons with variables you set the type to variable and then pass the clicked variable button to the value property.

```javascript
{
    "type": "variable",
    "sandbox": false,
    "chatId": "1613387504.052.02589455-7427-4036-8573-a8eb55f69520",
    "value": {
        "name": "button",
        "value": "Button value"
    }
}
```

### Make transition

If you have a triggered scenario that contains buttons with a transition to another scenario you have to send the request with type scenario. You either link to the top of the scenario by passing the scenario id or link to a state in that scenario by adding the state id.&#x20;

```javascript
{
    "type": "scenario",
    "sandbox": false,
    "chatId": "1613387504.052.02589455-7427-4036-8573-a8eb55f69520",
    "value": {
        "scenario": "82cd1000-6f61-11eb-aed8-d37ca2e276ae_f3e9282a-5502-4dc2-bffc-b1b9efa7aa3a"
    }
}
```
