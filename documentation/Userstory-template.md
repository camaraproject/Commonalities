# User Story Template
This document specifies the template for documenting user stories related to API families in CAMARA project. 

| Item                      | Description | Support Qualifier |
|---------------------------|-------------|-------------------|
| Summary                   |             | M                 |
| Roles, Actor(s) and scope |             | M                 |
| NF Requirements           |             | O                 |
| Pre-conditions            |             | M                 |
| Begins when               |             | M                 |
| Step 1                    |             | (M/O/CM)          |
| Step 2                    |             | (M/O/CM           |
| ...                       |             | (M/O/CM)          |
| Step N                    |             | (M/O/CM)          |
| Ends when                 |             | M                 |
| Post-conditions           |             | M                 |
| Exceptions                |             | M                 | 


Some notes related to the above template:

- The **Support Qualifier** column allows capturing the need for specifying the item. _Options -> M (Mandatory); O (Optional); CM (Conditional Mandatory)_.
- The **Summary** item provides a user story description as a user persona, following the same syntax structure -> "**As a** (Persona), **I want** (Need), **so that** (Goal)".
  - A user story based on _user persona_ focuses on expectations from the Point-of-View of an end-user. This is contrary to a user story based on _system persona_, which is designed to represent background system functions that do not require interaction from the end-user (i.e., elaborate on the behind-the-scenes integration tasks that are not user-centric).
- The **Roles, Actor(s) and scope** item allows linking a user story with existing Cloud/NaaS reference architectures. The architectures that are within the scope of the CAMARA project are detailed in this document: [Reference.Architectures.pptx](/documentation/SupportingDocuments/Reference.Architectures.pptx)
  - Roles: specifies the role(s) that the CAMARA API customer plays for the user story. _Options -> customer:user; customer:administrator; customer:business manager_.
  - Actor(s): API usage should not be restricted to a particular actor (e.g., application service provider, hyperscaler, application developer, or end user where e.g. consent is required). Examples may use a particular actor to perform a role in the API flow, but that does not exclude other Actors from performing the role.
  - Scope: specifies the service lifecycle area(s) that the user story impacts on. _Options -> Design time; Prospect to Order (P2O); Usage to Cash (U2C); Order to Activate (O2A); Trouble to Resolution (T2R)_.

# Linking a user story to API design

Once we have the user story, the next step is to clarify the **data journey** in the context of the target and source systems we are integrating:
- Think about triggers for workflows: how and when does data need to be moved between the application and the service?
- Think about dependencies of data objects: does the data in underlying objects need to be regularly kept in sync with another system?
- Think about any parameters the user might need to configure or change. This is particularly important when building self-serve integrations for non-technical end users.
- Think about privacy by design: does any data represent sensitive information, and how can this be safely shared/stored according to regulation (e.g., anonymisation, tokenisation, zero-trust principles)
