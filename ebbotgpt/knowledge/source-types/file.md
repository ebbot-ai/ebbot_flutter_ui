# File

The File source lets you upload CSV and JSON files as sources. Documents will then be generated from the fields in the file.&#x20;

<figure><img src="../../../.gitbook/assets/image (7).png" alt=""><figcaption></figcaption></figure>

## Settings

In the settings you are able to specify which fields to be used and which field is to be used as an ID column. You can also define some advanced settings like Separator and quoteChar.

**Format**

Select which file type you are uploading. Advanced options are only available for CSV type files.

**Id Field**

Please note that uploaded files need to have an ID-field in order to create documents. It can be any field in your file provided it has unique values per source.&#x20;

**Searchable fields**

These are the fields the embedder will search and find for EbbotGPT to generate answers from. When an end user asks a question, this is the information EbbotGPT will have available. Here you will add all field names from your file that you want to include in the documents created from this source.&#x20;

**Stringified fields**

If specified, only the Stringified fields will be used to generate responses and be visible in the "Show sources" panel in the widget. Searchable fields will still be used for the embedder to find documents, but responses will only be generated from the fields specified here. If not specified, all fields specified in searchable fields will be included.

## Advanced Settings (CSV only)

Here you can specify some things specific to CSV files:&#x20;

**Delimiter**

The delimiter is a character used to separate individual fields within a record in your file. Commonly used delimiters include commas (`,`), semicolons (`;`),  (`\t`). Choose the delimiter that matches the format of the file you are uploading to ensure that the data is parsed correctly into distinct fields. Comma (`,`) is used by default.

**QuoteChar**

The quote character (quoteChar) is used to encapsulate fields that contain delimiters or special characters, ensuring they are treated as single units. Double quotes (`"`) are commonly used and set as default, but you can specify a different character if your data requires it. Enclosing complex fields in quotes prevents parsing errors during the upload process.&#x20;

**Encoding**

Encoding determines how characters in your file are interpreted and stored. UTF-8 is the default encoding, supporting a wide range of characters from different languages. If your file uses a different character set, adjust the encoding setting accordingly to preserve the integrity of the data during conversion.
