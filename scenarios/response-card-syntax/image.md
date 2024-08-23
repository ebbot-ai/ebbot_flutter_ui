# Image

## Image card

The image card is used when you would like to send an image to the user. This cards allows you to show one single image. If you want to upload more images, please use the [carousel card](carousel.md).&#x20;

The following types are allowed `.jpeg`, `.png` and `.gif`

{% tabs %}
{% tab title="GUI" %}
![](<../../.gitbook/assets/image (81).png>)
{% endtab %}

{% tab title="Syntax" %}
### Syntax

```bash
[
	{
		"name": "state_1613371653983",
		"component": "ebbot_image",
		"properties": {
			"image_description": "<IMAGE DESCRIPTION>",
			"url": "<IMAGE URL>"
		}
	}
]
```

### Example usage

```bash
[
	{
		"name": "state_1613082140872",
		"component": "ebbot_image",
		"properties": {
			"impage_description": "A cat",
			"url": "https://ebbot.ai/cat.png"
		}
	}
]
```
{% endtab %}
{% endtabs %}

{% hint style="info" %}
When you using the GUI section you are allowed to upload images from your computer. In the code editor you have to define an already existing image online.
{% endhint %}
