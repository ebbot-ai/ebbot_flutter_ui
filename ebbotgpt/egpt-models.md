# EGPT models

Read about the technical details and practical implications of Ebbot's models.

### GPT models <a href="#gpt-models" id="gpt-models"></a>

#### 0.6.4 - 5/2024

This model is our best so far for all use cases over our older models. Here are som general information about the model's abilities and limitations.&#x20;

**Intelligence** \
✅ **Math:** Proficient in math (GenAI is generally not great for precise calculations)\
✅/🟡 **Data tables:** \
\- Comprehension: Generally good, depends on table's complexity.\
\- Sending tables: Good, can create new columns and tables and send them in chat.\
🟡 **Language switch:** Doesn't always switch language - depends on welcome message.\
🟡 **Talking out of context:** Model sometimes talk about things not in the sources - depends on persona.

**Hallucinations** \
🟡 **Links, emails, phone numbers**: It sometimes generate fake links, emails, phone numbers - depends on persona.&#x20;

**Effective texts in persona**  \
✅ Listing information in lists with bullet points. \
✅ Asking follow up questions. \
✅ Asking if user wants to speak with a human agent. \
✅/🟡 Talking with a specific tonality - depends on tonality.
