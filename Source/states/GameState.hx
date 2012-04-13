package states;

import data.Library;
import haxe.Log;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.plugin.photonstorm.FlxGridOverlay;
import utils.Colors;
import world.Coin;
import world.Level;
import world.Player;

class GameState extends FlxState {
	var level:Level;
	var levelNumber:Int;
	
	var coinCounter:FlxText;
	var ghostCounter:FlxText;
	
	public var killedGhosts:Int;
	public var spawnRate:Float;
	
	override public function create():Void {
		Log.setColor(0xFFFFFF);
		FlxG.mouse.show();
		FlxG.bgColor = Colors.BLACK;

		FlxG.camera.scroll.y = FlxG.camera.scroll.x = -Library.tileSize / 2;
		
		newLevel();
		
		coinCounter = new FlxText(level.width + 8, 8, Std.int(FlxG.width - level.width - 8), "$: 0");
		coinCounter.scrollFactor.x = 0;
		coinCounter.scrollFactor.y = 0;
		coinCounter.setColor(Colors.BLUEGRAY);
		add(coinCounter);
		
		FlxG.worldBounds.x -= 50; 
		FlxG.worldBounds.y -= 50;
		FlxG.worldBounds.width += 100; 
		FlxG.worldBounds.height += 100;
	}
	
	function newLevel():Void {
		FlxG.fade(0, 0.5, true, null, true);
		level = new Level();
		add(FlxGridOverlay.create(Library.tileSize, Library.tileSize, Std.int(level.width), Std.int(level.height), false, true, Colors.DBLUE, Colors.DGREEN));
		add(level);
		add(level.coins);
		add(level.player);
		add(level.ghosts);
		
		for (g in 0...10) {
			level.spawnGhost();
		}
	}
	
	override public function update() {
		super.update();
		
		FlxG.collide(level, level.player);
		FlxG.collide(level, level.ghosts);
		FlxG.overlap(level.player, level.coins, pickUpCoin);
	}
	
	function pickUpCoin(p:Player, c:Coin) {		
		level.coins.remove(c);
		level.player.coins++;
		coinCounter.text = "$: " + level.player.coins;
	}
}