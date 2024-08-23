# File

## File card&#x20;

Send a file to the user by using the file card. The user will see a file icon together with a button to download the file.&#x20;

> You can upload `.pdf` or `.txt` with a maximum size of `10MB`

{% tabs %}
{% tab title="GUI" %}
![](<../../.gitbook/assets/image (48).png>)
{% endtab %}

{% tab title="Syntax" %}
### Syntax

```javascript
[
	{
		"id": "b3792de1-f8bd-4752-a531-b918fb2157e2",
		"name": "state_1613372284581",
		"component": "ebbot_file",
		"properties": {
			"url": "<URL>",
			"image_description": "<FILE DESCRIPTION>"
		}
	}
]
```

### Example usage

```javascript
[
	{
		"id": "b3792de1-f8bd-4752-a531-b918fb2157e2",
		"name": "state_1613372284581",
		"component": "ebbot_file",
		"properties": {
			"url": "https://ebbot-v2.storage.googleapis.com/uploads/invoice.pdf",
			"image_description": "Invoice"
		}
	}
]
```
{% endtab %}
{% endtabs %}
