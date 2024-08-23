# Encoding

## Message body

Messages sent with the REST API are divided into one or more SMSs. The message body, which is represented by the Text parameter, is encoded using UTF-8. When only GSM characters1 are used the maximum size of a single SMS is 160 characters. For longer messages the API will automatically split the text into multiple SMSs, each with a maximum of 153 characters. When characters not represented in the GSM 03.38 are used, the message body will be encoded using UCS-2 (UTF-16 Big Endian) and the maximum size of each SMS is 70 characters. The API will split the message into several SMSs of maximum 67 characters.

> A long message split into multiple SMSs are automatically interlaced on the receiving device and shown as one message.

## Phone number formats

All phone numbers should be given in international format, see E.164 and NANP. MSISDNs (phone numbers) should start with +, e.g. +46707659443. If part of an URI the + shall be omitted, e.g. 46707659443.

