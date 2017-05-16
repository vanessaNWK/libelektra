# Use Case: Create A Misconfiguration Report

## Summary

Title: Create A Misconfiguration Report
Scope: Entry Management
Level: User Goal
Actors: Logged in user
Brief: User can create new misconfiguration report through variuous parameters including the misconfiguration itself

## Scenarios

Precondition: user is logged in
Main success scenario: The report could be stored in the database and the validation returns no errors. The user is redirected to view the submitted report.
Alternative scenario: The report could be stored in the database and the validation returns with an error message for the user. The user is redirected to view the submitted report.
Error scenario: The report could not be stored in the database (e.g. not all non optional input fields have been filled out correctly). An appropriate error message is displayed.
Postcondition: New misconfiguration report is stored in the database and can be searched.
Non-functional Constraints:
	- Essential functionality
