component
	accessors = true
	output = false
	hint = "I provide entity methods for tickets."
	{

	// Define properties for dependency-injection.
	property ticketGateway;

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I create a new ticket and return the ID of the generated record.
	*/
	public numeric function createTicket(
		required numeric boardID,
		required numeric localID,
		required string title,
		required string description
		) {

		if ( ! title.len() ) {

			throwEmptyTitleError( arguments );

		}

		var existingTickets = ticketGateway.getTicketsByFilter(
			boardID = boardID,
			localID = localID
		);

		// NOTE: The underlying database enforces a UNIQUE KEY on the boardID / localID
		// combination. However, by explicitly checking for a conflict prior to creation,
		// it gives us a chance to throw a more consumable error (instead of bubbling-up
		// a key-constraint violation error from the database).
		if ( existingTickets.len() ) {

			throwLocalIdConflictError( arguments );

		}

		var id = ticketGateway.createTicket(
			boardID = boardID,
			localID = localID,
			title = title,
			description = description,
			createdAt = dateConvert( "local2utc", now() )
		);

		return( id );

	}

	// ---
	// PRIVATE METHODS.
	// ---

	/**
	* I throw an empty-title error for the given context.
	*/
	private void function throwEmptyTitleError( required struct errorContext ) {

		throw(
			type = "Ticket.EmptyTitle",
			message = "Ticket cannot have an empty title",
			extendedInfo = serializeJson( errorContext )
		);

	}


	/**
	* I throw a localID conflict error for the given context.
	*/
	private void function throwLocalIdConflictError( required struct errorContext ) {

		throw(
			type = "Ticket.LocalIdConflict",
			message = "LocalID value already being used",
			extendedInfo = serializeJson( errorContext )
		);

	}

}
