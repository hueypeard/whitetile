class window.whitetile.gamemodes.WhiteTileGamemode
	constructor: (game) ->
		@isPlaying = false
		@reset(game)

	render: (game) ->
		if @isPlaying
			@renderOverlay(game)
		else
			@renderGameOver(game)

		game.textureList.logo.renderCenter(game, game.width / 2, 20, 3)

	renderStatusBar: (game, startY) ->
		game.gameContext.fillStyle = "#2c3e50"
		game.gameContext.fillRect(0, startY, game.width, game.statusBarHeight)
		game.gameContext.fillStyle = "#34495e"
		game.gameContext.fillRect(4, startY + 5, game.width - 8, game.statusBarHeight - 8)
		return

	renderGameOver: (game) ->
		game.gameContext.fillStyle = "rgba(192, 57, 43, 0.8)"
		game.gameContext.fillRect(0, 0, game.width, game.height)

		game.textureList.game_over.renderCenter(game, game.width / 2, game.height / 2 - 150, 3)
		game.textureList.press_enter.renderCenter(game, game.width / 2, 550, 2)

		return

	renderOverlay: (game) ->
	onHit: (game, tileIndex) ->
	onFail: (game, tileIndex) ->
	onKeyDown: (game, e) ->
		return true

	reset: (game) ->
		game.regenerateTiles()
		@isPlaying = true
		return


class window.whitetile.WhiteTile extends window.gamelib.BaseGame
	constructor: (@canvasSelector) ->
		@gamemode = new window.whitetile.gamemodes.WhiteTileGamemode(this)
		@width = 384
		@statusBarHeight = 64
		@height = 640 + @statusBarHeight
		@regenerateTiles()

		@tileHeight = Math.floor (@height - @statusBarHeight) / 4
		@tileWidth = Math.floor @width / 4

		@textureList = {
			"press_enter":new window.gamelib.Texture(0, 12, 123, 16)
			"logo":new window.gamelib.Texture(0, 32, 113, 33)
			"game_over":new window.gamelib.Texture(0, 72, 108, 20)
		}

		@font = new window.gamelib.BitmapFont(
			"1234567890.CEIMOSRT"
			9
			12
			0
			0
		)

		@specialTileColors = [
			"#1A71AA"
			"#1F76AF"
			"#247BB4"
			"#2980b9"
		]
		
		@whiteTileColors = [
			"#DDE1E2"
			"#E2E6E7"
			"#E7EBEC"
			"#ecf0f1"
		]

		@deadTileColors = [
			"#DDDDDD"
			"#E2E2E2"
			"#E7E7E7"
			"#ECECEC"
		]

		@keys = [81, 87, 69, 82]

		@resourceImage = new Image();
		@resourceImage.src = "font.png";

	regenerateTiles: ->
		@tiles = (@generateLine() for num in [0...4])

	generateLine: ->
		specialTile = Math.floor(Math.random()*4)
		return ((if specialTile is num then 1 else 0) for num in [0...4])

	render: ->
		@renderTiles()

		if not @inMainMenu()
			@gamemode.renderStatusBar(this, @height - @statusBarHeight)
		else
			@gameContext.fillStyle = @specialTileColors[-1]
			@gameContext.fillRect 0, @height - @statusBarHeight, @width, @statusBarHeight
			@textureList.press_enter.renderCenter(this, @width / 2, 500, 2)

		@gamemode.render(this)


		requestAnimationFrame(=> @render())
		
		return

	renderTiles: ->
		for row, index in @tiles
			@renderRow(row, index) 
		return

	renderTile: (x, y, color) ->
		@gameContext.fillStyle = color
		@gameContext.fillRect x, y, @tileWidth, @tileHeight
		return

	renderGameOver: (x, y, color) ->


	getTileColor: (row, index, special) ->
		tileColor = @whiteTileColors[index]
		if special
			tileColor = @specialTileColors[index]
		if not @gamemode.isPlaying
			tileColor = @deadTileColors[index]
		return tileColor

	renderRow: (row, index) ->
		for tile, tileIndex in row
			if @inMainMenu()
				tile = 1
			tileColor = if tile == 1 then @specialTileColors[index] else @whiteTileColors[index]
			@renderTile(tileIndex*@tileWidth, index*@tileHeight, tileColor)

		return

	inMainMenu: ->
		return @gamemode.constructor.name is "WhiteTileGamemode"

	keyDown: (e) ->
		if @gamemode.onKeyDown(this, e)
			if @inMainMenu() and e.keyCode == 13
				@gamemode = new window.whitetile.gamemodes.TimeAttackGamemode(this)
			else
				if e.keyCode in @keys
					tileIndex = @keys.indexOf(e.keyCode)
					if @tiles[3][tileIndex] is 1
						@gamemode.onHit(this, tileIndex)
						@tiles.pop()
						@tiles.unshift @generateLine()
						console.log "hit the right tile"
					else
						@gamemode.onFail(this, tileIndex)
						console.log "game over"
						#TODO

		return