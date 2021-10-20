component
	output = false
	hint = "I provide data-access methods for boards."
	{

	/**
	* I create a new board and return the ID of the generated record.
	*/
	public numeric function createBoard(
		required numeric companyID,
		required string slug,
		required string title,
		required date createdAt
		) {

		```
		<cfquery result="local.insertResults">
			INSERT INTO
				board
			SET
				companyID = <cfqueryparam value="#companyID#" sqltype="integer" />,
				slug = <cfqueryparam value="#slug#" sqltype="varchar" />,
				title = <cfqueryparam value="#title#" sqltype="varchar" />,
				createdAt = <cfqueryparam value="#createdAt#" sqltype="timestamp" />
			;
		</cfquery>
		```

		return( insertResults.generatedKey );

	}


	/**
	* I create a new board ticket incrementer row to keep track of local IDs.
	*/
	public void function createTicketIncrementer(
		required numeric boardID,
		required numeric maxTicketID
		) {

		```
		<cfquery name="local.results">
			INSERT INTO
				board_ticket_incrementer
			SET
				boardID = <cfqueryparam value="#boardID#" sqltype="integer" />,
				maxTicketID = <cfqueryparam value="#maxTicketID#" sqltype="integer" />
			;
		</cfquery>
		```

	}


	/**
	* I return the boards that match the given filter criteria.
	*/
	public array function getBoardsByFilter(
		numeric id = 0,
		numeric companyID = 0,
		string slug = ""
		) {

		```
		<cfquery name="local.results" returntype="array">
			SELECT
				b.id,
				b.companyID,
				b.slug,
				b.title,
				b.createdAt
			FROM
				board b
			WHERE
				TRUE

			<cfif id>
				AND
					id = <cfqueryparam value="#id#" sqltype="integer" />
			</cfif>

			<cfif companyID>
				AND
					companyID = <cfqueryparam value="#companyID#" sqltype="integer" />
			</cfif>

			<cfif slug.len()>
				AND
					slug = <cfqueryparam value="#slug#" sqltype="varchar" />
			</cfif>
			;
		</cfquery>
		```

		return( results );

	}


	/**
	* I get the maxTicketID value for the given board.
	*/
	public numeric function getMaxTicketID( required numeric boardID ) {

		```
		<cfquery name="local.results">
			SELECT
				i.maxTicketID
			FROM
				board_ticket_incrementer i
			WHERE
				i.boardID = <cfqueryparam value="#boardID#" sqltype="integer" />
			;
		</cfquery>
		```

		return( val( results.maxTicketID ) );

	}


	/**
	* I increment the maxTicketID value for the given board.
	*/
	public void function incrementMaxTicketID( required numeric boardID ) {

		```
		<cfquery name="local.results">
			UPDATE
				board_ticket_incrementer
			SET
				maxTicketID = ( maxTicketID + 1 )
			WHERE
				boardID = <cfqueryparam value="#boardID#" sqltype="integer" />
			;
		</cfquery>
		```

	}

}
