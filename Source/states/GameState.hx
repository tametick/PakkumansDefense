package states;

import com.eclecticdesignstudio.motion.Actuate;
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
import world.Ghost;
import world.Level;
import world.Player;

class GameState extends FlxState {
	var level:Level;
	var levelNumber:Int;
	
	var coinCounter:FlxText;
	var ghostCounter:FlxText;
	
	var killedGhosts:Int;
	var spawnRate:Float;
	var counter:Float;
	
	override public function create():Void {
		Log.setColor(0xFFFFFF);
		FlxG.mouse.show();
		FlxG.bgColor = Colors.BLACK;

		FlxG.camera.scroll.y = FlxG.camera.scroll.x = -Library.tileSize / 2;
		
		newLevel();
		
		coinCounter = new FlxText(level.width + 8, 8, Std.int(FlxG.width - level.width - 8), "$: 0");
		coinCounter.scrollFactor.x = 0;
		coinCounter.scrollFactor.y = 0;
		coinCounter.setColor(Colors.LGREEN);
		add(coinCounter);
		
		ghostCounter = new FlxText(level.width + 8, coinCounter.y+coinCounter.height, Std.int(FlxG.width - level.width - 8), "Kills: 0");
		ghostCounter.scrollFactor.x = 0;
		ghostCounter.scrollFactor.y = 0;
		ghostCounter.setColor(Colors.BLUEGRAY);
		add(ghostCounter);
		
		FlxG.worldBounds.x -= 50; 
		FlxG.worldBounds.y -= 50;
		FlxG.worldBounds.width += 100; 
		FlxG.worldBounds.height += 100;
	}
	
	function newLevel():Void {
		levelNumber++;
		spawnRate = 2 / levelNumber;
		
		FlxG.fade(0, 0.5, true, null, true);
		
		var p:Player = null;
		if (level != null) {
			p = level.player;
		}	
		
		level = new Level(p);
		add(FlxGridOverlay.create(Library.tileSize, Library.tileSize, Std.int(level.width), Std.int(level.height), false, true, Colors.DBLUE, Colors.DGREEN));
		add(level);
		add(level.coins);
		add(level.player);
		add(level.ghosts);
		
		counter = 0;
	}
	
	override public function update() {
		super.update();
		
		FlxG.collide(level, level.player);
		FlxG.collide(level, level.ghosts);
		FlxG.overlap(level.player, level.coins, pickUpCoin);
		FlxG.overlap(level.player, level.ghosts, gameOver);
		
		counter += FlxG.elapsed;
		if (counter >= spawnRate) {
			counter = 0;
			level.spawnGhost();
		}
	}
	
	function gameOver(p:Player, g:Ghost) {
		reset();
	}
	
	function reset(){
		FlxG.fade(0, 0.5);
		Actuate.timer(0.5).onComplete(FlxG.switchState, [new MenuState()]);
	}
	
	function pickUpCoin(p:Player, c:Coin) {		
		level.coins.remove(c);
		level.player.coins++;
		coinCounter.text = "$: " + level.player.coins;
	}
	
	override public function destroy() {
		super.destroy();
		
		level.player.destroy();
		level.player = null;
		
		level = null;
	
		coinCounter.destroy();
		coinCounter = null;
		ghostCounter.destroy();
		ghostCounter = null;
	}
}