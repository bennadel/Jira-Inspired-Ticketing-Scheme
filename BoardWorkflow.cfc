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
		// NOTE: We're using the LAST_INSERT_ID() function, under the hood, to safely
		// increment this value across parallel requests.
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
