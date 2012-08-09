package world;
import data.Library;
import nme.system.System;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import org.flixel.FlxTilemap;
import org.flixel.FlxU;
import utils.Colors;
import utils.Utils;
import world.Ghost;


class Level extends FlxTilemap {
	var playerStart:FlxPoint;
	public var player:Player;
	public var ghosts:FlxGroup;
	public var coins:FlxGroup;
	public var towers:FlxGroup;
	public var bullets:FlxGroup;
	public var powerups:FlxGroup;
	public var powerupEffect:Splosion;
	public var activePowerups:Hash<Float>;
	public var freePos:Array<FlxPoint>;
	
	
	public function new(p:Player) {
		super();
		
		freePos = [];
		
		var w = Library.levelW;
		var h = Library.levelH;
		var halfW = Std.int(w / 2);
		var halfH = Std.int(h / 2);
		
		var mazeGenerator = new MazeGenerator(halfW, halfH);
		mazeGenerator.initMaze();
		mazeGenerator.createMaze();
		
		activePowerups = new Hash();
		
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
			//player.level.destroy();
			player.level = this;
		}
		
		player.time = 120;
		
		ghosts = new FlxGroup();
		towers = new FlxGroup();
		bullets = new FlxGroup();
		powerups = new FlxGroup();
		
		powerupEffect = new Splosion(Colors.WHITE);
		
	}
	
	public function spawnGhost():Ghost {
		var typeName = FlxG.getRandom(Type.getEnumConstructs(GhostType));
		var pos = new FlxPoint();
		var g = new Ghost(this, pos, typeName);
		var posTaken = false;
		
		var playerPos = new FlxPoint(player.x, player.y);
		Utils.convertPixelToTilePosition(playerPos);
				
		var tries = 0;
		do {
			pos = getFreeTile();
			g.setPosition(pos);
			
			posTaken = FlxG.overlap(ghosts, g);
			tries++;
		} while (FlxU.getDistance(pos, playerPos) < 5 || posTaken || tries>20 || FlxU.getDistance(movePoint(pos, 10), movePoint(playerPos, 10)) < 5);
		
		if(g!=null)
			ghosts.add(g);
		
		return g;
	}
	
	public function movePoint(p:FlxPoint,d:Int):FlxPoint {
		var alternateX = p.x + 5;
		if (alternateX >= Library.levelW) alternateX -= Library.levelW;
		var alternateY = p.y + 5;
		if (alternateY >= Library.levelH) alternateY -= Library.levelH;
		return new FlxPoint(alternateX, alternateY);
	}
	
	public function spawnPowerup(pos:FlxPoint):Powerup {
		var p = new Powerup(this, pos);
		powerups.add(p);
		if (Library.debug) {
			//trace("powerup added "+pos.x+" "+pos.y);
		}
		return p;
	}
	
	public function buildTower(pos:FlxPoint):Tower {
		Utils.convertPixelToTilePosition(pos);
		
		var t:Tower = new Tower(this,pos);
		towers.add(t);
		bullets.add(t.weapon.group);
		
		return t;
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
	
	public function isFree(x:Int, y:Int):Bool {
		if (x < 0) {
			x = Library.levelW - 1;
		} else if (x >= Library.levelW ) {
			x = 0;
		} 
		if (y < 0) {
			y = Library.levelH - 1;
		} else if (y >= Library.levelH) {
			y = 0;
		}
		
		return Utils.get(getData(), Library.levelW, x, y) == 0;
	}
	
	var p0:FlxPoint;
	var p1:FlxPoint;
	public function getGhostInRange(s:FlxSprite, range:Float):Ghost {
		if (p0 == null) {
			p0 = new FlxPoint();
			p1 = new FlxPoint();
		}
		p1.x = s.x;
		p1.y = s.y;
		for (g in ghosts.members) {
			var ghost = cast(g, Ghost);
			p0.x = ghost.x;
			p0.y = ghost.y;
			
			if (FlxU.getDistance(p0, p1) < range) {
				return ghost;
			}
		}
		
		return null;
	}
	
	override public function destroy() {
		super.destroy();
		
		playerStart = null;
		ghosts.destroy();
		ghosts = null;
		coins.destroy();
		coins = null;
		towers.destroy();
		towers = null;
		bullets.destroy();
		bullets = null;
		powerups.destroy();
		powerups = null;
		activePowerups = null;
		powerupEffect.destroy();
		powerupEffect = null;
		
		freePos = null;
		
		p0 = null;
		p1 = null;
		
		System.gc();
		System.gc();
	}
}