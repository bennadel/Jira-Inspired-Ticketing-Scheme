
# Creating A Group-Based Incrementing Value in MySQL 5.7.32 And Lucee CFML 5.3.7.47

by [Ben Nadel][bennadel]

This is a **code kata** to create a Jira-inspired ticketing scheme, in which the tickets within a board have a unique ID local to that board.

## Performance Comparison of `SERIALIZABLE` vs `LAST_INSERT_ID()`

**`SERIALIZABLE` Approach**:

* Load Test Execution: 99,978 ms
* Load Test Execution: 92,423 ms
* Load Test Execution: 89,788 ms
* Load Test Execution: 94,659 ms
* Load Test Execution: 88,517 ms

**`LAST_INSERT_ID()` Approach**:

* Load Test Execution: 52,441 ms
* Load Test Execution: 40,282 ms
* Load Test Execution: 45,239 ms
* Load Test Execution: 47,421 ms
* Load Test Execution: 46,509 ms


[bennadel]: https://www.bennadel.com/
