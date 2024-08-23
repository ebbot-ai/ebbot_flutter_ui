---
description: >-
  The input cards are useful when you need to ask the user for information and
  store it in a variable.
---

# Input

## Input string

Ask the user about information and store it in a variable.&#x20;

{% tabs %}
{% tab title="GUI" %}
![](<../../.gitbook/assets/image (79).png>)
{% endtab %}

{% tab title="Syntax" %}
### Syntax

```python
[
	{
		"name": "<STATE_NAME>",
		"component": "ebbot_input_string",
		"properties": {
			"text": "<TEXT_MESSAGE>",
			"output": "<VARIABLE_NAME",
			"ask_again": false,
			"validation": {}
		}
	}
]
```

### Example Usage

```bash
[
	{
		"name": "state_1613081714484",
		"component": "ebbot_input_string",
		"properties": {
			"text": "Whats your name",
			"output": "name",
			"ask_again": false,
			"validation": {}
		}
	}
]
```
{% endtab %}

{% tab title="Properties" %}

{% endtab %}
{% endtabs %}

## Input pattern

Ask the user about information and match it against a regular expression before saving it to a variable. Useful when you need to validate the inputted informationen.&#x20;

{% tabs %}
{% tab title="GUI" %}
![](<../../.gitbook/assets/image (29).png>)
{% endtab %}

{% tab title="Syntax" %}
### Syntax

```python
[
	{
		"name": "<STATE_NAME>",
		"component": "ebbot_input_pattern",
		"properties": {
			"text": "<TEXT_MESSAGE>",
			"output": "<VARIABLE_NAME>",
			"ask_again": false,
			"pattern": "<REGEX_PATTERN>",
			"error_message": "<ERROR_MESSAGE>",
			"validation": {}
		}
	}
]
```

### Example Usage

```bash
[
	{
		"name": "state_1613081823403",
		"component": "ebbot_input_pattern",
		"properties": {
			"text": "How old are you?",
			"output": "age",
			"ask_again": false,
			"pattern": "^[0-9]{2}$",
			"error_message": "Not a valid number",
			"validation": {}
		}
	}
]
```
{% endtab %}

{% tab title="Properties" %}
| **Property**   | **Description**                                                                                                  |
| -------------- | ---------------------------------------------------------------------------------------------------------------- |
| text           | The text message that should ask for the variable                                                                |
| output         | Variable name                                                                                                    |
| ask\_again     | Default value: false. Change to true if you like to always ask for the variable each time the card is triggered. |
| pattern        | Regular expresson to match                                                                                       |
| error\_message | Error message to prompt if the variable doesn't match the pattern                                                |
{% endtab %}
{% endtabs %}

{% hint style="info" %}
As default each input card is triggered only if the variable is empty. The second time the card is triggered it will jump to the next state. You can change this by setting "ask\_again" to true.&#x20;
{% endhint %}

## Using the variable&#x20;

You can use the collected variable in a response card by placing the variable name inside double curly brackets.&#x20;

```
    "text": "Hello, my name is {{ name }} and I'm {{ age }} years old"
```

The variable is also accessible in a custom component.

```python
def main(data):
    age = data['db']['age']
    name = data['db']['name']
```
