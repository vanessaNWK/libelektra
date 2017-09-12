# Use Case: Track A Misconfiguration Report

## Summary

Title: Track A Misconfiguration Report
Scope: Tracking
Level: User Goal
Actors: Logged in user
Brief: A user can track misconfigurations so he/she will be notified everytime something changes. (e.g. new comment is posted, solution is marked, misconfiguration is closed)

## Scenarios

Precondition: User is logged in and not already tracking the misconfiguration
Main success scenario: Misconfiguration is successfullly marked as tracked and a notification arrives via email.
Alternative scenario: Misconfiguration is successfully marked as tracked and no notification arrives via email. Misconfiguration has to be untracked and tracked again.
Error scenario: Misconfiguration could not be tracked (e.g. connection issue). User is informed via error message.
Postcondition: Misconfiguration is marked as tracked and notifications arrive via email.
Non-functional Constraints:
	- Essential functionality
