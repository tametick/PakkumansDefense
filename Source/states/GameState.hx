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
import org.flixel.plugin.photonstorm.baseTypes.Bullet;
import org.flixel.plugin.photonstorm.FlxGridOverlay;
import ui.Cursor;
import utils.Colors;
import utils.Utils;
import world.Coin;
import world.Ghost;
import world.Level;
import world.Player;

class GameState extends FlxState {
	var bg: FlxSprite;
	
	var level:Level;
	var levelNumber:Int;
	
	var levelCounter:FlxText;
	var coinCounter:FlxText;
	var ghostCounter:FlxText;
	var towerCounter:FlxText;
	var instructions:FlxText;
	
	var killedGhosts:Int;
	var spawnRate:Float;
	var counter:Float;
	
	var cursor:FlxSprite;
	
	override public function create():Void {
		Log.setColor(0xFFFFFF);
		FlxG.mouse.show();
		FlxG.bgColor = Colors.BLACK;

		FlxG.camera.scroll.y = FlxG.camera.scroll.x = -Library.tileSize / 2;
		
		cursor = new Cursor();
		newLevel();
		add(cursor);
		
		var base = 3;
		
		
		levelCounter = new FlxText(level.width + 8, base, Std.int(FlxG.width - level.width - 8), "Level 1");
		levelCounter.scrollFactor.x = 0;
		levelCounter.scrollFactor.y = 0;
		levelCounter.setColor(Colors.LGREEN);
		levelCounter.setFont(Library.getFont().fontName);
		add(levelCounter);
		
		coinCounter = new FlxText(level.width + 8,  base + Library.tileSize*2, Std.int(FlxG.width - level.width - 8), "$: 0");
		coinCounter.scrollFactor.x = 0;
		coinCounter.scrollFactor.y = 0;
		coinCounter.setColor(Colors.LBLUE);
		coinCounter.setFont(Library.getFont().fontName);
		add(coinCounter);
		
		ghostCounter = new FlxText(level.width + 8, base + Library.tileSize*4, Std.int(FlxG.width - level.width - 8), "Kills: 0 (+$1)");
		ghostCounter.scrollFactor.x = 0;
		ghostCounter.scrollFactor.y = 0;
		ghostCounter.setColor(Colors.PINK);
		ghostCounter.setFont(Library.getFont().fontName);
		add(ghostCounter);
		
		towerCounter = new FlxText(level.width + 8, base + Library.tileSize*6, Std.int(FlxG.width - level.width - 8), "Towers: 0 (-$20)");
		towerCounter.scrollFactor.x = 0;
		towerCounter.scrollFactor.y = 0;
		towerCounter.setColor(Colors.YELLOW);
		towerCounter.setFont(Library.getFont().fontName);
		add(towerCounter);
		
		instructions = new FlxText(level.width + 8, base + Library.tileSize*8, Std.int(FlxG.width - level.width - 8), "How to play....bla bla much text is here");
		instructions.scrollFactor.x = 0;
		instructions.scrollFactor.y = 0;
		instructions.setColor(Colors.BLUEGRAY);
		instructions.setFont(Library.getFont().fontName);
		add(instructions);
		
		FlxG.worldBounds.x -= 50; 
		FlxG.worldBounds.y -= 50;
		FlxG.worldBounds.width += 100; 
		FlxG.worldBounds.height += 100;
	}
	
	function newLevel():Void {
		levelNumber++;
		spawnRate = 3 / levelNumber;
		
		
		FlxG.fade(0, 0.5, true, null, true);
		
		var p:Player = null;
		if (level != null) {
			remove(bg);
			bg.destroy();
			
			p = level.player;
			Actuate.stop(p);
			p.level = null;
			remove(level);
			remove(level.coins);
			remove(level.player);
			remove(level.ghosts);
			remove(level.towers);
			remove(level.bullets);
		}
		
		level = new Level(p);
		bg = FlxGridOverlay.create(Library.tileSize, Library.tileSize, Std.int(level.width), Std.int(level.height), false, true, Colors.DBLUE, Colors.DGREEN);
		add(bg);
		add(level);
		add(level.coins);
		add(level.player);
		add(level.ghosts);
		add(level.towers);
		add(level.bullets);
		
		level.player.kills = 0;
		if(towerCounter!=null) {
			towerCounter.text = "Towers: 0 (-$20)";
			ghostCounter.text = "Kills: 0 (+$1)";
			levelCounter.text = "Level " + levelNumber;
		}
		
		counter = 0;
	}
	
	var up:FlxPoint;
	override public function update() {
		super.update();
		
		FlxG.overlap(level.player, level.coins, pickUpCoin);
		FlxG.overlap(level.player, level.ghosts, gameOver);
		FlxG.overlap(level.bullets, level.ghosts, killGhost);
		
		counter += FlxG.elapsed;
		if (counter >= spawnRate) {
			counter = 0;
			level.spawnGhost();
		}
		
		if (up == null)
			up = new FlxPoint();
		
		FlxG.mouse.getWorldPosition(null, up);
		var cy = Utils.pixelToTile(up.y);
		var cx = Utils.pixelToTile(up.x);
		cursor.x = cx*Library.tileSize;
		cursor.y = cy*Library.tileSize;
		
		if (level.isFree(cx, cy) || cx >= Library.levelW || cy >= Library.levelH) {
			cursor.visible = false;
		} else {
			cursor.visible = true;
		}
		
		if (FlxG.mouse.justPressed() && cursor.visible) {
			if (level.player.coins >= 20) {
				// todo - cash register sound
				level.player.coins -= 20;
				coinCounter.text = "$: " + level.player.coins;
				level.buildTower(up);
				towerCounter.text = "Towers: " + level.towers.length + " (-$20)";
				
			} else {
				// todo - error sound
			}
		}
		
		
		// debug
		/*if (FlxG.keys.justReleased("L")) {
			newLevel();
		}*/
	}
	
	override public function draw():Void {		
		super.draw();
	}
	
	function killGhost(b:Bullet, g:Ghost) {
		b.kill();
		level.ghosts.remove(g,true);
		g.kill();
		
		level.player.kills++;
		level.player.coins++;
		ghostCounter.text = "Kills: " + level.player.kills + " (+$1)";
		coinCounter.text = "$: " + level.player.coins;
	}
	
	function gameOver(p:Player, g:Ghost) {
		reset();
	}
	
	function reset(){
		FlxG.fade(0, 0.5);
		Actuate.timer(0.5).onComplete(FlxG.switchState, [new MenuState()]);
	}
	
	function pickUpCoin(p:Player, c:Coin) {		
		level.coins.remove(c, true);
		level.player.coins++;
		coinCounter.text = "$: " + level.player.coins;
		
		if (level.coins.length < 1) {
			newLevel();
		}
	}
	
	override public function destroy() {
		super.destroy();
		
		remove(bg);
		remove(level);
		remove(level.coins);
		remove(level.player);
		remove(level.ghosts);
		remove(level.towers);
		remove(level.bullets);
		
		level.player.destroy();
		level.player = null;
		
		level = null;
		
		bg.destroy();
		bg = null;
		levelCounter.destroy();
		levelCounter = null;
		coinCounter.destroy();
		coinCounter = null;
		ghostCounter.destroy();
		ghostCounter = null;
		towerCounter.destroy();
		towerCounter = null;
		instructions.destroy();
		instructions = null;
		
		up = null;
		cursor.destroy();
		cursor = null;
	}
}