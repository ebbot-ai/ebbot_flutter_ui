# Python components

{% hint style="warning" %}
**Note:**

Deploying custom components in Ebbot is currently only available to Ebbot developers, however this documentation can be used to locally recreate the data object that all components bases its functionality on. If you have created a component you would like to use in Ebbot, reach out to helpme@ebbot.ai and we'll help you set it up.
{% endhint %}

You are able to pass data from your scenario to a custom component, where it can be processed and then returned to the scenario, or if you like, trigger another scenario or state. Custom components are useful for calling an external API, creating a ticket, or passing data to your own systems.

## Passing data to python component



Create a new state and give your component a name. In the example below we named the component `test_component` You can pass as many variables as you like to the component.

```javascript
[
    {
        "name": "state_1",
        "component": "test_component",
        "properties": {
            "key": "value1",
            "key2": "value2"
        }
    }
]
```

### `test_component.py`

The following component collects data from the scenario and returns a text response to the chat.

```python
def main(data):

    ## 1. Collecting data from scenario
    variableOne = data['properties']['key'] ## value1
    variableTwo = data['properties']['key2'] ## value2

    ## 2. Write some magic code

    ## 3. Returning a component to the scenario
    return
    {
        "component": "ebbot_text",
        "properties": {
            "text": variableTwo
        }
    }
```

### `test_store_data.py`

The following component returns data, making it accessible from a scenario or other custom components.

```python
def main(data):

    ## 1. Collecting data from scenario
    variableOne = data['db']['key'] ## value1

    ## 2. New variable to pass into scenario
    variableTwo = "Some data that should be accessed from the chat"

    ## 3. Write some magic code

    ## 4. Returning a variable to the scenario
    return
    {
        "database": {
            "key2": variableTwo
        }
    }
```

> **Note!** You need to write your code for python 3.4 or later.

## Custom dependencies

You can easily add your own python dependencies by adding them to the requirements tab. This is useful if you want to add a python package to your bot or if you want to re-use code.

```
requests
numpy
scrapy
```

You need to import the package into the python code to use it

```python
import requests
import numpy
import scrapy
```
