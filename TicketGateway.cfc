component
	output = false
	hint = "I provide data-access methods for tickets."
	{

	/**
	* I create a new ticket and return the ID of the generated record.
	*/
	public numeric function createTicket(
		required numeric boardID,
		required numeric localID,
		required string title,
		required string description,
		required date createdAt
		) {

		```
		<cfquery result="local.insertResults">
			INSERT INTO
				ticket
			SET
				boardID = <cfqueryparam value="#boardID#" sqltype="integer" />,
				localID = <cfqueryparam value="#localID#" sqltype="integer" />,
				title = <cfqueryparam value="#title#" sqltype="varchar" />,
				description = <cfqueryparam value="#description#" sqltype="varchar" />,
				createdAt = <cfqueryparam value="#createdAt#" sqltype="timestamp" />
			;
		</cfquery>
		```

		return( insertResults.generatedKey );

	}


	/**
	* I return the tickets that match the given filter criteria.
	*/
	public array function getTicketsByFilter(
		numeric id = 0,
		numeric boardID = 0,
		numeric localID = 0
		) {

		```
		<cfquery name="local.results" returntype="array">
			SELECT
				t.id,
				t.boardID,
				t.localID,
				t.title,
				t.description,
				t.createdAt
			FROM
				ticket t
			WHERE
				TRUE

			<cfif id>
				AND
					id = <cfqueryparam value="#id#" sqltype="integer" />
			</cfif>

			<cfif boardID>
				AND
					boardID = <cfqueryparam value="#boardID#" sqltype="integer" />
			</cfif>

			<cfif localID>
				AND
					localID = <cfqueryparam value="#localID#" sqltype="integer" />
			</cfif>
			;
		</cfquery>
		```

		return( results );

	}

}
