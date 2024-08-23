# Add bot responses

Now, we will add the bot's responses. First, click "add bot responses" in the top of the right panel.&#x20;

<figure><img src="../../.gitbook/assets/image (116).png" alt=""><figcaption></figcaption></figure>

In this example we will use two of the most common card types: Text and Input String.

### Add a text response

Click the "Text" bot reaction in the left panel to add it to the scenario, then provide some text that the bot should send.&#x20;

<figure><img src="../../.gitbook/assets/image (117).png" alt=""><figcaption></figcaption></figure>

### Save and test

Scenarios that are published will be active when talking to the bot, the bot will not play unpublished scenarios. Make sure that the "Published" toggle is on, and hit "Save scenario".&#x20;

<figure><img src="../../.gitbook/assets/image (118).png" alt=""><figcaption></figcaption></figure>

### **Train the bot**

When NLP scenarios are added or updated in Ebbot, the bot needs to be trained. When saving your new scenario, it will change color along with the "Train Bot" button in the bot builder. Press "Train Bot" to run the training, this activates your new scenario and makes it react to the phrases you previously added. Training may take up to 3 minutes.

{% hint style="info" %}
**Training is needed when:**

* A new NLP type scenario is created
* The list of NLP phrases is edited in a scenario
{% endhint %}

<figure><img src="../../.gitbook/assets/image (119).png" alt=""><figcaption></figcaption></figure>

<figure><img src="../../.gitbook/assets/image (120).png" alt=""><figcaption></figcaption></figure>

When the training is completed you will get a success notification in the app. As soon as it is done, you should be able to trigger your new scenario.&#x20;

By clicking on the message bubble in the upper right corner you are always able to start talking with the bot and to test your flow.&#x20;

<figure><img src="../../.gitbook/assets/image (121).png" alt="" width="61"><figcaption></figcaption></figure>

<figure><img src="../../.gitbook/assets/image (123).png" alt="" width="322"><figcaption></figcaption></figure>

### **Get to know the user**

Now we should let the bot ask a question back to the user about their favorite color.&#x20;

Bot responses are sent to the user in the order they are placed in the scenario, so we will add the question after the first text about the bot's favorite color.&#x20;

Head back to the scenario and drag the "input string" card from the left and place it **under** the first text card. This time we will use the input string. This allow us to ask a question and then store the answer in a variable. The output variable name can be named anything but in this case we'll name it _color._

<figure><img src="../../.gitbook/assets/image (124).png" alt="" width="375"><figcaption></figcaption></figure>

Once a variable has been defined you can always reach it at any time during the conversation. To do so we can for example add another text card under the input string, repeating what the user just told us:&#x20;

<figure><img src="../../.gitbook/assets/image (126).png" alt="" width="375"><figcaption></figcaption></figure>

The result is that we now have the users favorite color stored in the data object and can use it throughout the conversation. In this case we use it immediately in the following bot reaction when given to us:&#x20;

<figure><img src="../../.gitbook/assets/image (127).png" alt="" width="334"><figcaption></figcaption></figure>
