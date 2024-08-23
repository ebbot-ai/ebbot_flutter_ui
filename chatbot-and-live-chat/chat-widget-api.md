# Chat widget API

With the Chat widget API it is possible to control the chat widget's behavior and call the JavaScript methods listed below. For example, you can [trigger scenarios](https://docs.ebbot.ai/chat-widget-api#triggerscenario), [hide the chat window](https://docs.ebbot.ai/chat-widget-api#hide) or [set attributes into an existing conversation.](https://docs.ebbot.ai/chat-widget-api#setuserattribute)&#x20;

The chat widget API is active whenever an Ebbot chat widget is loaded on a page. It can be tested through the developer console.&#x20;

## Hooks

Use hooks to make the widget call a function.

### onBeforeLoad

Callback function invoked when widget code is loaded but chat window is not rendered yet

```javascript
window.Ebbot.onBeforeLoad = function(data) {
  // ...
};
```

### onLoad

Callback function invoked when widget code is loaded and chat window is rendered

```javascript
window.Ebbot.onLoad = function(data) {
  // ...
};
```

### onReset

Callback function invoked when conversation is reset

```javascript
window.Ebbot.onReset = function() {
  // ...
};
```

### onCreate

Callback function invoked after create() API method call.

```javascript
window.Ebbot.onCreate = function() {
  // ...
};
```

### onDestroy

Callback function invoked after destroy() API method call.

```javascript
window.Ebbot.onDestroy = function() {
  // ...
};
```

### onChatWindowOpen

Callback function invoked when the chat window is opened

```javascript
window.Ebbot.onChatWindowOpen = function() {
  // ...
};
```

### onChatWindowClose

Callback function invoked when the chat window is closed

```javascript
window.Ebbot.onChatWindowClose = function() {
  // ...
};
```

### onMessage

Callback function invoked after query result

```javascript
window.Ebbot.onMessage = function(data) {
  // ...
};
```

### onBotMessage

Callback function invoked after a bot message is received

```javascript
window.Ebbot.onBotMessage = function(data) {
  // ...
};
```

### onUserMessage

Callback function invoked after user types a message

```javascript
window.Ebbot.onUserMessage = function(data) {
  // ...
};
```

### onStartConversation

Callback function invoked after query result

```javascript
window.Ebbot.onStartConversation = function(data) {
  // ...
};
```



## Methods

Use methods to call a function in the widget.

### create

Create chat widget if does not exist

```javascript
window.Ebbot.create();
```

### destroy

Destroy chat widget if exist

```javascript
window.Ebbot.destroy();
```

### initChatWindow <a href="#initchatwindow" id="initchatwindow"></a>

Displays chat conversation box and initialises the chat

```javascript
window.ebbot.initChatWindow();
```

### isInitialized

Returns true if the chat is initialized

```javascript
window.Ebbot.isInitialized();
```

### resetSession

Reset current session

```javascript
window.Ebbot.resetSession();
```

### openChatWindow

Open chat window

```javascript
window.Ebbot.openChatWindow();
```

### closeChatWindow

Close chat window

```javascript
window.Ebbot.closeChatWindow();
```

### isChatWindowOpened

Check if chat window is opened

```javascript
window.Ebbot.isChatWindowOpened();
```

### isChatWindowClosed

Check if chat window is closed

```javascript
window.Ebbot.isChatWindowClosed();
```

### sendMessage

Send Message

```javascript
window.Ebbot.sendMessage("Hello !");
```

### setUserAttribute

Set User Attribute

```javascript
window.Ebbot.setUserAttribute({ test: "123" });
```

### triggerScenario

Trigger Scenario

```javascript
window.Ebbot.triggerScenario({
  scenario: "scenarioId", // Found in the URL of a scenario
  state: "stateId"
});
```

### endChat

End Chat

```javascript
window.Ebbot.endChat();
```

### transcriptChat

Transcript chat

```javascript
window.Ebbot.transcriptChat();
```

### snoozeChat

Turn on/off chat notifications

```javascript
window.Ebbot.snoozeChat();
```

### isSnoozed

Check if notifications are on/off

```javascript
window.Ebbot.isSnoozed();
```

### hide

Hide the chat

```javascript
window.Ebbot.hide();
```

### show

Show the chat

```javascript
window.Ebbot.show();
```

### isHidden

Is the chat window hidden

```javascript
window.Ebbot.isHidden();
```

### clearChat

Clears all the messages from the chat window

```javascript
window.Ebbot.clearChat();
```

### isUserActive

Returns true if the user is/was active

```javascript
window.Ebbot.isUserActive();
```

### isConversationActive

Returns true if the conversation is started

```javascript
window.Ebbot.isConversationActive();
```

### getWidgetSize

Returns an object containing the width and height of the widget (including blob, if its not on mobile). As calculations depend on the open animation, it might take 500ms for the size to update.&#x20;

```javascript
window.Ebbot.getWidgetSize();
```
