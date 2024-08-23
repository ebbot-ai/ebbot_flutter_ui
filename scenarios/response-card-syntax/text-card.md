# Text card

## Text card

A simple text card with the defined text as bot response

{% tabs %}
{% tab title="GUI" %}
![](<../../.gitbook/assets/image (88).png>)
{% endtab %}

{% tab title="Syntax" %}
### Syntax

```bash
[
	{
		"name": "<STATE_NAME>",
		"component": "ebbot_text",
		"properties": {
			"text": "<TEXT>"
		}
	}
]
```

### Example usage

```bash
[
	{
		"name": "state_1613080611608",
		"component": "ebbot_text",
		"properties": {
			"text": "Hello there"
		}
	}
]
```
{% endtab %}

{% tab title="Properties" %}
| **Property** | **Type** | **Description**                   |
| ------------ | -------- | --------------------------------- |
| text         | string   | Response text to send to the user |
{% endtab %}
{% endtabs %}

## Random text card

Randomize the text response each time the scenario is triggered.&#x20;

{% tabs %}
{% tab title="GUI" %}
![](<../../.gitbook/assets/image (60).png>)
{% endtab %}

{% tab title="Syntax" %}
### Syntax

```bash
[
	{
		"name": "<STATE_NAME>",
		"component": "ebbot_random_text",
		"properties": {
			"responses": [
				"<TEXT 1>",
				"<TEXT 2>",
				"<TEXT 3>"
			]
		}
	}
]
```

### Example usage

```bash
[
	{
		"name": "state_1613081376364",
		"component": "ebbot_random_text",
		"properties": {
			"responses": [
				"thank you",
				"thanks",
				"😊"
			]
		}
	}
]
```
{% endtab %}

{% tab title="Properties" %}
| **Property** | **Type** | **Description**          |
| ------------ | -------- | ------------------------ |
| responses    | array    | A list of text responses |
{% endtab %}
{% endtabs %}



