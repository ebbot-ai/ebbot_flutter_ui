# Knowledge

"Knowledge is power," as the saying goes. In the realm of EbbotGPT, 'Knowledge' refers to the dedicated page where EbbotGPT sources its information. On this page, you can craft data sets by scraping websites, invoking APIs, and uploading files for EbbotGPT to convert into documents. These documents are then organized into Data Sets. When EbbotGPT receives a question or request, it searches through these Data Sets and formulates responses based on the most relevant documents available in the configured Data Set.

It is also possible to edit Documents after they have been pulled from a source. This will create a custom version of that document and exclude the source from updating that document in the future.

<figure><img src="../../.gitbook/assets/image (5).png" alt=""><figcaption></figcaption></figure>

### Data Sets

When accessing the Knowledge page, you will find the Data Sets tab selected by default. Data Sets are compilations of sources that update their documents concurrently. When a Data Set is refreshed, it retrieves data from all the sources linked to that specific Data Set. On this tab, all data sets are listed. When clicking a data set, you will see the a list of documents associated with the selected data set. Here, you can search and edit these documents to quickly review EbbotGPT's current knowledge.

### Sources

Sources are the data points from which EbbotGPT gets its knowledge. There are currently 6 types of sources available, you can read more about them and how to set them up on the page below. Under the source tab, you can create and edit your sources settings.&#x20;

{% content-ref url="source-types/" %}
[source-types](source-types/)
{% endcontent-ref %}

### Documents

Documents are generated from the data retrieved from sources. EbbotGPT processes files, websites, and APIs, extracting information to create documents. Each piece of information is parsed into different fields. An embedder then analyzes these fields to identify relevant documents, enabling the model to formulate responses based on these findings.

This structured approach ensures that EbbotGPT can efficiently handle and respond to inquiries by tapping into a rich, organized repository of information, tailored to the specific needs of its users.
