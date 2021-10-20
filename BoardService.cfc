component
	accessors = true
	output = false
	hint = "I provide entity methods for boards."
	{

	// Define properties for dependency-injection.
	property boardGateway;

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I create a new board and return the ID of the generated record.
	*/
	public numeric function createBoard(
		required numeric companyID,
		required string slug,
		required string title
		) {

		if ( ! slug.len() ) {

			throwEmptySlugError( arguments );

		}

		if ( ! title.len() ) {

			throwEmptyTitleError( arguments );

		}

		var existingBoards = boardGateway.getBoardsByFilter(
			companyID = companyID,
			slug = slug
		);

		// NOTE: The underlying database enforces a UNIQUE KEY on the companyID / slug
		// combination. However, by explicitly checking for a conflict prior to creation,
		// it gives us a chance to throw a more consumable error (instead of bubbling-up
		// a key-constraint violation error from the database).
		if ( existingBoards.len() ) {

			throwSlugConflictError( arguments );

		}

		transaction {

			var id = boardGateway.createBoard(
				companyID = companyID,
				slug = slug,
				title = title,
				createdAt = dateConvert( "local2utc", now() )
			);
			// NOTE: We are keeping track of the board-local maxTicketID in an isolated
			// table since incrementing and reading the maxTicketID will require a
			// SERIALIZABLE transaction row-lock in the future. And, we don't want to
			// have locks on the main board table affect other parts of the application.
			boardGateway.createTicketIncrementer(
				boardID = id,
				maxTicketID = 0
			);

		}

		return( id );

	}


	/**
	* I return the board with the given ID.
	*/
	public struct function getBoardByID( required numeric id ) {

		var boards = boardGateway.getBoardsByFilter( id = id );

		if ( ! boards.len() ) {

			throwBoardNotFoundError( arguments );

		}

		return( boards.first() );

	}


	/**
	* I increment the maxTicketID for the given board and return the incremented value.
	*/
	public numeric function incrementAndGetMaxTicketID( required numeric id ) {

		// Since we need to atomically UPDATE a row and then READ the isolated result,
		// we need to run this within a SERIALIZABLE transaction. This will LOCK the row
		// with the given boardID for update ensuring that we read the incremented
		// maxTicketID without having to worry about competing threads.
		transaction isolation = "serializable" {

			// WHY NOT USE A COUNT()? WHY STORE THE MAXTICKETID? If we were to use a
			// COUNT() aggregate to calculate the next maxTicketID value on-the-fly, we
			// wouldn't be able to account for historical records. As such, we might end
			// up re-using old values as rows are deleted from the database. This could
			// cause all sorts of referential integrity problems once ticket IDs make it
			// out "into the wild". By persisting the maxTicketID, we make sure that it
			// only ever contains historically-unique values.
			boardGateway.incrementMaxTicketID( id );

			return( boardGateway.getMaxTicketID( id ) );

		}

	}

	// ---
	// PRIVATE METHODS.
	// ---

	/**
	* I throw a not found error for the given context.
	*/
	private void function throwBoardNotFoundError( required struct errorContext ) {

		throw(
			type = "Board.NotFound",
			message = "Board not found",
			extendedInfo = serializeJson( errorContext )
		);

	}


	/**
	* I throw an empty-slug error for the given context.
	*/
	private void function throwEmptySlugError( required struct errorContext ) {

		throw(
			type = "Board.EmptySlug",
			message = "Board cannot have an empty slug",
			extendedInfo = serializeJson( errorContext )
		);

	}


	/**
	* I throw an empty-title error for the given context.
	*/
	private void function throwEmptyTitleError( required struct errorContext ) {

		throw(
			type = "Board.EmptyTitle",
			message = "Board cannot have an empty title",
			extendedInfo = serializeJson( errorContext )
		);

	}


	/**
	* I throw a slug conflict error for the given context.
	*/
	private void function throwSlugConflictError( required struct errorContext ) {

		throw(
			type = "Board.SlugConflict",
			message = "Slug value already being used",
			extendedInfo = serializeJson( errorContext )
		);

	}

}
