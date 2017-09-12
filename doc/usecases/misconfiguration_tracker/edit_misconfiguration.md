# Use Case: Edit A Misconfiguration Report

## Summary

Title: Edit A Misconfiguration Report
Scope: Entry Management
Level: User Goal
Actors: Logged in user, creator of the report
Brief: Users can edit their own reports and save the changes to the database.

## Scenarios

Precondition: User is logged in, user is the creator of the misconfiguration
Main success scenario: Changes to the report are successfully stored in the database. Misconfiguration is validated. 
Alternative scenario: The submitted changes could not be stored (e.g. due to input validation). The user is informed about the error. 
Error scenario: The submitted changes could not be stored (e.g. due to connection issues) The user is informed about the error.
Postcondition: Changes are stored in the database and can be viewed.
Non-functional Constraints:
	- Moderative feature
