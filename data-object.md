# Data Object

The data object is a powerful tool for managing and accessing information throughout a conversation. It allows you to store and retrieve data as well as access conversation and customer information, providing flexibility and customization for your chatbot. This documentation will guide you through the structure of the data object and its various components.

## Overview

The data object consists of the following key components:

* `id`: Unique identifier for the current state in the conversation.
* `name`: Name of the current state.
* `parameters`: An object to pass data into custom components, not persisted across states.
* `db`: An object to store and retrieve data throughout the conversation.
* `conversation`: An object containing information about the conversation.
* `customer_info`: An object containing information about the customer.
* `chatId`: Unique identifier for the chat.

## Structure

The data object has the following structure:

```json
{
    "id": "example_id",
    "name": "state_example",
    "parameters": {},
    "db": {},
    "conversation": {
        "user_last_input": "Hello there 😀",
        "browser": "chrome",
        "os": "Mac OS",
        "platform": "web",
        "time_before_start": 0
    },
    "customer_info": {
        "id": "example_customer_id",
        "image": null,
        "info": {
            "invoice_id": "3453342",
            "premium_customer": "true"
        },
        "first_name": "Inclined", 
        "last_name": "Kangaroo"
    },
    "chatId": "example_chat_id"
}
```

### Parameters Object

The `parameters` object is empty by default but can be used to pass data into custom components. The data stored in the `parameters` object will not be persisted during the conversation and is only valid for the triggered component.

### DB Object

The `db` object allows you to store and retrieve data during the conversation. For example, you can store user inputs, variable button presses, and information about uploaded files.

### Conversation Object

The `conversation` object contains information about the ongoing conversation, such as the user's last input, the browser used, the operating system, and the platform.

### Customer Object

The `customer_info` object contains information about the customer, such as their unique ID, first and last name, and any additional information you'd like to store.

## Usage

You can access and manipulate the data object throughout the conversation to provide a personalized and dynamic user experience. Store data in the `db` object, pass temporary data through the `parameters` object, and access conversation and customer information to customize the chatbot's responses.

## File Upload Card Example

When a user uploads a file using a File Upload Card, the information about the uploaded file is stored in the `db` object. Here is an example of how the `db` object would look like after a file has been uploaded:

```json
"db": {
    "customer_uploaded_file": {
        "messageId": "example_message_id",
        "files": [{
            "filename": "logo (1).png",
            "size": 3385,
            "mimetype": "image/png",
            "label": "logo (1).png",
            "key": "example_key",
            "url": "https://example.storage.googleapis.com/example_path/logo_(1).png"
        }],
        "type": "file_list"
    }
}
```

In this example, a user has uploaded a file named "logo (1).png". The file information is stored under the `customer_uploaded_file` key in the `db` object. You can access this information throughout the conversation to perform actions such as displaying the file, sending it to another API, or storing it in a database.

To access the uploaded file's URL, you can use the following syntax:

```python
file_url = data['db']['customer_uploaded_file']['files'][0]['url']
```

This will retrieve the URL of the uploaded file, which can be used for further processing or displaying to the user. For more information and examples on working with Multi File Input, please refer to our [GitBook](scenarios/response-card-syntax/file-input.md#multi-file-input) page.
