# Outgoing webhooks

Outgoing webhooks allows you to subscribe to certain events in the conversation. This is useful if you would like to add triggers on your side based on things happening in the conversation. It's also useful if you would like to keep track of conversations in real time.&#x20;

Head to the webhook page in the integration section on the left sided menu and click on add and then click on outgoing as a type. Once you have done so you have to select the topics that you would like to subscribe to.&#x20;

### Overview

| Topic                                                           | Description                                               |
| --------------------------------------------------------------- | --------------------------------------------------------- |
| [chat.create](outgoing-webhooks.md#chat.create)                 | when the chat is created                                  |
| [chat.update](outgoing-webhooks.md#chat.update)                 | when the chat is updated                                  |
| [chat.data.update](outgoing-webhooks.md#chat.data.update)       | when the conversations property in the session is updated |
| [chat.user.update](outgoing-webhooks.md#chat.user.update)       | when the chat user entity is updated                      |
| [chat.user.message](outgoing-webhooks.md#chat.user.message)     | subset of chat.message holds just the user’s messages     |
| [chat.bot.message](outgoing-webhooks.md#chat.bot.message)       | subset of chat.message holds just the bot’s messages      |
| [chat.agent.message](outgoing-webhooks.md#chat.agent.message)   | subset of chat.message holds just the agent’s messages    |
| [chat.system.message](outgoing-webhooks.md#chat.system.message) | subset of chat.message holds just the system’s messages   |
| [chat.message](outgoing-webhooks.md#chat.message)               | handles all messages sent in the chat                     |
| [chat.scenario.run](outgoing-webhooks.md#chat.scenario.run)     | when a scenario is executed                               |
| [chat.status.change](outgoing-webhooks.md#chat.)                | subset of chat.update holds just the status update        |
| [chat.close](outgoing-webhooks.md#chat.close)                   | when the chat is closed, sends the whole chat transcript  |

### Details

#### chat.create

Example:

```json
{
    "topic": "chat.create",
    "botId": "<BOT_ID>",
    "data": {
      "id": "<CHAT_ID>",
      "type": "web",
      "status": "ongoing",
      "user": { "first_name": "Identical", "last_name": "Goat" }
    },
    "context": {
      "company_id": "",
      "user_id": "",
      "impersonated_user_id": "",
      "request_id": "<REQUEST_ID>"
    },
    "requestId": "<REQUEST_ID>",
    "timestamp": 1672531200000
  }
```

#### chat.update

Example:

```json
{
    "topic": "chat.update",
    "botId": "<BOT_ID>",
    "chat": {
      "id": "<CHAT_ID>",
      "botId": "<BOT_ID>",
      "companyId": "<COMPANY_ID>",
      "name": "Name Goat",
      "integration_type": "web",
      "scenario": null,
      "type": "close_chat",
      "status": "ongoing",
      "statusTimestamp": "1672531200.427187915",
      "chatUserId": "<CHAT_USER_ID>",
      "handled_by": "bot",
      "handledByAgentTimestamp": null,
      "transfer_data": {},
      "userId": null,
      "last_message": "1672531200.085565643",
      "new_messages": false,
      "scenarios_in_progress": [],
      "successful_scenarios": {},
      "language": "sv",
      "nps": null,
      "rating": null,
      "transferSkillId": null,
      "participants": [],
      "agents": [],
      "createdAt": "2023-01-01T07:34:43.000Z",
      "updatedAt": "2023-01-01T07:36:11+00:00",
      "chat_user": {
        "id": "<CHAT_USER_ID>",
        "image": null,
        "info": "{\"first_name\":\"Identical\",\"last_name\":\"Goat\"}",
        "createdAt": "2023-01-01T07:34:43.000Z",
        "updatedAt": "2023-01-01T07:34:43.000Z"
      },
      "supervised": false
    },
    "context": {
      "company_id": "",
      "user_id": "",
      "impersonated_user_id": "",
      "request_id": "<REQUEST_ID>"
    },
    "requestId": "<REQUEST_ID>",
    "timestamp": 1672531200000
  }
```

#### chat.data.update

Example:

```json
{
  "topic": "chat.data.update",
  "botId": "<BOT_ID>",
  "data": {
    "id": "<CHAT_ID>",
    "time_before_start": 0,
    "os": "Windows",
    "user_last_input": "test",
    "current_host": "<WEBSITE_HOST>",
    "clientIp": "<IP_ADRESS>",
    "browser": "chrome",
    "chat_theme_details": {
      "id": "<CHAT_THEME_ID>",
      "path": null,
      "isDefault": true
    },
    "current_page": "<WEBSITE_PAGE>",
    "platform": "web"
  },
  "context": {
    "company_id": "",
    "user_id": "",
    "impersonated_user_id": "",
    "request_id": "<REQUEST_ID>"
  },
  "requestId": "<REQUEST_ID>",
  "timestamp": 1672531200000
}
```

#### chat.user.update

Example:

```json
{
  "topic": "chat.user.update",
  "botId": "<BOT_ID>",
  "data": {
    "id": "<CHAT_ID>",
    "user": { "first_name": "Name", "id": "<CHAT_USER_ID>" }
  },
  "context": {
    "company_id": "",
    "user_id": "",
    "impersonated_user_id": "",
    "request_id": "<REQUEST_ID>"
  },
  "requestId": "<REQUEST_ID>",
  "timestamp": 1672531200000
},
```

#### chat.user.message

Example:

```json
{
  "topic": "chat.user.message",
  "botId": "<BOT_ID>",
  "data": {
    "chatId": "<CHAT_ID>",
    "sender": "user",
    "value": "<MESSAGE>",
    "type": "text",
    "id": "<USER_ID>",
    "timestamp": "1672531200000.397183857"
  },
  "context": {
    "company_id": "",
    "user_id": "",
    "impersonated_user_id": "",
    "request_id": "<REQUEST_ID>"
  },
  "requestId": "<REQUEST_ID>",
  "timestamp": 1672531200000
}
```

#### chat.bot.message

Example:

```json
{
  "topic": "chat.bot.message",
  "botId": "<BOT_ID>",
  "data": {
    "chatId": "<CHAT_ID>",
    "sender": "bot",
    "value": {
      "description": "Didn't quite get that... Would you like human help instead?",
      "urls": [
        {
          "id": "ef7af21c-d875-41f2-9d36-6bfe191cd58c",
          "label": "Yes",
          "type": "scenario",
          "next": {
            "scenario": "<SCENARIO_ID>",
            "state": "fba34726-bd31-4ef2-964a-3cf9a64f5df5"
          }
        },
        {
          "id": "cb029428-6513-4540-b3e2-44ed9e832bdc",
          "label": "No",
          "type": "scenario"
        }
      ]
    },
    "type": "url",
    "id": "f7011d1a-e192-4351-9251-c0c6d3b32524",
    "timestamp": "1672531200000.241731866"
  },
  "context": {
    "company_id": "",
    "user_id": "",
    "impersonated_user_id": "",
    "request_id": "<REQUEST_ID>"
  },
  "requestId": "<REQUEST_ID>",
  "timestamp": 1672531200000
}
```

#### chat.agent.message

Example:

```json
{
  "topic": "chat.agent.message",
  "botId": "<BOT_ID>",
  "data": {
    "chatId": "<CHAT_ID>",
    "sender": "agent",
    "value": "<MESSAGE>",
    "type": "text",
    "id": "e8328e60-6757-48ea-87d1-3be485348b4c",
    "timestamp": "1672531200.310412954"
  },
  "context": {
    "company_id": "",
    "user_id": "",
    "impersonated_user_id": "",
    "request_id": "<REQUEST_ID>"
  },
  "requestId": "<REQUEST_ID>",
  "timestamp": 1672531200000
}
```

#### chat.system.message

Example:

```json
{
  "topic": "chat.system.message",
  "botId": "<BOT_ID>",
  "data": {
    "chatId": "<CHAT_ID>",
    "sender": "system",
    "value": "<MESSAGE>",
    "type": "text_info",
    "id": "2276d442-3af1-4f80-a21b-c405632e3b60",
    "timestamp": "1672531200000.158836861"
  },
  "context": {
    "company_id": "",
    "user_id": "",
    "impersonated_user_id": "",
    "request_id": "<REQUEST_ID>"
  },
  "requestId": "<REQUEST_ID>",
  "timestamp": 1672531200000
}
```

#### chat.message

_Any of the chat.\<sender>.message._

#### chat.scenario.run

Example:

```json
{
  "topic": "chat.scenario.run",
  "botId": "<BOT_ID>",
  "data": {
    "chatId": "<CHAT_ID>",
    "scenario": {
      "id": "<SCENARIO_ID>",
      "name": "<SCENARIO_NAME>",
      "states": 1
    }
  },
  "context": {
    "company_id": "",
    "user_id": "",
    "impersonated_user_id": "",
    "request_id": "<REQUEST_ID>"
  },
  "requestId": "<REQUEST_ID>",
  "timestamp": 1672531200000
}
```

#### chat.status.change

Example:

```json
{
  "topic": "chat.status.change",
  "botId": "<BOT_ID>",
  "data": {
    "id": "<CHAT_ID>",
    "status": "ongoing",
    "supervised": false,
    "type": "scenario"
  },
  "context": {
    "company_id": "",
    "user_id": "",
    "impersonated_user_id": "",
    "request_id": "<REQUEST_ID>"
  },
  "requestId": "<REQUEST_ID>",
  "timestamp": 1672531200000
}
```

#### chat.close

Example:

```json
{
  "topic": "chat.close",
  "botId": "<BOT_ID>",
  "data": {
    "id": "<CHAT_ID>",
    "conversation": [
      {
        "id": "<MESSAGE_ID>",
        "sender": "user",
        "type": "scenario",
        "value": {
          "scenario": "<SCENARIO_ID>"
        },
        "timestamp": "1672531200.063057626"
      },
      {
        "id": "<MESSAGE_ID>",
        "sender": "bot",
        "type": "rating_request",
        "value": { "question": "<MESSAGE>" },
        "timestamp": "1672531200.718404236"
      },
      {
        "id": "<MESSAGE_ID>",
        "sender": "user",
        "type": "rating",
        "value": { "rating": 5 },
        "timestamp": "1672531200.575724287"
      },
      {
        "id": "<MESSAGE_ID>",
        "sender": "bot",
        "type": "url",
        "value": {
          "description": "<MESSAGE>",
          "urls": [
            {
              "id": "<BUTTON_ID>",
              "label": "<LABEL>",
              "type": "url",
              "value": "ebbot://reset"
            }
          ]
        },
        "timestamp": "1672531200.620270927"
      }
    ]
  },
  "context": {
    "company_id": "",
    "user_id": "",
    "impersonated_user_id": "",
    "request_id": "<REQUEST_ID>"
  },
  "requestId": "<REQUEST_ID>",
  "timestamp": 1672531200000
}
```
