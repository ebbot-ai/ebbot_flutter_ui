# Entities

Entities allows you to extract data from a user expression. Ebbot provides predefined entities that can be used to extract data such as color, numbers, location, date and so on. You can also define your own entities for matching custom data. For example, you can define a car brand entity to that can match different brands to this particular entity and then re use the information in the dialog.

You will find it under Custom vocabulary

![](<../.gitbook/assets/image (42).png>)

## Custom vocabulary

You can easily create your own entity to extract custom data. In this example we are going to create a new entity that can match car models from the user expressions.

1. Start by clicking new button on the entity page and then give a few examples of the new entity. If you want, you can add synonyms to each row to get a better match.&#x20;
2. Now we need to train a scenario and mark the part of the user expression that match our new entity. We are doing that by entering training phrases and then select which part of the text that is a car brand in this case.

&#x20;3\. You don't need to have all the possible alternatives for car brands in the entity list. You can just mark the part of phrase that should be extracted as a car brand and then select the car model entity.

## Predefined entities

In order to make it easier and more powerful for you we have already implemented support for a lot of predefined entities so that you can start extracting data without the need to create custom entities for everything. The most common ones are:

* date and time&#x20;
* numbers&#x20;
* amounts with units (temperature, speed, weight, percentage)
* street address and cities
* zip code
* full name
* given name
* last name
* email
* phone number
* url
