# Scenarios

The scenario is where the magic happens since a bot is built entirely on scenarios. Each chatbot is made up of "scenarios". You build a chatbot by combining different scenarios which in turn allows Ebbot to understand and have a human dialogue with the user. When a user says something, Ebbot matches the user expression to the best scenario in your bot and return the proper reply/action

## Creating a scenario

For example, you can create a weather chatbot that understands and replies to the user's weather questions.

For instance you could create a weather bot that recognizes and responds to user questions about the weather.

A scenario contains the following:

*   **Trigger** - What type of trigger should launch the scenario? The most common variant is "NLP" where Ebbot uses data models to identify what the user wants by using Natural Language Processing to match this to the correct scenario.

    You can also use traditional keywords or use no trigger. A no trigger scenario can only be triggered by buttons or actions from other scenarios.
* **Training phrases** - When using the NLP trigger you need to provide example phrases for what users might say. You do not need to write every conceivable variation of how users express themselves. Provide Ebbot with around 20 examples and the data model will learn from that.
* **Bot responses** - This is what Ebbot should output as a response to the user. You may use several different responses such as simple text, images, cards, buttons or trigger your custom components that can be integrated with your own backend in order to create powerful experiences for the users.

## Contexts

Ebbot context is similar to the one in natural language. If a person asks “how much does it cost”? You need to know which product or object the person is talking about. In the same way Ebbot needs to be configured by context to understand the sentences. We have developed an automatic context creation so that you don't need to think about it at all. By using context, Ebbot is allowed to detect follow-up questions.

By using contexts Ebbot are allowed to detect follow-up questions. Ebbot’s memory capacity lets you return to a previous topic even after one or several other topics has been discussed. Ebbot will still remember the context of the first topic, and can smoothly transition back and forth.

### Follow-up scenarios

By clicking on the plus sign on a root scenario you are able to create a follow-up scenario to cover questions related to the main scenario. You need to train the child scenario with specific phrases. Let's say we want to create a follow-up scenario to the weather scenario, giving the user the opportunity to ask about other dates but keeping the city and scenario in memory.

The weather scenario have training phrases similar to “What is the weather in Stockholm tomorrow?” and we now want to be able to respond to follow-up questions like “what about the weekend or on monday next week”

1. We start by adding a child scenario to the weather scenario by clicking on the plus sign and add a scenario with the name "asking\_about\_date".
2. Then we train the scenario with the following phrases:
3. What about tomorrow then?
4. And on saturday?
5. What about the weekend
6. And next week?

What's happening now is that we are able to cover the following conversation. And this is possible thanks to the context setup.
