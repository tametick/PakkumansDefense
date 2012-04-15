package states;

import com.eclecticdesignstudio.motion.Actuate;
import data.Library;
import data.Score;
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

class GameState extends BasicState {
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
		FlxG.playMusic(Library.getMusic(THEME));
		
		Log.setColor(0xFFFFFF);
		FlxG.mouse.show();
		FlxG.bgColor = Colors.BLACK;

		FlxG.camera.scroll.y = FlxG.camera.scroll.x = -Library.tileSize / 2;
		
		cursor = new Cursor();
		newLevel();
		add(cursor);
		
		var base = 3;
		
		
		levelCounter = newText(level.width + 8, base, Std.int(FlxG.width - level.width - 8), "Level 1",Colors.LGREEN);
		levelCounter.scrollFactor.x = 0;
		levelCounter.scrollFactor.y = 0;
		
		coinCounter = newText(level.width + 8,  base + Library.tileSize*2, Std.int(FlxG.width - level.width - 8), "$: 0",Colors.LBLUE);
		coinCounter.scrollFactor.x = 0;
		coinCounter.scrollFactor.y = 0;
		
		ghostCounter = newText(level.width + 8, base + Library.tileSize*4, Std.int(FlxG.width - level.width - 8), "Kills: 0", Colors.PINK);
		ghostCounter.scrollFactor.x = 0;
		ghostCounter.scrollFactor.y = 0;
		
		towerCounter = newText(level.width + 8, base + Library.tileSize*6, Std.int(FlxG.width - level.width - 8), "Towers: 0 (-$20)",Colors.YELLOW);
		towerCounter.scrollFactor.x = 0;
		towerCounter.scrollFactor.y = 0;
		
		instructions = newText(level.width + 8, base + Library.tileSize*15, Std.int(FlxG.width - level.width - 8), "Move with WASD or the arrow keys.", Colors.BLUEGRAY);
		instructions.scrollFactor.x = 0;
		instructions.scrollFactor.y = 0;
		
		instructions = newText(level.width + 8, base + Library.tileSize*18, Std.int(FlxG.width - level.width - 8), "Click to place towers.", Colors.BLUEGRAY);
		instructions.scrollFactor.x = 0;
		instructions.scrollFactor.y = 0;
		
		FlxG.worldBounds.x -= 50; 
		FlxG.worldBounds.y -= 50;
		FlxG.worldBounds.width += 100; 
		FlxG.worldBounds.height += 100;
	}
	
	function newLevel():Void {
		levelNumber++;
		spawnRate = 1.5 / levelNumber;
		
		
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
		bg = FlxGridOverlay.create(Library.tileSize, Library.tileSize, Std.int(level.width), Std.int(level.height), false, true, levelNumber%2==1?Colors.DBLUE:Colors.BLACK, levelNumber%2==1?Colors.DGREEN:Colors.BROWN);
		add(bg);
		add(level);
		add(level.coins);
		add(level.player);
		add(level.ghosts);
		add(level.towers);
		add(level.bullets);
		
		if(towerCounter!=null) {
			towerCounter.text = "Towers: 0 (-$20)";
			ghostCounter.text = "Kills: "+level.player.kills;
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
		
		var overTower = FlxG.overlap(cursor, level.towers);
		
		if (level.isFree(cx, cy) || cx >= Library.levelW || cy >= Library.levelH || overTower) {
			cursor.visible = false;
		} else {
			cursor.visible = true;
		}
		
		if (FlxG.mouse.justPressed() && cursor.visible) {
			if (level.player.coins >= 20) {
				FlxG.play(Library.getSound(Sound.CASH_REGISTER));
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
		if (FlxG.keys.justReleased("L")) {
			newLevel();
		}
	}
	
	override public function draw():Void {		
		super.draw();
	}
	
	function killGhost(b:Bullet, g:Ghost) {
		FlxG.play(Library.getSound(Sound.GHOST_HIT));
		b.kill();
		level.ghosts.remove(g,true);
		g.kill();
		
		level.player.kills++;
		ghostCounter.text = "Kills: " + level.player.kills;
		coinCounter.text = "$: " + level.player.coins;
	}
	
	function gameOver(p:Player, g:Ghost) {
		if (!active)
			return;
		active = false;
		FlxG.play(Library.getSound(Sound.DEATH));
		
		HighScoreState.mostRecentScore = new Score(levelNumber,level.player.coins,level.player.kills,level.towers.length);
		
		FlxG.fade(0, 0.5);
		Actuate.timer(0.5).onComplete(FlxG.switchState, [new HighScoreState()]);
	}
	
	function reset(){
		FlxG.fade(0, 0.5);
		Actuate.timer(0.5).onComplete(FlxG.switchState, [new MenuState()]);
	}
	
	function pickUpCoin(p:Player, c:Coin) {	
		FlxG.play(Library.getSound(Sound.MONEY));
		level.coins.remove(c, true);
		level.player.coins++;
		coinCounter.text = "$: " + level.player.coins;
		
		if (level.coins.length < 1) {
			newLevel();
		}
	}
	
	override public function destroy() {
		super.destroy();
				
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