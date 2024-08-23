# Buttons

## Button card

The button card can be used to link to another scenario, an URL or to assign a value to a variable. \
The conversation will be paused once a button card is active and will continue when the user has clicked on any button.&#x20;

{% tabs %}
{% tab title="GUI" %}
![](<../../.gitbook/assets/image (101).png>)
{% endtab %}

{% tab title="Syntax" %}
### Syntax

```javascript
[
		{
		"name": "<STATE_NAME>",
		"component": "ebbot_url",
		"properties": {
			"description": "<TEXT_MESSAGE>",
			"buttons": [
				{
					"label": "<BUTTON_TEXT>",
					"type": "variable",
					"name": "<VARIABLE_NAME>",
					"value": "<VARIABLE_VALUE>"
				},
				{
					"label": "<BUTTON_TEXTT>",
					"url": "<URL>",
				},
				{
					"label": "<BUTTON_TEXT>",
					"type": "scenario",
					"next": {
						"scenario": "<SCENARIO_NAME>"
					}
				}
			]
		}
	}
]
```

### Example Usage

```javascript
[
		{
		"name": "state_1613141123674",
		"component": "ebbot_url",
		"properties": {
			"description": "Please choose your favorite color",
			"buttons": [
				{
					"label": "Green",
					"type": "variable",
					"name": "color",
					"value": "green"
				},
				{
					"label": "Red",
					"type": "variable",
					"name": "color",
					"value": "red"
				},
				{
					"label": "Blue",
					"type": "variable",
					"name": "color",
					"value": "blue"
				}
			]
		}
	}
]
```
{% endtab %}
{% endtabs %}

If you have the button card in the middle the remaining cards will be played except if the user clicks on a button thats leads to another scenario or a state. Then the remaining cards in the previous scenario will be discarded.&#x20;

You can always discard the remaining cards on a button click regardless of the type if you pass the stop property.&#x20;

| Property | Type    | Description                                                                     |
| -------- | ------- | ------------------------------------------------------------------------------- |
| stop     | Boolean | <p>Stop the remaining cards to be played. <br>Default value: <em>false</em></p> |

### Example usage of stop property

```javascript
[
	{
		"id": "83879772-8d38-4a5c-9204-67fc9a7e0865",
		"name": "state_1613156908482",
		"component": "ebbot_url",
		"properties": {
			"description": "Favorite color",
			"stop": true,
			"buttons": [
				{
					"label": "green",
					"type": "variable",
					"name": "color",
					"value": "green"
				}
			]
		}
	}
]
```
