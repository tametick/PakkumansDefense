package states;

import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Linear;
import data.Library;
import data.Score;
import haxe.Log;
import nme.display.Bitmap;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxObject;
import org.flixel.FlxPoint;
import org.flixel.FlxSave;
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
	static var hud:Bitmap;
	var bg: FlxSprite;
	var level:Level;
	
	var help:Int;
	static var help1:FlxGroup;
	static var help2:FlxGroup;
	
	public static var startingLevel:Int;
	var levelNumber(default, setLevelNumber):Int;
	function setLevelNumber(l:Int):Int {
		levelNumber = l;
		
		var levels = new FlxSave();
		levels.bind("Levels");
		if (levels.data.highest < levelNumber)
			levels.data.highest = levelNumber;
			
		return levelNumber;
	}
	
	var levelCounter:FlxText;
	var coinCounter:FlxText;
	var ghostCounter:FlxText;
	var towerCounter:FlxText;
	
	var killedGhosts:Int;
	var spawnRate:Float;
	var counter:Float;
	
	var cursor:FlxSprite;
	
	override public function create():Void {
		if (hud == null) {
			hud = new Bitmap(Library.getImage(Image.HUD_OVERLAY));
			hud.width *= 2;
			hud.height *= 2;
		}
		
		var mouseIndex = FlxG._game.getChildIndex(FlxG._game._mouse);
		FlxG._game.addChildAt(hud, mouseIndex);
		
		var w = Std.int(FlxG.width * 2 / 3);
		var h = Std.int(FlxG.height * 2 / 3);
		
		FlxG.playMusic(Library.getMusic(THEME));
		help = 1;
		if (help1 == null) {				
			help1 = new FlxGroup();
			help2 = new FlxGroup();
			
			var help1Bg = new FlxSprite(0, 0);
			help1Bg.makeGraphic(w, h, 0x88000000);
			help1.add(help1Bg);
			
			var help1Text = new FlxText(-2, 0, w, "Tap edges to change direction");
			help1Text.setFormat(Library.getFont().fontName,null,null,"center");
			help1Text.scrollFactor.x = help1Text.scrollFactor.y = 0;
			help1Text.y = h / 2 - help1Text.height + Library.tileSize +1;
			help1.add(help1Text);
			
			var w1 = new FlxSprite(0, 0);
			var e1 = new FlxSprite(0, 0);
			var n1 = new FlxSprite(0, 0);
			var s1 = new FlxSprite(0, 0);
			w1.loadGraphic(Library.getFilename(Image.BIG_ARROW),true,false,7,7);
			w1.addAnimation("idle", [0]);
			w1.play("idle");
			e1.loadGraphic(Library.getFilename(Image.BIG_ARROW),true,false,7,7);
			e1.addAnimation("idle", [1]);
			e1.play("idle");
			n1.loadGraphic(Library.getFilename(Image.BIG_ARROW),true,false,7,7);
			n1.addAnimation("idle", [2]);
			n1.play("idle");
			s1.loadGraphic(Library.getFilename(Image.BIG_ARROW),true,false,7,7);
			s1.addAnimation("idle", [3]);
			s1.play("idle");
			w1.x = 1;
			w1.y = (h - w1.height) / 2 - Library.tileSize;
			help1.add(w1);			
			e1.x = Library.tileSize*(Library.levelW-1);
			e1.y = (h - w1.height) / 2 - Library.tileSize;
			help1.add(e1);
			n1.x = (Library.tileSize*Library.levelW-n1.width) /2;
			n1.y = 1;
			help1.add(n1);
			s1.x = n1.x;
			s1.y = Library.tileSize * Library.levelH - s1.height - 1;
			help1.add(s1);
			
			
			var help2Bg = new FlxSprite(0, 0);
			help2Bg.makeGraphic(w, h, 0x88000000);
			help2.add(help2Bg);
			
			var w2 = new FlxSprite(0, 0);
			var e2 = new FlxSprite(0, 0);
			var n2 = new FlxSprite(0, 0);
			var s2 = new FlxSprite(0, 0);
			w2.loadGraphic(Library.getFilename(Image.BIG_ARROW),true,false,7,7);
			w2.addAnimation("idle", [1]);
			w2.play("idle");
			e2.loadGraphic(Library.getFilename(Image.BIG_ARROW),true,false,7,7);
			e2.addAnimation("idle", [0]);
			e2.play("idle");
			n2.loadGraphic(Library.getFilename(Image.BIG_ARROW),true,false,7,7);
			n2.addAnimation("idle", [3]);
			n2.play("idle");
			s2.loadGraphic(Library.getFilename(Image.BIG_ARROW),true,false,7,7);
			s2.addAnimation("idle", [2]);
			s2.play("idle");
			s2.x = s1.x;
			s2.y = s1.y+1;
			n2.x = n1.x;
			n2.y = n1.y-1;
			w2.x = w1.x-1;
			w2.y = w1.y;
			e2.x = e1.x+1;
			e2.y = e1.y;
			help2.add(w2);
			help2.add(e2);
			help2.add(n2);
			help2.add(s2);
			
			
			var help2Text = new FlxText(0, 0, w, "Tap center to build towers");
			help2Text.setFormat(Library.getFont().fontName,null,null,"center");
			help2Text.scrollFactor.x = help2Text.scrollFactor.y = 0;
			help2Text.y = h / 2 - help2Text.height + Library.tileSize +1;
			help2.add(help2Text);
		}
				
		Actuate.defaultEase = Linear.easeNone;
		
		Log.setColor(0xFFFFFF);
		FlxG.mouse.show();
		FlxG.bgColor = Colors.BLACK;
		
		cursor = new Cursor();
		newLevel();
		add(cursor);
		
		levelCounter = newText(0, -1, Std.int(FlxG.width - level.width - 8), "Level "+startingLevel,Colors.LGREEN);
		levelCounter.scrollFactor.x = 0;
		levelCounter.scrollFactor.y = 0;
		
		coinCounter = newText(w/4, -1, Std.int(FlxG.width - level.width - 8), "$: 20",Colors.LBLUE);
		coinCounter.scrollFactor.x = 0;
		coinCounter.scrollFactor.y = 0;
		
		ghostCounter = newText(w/2, -1, Std.int(FlxG.width - level.width - 8), "Kills: 0", Colors.PINK);
		ghostCounter.scrollFactor.x = 0;
		ghostCounter.scrollFactor.y = 0;
		
		towerCounter = newText(w*3/4, -1, Std.int(FlxG.width - level.width - 8), "Towers: 0",Colors.YELLOW);
		towerCounter.scrollFactor.x = 0;
		towerCounter.scrollFactor.y = 0;
		
		FlxG.worldBounds.x -= 50; 
		FlxG.worldBounds.y -= 50;
		FlxG.worldBounds.width += 100; 
		FlxG.worldBounds.height += 100;
		
		add(help1);
		
		var gap = FlxG.width * 2 / 3 - Library.levelW * Library.tileSize;
		
		FlxG.camera.scroll.y = -Library.tileSize * 1.5;
		FlxG.camera.scroll.x = -gap/2;
		
		FlxG.camera.setZoom(3);
	}
	
	function newLevel():Void {
		levelNumber++;
		if (startingLevel > levelNumber)
			levelNumber = startingLevel;
		
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
		
		var c0 = 0;
		var c1 = 0;
		switch (levelNumber % 3) {
			case 0:
				c0 = Colors.DBLUE;
				c1 = Colors.GREEN;
			case 1:
				c0 = Colors.DGREEN;
				c1 = Colors.DBLUE;
			case 2:
				c0 = Colors.BROWN;
				c1 = Colors.BLACK;
		}
		
		bg = FlxGridOverlay.create(Library.tileSize, Library.tileSize, Std.int(level.width), Std.int(level.height), false, true, c0, c1);
		add(bg);
		add(level);
		add(level.coins);
		add(level.player);
		add(level.player.arrow);
		add(level.ghosts);
		add(level.towers);
		add(level.bullets);
		
		if(towerCounter!=null) {
			towerCounter.text = "Towers: 0";
			ghostCounter.text = "Kills: "+level.player.kills;
			levelCounter.text = "Level " + levelNumber;
		}
		
		counter = -3;
	}
	
	var up:FlxPoint;
	override public function update() {
		if (help < 3) {
			if (FlxG.mouse.justPressed()) {
				if (help == 1) {
					help = 2;
					remove(help1);
					add(help2);
				} else {
					help = 3;
					remove(help2);
				}
			}
			
			return;
		}
		
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
				coinCounter.text = "Money: " + level.player.coins;
				level.buildTower(up);
				towerCounter.text = "Towers: " + level.towers.length;
				
			} else {
				// todo - error sound
			}
		}
	}
	
	function killGhost(b:FlxObject, g:FlxObject) {
		FlxG.play(Library.getSound(Sound.GHOST_HIT));
		b.kill();
		level.ghosts.remove(g, true);
		cast(g,Ghost).explode();
		
		level.player.kills++;
		ghostCounter.text = "Kills: " + level.player.kills;
		coinCounter.text = "$: " + level.player.coins;
	}
	
	function gameOver(p:FlxObject, g:FlxObject) {
		if (!active)
			return;
		active = false;
		FlxG.play(Library.getSound(Sound.DEATH));
		level.player.explode();
		
		HighScoreState.mostRecentScore = new Score(levelNumber,level.player.coins,level.player.kills,level.towers.length);
		
		FlxG.fade(0, 0.5);
		Actuate.timer(0.5).onComplete(FlxG.switchState, [new HighScoreState()]);
	}
	
	function reset(){
		FlxG.fade(0, 0.5);
		Actuate.timer(0.5).onComplete(FlxG.switchState, [new MenuState()]);
	}
	
	function pickUpCoin(p:FlxObject, c:FlxObject) {	
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
		
		up = null;
		cursor.destroy();
		cursor = null;
		
		FlxG._game.removeChild(hud);
	}
}