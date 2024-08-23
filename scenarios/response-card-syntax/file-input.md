# File Input

## Multi File Input

Prompt the user to upload a number of files (1-10) of one or more specific mime (file) types.

{% tabs %}
{% tab title="GUI" %}
![](<../../.gitbook/assets/image (44).png>)
{% endtab %}

{% tab title="Syntax" %}
### Syntax

```javascript
[
    {
        "id": "b3792de1-f8bd-4752-a531-b918fb2ks2jz",
        "name": "state_1616140357083",
        "component": "ebbot_multi_file",
        "properties": {
            "mimeType": "application/pdf,image/png",
            "ask_again": false,
            "minFiles": 1,
            "maxFiles": 3,
            "text": "Upload your files please",
            "disclaimer": "You're allowed to upload 1-3 files. Only PDF and PNG file types are allowed in this example.",
            "output": "uploaded_files",
            "uploadText": "Choose files",
            "submitText": "Submit files"
        }
    }
]
```
{% endtab %}
{% endtabs %}

#### What the chat user will see:

* Headline text (description)
* Disclaimer text (disclaimer)
* Browse file button text (upload button text)
* Submit file button text (submit button text)

#### In the scenario editor you will be able to set the settings above, as well as:

* A range of files to allow the user to upload (with a maximum of 10).
* Which mime (file) types that the users are allowed to upload using that multi file input card.
  * If the mime type you would like to allow for upload is not present in the dropdown menu, you can add it manually in the code editor.
* Name of the variable (in the data object) where the file information is saved.

### Data object

The file objects stored in the data object will in this example look like the example below.

The individual file objects contain:

* 'label' (file name)
* 'mimetype'
* 'size' (in Bytes)
* 'url' (to the file)

The files are stored in an array in uploaded\_files (the variable name you set in the card settings) -> files -> array.

```javascript
...
'db': {
    'uploaded_files': {
        'files': [{
            'label': '1615980339237_1615890209161_name_of_first_file_1615980339237_1615890209161.pdf',
            'mimetype': 'application/pdf',
            'size': 13831,
            'url': 'https: //url_to_the_file.com/'
        }, {
            'label': '1615980339237_1615890209161_name_of_second_file_1615890209232_1615980339327.png',
            'mimetype': 'image/png',
            'size': 9473,
            'url': 'https: //url_to_the_file.com/'
        }]
    }
...
```

{% hint style="info" %}
In order to use the files you need to create a custom component and parse the data above from the data object.
{% endhint %}
