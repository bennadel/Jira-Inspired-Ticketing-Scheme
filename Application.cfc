component
	output = false
	hint = "I define the application settings and event handlers."
	{

	// Configure the application settings.
	this.name = "TicketingDemo";
	this.applicationTimeout = createTimeSpan( 0, 1, 0, 0 );
	this.sessionManagement = false;
	this.setClientCookies = false;

	// Setup default data-source.
	this.datasources.testing = buildDatasource();
	this.datasource = "testing";

	// ---
	// LIFE-CYCLE METHODS.
	// ---

	/**
	* I get called once when the application is being initialized.
	*/
	public void function onApplicationStart() {

		var boardGateway = new BoardGateway();
		var boardService = new BoardService()
			.setBoardGateway( boardGateway );
		;

		var ticketGateway = new TicketGateway();
		var ticketService = new TicketService()
			.setTicketGateway( ticketGateway )
		;

		var boardWorkflow = new BoardWorkflow()
			.setBoardService( boardService )
			.setTicketService( ticketService )
		;

		// Make services more widely available.
		application.boardService = boardService;
		application.ticketService = ticketService;
		application.boardWorkflow = boardWorkflow;

	}


	/**
	* I get called once when the request is being initialized.
	*/
	public void function onRequestStart() {

		// If the INIT flag is defined, restart the application in order to refresh the
		// in-memory cache of components.
		if ( url.keyExists( "init" ) ) {

			applicationStop();
			location( url = cgi.script_name, addToken = false );

		}

	}

	// ---
	// PRIVATE METHODS.
	// ---

	/**
	* I build and return the default data-source configuration.
	*/
	private struct function buildDatasource() {

		var connectionParams = [
			"useUnicode": "true",
			"characterEncoding": "UTF-8",
			"zeroDateTimeBehavior": "round",
			"serverTimezone": "Etc/UTC",
			"autoReconnect": "true",
			"allowMultiQueries": "true",
			"useLegacyDatetimeCode": "false",
			"tinyInt1isBit": "false",
			"useDynamicCharsetInfo": "false",
			// Maximum performance options:
			// https://dev.mysql.com/doc/connector-j/5.1/en/connector-j-reference-configuration-properties.html
			"cachePrepStmts": "true",
			"cacheCallableStmts": "true",
			"cacheServerConfiguration": "true",
			"useLocalSessionState": "true",
			"elideSetAutoCommits": "true",
			"alwaysSendSetIsolation": "false",
			"enableQueryTimeouts": "false"
		];

		var connectionStringParams = connectionParams
			.reduce(
				( reduction, key, value ) => {

					return( reduction.append( "#key#=#value#") );

				},
				[]
			)
			.toList( "&" )
		;

		return({
			class: "com.mysql.cj.jdbc.Driver",
			connectionString: 'jdbc:mysql://127.0.0.1:3307/ticketing?#connectionStringParams#',
			username: "demo",
			password: "password"
		});

	}

}
