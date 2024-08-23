# Rating request

![](<../../.gitbook/assets/image (39).png>)

The rating request card lets you send a five star rating request to the user.&#x20;

![](<../../.gitbook/assets/image (21).png>)

{% tabs %}
{% tab title="GUI" %}
![](<../../.gitbook/assets/image (103).png>)
{% endtab %}

{% tab title="Syntax" %}
### Syntax

```javascript
[
	{
		"id": "724b2b8f-dfc0-4572-b21a-3213e993c250",
		"name": "state_1613375130069",
		"component": "ebbot_rating_request",
		"properties": {
			"text": "<TEXT MESSAGE>"
		}
	}
]
```

### Example usage

```javascript
[
	{
		"id": "724b2b8f-dfc0-4572-b21a-3213e993c250",
		"name": "state_1613375130069",
		"component": "ebbot_rating_request",
		"properties": {
			"text": "Please rate your experience with me 😊"
		}
	}
]
```
{% endtab %}
{% endtabs %}

### Grab the value behind the stars

The number behind the star is stored in the conversation object with the rating property. It can be used in a filter or a custom component.

#### Filter

<div align="left">

<img src="../../.gitbook/assets/image (22).png" alt="">

</div>

#### Custom component

```python
def main(data):
rating = data['conversation']['rating']
```

