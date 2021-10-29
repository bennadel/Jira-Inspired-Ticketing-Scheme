
# Creating A Group-Based Incrementing Value in MySQL 5.7.32 And Lucee CFML 5.3.7.47

by [Ben Nadel][bennadel]

This is a **code kata** to create a Jira-inspired ticketing scheme, in which the tickets within a board have a unique ID local to that board.

## Blog Posts

I've written about the approaches outlined in this repository here:

* [Creating A Group-Based Incrementing Value In MySQL 5.7.32 And Lucee CFML 5.3.7.47][blog-4135]
* [Creating A Group-Based Incrementing Value Using LAST_INSERT_ID() In MySQL 5.7.32 And Lucee CFML 5.3.7.47][blog-4136]

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

[blog-4135]: https://www.bennadel.com/blog/4135-creating-a-group-based-incrementing-value-in-mysql-5-7-32-and-lucee-cfml-5-3-7-47.htm "Read article: Creating A Group-Based Incrementing Value In MySQL 5.7.32 And Lucee CFML 5.3.7.47"

[blog-4136]: https://www.bennadel.com/blog/4136-creating-a-group-based-incrementing-value-using-last-insert-id-in-mysql-5-7-32-and-lucee-cfml-5-3-7-47.htm "Read article: Creating A Group-Based Incrementing Value Using LAST_INSERT_ID() In MySQL 5.7.32 And Lucee CFML 5.3.7.47"
