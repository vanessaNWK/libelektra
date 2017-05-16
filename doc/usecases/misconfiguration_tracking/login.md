# Use Case: Login

## Summary

Title: Login
Scope: User Management
Level: User Goal
Actors:Anonymous user
Brief: Any user can login to gain more privilegues than search and view misconfigurations

## Scenarios

Precondition: User is not logged in
Main success scenario: User is logged in, username appears in the right upper corner 
Alternative scenario: Login was not successful (e.g. wrong username or password). Error messages appears, user is asked to check credientals again.
Error scenario: Login was not successful (e.g. lost connection). Error messages informs user about the problem.
Postcondition: User is able to create, edit his/her own, track and comment on reported misconfigurations.
Non-functional Constraints:
	- Precondition to access more privilegued functions
	
