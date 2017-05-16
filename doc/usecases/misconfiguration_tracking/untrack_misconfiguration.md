# Use Case: Untrack A Misconfiguration Report

## Summary

Title: Untrack A Misconfiguration Report
Scope: Tracking
Level: User Goal
Actors: Logged in user
Brief: A user can untrack misconfigurations so he/she will not be notified anymore everytime something changes. (e.g. new comment is posted, solution is marked, misconfiguration is closed)

## Scenarios

Precondition: User is logged in and already tracking the misconfiguration
Main success scenario: Misconfiguration is successfullly untracked and a last notification informs the user about it via email.
Alternative scenario: Misconfiguration is successfully untracked and no notification arrives via email. Misconfiguration has to be tracked and untracked again.
Error scenario: Misconfiguration could not be untracked (e.g. connection issue). User is informed via error message.
Postcondition: Misconfiguration is untracked and is notifications via email for the last time.
Non-functional Constraints:
	- Essential functionality
