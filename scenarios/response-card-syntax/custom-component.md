# Custom component

You can pass data from your scenario to a custom component where you can process it and then return it to the scenario. Or if you like trigger another scenario or state.

Custom components are useful when you want to call an external API or create a ticket or pass data to your own systems.

### Graphical view

Select the custom component card in the card selector and select the custom component that you have created. You need to create the component before calling it. When using the graphical mode, you will not be able to pass data to the component.

### Code editor

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

Each variable will be accessible through the data object sent to the custom component. In this scenario we will end up with the following two variables:

```python
data['properties']['key'] ## value1
data['properties']['key2'] ## value2
```

## Python component

You can easily create custom python components. For details on how to create python components [click here](https://ebbot.gitbook.io/ebbot-docs/python-components).

> The platform supports version 3.4 or later.

