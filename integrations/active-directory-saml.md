---
description: Add Ebbot to your Active Directory
---

# Active Directory - SAML

When a user logs into Ebbot it is done using the access management platform Keycloak. Keycloak can connect to your external Active Directory (AD) using a feature called “User Federation”. This feature makes it possible to synchronise users, groups and their roles from AD to Keycloak.&#x20;

We (Ebbot) always recommend that you configure the integration of Ebbot into a test AD, if you have one. If your organisation does not have a test AD, just follow the instructions and configure the integration to production.&#x20;

## Prerequisites in Ebbot

* Company&#x20;
* Bot(s)
* Skills (if relevant)
* Domain ([client.ebbot.eu](http://client.ebbot.eu))

If you have a contact person at Ebbot that is involved in the configuration, please add this person to your AD so that they can test the login.

## Configuration

Provide us with IdP SAML entity descriptor metadata (URL from where it can be fetched or as a file). The URL can look something like this: "[https://fed.client.se/federationmetadata/2007-06/federationmetadata.xml](https://fed.client.se/federationmetadata/2007-06/federationmetadata.xml)".

The federation file should include the needed attributes logging into Ebbot via AD. You will find the essential attributes below:

| <mark style="background-color:yellow;">**Attribute**</mark> | <mark style="background-color:yellow;">**Description**</mark> |
| ----------------------------------------------------------- | ------------------------------------------------------------- |
| First name                                                  | The user’s first name                                         |
| Last name                                                   | The user’s last name                                          |
| Email                                                       | The user’s email address                                      |
| UserID                                                      | The user’s user ID                                            |
| Roles                                                       | The role that the user should have in Ebbot                   |
| Bots                                                        | The bots that the user should access in Ebbot                 |
| Skills                                                      | The skills the user should have in Ebbot                      |

In your AD, the configuration of attributes can look something like this: 

```
        <Subject>
            <SubjectConfirmation Method="XXXX">
                <SubjectConfirmationData InResponseTo="XXXX" NotOnOrAfter="XXXX" Recipient=“XXXX.ebbot.eu”/>
            </SubjectConfirmation>
        </Subject>
        <Conditions NotBefore="XXXX" NotOnOrAfter="XXXX">
            <AudienceRestriction>
                <Audience>https://account.ebbot.eu/realms/ebbot</Audience>
            </AudienceRestriction>
        </Conditions>
        <AttributeStatement>
            <Attribute Name="Firstname">
                <AttributeValue>Sara</AttributeValue>
            </Attribute>
            <Attribute Name="Lastname">
                <AttributeValue>Andersson</AttributeValue>
            </Attribute>
            <Attribute Name="Email">
                <AttributeValue>sara@ebbot.ai</AttributeValue>
            </Attribute>
            <Attribute Name="Roles">
                <AttributeValue>ebbot-access-role-admin</AttributeValue>
            </Attribute>
        </AttributeStatement>
        <AuthnStatement AuthnInstant="XXXXXX">
            <AuthnContext>
                <AuthnContextClassRef>urn:federation:authentication:windows</AuthnContextClassRef>
            </AuthnContext>
        </AuthnStatement>

```

Please note that:

* Skills are only relevant if they are included in your Ebbot setup
* When setting the roles, make sure that there is only one role per person

To continue the configuration, you need a SP SAML entity descriptor metadata URL from Ebbot to insert in your AD.

You can set up yourself, a colleague or your Ebbot contact person as an Ebbot user in your AD to test if the configuration was successful.
