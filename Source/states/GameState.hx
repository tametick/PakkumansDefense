package states;

import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Linear;
import data.Library;
import data.Score;
import haxe.Log;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.CapsStyle;
import nme.display.JointStyle;
import nme.display.LineScaleMode;
import nme.display.PixelSnapping;
import nme.display.Shape;
import nme.display.StageQuality;
import nme.geom.Point;
import nme.Lib;
import nme.ui.MultitouchInputMode;
import nme.Vector;
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
import org.flixel.system.input.Input;
import ui.Cursor;
import utils.Colors;
import utils.Utils;
import world.Coin;
import world.Powerup;
import world.Ghost;
import world.Level;
import world.Player;
import flash.events.TransformGestureEvent;


class GameState extends BasicState {
	static var hud:Bitmap;
	static var buttonS:Bitmap;
	static var buttonN:Bitmap;
	static var buttonE:Bitmap;
	static var buttonW:Bitmap;

	
	static var buttonT:Bitmap;
	static var buttonTData:BitmapData;
	static var buttonT2Data:BitmapData;
	static var buttonT2DataR:BitmapData;

	
	var bg: FlxSprite;
	var level:Level;
	
	// clear these on next level or game over
	var deadGhosts:FlxGroup;
	
	public var screenWidth:Int;
	public var screenHeight:Int;
	
	var mouse:FlxText;
	
	public var help:Int;
	static var help1:FlxGroup;
	static var help2:FlxGroup;
	
	public static var controlScheme:CtrlMode; 
	 
	public function setHighlighted(direction:Command) {
		switch (direction) {
			case LEFT:
				buttonW.alpha = 2;
				
				Utils.play(Library.getSound(CLICK));
			case RIGHT:
				buttonE.alpha = 2;
				
				Utils.play(Library.getSound(CLICK));
			case UP:
				buttonN.alpha = 2;
				
				Utils.play(Library.getSound(CLICK));
			case DOWN:
				buttonS.alpha = 2;
				
				Utils.play(Library.getSound(CLICK));
			case TOWER:
				if (level.player.coins < Library.towerCost) {
					buttonT.bitmapData = buttonT2DataR;
				} else {
					buttonT.bitmapData = buttonT2Data;
					Utils.play(Library.getSound(CLICK));
				}
		}
	}
	public function setUnhighlighted(direction:Command) {
		switch (direction) {
			case LEFT:
				buttonW.alpha = 1;
				
			case RIGHT:
				buttonE.alpha = 1;
				
			case UP:
				buttonN.alpha = 1;
				
			case DOWN:
				buttonS.alpha = 1;
				
			case TOWER:
				buttonT.bitmapData = buttonTData;
		}
	}
	
	public static var startingLevel:Int;
	public var levelNumber(default, setLevelNumber):Int;
	function setLevelNumber(l:Int):Int {
		levelNumber = l;
		
		var levels = new FlxSave();
		levels.bind("Levels");
		if (levels.data.highest < levelNumber)
			levels.data.highest = levelNumber;
			
		return levelNumber;
	}
	
	var levelCounter:FlxText;
	public var coinCounter:FlxText;
	var ghostCounter:FlxText;
	public var towerCounter:FlxText;
	public var timeCounter:FlxText;
	
	var killedGhosts:Int;
	var spawnRate:Float;
	var counter:Float;
	
	var cursor:FlxSprite;
	
	function drawTriangle(v1x:Float, v1y:Float, v2x:Float, v2y:Float, v3x:Float, v3y:Float, ?alpha = 0.2, ?color = 0xffffff):Bitmap {
		Lib.stage.quality = StageQuality.BEST;
		var shape = new Shape();
		//shape.graphics.lineStyle(1, color, alpha, false, null, null,JointStyle.ROUND);
		shape.graphics.beginFill(color, alpha);
		var triangle = Vector.ofArray([v1x, v1y, v2x, v2y, v3x, v3y]);
		shape.graphics.drawTriangles(triangle);
		shape.graphics.endFill();
		
		var bmp = new Bitmap(new BitmapData(160, 160, true, 0x00000000),PixelSnapping.AUTO,true);
		bmp.bitmapData.draw(shape);
		Lib.stage.quality = StageQuality.LOW;
		return bmp;
	}
	/*
	function drawRectangle(v1x:Float, v1y:Float, v2x:Float, v2y:Float, v3x:Float, v3y:Float,v4x:Float, v4y:Float, ?alpha = 0.2, ?color = 0xffffff):Bitmap {
		Lib.stage.quality = StageQuality.BEST;
		var shape = new Shape();
		//shape.graphics.lineStyle(1, color, alpha, false, null, null,JointStyle.ROUND);
		shape.graphics.beginFill(color, alpha);
		var rectangle = Vector.ofArray([v1x, v1y, v2x, v2y, v3x, v3y, v4x, v4y]);
		shape.graphics.drawRect(rectangle);
		shape.graphics.endFill();
		
		var bmp = new Bitmap(new BitmapData(160, 160, true, 0x00000000),PixelSnapping.AUTO,true);
		bmp.bitmapData.draw(shape);
		Lib.stage.quality = StageQuality.LOW;
		return bmp;
	}
	*/
	override public function create():Void {
		super.create();
		
		screenWidth = Std.int(FlxG.width * 2 / 3);
		screenHeight = Std.int(FlxG.height * 2 / 3);
		
		mouse = new FlxText(0, 0, 40);
		mouse.scrollFactor.x = mouse.scrollFactor.y = 0;
		
		
		if (controlScheme == null) {
			controlScheme = CtrlMode.OVERLAY;
		}
		
		if (hud == null) {
			hud = new Bitmap(Library.getImage(Image.HUD_OVERLAY));
			hud.width *= 2;
			hud.height *= 2;
			
			var dim1, dim2;
			switch(controlScheme) {
				default:
					dim1 = 80;
					dim2 = 160;	
				case CtrlMode.GAMEPAD,CtrlMode.GAMEPAD_L:
					dim1 = 40;
					dim2 = 80;	
			}
			
			buttonS = drawTriangle(0, 0, dim2, 0, dim1, dim1);
							
			buttonN = drawTriangle(0,dim1,dim1,0,dim2,dim1);
							
			buttonW = drawTriangle(0,dim1,dim1,0,dim1,dim2);
			
			buttonE = drawTriangle(0,0,dim1,dim1,0,dim2);
			
						
			if (controlScheme == CtrlMode.SWIPE) {
				buttonS.visible = false;
				buttonN.visible = false;
				buttonW.visible = false;
				buttonE.visible = false;
				}
				
			
			
			buttonT = new Bitmap(buttonTData = Library.getImage(Image.BUTTONS_OVERLAY_T), PixelSnapping.AUTO, true);
			buttonT2Data = Library.getImage(Image.BUTTONS_OVERLAY_T2);
			buttonT2DataR = Library.getImage(Image.BUTTONS_OVERLAY_T2R);
			
			var spacer2 = 2 * dim1 + dim2;
			var spacer1 = dim1 + dim2;
			
			switch(controlScheme) {
				default:
					buttonW.y = buttonE.y = 80;
					buttonE.x = 400;
					buttonS.x = buttonN.x = 160;
					buttonS.y = 240;
					buttonT.x = 180;
					buttonT.y = 100;		
				case CtrlMode.GAMEPAD:
					buttonN.y = 320-spacer2;
					buttonW.y = buttonE.y = 320-spacer1;
					buttonE.x = spacer1;
					buttonS.x = buttonN.x = dim1;
					buttonS.y = 320-dim1;
					buttonT.x = 480-120;
					buttonT.y = 320 - (spacer2 + 120) / 2;
				case CtrlMode.GAMEPAD_L:
					buttonN.y = 320-spacer2;
					buttonW.y = buttonE.y = 320-spacer1;
					buttonE.x = 480 - dim1;
					buttonW.x = 480 - spacer2;
					buttonS.x = buttonN.x = 480-spacer1;
					buttonS.y = 320-dim1;
					buttonT.x = 0;
					buttonT.y = 320-(spacer2+120)/2;
			}

			
			
			
		}
		
		var index = FlxG._game.getChildIndex(FlxG._game._mouse);
		FlxG._game.addChildAt(hud, index);
		#if !keyboard
		FlxG._game.addChild(buttonS);
		FlxG._game.addChild(buttonN);
		FlxG._game.addChild(buttonW);
		FlxG._game.addChild(buttonE);
		FlxG._game.addChild(buttonT);
		#end
		
		Utils.playMusic(Library.getMusic(THEME));
		help = 1;
		if (help1 == null) {				
			help1 = new FlxGroup();
			help2 = new FlxGroup();
			
			var help1Bg = new FlxSprite(0, 0);
			help1Bg.makeGraphic(screenWidth, screenHeight, 0x88000000);
			help1.add(help1Bg);
			
			#if keyboard
			var help1Text = new FlxText(-2, 0, screenWidth, "Arrows/WASD to change direction");
			#else
			var instructions;
			var instructions1;
			switch(controlScheme) {
				default:
					instructions = "Tap edges to change direction";
					instructions1 = "Tap center to build towers";
				case CtrlMode.GAMEPAD,CtrlMode.GAMEPAD_L:
					instructions = "Tap arrows to change direction";	
					instructions1 = "Tap tower to build towers";
				case CtrlMode.SWIPE:
					instructions = "Swipe to change direction";
					instructions1 = "Tap to build towers";
			}
			var help1Text = new FlxText(-2, 0, screenWidth, instructions);
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
			w1.y = (screenHeight - w1.height) / 2 - Library.tileSize;
			help1.add(w1);			
			e1.x = Library.tileSize*(Library.levelW-1);
			e1.y = (screenHeight - w1.height) / 2 - Library.tileSize;
			help1.add(e1);
			n1.x = (Library.tileSize*Library.levelW-n1.width) /2;
			n1.y = 1;
			help1.add(n1);
			s1.x = n1.x;
			s1.y = Library.tileSize * Library.levelH - s1.height - 1;
			help1.add(s1);
			#end
			
			help1Text.setFormat(Library.getFont().fontName,null,null,"center");
			help1Text.scrollFactor.x = help1Text.scrollFactor.y = 0;
			help1Text.y = screenHeight / 2 - help1Text.height + Library.tileSize +1;
			help1.add(help1Text);
			
			var help2Bg = new FlxSprite(0, 0);
			help2Bg.makeGraphic(screenWidth, screenHeight, 0x88000000);
			help2.add(help2Bg);
			
			#if keyboard
			var help2Text = new FlxText(0, 0, screenWidth, "Space bar to build towers");
			#else
			var help2Text = new FlxText(0, 0, screenWidth, instructions1);
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
			#end
			
			
			help2Text.setFormat(Library.getFont().fontName,null,null,"center");
			help2Text.scrollFactor.x = help2Text.scrollFactor.y = 0;
			help2Text.y = screenHeight / 2 - help2Text.height + Library.tileSize +1;
			help2.add(help2Text);
			
		}
				
		Actuate.defaultEase = Linear.easeNone;
		
		Log.setColor(0xFFFFFF);
		#if keyboard
		FlxG.mouse.show();
		#end
	
		FlxG.bgColor = Colors.BLACK;
		
		//cursor = new Cursor();
		newLevel();
		//add(cursor);
		
		levelCounter = newText(0, -1, Std.int(FlxG.width - level.width - 8), "Level "+levelNumber,Colors.LGREEN);
		levelCounter.scrollFactor.x = 0;
		levelCounter.scrollFactor.y = 0;
		
		timeCounter = newText(screenWidth/5, -1, Std.int(FlxG.width - level.width - 8), "2:00",Colors.ORANGE);
		timeCounter.scrollFactor.x = 0;
		timeCounter.scrollFactor.y = 0;
		
		coinCounter = newText(screenWidth/6*2, -1, Std.int(FlxG.width - level.width - 8), "$: "+Library.towerCost,Colors.LBLUE);
		coinCounter.scrollFactor.x = 0;
		coinCounter.scrollFactor.y = 0;
		
		ghostCounter = newText(screenWidth/6*3, -1, Std.int(FlxG.width - level.width - 8), "Kills: 0", Colors.PINK);
		ghostCounter.scrollFactor.x = 0;
		ghostCounter.scrollFactor.y = 0;
		
		towerCounter = newText(screenWidth/6*4.5, -1, Std.int(FlxG.width - level.width - 8), "Towers: 0",Colors.YELLOW);
		towerCounter.scrollFactor.x = 0;
		towerCounter.scrollFactor.y = 0;
		
		FlxG.worldBounds.x -= 50; 
		FlxG.worldBounds.y -= 50;
		FlxG.worldBounds.width += 100; 
		FlxG.worldBounds.height += 100;
		
		add(help1);
		
		var gap = screenWidth - Library.levelW * Library.tileSize;
		
		FlxG.camera.scroll.y = -Library.tileSize * 1.5;
		FlxG.camera.scroll.x = -gap/2;
		
		if (Library.debug) {
			add(mouse);
		}
		
		FlxG.camera.setZoom(3);
		
	//	level.player.powerupIndicator=drawRectangle(0,0,5,0,5,2,0,2);
	}
	
	function newLevel():Void {
		levelNumber++;
		if (startingLevel > levelNumber)
			levelNumber = startingLevel;
		
		#if keyboard
		spawnRate = 4 / levelNumber;
		#else
		spawnRate = 5 / levelNumber;
		#end
		
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
			remove(level.powerups);
			remove(level.powerupEffect);
			
			level.destroy();
			deadGhosts.destroy();
			deadGhosts = null;
		}
		
		level = new Level(p);
		deadGhosts = new FlxGroup();
		
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
		add(level.powerups);
		add(level.powerupEffect);
			
		if(towerCounter!=null) {
			towerCounter.text = "Towers: 0";
			ghostCounter.text = "Kills: "+level.player.kills;
			levelCounter.text = "Level " + levelNumber;
			timeCounter.text = "2:00";
		}
		
		counter = -3;
	}
	
	var up:FlxPoint;
	override public function update() {
		super.update();
		
		var min = Std.int(level.player.time) % 60;		
		timeCounter.text = Std.int((Std.int(level.player.time) / 60)) + ":" ;
		if (min < 10) timeCounter.text += "0";
		timeCounter.text+= min;
		if (help < 3) {
			if (FlxG.mouse.justPressed() || FlxG.keys.justReleased("SPACE") || FlxG.keys.justReleased("ENTER") ) {
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
		
		

		FlxG.overlap(level.player, level.powerups, pickUpPowerup);
		FlxG.overlap(level.player, level.coins, pickUpCoin);
		FlxG.overlap(level.player, level.ghosts, gameOver);
		FlxG.overlap(level.bullets, level.ghosts, killGhost);
		
		//check if powerups need to be removed from field
		for (p in level.powerups.members) {
			var pu = cast(p, Powerup);
			if (pu.life <= 0) pu.remove();
			}
			
		//check if active powerups need to stop being active
		
		for (p in level.activePowerups.keys()) {
			
			var t = level.activePowerups.get(p);
			t-= FlxG.elapsed;
			if (t <= 0) level.activePowerups.remove(p);
			else level.activePowerups.set(p,t);
			}
		
		counter += FlxG.elapsed;
		if (counter >= spawnRate) {
			counter = 0;
			level.spawnGhost();
		}
		
	}
	
	function killGhost(b:FlxObject, g:FlxObject) {
		if (level.activePowerups.exists(Type.enumConstructor(PowerupType.CASHFORKILLS))) {
			level.player.coins++;
		}
		Utils.play(Library.getSound(Sound.GHOST_HIT));
		b.kill();
		level.ghosts.remove(g, true);
		cast(g, Ghost).explode();
		
		// remove dead ghosts later
		deadGhosts.add(g);
		
		level.player.kills++;
		ghostCounter.text = "Kills: " + level.player.kills;
		coinCounter.text = "$: " + level.player.coins;
	}
	
	public function gameOver(?p:FlxObject, ?g:FlxObject) {
		if (!active)
			return;
		active = false;
		Utils.play(Library.getSound(Sound.DEATH));
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
		Utils.play(Library.getSound(cast(c,Coin).snd));
		
		level.freePos.insert(0,new FlxPoint(Std.int(c.x/Library.tileSize),Std.int(c.y/Library.tileSize)));
		
		level.coins.remove(c, true);
		level.player.coins++;
		if(cast(c,Coin).type==BIG)	level.player.coins+=9;	
		coinCounter.text = "$: " + level.player.coins;
		if (level.coins.length % 15 == 0) {
			addPowerup();
		}
		if (level.coins.length < 1) {
			newLevel();
		}
	}
	
	function addPowerup() {
		var pu,pup, pl:FlxPoint, cnt = 0;
		pl = new FlxPoint(level.player.tileX,level.player.tileY);
		do { cnt++;
			pup = level.freePos[Utils.randomIntInRange(0, level.freePos.length) - 1];
		}while (pl != pup && cnt <= 10);
		if (pup != null) {
			pu = level.spawnPowerup(pup);
			Utils.play(Library.getSound(Sound.POWERUP));
			add(level.powerupEffect);
			level.powerupEffect.explode(pu.x, pu.y);
		}
	}
	
	function pickUpPowerup(p:FlxObject, c:FlxObject) {	
		Utils.play(Library.getSound(Sound.CASH_REGISTER));
		var cc:Powerup = cast(c, Powerup);
		level.activePowerups.set(Type.enumConstructor(cc.type), cc.duration);
		level.powerups.remove(cc, true);
		cc.remove();
	}
	
	override public function destroy() {
		deadGhosts.destroy();
		deadGhosts = null;
		
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
		//cursor.destroy();
		cursor = null;
		
		FlxG._game.removeChild(hud);
		#if !keyboard
		FlxG._game.removeChild(buttonS);
		FlxG._game.removeChild(buttonN);
		FlxG._game.removeChild(buttonW);
		FlxG._game.removeChild(buttonE);
		FlxG._game.removeChild(buttonT);
		#end
	}
	
}

enum CtrlMode {
	OVERLAY;
	GAMEPAD;
	GAMEPAD_L;
	SWIPE;	
}

