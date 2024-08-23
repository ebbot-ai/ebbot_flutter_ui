# Web

## Script to implement the snippet

You will find the code under Chat widget/Settings.

\
**Example code:**

```markup
<script>
      window.Ebbot = {
        botId: 'XXXXXXXXXXXXXXXXXX',
      };
</script>
    
<script>!function(t){var e="init-js-widget";if(!t.getElementById(e)){var i=t.createElement("script");i.id=e,i.src="https://ebbot-v2.storage.googleapis.com/ebbot-web/init.js?t="+Math.random(),t.querySelector("body").appendChild(i)}}(document);</script>
```

## Settings

| **Name**                                                |             Setting             | **Description**                                                                                                                                     |
| ------------------------------------------------------- | :-----------------------------: | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Avatar**                                              |         `Default/custom`        | <p>Default is a picture of Ebbot. <br>If you choose custom it let's you upload what ever image you want. Supported images are gif, png and jpeg</p> |
| **Chat bubble icon**                                    |         `Default/custom`        | <p>Default is the ebbot chat icon<br>If you choose custom it let's you upload what ever image you want. Supported images are gif, png and jpeg</p>  |
| **Color**                                               |        Example `#ff33f3`        | Insert the desired color code or use the built in color picker                                                                                      |
| **Placeholder text**                                    | Example:`"Ask me something..."` | The text that is visible in the chats input field by default                                                                                        |
| **Chat client height**                                  |           `Half/Tall`           | Half takes up 60% of the screen, Tall takes up 90%                                                                                                  |
| **Footer**                                              |             `On/Off`            | Let's you toggle a small footer below the chats input field on or off.                                                                              |
| **Chat Client Position**                                |           `Left/Right`          | Positions the chat to the left bottom corner or the right bottom corner                                                                             |
| **Chat client position on mobile**                      |           `Left/Right`          | Positions the chat to the left bottom corner or the right bottom corner (for mobile only)                                                           |
| **Open chat automatically on page load on mobile?**     |             `Yes/No`            | Wether or not to auto-open the chat on page load for mobile (no is recommended)                                                                     |
| **Allow different arrow color?**                        |             `Yes/No`            | Yes shows the colorpicker where you can set the color: Example `#ff33f3`                                                                            |
| **Hide chat**                                           |             `Yes/No`            | Disables the chat for everyone                                                                                                                      |
| **Disable pop after internal link in desktop**          |             `Yes/No`            | If set to yes the chat wont auto-open when you link to a page within the same domain                                                                |
| **Disable pop after internal link in mobile landscape** |             `Yes/No`            | Same as above for but for mobile (landscape)                                                                                                        |
| **Disable pop after internal link on mobile portrait**  |             `Yes/No`            | Same as above for but for mobile (portrait)                                                                                                         |
| **Disable title and badge count for bot messages**      |             `Yes/No`            | Yes removes the badge that show number of unread messages                                                                                           |
| **Sounds for bot**                                      |             `Yes/No`            | Enable and disable the sound for when a new message is received from the bot                                                                        |
| **Sounds for agent**                                    |             `Yes/No`            | Enable and disable the sound for when a new message is received from an agent (after handover to a human)                                           |
| **Show agent typing on chat**                           |             `Yes/No`            | Wether to send typing indicator or not                                                                                                              |
| **Show agent avatar on chat top**                       |             `Yes/No`            | Show the agents avatar after handover has been done (top)                                                                                           |
| **Show agent avatar on chat bubble**                    |             `Yes/No`            | Show the agents avatar after handover has been done (with messages)                                                                                 |
| **Clear chat on tab close**                             |             `Yes/No`            | Resets the chat if the user closes the tab (good for sensitive data)                                                                                |
| **Chat language**                                       |   `English/Swedish/Norwegian`   | Let you choose what language the chat should be displayed in (menus, buttons and also WCAG-support)                                                 |
| **Min Message Delay (ms)**                              |            `0-100000`           | <p>The minimum time in ms that it will take before the message gets sent.</p><p>Example: <code>100</code></p>                                       |
| **Max Message Delay (ms)**                              |            `0-100000`           | <p>The maximum time in ms that the bot will wait before the message gets sent</p><p>Example: <code>1000</code></p>                                  |
| **Character Delay (ms)**                                |            `0-100000`           | <p>How much time each character adds to the calculated time before the message gets sent.</p><p>Example: <code>15</code></p>                        |
| T**yping Delay (ms)**                                   |            `0-100000`           | <p>For how long the typing indicator is sent.</p><p>Example: <code>50</code></p>                                                                    |

## CSS Editor

If you need even more branding possibilities our chat is fully customizable with the use of CSS.&#x20;

