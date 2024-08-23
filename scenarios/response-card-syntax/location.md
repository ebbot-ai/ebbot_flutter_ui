# Location

## Location card

Define a google maps location and render it as a map to the user. Separate addresses with a comma.

{% tabs %}
{% tab title="GUI" %}
![](<../../.gitbook/assets/image (63).png>)
{% endtab %}

{% tab title="Syntax" %}
### Syntax

```
[
	{
		"name": "state_1613373974571",
		"component": "ebbot_location",
		"properties": {
			"query": "<GOOGLE MAPS QUERY>"
		}
	}
]
```

### Example usage

```
[
	{
		"name": "state_1613373974571",
		"component": "ebbot_location",
		"properties": {
			"query": "Kungsgatan 1, Stockholm, Sverige"
		}
	}
]
```
{% endtab %}
{% endtabs %}

