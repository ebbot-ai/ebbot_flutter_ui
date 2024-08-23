# Website scrape

This section helps you customize the website scraping process to efficiently collect the data you need. Here, you'll learn how to specify which pages to scrape, refine data extraction, and adjust scraper behavior to respect website protocols and optimize performance.

It's important to note that websites differ significantly in their structure and content management. Therefore, tweaking the settings to align with the specific characteristics of the site you are targeting is crucial for getting accurate and relevant results. Each setting is designed to enhance control and efficiency in your data collection tasks, allowing for a tailored approach to each unique web environment.

Let's get started and configure your scraper effectively to help EbbotGPT gain some knowledge!

<figure><img src="../../../.gitbook/assets/image (131).png" alt=""><figcaption></figcaption></figure>

#### URL

Here you provide the URL that the scraper should start from, if "Only scrape pages starting with url" is checked, the scraper will only scrape pages that contains the full URL provided in this field.&#x20;

#### Include/Exclude Settings

Also referred to as whitelist/blacklist, these settings allow you to control which pages are included or excluded during scraping. For inclusion, specify parts of the URL that must or must not match. For example, to include pages containing "/ai-chatbot" in the URL, you can add "ebbot.com/sv/ai-chatbot" or "/ai-chatbot" to the whitelist. Use "and" to require that all conditions are met, or "or" to allow any condition to be sufficient.

#### Query Selector

Understanding query selectors is beneficial when configuring this setting. The scraper waits for the specified HTML element to appear before proceeding. To define a selector, inspect the desired element on the web page, identify a unique ID or class, and input it as `#yourId` for IDs or `.yourClass` for classes. You can combine these for more specific targeting (e.g., `#id1.class1.class2`). Test your selector using the browser's console to ensure it selects the intended element correctly.

#### Query Selector Remove

This option allows you to remove elements from the HTML by matching them with a query selector. If certain content is consistently undesirable (cookie consent elements for example), specify it here to exclude it from all scraped data. Similar methods apply as with the initial query selector configuration.&#x20;

#### Disable JavaScript

Enabling this setting will stop all JavaScript on the page, which can prevent tracking scripts and cookie banners from loading. However, be cautious with sites that rely on JavaScript for rendering, as disabling it may prevent the page from displaying correctly.

#### Disable Readability

This setting turns off the readability script, allowing the scraper to view the page as a regular visitor would. If the site does not support readability mode, or if readability alters the desired content, consider disabling this feature.

#### Check sitemap.xml

If enabled, the scraper checks the site's sitemap.xml for URLs before starting, which may reveal unlinked or hidden pages. Be mindful of scraping non-public pages and disable this feature if necessary.

#### Slowmode

Slowmode reduces the number of simultaneous connections to one, decreasing the likelihood of being perceived as a threat by security systems. This mode significantly increases scrape duration. If a lengthy scrape is necessary, consider breaking it into segments using targeted whitelists/blacklists to ensure completion within time limits.

These settings provide comprehensive control over the scraping process, allowing for tailored data collection that respects site constraints and maximizes efficiency.
