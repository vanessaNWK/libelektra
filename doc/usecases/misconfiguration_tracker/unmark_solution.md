# Use Case: Unmark Comment As Solution

## Summary

Title: Unmark Comment As Solution
Scope: Commenting
Level: User Goal
Actors: Logged in user, creator of the misconfiguration
Brief: One or more comments are unmarked as solutions.

## Scenarios

Precondition: User is logged in and the creator of the misconfiguration report. The report has at least one comment that is marked as solution.
Main success scenario: One or more comments are successfully unmarked as solutions. If the report has at least one comment marked as solution it stays closed,
otherwise it is reopened.
Alternative scenario: 
Error scenario: The comment could not be unmarked. User is informed about the error.
Postcondition: The report is either closed and has a solution, or open and comments can be added again.
Non-functional Constraints:
	- Essential function
