// Generated by CoffeeScript 1.7.1
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  window.whitetile.gamemodes.WhiteTileGamemode = (function() {
    function WhiteTileGamemode(game) {
      this.isPlaying = false;
      this.reset(game);
    }

    WhiteTileGamemode.prototype.render = function(game) {
      if (this.isPlaying) {
        this.renderOverlay(game);
      } else {
        this.renderGameOver(game);
      }
      return game.textureList.logo.renderCenter(game, game.width / 2, 20, 3);
    };

    WhiteTileGamemode.prototype.renderStatusBar = function(game, startY) {
      game.gameContext.fillStyle = "#2c3e50";
      game.gameContext.fillRect(0, startY, game.width, game.statusBarHeight);
      game.gameContext.fillStyle = "#34495e";
      game.gameContext.fillRect(4, startY + 5, game.width - 8, game.statusBarHeight - 8);
    };

    WhiteTileGamemode.prototype.renderGameOver = function(game) {
      game.gameContext.fillStyle = "rgba(192, 57, 43, 0.8)";
      game.gameContext.fillRect(0, 0, game.width, game.height);
      game.textureList.game_over.renderCenter(game, game.width / 2, game.height / 2 - 150, 3);
      game.textureList.press_enter.renderCenter(game, game.width / 2, 550, 2);
    };

    WhiteTileGamemode.prototype.renderOverlay = function(game) {};

    WhiteTileGamemode.prototype.onHit = function(game, tileIndex) {};

    WhiteTileGamemode.prototype.onFail = function(game, tileIndex) {};

    WhiteTileGamemode.prototype.onKeyDown = function(game, e) {
      return true;
    };

    WhiteTileGamemode.prototype.reset = function(game) {
      game.regenerateTiles();
      this.isPlaying = true;
    };

    return WhiteTileGamemode;

  })();

  window.whitetile.WhiteTile = (function(_super) {
    __extends(WhiteTile, _super);

    function WhiteTile(canvasSelector) {
      this.canvasSelector = canvasSelector;
      this.gamemode = new window.whitetile.gamemodes.WhiteTileGamemode(this);
      this.width = 384;
      this.statusBarHeight = 64;
      this.height = 640 + this.statusBarHeight;
      this.regenerateTiles();
      this.tileHeight = Math.floor((this.height - this.statusBarHeight) / 4);
      this.tileWidth = Math.floor(this.width / 4);
      this.textureList = {
        "press_enter": new window.gamelib.Texture(0, 12, 123, 16),
        "logo": new window.gamelib.Texture(0, 32, 113, 33),
        "game_over": new window.gamelib.Texture(0, 72, 108, 20)
      };
      this.font = new window.gamelib.BitmapFont("1234567890.CEIMOSRT", 9, 12, 0, 0);
      this.specialTileColors = ["#1A71AA", "#1F76AF", "#247BB4", "#2980b9"];
      this.whiteTileColors = ["#DDE1E2", "#E2E6E7", "#E7EBEC", "#ecf0f1"];
      this.deadTileColors = ["#DDDDDD", "#E2E2E2", "#E7E7E7", "#ECECEC"];
      this.keys = [81, 87, 69, 82];
      this.resourceImage = new Image();
      this.resourceImage.src = "font.png";
    }

    WhiteTile.prototype.regenerateTiles = function() {
      var num;
      return this.tiles = (function() {
        var _i, _results;
        _results = [];
        for (num = _i = 0; _i < 4; num = ++_i) {
          _results.push(this.generateLine());
        }
        return _results;
      }).call(this);
    };

    WhiteTile.prototype.generateLine = function() {
      var num, specialTile;
      specialTile = Math.floor(Math.random() * 4);
      return (function() {
        var _i, _results;
        _results = [];
        for (num = _i = 0; _i < 4; num = ++_i) {
          _results.push(specialTile === num ? 1 : 0);
        }
        return _results;
      })();
    };

    WhiteTile.prototype.render = function() {
      this.renderTiles();
      if (!this.inMainMenu()) {
        this.gamemode.renderStatusBar(this, this.height - this.statusBarHeight);
      } else {
        this.gameContext.fillStyle = this.specialTileColors[-1];
        this.gameContext.fillRect(0, this.height - this.statusBarHeight, this.width, this.statusBarHeight);
        this.textureList.press_enter.renderCenter(this, this.width / 2, 500, 2);
      }
      this.gamemode.render(this);
      requestAnimationFrame((function(_this) {
        return function() {
          return _this.render();
        };
      })(this));
    };

    WhiteTile.prototype.renderTiles = function() {
      var index, row, _i, _len, _ref;
      _ref = this.tiles;
      for (index = _i = 0, _len = _ref.length; _i < _len; index = ++_i) {
        row = _ref[index];
        this.renderRow(row, index);
      }
    };

    WhiteTile.prototype.renderTile = function(x, y, color) {
      this.gameContext.fillStyle = color;
      this.gameContext.fillRect(x, y, this.tileWidth, this.tileHeight);
    };

    WhiteTile.prototype.renderGameOver = function(x, y, color) {};

    WhiteTile.prototype.getTileColor = function(row, index, special) {
      var tileColor;
      tileColor = this.whiteTileColors[index];
      if (special) {
        tileColor = this.specialTileColors[index];
      }
      if (!this.gamemode.isPlaying) {
        tileColor = this.deadTileColors[index];
      }
      return tileColor;
    };

    WhiteTile.prototype.renderRow = function(row, index) {
      var tile, tileColor, tileIndex, _i, _len;
      for (tileIndex = _i = 0, _len = row.length; _i < _len; tileIndex = ++_i) {
        tile = row[tileIndex];
        if (this.inMainMenu()) {
          tile = 1;
        }
        tileColor = tile === 1 ? this.specialTileColors[index] : this.whiteTileColors[index];
        this.renderTile(tileIndex * this.tileWidth, index * this.tileHeight, tileColor);
      }
    };

    WhiteTile.prototype.inMainMenu = function() {
      return this.gamemode.constructor.name === "WhiteTileGamemode";
    };

    WhiteTile.prototype.keyDown = function(e) {
      var tileIndex, _ref;
      if (this.gamemode.onKeyDown(this, e)) {
        if (this.inMainMenu() && e.keyCode === 13) {
          this.gamemode = new window.whitetile.gamemodes.TimeAttackGamemode(this);
        } else {
          if (_ref = e.keyCode, __indexOf.call(this.keys, _ref) >= 0) {
            tileIndex = this.keys.indexOf(e.keyCode);
            if (this.tiles[3][tileIndex] === 1) {
              this.gamemode.onHit(this, tileIndex);
              this.tiles.pop();
              this.tiles.unshift(this.generateLine());
              console.log("hit the right tile");
            } else {
              this.gamemode.onFail(this, tileIndex);
              console.log("game over");
            }
          }
        }
      }
    };

    return WhiteTile;

  })(window.gamelib.BaseGame);

}).call(this);
