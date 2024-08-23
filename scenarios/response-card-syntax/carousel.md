# Carousel

## Carousel card

{% tabs %}
{% tab title="GUI" %}
![](<../../.gitbook/assets/image (38).png>)
{% endtab %}

{% tab title="Syntax" %}
### Syntax

```javascript
[
	{
		"id": "5f7f822e-e44a-4162-b312-e4c2bf6a5b1b",
		"name": "state_1613373374446",
		"component": "ebbot_carousel",
		"properties": {
			"slides": [
				{
					"title": "<TITLE>",
					"description": "<DESCRIPTION>",
					"image_url": "<IMAGE URL>",
					"buttons": [
						{
							"label": "<BUTTON LABEL>",
							"url": "<BUTTON URL>"
						},
						{
							"label": "<BUTTON LABEL>",
							"url": "<BUTTON URL>"
						}
					],
					"image_description": "<IMAGE DESCRIPTION>"
				}
			]
		}
	}
]
```

### Example usage

```javascript
[
	{
		"id": "5f7f822e-e44a-4162-b312-e4c2bf6a5b1b",
		"name": "state_1613373374446",
		"component": "ebbot_carousel",
		"properties": {
			"slides": [
				{
					"title": "Black sport shoe",
					"description": "Our latest and greatest shoes",
					"image_url": "https://img01.ztat.net/article/spp-media-p1/73e22847ed7e32a68e2e12aa47a36cc3/5d104215d6964f7ab603ada79197a15a.jpg?imwidth=1800",
					"buttons": [
						{
							"label": "Add to cart",
							"url": "js://addTochart"
						},
						{
							"label": "Read more",
							"url": "https://shoestore.com/product/shoes/nike/black"
						}
					],
					"image_description": "black shoe"
				},
				{
					"title": "White sport shoe",
					"description": "Our latest and greatest shoes",
					"image_url": "https://images.afound.com/images/91988afa-51f7-4f0d-b1f0-89bb47e09b47/93e96a9a234c4ca3b6143178fc2f0883.jpg?preset=product-details-desktop",
					"buttons": [
						{
							"label": "Add to cart",
							"url": "js://addTochart"
						},
						{
							"label": "Read more",
							"url": "https://shoestore.com/product/shoes/nike/white",
							"name": "",
							"value": ""
						}
					]
				}
			]
		}
	}
]
```
{% endtab %}
{% endtabs %}



