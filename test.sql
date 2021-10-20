
-- Reset tables.
TRUNCATE TABLE `board`;
TRUNCATE TABLE `board_ticket_incrementer`;
TRUNCATE TABLE `ticket`;


-- Look at localIDs per board.
SELECT
	boardID,
	MAX( localID ),
	COUNT( * )
FROM
	ticket
GROUP BY
	boardID
;
