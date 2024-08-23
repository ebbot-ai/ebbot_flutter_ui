# Contact Agent

## Contact agent card

The contact agent card lets you make a transfer from the bot to a human. You can make a handover directly or make a transfer to agents within a certain skill or department.

### Basic handover

Make a basic handover to an agent. The conversation will be placed in queue for all available agents regardless of their skill.

The fallback scenario is the scenario that should be triggered when no agents are online or available. In the most common cases it should link to a scenario saying something similar to `Hey! We are closed 🤓`

{% tabs %}
{% tab title="GUI" %}
![](<../../.gitbook/assets/image (104).png>)
{% endtab %}

{% tab title="Syntax" %}

{% endtab %}
{% endtabs %}

### Skill based handover

A skill based handover lets you transfer a conversation to agents within a certain skill. The skill based handover is a combination of the contact agent card and contact agent skills.&#x20;

{% tabs %}
{% tab title="GUI" %}
![](<../../.gitbook/assets/image (75).png>)
{% endtab %}

{% tab title="Syntax" %}
### Syntax

```javascript
[
	{
		"id": "978c3c5b-b485-4fe8-88e3-ec4adf4262b3",
		"name": "state_1613374859518",
		"component": "ebbot_contact_agent_skills",
		"properties": {
			"buttons": [
				{
					"label": "Billing",
					"skill": "billing_skill",
					"type": "variable"
				},
				{
					"label": "Technical Support",
					"skill": "technical_skill",
					"type": "variable"
				}
			],
			"description": "Please choose the department that you would like to talk to",
			"fallbackSkill": {}
		}
	},
	{
		"id": "7b820215-4dbb-4f54-be14-34ad0e9b1d5f",
		"name": "state_1613374338635",
		"component": "ebbot_contact_agent",
		"properties": {
			"text": "Ill connect you to a human shorty",
			"next": {
				"scenario": "we_are_closed"
			}
		},
		"next": {
			"scenario": "we_are_closed"
		}
	}
]
```

### Example usage

```javascript
[
	{
		"id": "978c3c5b-b485-4fe8-88e3-ec4adf4262b3",
		"name": "state_1613374859518",
		"component": "ebbot_contact_agent_skills",
		"properties": {
			"buttons": [
				{
					"label": "Billing",
					"skill": "billing_skill",
					"type": "variable"
				},
				{
					"label": "Technical Support",
					"skill": "technical_skill",
					"type": "variable"
				}
			],
			"description": "Please choose the department that you would like to talk to",
			"fallbackSkill": {}
		}
	},
	{
		"id": "7b820215-4dbb-4f54-be14-34ad0e9b1d5f",
		"name": "state_1613374338635",
		"component": "ebbot_contact_agent",
		"properties": {
			"text": "Ill connect you to a human shorty",
			"next": {
				"scenario": "we_are_closed"
			}
		},
		"next": {
			"scenario": "we_are_closed"
		}
	}
]
```
{% endtab %}
{% endtabs %}
