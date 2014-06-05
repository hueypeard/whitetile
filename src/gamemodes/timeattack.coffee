class window.whitetile.gamemodes.TimeAttackGamemode extends window.whitetile.gamemodes.WhiteTileGamemode

	renderGameOver: (game) ->
		super game
		game.font.renderStringCenter(
			game
			"SCORE " + @steps
			game.width / 2
			game.height / 2
			3
		)
		return

	renderOverlay: (game) ->
		timeNow = (new Date().getTime() / 1000)
		
		xOffset = 20
		leftX = xOffset
		rightX = game.width - xOffset
		#captions

		captionY = game.height - 55
		game.font.renderString(game, "SCORE", leftX, captionY, 1)
		game.font.renderStringRight(game, "TIME", rightX, captionY, 1)
		
		#data items
		valueY = game.height - 35
		game.font.renderString(
			game
			@steps.toString()
			leftX
			valueY
			2
		)

		game.font.renderStringRight(
			game
			(@endTime - timeNow).toFixed(3).toString()
			rightX
			valueY
			2
		)

		if @endTime < timeNow
			@isPlaying = false

		return

	onHit: (game, tileIndex) ->
		@steps += 1
		
	onFail: (game, tileIndex) ->
		@isPlaying = false

	reset: (game) ->
		@steps = 0
		@startTime = new Date().getTime() / 1000
		@timeLimit = 15
		@endTime = @startTime + @timeLimit
		super game

	onKeyDown: (game, e) ->
		if e.keyCode == 13
			@reset(game)
			return false
	
		return @isPlaying
