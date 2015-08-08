## Dependencies ################################################################

{CompositeDisposable} = require "atom"
{Socket} = require "net"

## Package #####################################################################

module.exports = GmodLuadev =

	## Fields ##################################################################

	commands: null

	## Activator / Deactivator #################################################

	activate: ->
		# Regsiter command event handlers
		@events = new CompositeDisposable
		@events.add( atom.commands.add( "atom-text-editor", {
			"gmod-luadev:sv": => @send( "sv" )
			"gmod-luadev:sh": => @send( "sh" )
			"gmod-luadev:cl": => @send( "cl" )
			"gmod-luadev:self": => @send( "self" )
		} ) )

	deactivate: ->
		@events.dispose()

	## Command #################################################################

	send: ( destination, client = "" ) ->
		ed = atom.workspace.getActiveTextEditor()
		if not ed?
			return

		s = Socket()
		s.connect( 27099 )
		s.write(
			# Destination
			destination + "\n" +
			# Filename
			ed.getTitle() + "\n" +
			# Specific client (or "" for all)
			client + "\n" +
			# Source
			ed.getText()
		)
		s.end()
