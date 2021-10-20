
CREATE TABLE `board` (
	`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	`companyID` int(10) unsigned NOT NULL,
	`slug` varchar(10) NOT NULL,
	`title` varchar(255) NOT NULL,
	`createdAt` datetime NOT NULL,
	PRIMARY KEY (`id`),
	UNIQUE KEY `IX_bySlug` (`companyID`,`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `board_ticket_incrementer` (
	`boardID` int(10) unsigned NOT NULL,
	`maxTicketID` int(10) unsigned NOT NULL,
	PRIMARY KEY (`boardID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `ticket` (
	`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	`boardID` int(10) unsigned NOT NULL,
	`localID` int(10) unsigned NOT NULL,
	`title` varchar(255) NOT NULL,
	`description` varchar(3000) NOT NULL,
	`createdAt` datetime DEFAULT NULL,
	PRIMARY KEY (`id`),
	UNIQUE KEY `IX_byLocalID` (`boardID`,`localID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;











TRUNCATE TABLE `board`;
TRUNCATE TABLE `board_ticket_incrementer`;
TRUNCATE TABLE `ticket`;

SELECT
	boardID,
	MAX( localID ),
	COUNT( * )
FROM
	ticket
GROUP BY
	boardID
;