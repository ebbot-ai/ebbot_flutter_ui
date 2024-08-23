---
description: >-
  Each scenario has a trigger type associated, this lets the bot know how it
  should trigger the scenario. Below is the different types of triggers that
  exist in Ebbot explained.
---

# Triggers

### No trigger&#x20;

A scenario without a trigger can not be directly entered. It can only be entered through a button click from another scenario or a transition.&#x20;

### Keyword

A scenario with a keyword trigger can only be entered by a visitor entering the exact keyword. This type of trigger is useful if you would like to add a shortcut to the scenario.&#x20;

### NLP

A scenario with NLP trigger is the most common one. NLP stands for Natural Language Processing and its one of the magic parts behind conversational AI. With this trigger you supply the bot a bunch of phrases or words it should "understand" and respond to. You specify the phrases that the bot will use to interact with the user. This allows the bot to comprehend user queries and respond accordingly, creating a more natural and fluid conversation flow.

### **Catch All**

A scenario with the CatchAll trigger will be triggered any time the bot does not comprehend the user input. If there are no available NLP scenarios that matches the user input, catchall will be triggered instead. If EbbotGPT is active on the bot, the catchall works as a fallback if the GPT response would fail. Usually, there is only one CatchAll scenario in the root of the scenario tree.

### **Close**

This trigger needs to be used in scenarios that should end the conversation. A scenario with the Close trigger is created by default (End conversation) and usually that is the scenario that should be used for this purpose.&#x20;

### **Location**

This trigger is used specifically for Messenger integrations, it prompts the user on their device to allow them to share their location.&#x20;

### **CoBrowsing**&#x20;

This trigger is used specifically for CoBrowsing scenarios, where the user should be prompted to share their screen with the agent.&#x20;
