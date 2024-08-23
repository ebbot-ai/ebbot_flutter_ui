# Select a trigger

Now it's time to choose a trigger. A trigger is an instruction for the bot so it knows when to play out the scenario. The most common way to trigger a scenario is by using the NLP trigger. NLP stands for **N**atural **L**anguage **P**rocessing. When using this trigger you will train the bot to understand the intent in a sentence by providing a bunch of variations meaning the same thing. If you can give around 10-15 variations then the bot will have a good understanding and the chances are really high that it will detect similar phrases from your users.

{% hint style="info" %}
We will only use the NLP trigger in this tutorial. See the [triggers page](../../untitled/triggers.md) for  full reference
{% endhint %}

Since we are creating a scenario that should cover questions related to favorite color we will add the following phrases to the NLP trigger. In our example we're only giving 5 phrases but try to reach above 15 NLP phrases on your production bots.&#x20;

```bash
What is your favorite color
I would like to know your favorite color
Tell me your favorite color
Do you have a favorite color
Whats your favorite color
```

<figure><img src="../../.gitbook/assets/image (112).png" alt=""><figcaption></figcaption></figure>

