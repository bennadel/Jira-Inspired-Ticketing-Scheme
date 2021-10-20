component
	accessors = true
	output = false
	hint = "I provide workflow methods for boards."
	{

	// Define properties for dependency-injection.
	property boardService;
	property ticketService;

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I create a new board and return the ID of the board.
	*/
	public numeric function createBoard(
		required numeric companyID,
		required string slug,
		required string title
		) {

		var boardID = boardService.createBoard(
			companyID = companyID,
			slug = slug,
			title = title
		);

		return( boardID );

	}


	/**
	* I create a new ticket within the given board and return the ID of the new ticket.
	*/
	public numeric function createTicket(
		required numeric boardID,
		required string title,
		required string description
		) {

		var board = boardService.getBoardByID( boardID );
		// Each ticket will have a board-specific (local) ID. This allows a ticket to be
		// uniquely identified by a combination of the board SLUG and the LOCAL ID such
		// that two tickets with the same local ID, ex: "MYBOARD-1" and "YOURBOARD-1",
		// can peacefully coexist.
		// --
		// CAUTION: The following method uses a SERIALIZABLE transaction under the hood
		// in order to lock the board-row for the increment-and-get operation. DO NOT try
		// to include this operation in a larger, multi-statement transaction as
		// extending the serializable transaction to include different tables may cause
		// unexpected deadlocks (especially if the ticket table has no rows associated
		// with a given board ID). Read more at:
		// --
		// https://www.bennadel.com/blog/4133-the-scope-of-serializable-transaction-row-locking-is-larger-when-rows-dont-yet-exist-in-mysql-5-7-32.htm
		// https://bugs.mysql.com/bug.php?id=25847
		// https://stackoverflow.com/questions/17068686/how-do-i-lock-on-an-innodb-row-that-doesnt-exist-yet
		var localID = boardService.incrementAndGetMaxTicketID( board.id );

		var ticketID = ticketService.createTicket(
			boardID = board.id,
			localID = localID,
			title = title,
			description = description
		);

		return( ticketID );

	}

}
