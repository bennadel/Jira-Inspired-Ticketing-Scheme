<cfscript>

	ninjaBoardID = application.boardWorkflow.createBoard(
		companyID = 1,
		slug = "NINJA",
		title = "Ninja Board"
	);
	rockstarBoardID = application.boardWorkflow.createBoard(
		companyID = 1,
		slug = "ROCK",
		title = "Rockstar Board"
	);

	// Create competing, sibling threads for the both the ROCKSTAR and NINJA boards -
	// each thread is going to try and create a large number of tickets, competing with
	// the sibling threads for localID ticket values.
	loop times = 10 {
		// LOOP will end up spawning 10 parallel threads and 10,000 tickets for ROCKSTAR.
		loadTestBoard( rockstarBoardID, 1000 );
		// LOOP will end up spawning 10 parallel threads and 10,000 tickets for NINJA.
		loadTestBoard( ninjaBoardID, 1000 );
	}

	thread action = "join";
	dump( cfthread );

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	/**
	* I spawn an asynchronous thread that creates the given number of tickets on the
	* given board.
	*/
	public void function loadTestBoard(
		required numeric boardID,
		required numeric ticketCount
		) {

		thread
			name = "load-test-#createUniqueId()#"
			boardID = boardID
			ticketCount = ticketCount
			{

			loop times = ticketCount {

				application.boardWorkflow.createTicket(
					boardID = boardID,
					title = "Ticket #createUniqueId()#",
					description = "Never gonna give you up, never gonna let you down."
				);

			}

		}

	}

</cfscript>
