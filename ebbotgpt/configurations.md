---
description: >-
  Your GPT configuration includes various settings for your GPT-bot, such as the
  model to use and its persona.
---

# Configurations

<figure><img src="../.gitbook/assets/image (135).png" alt=""><figcaption><p>Configuration persona and language settings</p></figcaption></figure>

### Persona

Your GPT persona is a way to give your bot instructions on who it is and how it should behave.&#x20;

* Bot's name and purpose
* Your organisation's name and a short description
* How the bot should write its answer
* Specific behaviour: "If asked about X answer Y"

### Language

This setting will prompt the bot to speak a specific language. \
**Same as bot** - The language set when the bot was created\
**Same as user** - The bot imitates the language of the user\
**Custom language** - Manually set a language  &#x20;

### Data set

Select what data set the bot should use as a source for it answer

<figure><img src="../.gitbook/assets/image (133).png" alt=""><figcaption><p>Configuration data set settings</p></figcaption></figure>

**Search definitions (advanced)**

Create a custom setup for how the Embedder should find sources. For most use cases the default setting is good enough.&#x20;

**Conversation filter** - Set if the user's or assistant's message should be used when searching for sources.

**Number of messages in search** - Specify the number of messages from the chat history that should be used to search for sources. When a user asks a question across multiple messages, ensure this setting is set to 2 or more.

**Numer of sources that the gpt will read** - How many sources should be retrieved based on the conversation filter och number of messages in search settings.

**Enable retrieve and rerank (Not recommended)** - Reorganise the sources to achieve improved accuracy. &#x20;



### GPT model

**Ebbot GPT** - Select if you want to use one of Ebbot's Models hosted on EU servers by EU companies and fine tuned for customer service.

**OpenAI GPT** **(Azure)** - Use OpenAI's model hosted through Microsoft Azure.

### GPT model versions

We regularly release new models versions that are smarter, faster, cheaper, or include new functionality. Typically, the latest model is the best one to use.

**EbbotGPT 0.6.4** (Newest)

**EbbotGPT 0.5.6**

### Advanced

<figure><img src="../.gitbook/assets/image (134).png" alt=""><figcaption><p>Configuration advanced settings</p></figcaption></figure>

**Number of messages in GPT memory** - How many messages in the chat history should the GPT model use as a basis for its answer.  \
\
Changing the following settings usually has a minimal impact on the bot's answers. While adjustments can positively affect specific questions, they might negatively impact others. Use with caution.

**Temperature** - Recommended setting 0.1

**Top P** - Recommended setting 0.1

**Typ P** - Recommended setting 0.5

**Top K** - Recommeded setting 40
