# Transition

A transition is a link from one scenario to another scenario. It can either be a link to the top of a scenario or to a state in the middle of a scenario. You can also to a certain state in your current scenario.

#### Transition Syntax

```javascript
"next": {
    "scenario": "<SCENARIO_ID_OR_NAME>",
    "state": "<STATE_ID>"
}
```

#### Example Usage

```javascript
[
	{
		"name": "state_1613080611608",
		"component": "ebbot_text",
		"properties": {
			"text": "Hello there"
		},
		"next":{
		  "scenario": "b6788f10-6ca5-11eb-aed8-d37ca2e276ae_2d9264fb-fd6f-4ae1-b947-a9f4c184d408"
		}
	}
]
```

{% hint style="info" %}
The state parameter is optional. If you do not use the state then it will make a transition to the top of the actual scenario
{% endhint %}

#### Make a transition combined with the button card

It's possible to combine the button&#x20;
