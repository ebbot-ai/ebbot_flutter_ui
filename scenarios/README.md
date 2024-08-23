# Scenarios

The scenario is where the magic happens since a bot is built entirely on scenarios. Each chatbot is made up of "scenarios". You build a chatbot by combining different scenarios which in turn allows Ebbot to understand and have a human dialogue with the user. When a user says something, Ebbot matches the user expression to the best scenario in your bot and return the proper reply/action

### Welcome scenario

All bots have one welcome scenario which is the first message that gets triggered when a conversation has been started. It's marked with a red color in our studio and you modify it as you like.

<div align="left">

<img src="../.gitbook/assets/image (41).png" alt="">

</div>

It's a good idea to add a bunch of relevant buttons that could act as a conversation starter and let the user know what kind of knowledge the bot is trained with.&#x20;

### Catchall scenario

A catchall scenario is a scenario that it's trigger if the bot couldn't match the phrase against another trained scenario. You should always consider to have human handover in the catchall scenario so that the user can have an answer on their questions and have good experience. If it's outside office hours you should have a flow that creates a ticket or send an email to you so that you don't loose anything.&#x20;

The catchall scenario is marked with a blue color in the studio.

<div align="left">

<img src="../.gitbook/assets/image (50).png" alt="">

</div>

