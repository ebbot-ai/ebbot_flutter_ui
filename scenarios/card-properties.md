# Card properties

The following properties is possible to add on each card regardless of the type

#### Ask again

The ask\_again property is only valid for input cards and lets you define if you would like to always ask for the inputted value every time the scenario is triggered or if you like to have it stored in memory. As default Ebbot will never ask for a variable that it already has.

```javascript
[
	{
		"name": "state_1613396374509",
		"component": "ebbot_input_string",
		"properties": {
			"text": "Tell me your name please",
			"output": "name",
			"ask_again": true
		}
	}
]
```

#### Database

The database object is used to add data to the database.&#x20;

```javascript
"database":{ 
    "first_name": "Emmett",
    "last_name": "Brown"
}
```

You can define whatever property you like and it's then reachable through either `{{ property }}` or `data['db']['property']`

#### Reaction

With the reaction property you can assign a card as a reaction to an output. A card that has a reaction will only be played the first time the variable is set. This is useful if you would like to add a thank you response when collecting values for instance.&#x20;

Here is an example of a reaction that says "Thank you" once the user has entered their name. The second time the scenario is triggered none of the cards will be played.&#x20;

```javascript
[
	{
		"name": "state_1613396374509",
		"component": "ebbot_input_string",
		"properties": {
			"text": "Tell me your name please",
			"output": "name",
			"ask_again": false,
			"validation": {}
		}
	},
	{
		"name": "state_1613396382298",
		"component": "ebbot_text",
		"reaction": "name",
		"properties": {
			"text": "Thank you"
		}
	}
]
```

#### Stop

By using the stop property you can discard all the remaining cards in a scenario. By default this property is set to `false`.

```javascript
[
	{
		"name": "state_1613396374509",
		"component": "ebbot_text",
		"properties": {
			"text": "Hello there 😊",
		},
		"stop": true
	}
]
```

#### Next

By using the next property you can link to another scenario at a given state. It is useful if you would like to trigger another scenario without using buttons.\
You can make a trigger to a scenario or to a given state in that scenario.

```javascript
[
	{
		"name": "state_1613396374509",
		"component": "ebbot_text",
		"properties": {
			"text": "Hello there 😊",
		},
		"next": {
		"scenario": "scenario_name_or_id",
		"state": "state_id" ## OPTIONAL
	}
]
```

