window.requestAnimationFrame = window.requestAnimationFrame || window.mozRequestAnimationFrame || window.webkitRequestAnimationFrame || window.msRequestAnimationFrame;

window.gamelib = {}
window.whitetile = {
	"gamemodes":{}
}

class window.gamelib.BaseGame
	setup: ->
		@loadCanvas @canvasSelector
		@hookKeyboard()
		return

	start: ->
		requestAnimationFrame(=> @render())
		return

	loadCanvas: (canvasSelector) ->
		@gameCanvas = $(canvasSelector)[0]

		@gameContext = @gameCanvas.getContext("2d")
		
		@gameContext.imageSmoothingEnabled = false
		@gameContext.webkitImageSmoothingEnabled = false
		@gameContext.mozImageSmoothingEnabled = false

		return

	hookKeyboard: ->
		window.addEventListener "keydown", ((e) => @keyDown(e))
		return

	renderResource: (sourceX, sourceY, sourceWidth, sourceHeight, destX, destY, destWidth, destHeight) ->
		@gameContext.drawImage(
			@resourceImage
			sourceX
			sourceY
			sourceWidth
			sourceHeight
			destX
			destY
			destWidth
			destHeight
		)
		return

	###
	The following methods are to be implemented
	by classes inheriting BaseGame
	###
	
	render: =>
		return

	keyDown: (e) ->
		return

class window.gamelib.BitmapFont
	constructor: (@characterList, @charWidth, @charHeight, @startX, @startY) ->

	getTextWidth: (text, scale) ->
		return text.length * (@charWidth * scale)

	getTextHeight: (text, scale) ->
		return @charHeight * scale

	renderCharacter: (game, character, x, y, scale) ->
		if character not in @characterList
			return
		
		charIndex = @characterList.indexOf(character)
		game.renderResource(
			@startX + charIndex * @charWidth
			@startY
			@charWidth
			@charHeight
			x
			y
			@charWidth*scale
			@charHeight*scale
		)
		return

	renderString: (game, text, x, y, scale) ->
		for currentX in [0...text.length] 
			@renderCharacter(
				game
				text[currentX]
				x + ((@charWidth * scale) * currentX)
				y
				scale
			)
		
		return

	renderStringRight: (game, text, x, y, scale) ->
		@renderString(game, text, x - @getTextWidth(text, scale), y, scale)
		return

	renderStringCenter: (game, text, x, y, scale) ->
		@renderString(game, text, x - (@getTextWidth(text, scale) / 2), y, scale)
		return

class window.gamelib.Texture
	constructor: (@startX, @startY, @width, @height) ->

	render: (game, x, y, scale) ->
		game.renderResource(
			@startX
			@startY
			@getWidth()
			@getHeight()
			x
			y
			@getWidth()*scale
			@getHeight()*scale
		)

	renderRight: (game, x, y, scale) ->
		@render(game, x - (@getWidth()*scale), y, scale)
		return

	renderCenter: (game, x, y, scale) ->
		@render(game, x - (@getWidth()*scale / 2), y, scale)
		return

	getWidth: ->
		return @width

	getHeight: ->
		return @height