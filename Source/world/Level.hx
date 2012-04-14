package world;
import data.Library;
import nme.system.System;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxPoint;
import org.flixel.FlxTilemap;
import org.flixel.FlxU;
import utils.Utils;
import world.Ghost;


class Level extends FlxTilemap {
	var playerStart:FlxPoint;
	public var player:Player;
	public var ghosts:FlxGroup;
	public var coins:FlxGroup;
	
	public function new(p:Player) {
		super();
		
		var w = Library.levelW;
		var h = Library.levelH;
		var halfW = Std.int(w / 2);
		var halfH = Std.int(h / 2);
		
		var mazeGenerator = new MazeGenerator(halfW, halfH);
		mazeGenerator.initMaze();
		mazeGenerator.createMaze();
		
		// generate basic maze
		var tilesIndex = [];
		for (y in 0...halfH) {
			for (x in 0...halfW) {
				var tile = mazeGenerator.maze[x][y]?1:0;
				Utils.set(tilesIndex, w, x, y, tile);
				Utils.set(tilesIndex, w, w - x - 1, y, tile);
				
				Utils.set(tilesIndex, w, x, h-y-1, tile);
				Utils.set(tilesIndex, w, w - x - 1, h-y-1, tile);
				
			}
		}
		
		mazeGenerator.destroy();
		mazeGenerator = null;
		
		// generate some empty lines
		var y = Utils.randomIntInRange(2, Std.int(h / 3));
		clearHorizontalLine(tilesIndex, y);
		clearHorizontalLine(tilesIndex, h - y - 1);

		var x = Utils.randomIntInRange(2, Std.int(w / 3));
		clearVerticalLine(tilesIndex, x);
		clearVerticalLine(tilesIndex, w - x - 1);
		
		loadMap(FlxTilemap.arrayToCSV(tilesIndex, w), FlxTilemap.imgAuto, 8, 8, FlxTilemap.AUTO);
		
		
		playerStart = getFreeTile();
		
		coins = new FlxGroup();
		var map = getData();
		var coinStart = new FlxPoint();
		var x = 0;
		var y = 0;
		for (mi in 0...map.length) {
			if (x >= Library.levelW) {
				x = 0;
				y++;
			}
			
			if (map[mi] == 0 && !(x==playerStart.x && y==playerStart.y)) {
				coinStart.x = x;
				coinStart.y = y;
				coins.add(new Coin(this, coinStart));
			}
			
			x++;
		}
		coinStart = null;
		map = null;
		
		if (p == null) {
			// first level
			player = new Player(this, playerStart);
		} else {
			// recycle the player from previous level
			player = p;
			player.x = playerStart.x * Library.tileSize + (Library.tileSize-player.width)/2;
			player.y = playerStart.y * Library.tileSize + (Library.tileSize-player.height) / 2;
			player.level.destroy();
			player.level = this;
		}
		
		ghosts = new FlxGroup();
	}
	
	public function spawnGhost():Ghost {
		var typeName = FlxG.getRandom(Type.getEnumConstructs(GhostType));
		var pos = new FlxPoint();
		var g = new Ghost(this, pos, typeName);
		var posTaken = false;
		
		do {
			pos = getFreeTile();
			g.setPosition(pos);
			
			posTaken = FlxG.overlap(ghosts, g);
			
		} while (FlxU.getDistance(pos, playerStart) < 5 || posTaken );
		
		ghosts.add(g);
		
		return g;
	}
	
	function clearHorizontalLine(tilesIndex:Array<Int>, y:Int) {
		for (x in 0...Library.levelW) {
			Utils.set(tilesIndex, Library.levelW, x, y, 0);
		}
	}
	
	function clearVerticalLine(tilesIndex:Array<Int>, x:Int) {
		for (y in 0...Library.levelH) {
			Utils.set(tilesIndex, Library.levelW, x, y, 0);
		}
	}
	
	public function getFreeTile():FlxPoint {
		var x = 0;
		var y = 0;
		var map = getData();
		
		do {
			x = Utils.randomInt(Library.levelW);
			y = Utils.randomInt(Library.levelH);			
		} while (Utils.get(map, Library.levelW, x, y) != 0);
		
		return new FlxPoint(x, y);
	}
	
	override public function destroy() {
		super.destroy();
		
		playerStart = null;
		ghosts.destroy();
		ghosts = null;
		coins.destroy();
		coins = null;
		
		System.gc();
		System.gc();
	}
}