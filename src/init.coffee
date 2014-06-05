window.whitetile.playingMusic = false
window.whitetile.backgroundMusic = new Audio("music.mp3")

Zepto(->

	window.game = new window.whitetile.WhiteTile("#game-canvas")
	window.game.setup()
	window.game.start()
	window.whitetile.backgroundMusic.loop = true

	playMusic = ->
		window.whitetile.backgroundMusic.currentTime = 0
		window.whitetile.backgroundMusic.play()

	stopMusic = ->
		window.whitetile.backgroundMusic.pause()
		return

	window.whitetile.backgroundMusic.addEventListener(
		"ended"
		->
			if window.whitetile.playingMusic
				playMusic()
	)

	$("#music-toggle").on(
		"click"
		->
			window.whitetile.playingMusic = not window.whitetile.playingMusic
			if window.whitetile.playingMusic
				playMusic()
			else
				stopMusic()

	)
)