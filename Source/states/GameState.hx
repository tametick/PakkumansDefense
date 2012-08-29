package states;

import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Linear;
import data.AssetsLibrary;
import data.Image;
import data.Sound;
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
import nme.text.TextField;
import nme.Vector;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxObject;
import org.flixel.FlxPoint;
import org.flixel.FlxSave;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxTextField;
import org.flixel.plugin.photonstorm.baseTypes.Bullet;
import org.flixel.plugin.photonstorm.FlxGridOverlay;
import org.flixel.system.input.Input;
import org.flixel.tileSheetManager.TileSheetManager;
import ui.Cursor;
import ui.PowerupIndicator;
import utils.Colors;
import utils.Utils;
import world.Coin;
import world.Powerup;
import world.Ghost;
import world.Level;
import world.Player;


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
	static var instructions:String;
	static var instructions1:String;

	var levelCounter:TextField;
	public var coinCounter:TextField;
	var ghostCounter:TextField;
	public var towerCounter:TextField;
	public var timeCounter:TextField;
	
	var killedGhosts:Int;
	var spawnRate:Float;
	var counter:Float;
	
	var cursor:FlxSprite;
	
	static var powerupIndicator:Hash<PowerupIndicator>;
	
	var bg: FlxSprite;
	public var level:Level;
	
	// clear these on next level or game over
	var deadGhosts:FlxGroup;
	
	public var screenWidth:Int;
	public var screenHeight:Int;
	
	public var help:Int;
	var help1:FlxGroup;
	var help2:FlxGroup;
	
	var help1Text:FlxTextField;
	var help2Text:FlxTextField;

	public static var controlScheme(getCtrlScheme, never):CtrlMode;
	static function getCtrlScheme():CtrlMode {		
		if (SettingsState.settings.data.controlScheme == null) {
			SettingsState.settings.data.controlScheme = Type.enumConstructor(AssetsLibrary.defaultCtrl);
		}
		
		var scheme = Type.createEnum(CtrlMode, SettingsState.settings.data.controlScheme);
		return scheme;
	}
	
	public function setHighlighted(direction:Command) {
		switch (direction) {
			case LEFT:
				buttonW.alpha = 2;
				
				//Utils.play(AssetsLibrary.getSound(CLICK));
			case RIGHT:
				buttonE.alpha = 2;
				
				//Utils.play(AssetsLibrary.getSound(CLICK));
			case UP:
				buttonN.alpha = 2;
				
				//Utils.play(AssetsLibrary.getSound(CLICK));
			case DOWN:
				buttonS.alpha = 2;
				
				//Utils.play(AssetsLibrary.getSound(CLICK));
			case TOWER:
				if (level.player.coins < AssetsLibrary.towerCost) {
					buttonT.bitmapData = buttonT2DataR;
				} else {
					buttonT.bitmapData = buttonT2Data;
					//Utils.play(AssetsLibrary.getSound(CLICK));
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
	
	static function drawTriangle(v1x:Float, v1y:Float, v2x:Float, v2y:Float, v3x:Float, v3y:Float, ?alpha = 0.2, ?color = 0xffffff):Bitmap {
		Lib.stage.quality = StageQuality.BEST;
		var shape = new Shape();
		//shape.graphics.lineStyle(1, color, alpha, false, null, null,JointStyle.ROUND);
		shape.graphics.beginFill(color, alpha);
		var triangle = Utils.arrayToVector([v1x, v1y, v2x, v2y, v3x, v3y]);
		shape.graphics.drawTriangles(triangle);
		shape.graphics.endFill();
		
		var bmp = new Bitmap(new BitmapData(160, 160, true, 0x00000000),PixelSnapping.AUTO,true);
		bmp.bitmapData.draw(shape);
		Lib.stage.quality = StageQuality.LOW;
		return bmp;
	}
	
	public static function initController(scheme:CtrlMode) {
		SettingsState.settings.data.controlScheme = Type.enumConstructor(scheme);
		
		// clean up old controller
		if (buttonS != null) {
			if(buttonS.parent != null && buttonS.parent.contains(buttonS)){
				buttonS.parent.removeChild(buttonS);
			}
			buttonS.bitmapData.dispose();
			buttonS.bitmapData = null;
			
			if (buttonN.parent != null && buttonN.parent.contains(buttonN)) {
				buttonN.parent.removeChild(buttonN);
			}
			buttonN.bitmapData.dispose();
			buttonN.bitmapData = null;
			
			if (buttonW.parent != null && buttonW.parent.contains(buttonW)) {
				buttonW.parent.removeChild(buttonW);
			}
			buttonW.bitmapData.dispose();
			buttonW.bitmapData = null;
			
			if(buttonE.parent != null && buttonE.parent.contains(buttonE)){
				buttonE.parent.removeChild(buttonE);
			}
			buttonE.bitmapData.dispose();
			buttonE.bitmapData = null;
		}
		
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
			setControllerVisiblity(false);
		}

		if(buttonT==null){
			buttonT = new Bitmap(buttonTData = AssetsLibrary.getImage(Image.BUTTONS_OVERLAY_T), PixelSnapping.AUTO, true);
			buttonT2Data = AssetsLibrary.getImage(Image.BUTTONS_OVERLAY_T2);
			buttonT2DataR = AssetsLibrary.getImage(Image.BUTTONS_OVERLAY_T2R);
		}
		
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
				instructions = "Tap edges to change direction";
				instructions1 = "Tap center to build towers";
			case CtrlMode.GAMEPAD:
				buttonN.y = 320-spacer2;
				buttonW.y = buttonE.y = 320-spacer1;
				buttonE.x = spacer1;
				buttonS.x = buttonN.x = dim1;
				buttonS.y = 320-dim1;
				buttonT.x = 480-120;
				buttonT.y = 320 - (spacer2 + 120) / 2;
				instructions = "Tap arrows to change direction";	
				instructions1 = "Tap tower to build towers";
			case CtrlMode.GAMEPAD_L:
				buttonN.y = 320-spacer2;
				buttonW.y = buttonE.y = 320-spacer1;
				buttonE.x = 480 - dim1;
				buttonW.x = 480 - spacer2;
				buttonS.x = buttonN.x = 480-spacer1;
				buttonS.y = 320-dim1;
				buttonT.x = 0;
				buttonT.y = 320 - (spacer2 + 120) / 2;
				instructions = "Tap arrows to change direction";	
				instructions1 = "Tap tower to build towers";
		}
	}
	
	public static function setControllerVisiblity(val:Bool, ?alsoTower:Bool = false) {		
		SettingsState.settings.data.blend = !val;
		buttonS.visible = val;
		buttonN.visible = val;
		buttonW.visible = val;
		buttonE.visible = val;
		if (alsoTower) {
			buttonT.visible = val;
		}
	}
	
	override public function create():Void {		
		super.create();
		
		var sc = SettingsState.settings.data.controlScheme==null?null:Type.createEnum(CtrlMode,SettingsState.settings.data.controlScheme);
		if (sc == null) {
			SettingsState.settings.data.controlScheme = Type.enumConstructor(AssetsLibrary.defaultCtrl);
			initController(AssetsLibrary.defaultCtrl);
		} else {
			initController(sc);
		}

		if (SettingsState.settings.data.blend != null) {
			setControllerVisiblity(!SettingsState.settings.data.blend,true);
		}
		
		
		screenWidth = Std.int(FlxG.width * 2 / 3);
		screenHeight = Std.int(FlxG.height * 2 / 3);
				
		if (hud == null) {
			hud = new Bitmap(AssetsLibrary.getImage(Image.HUD_OVERLAY));
			hud.width *= 2;
			hud.height *= 2;
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
		
		Utils.playMusic(AssetsLibrary.getMusic(THEME));
		help = 1;
		help1 = new FlxGroup();
		help2 = new FlxGroup();
		
		var help1Bg = new FlxSprite(0, 0);
		help1Bg.makeGraphic(screenWidth, screenHeight, 0x88000000);
		help1.add(help1Bg);
		
		#if keyboard
		help1Text = new FlxTextField(-2, 0, screenWidth, "Arrows/WASD to change direction");
		#else
	/*	var instructions;
		var instructions1;
		switch(controlScheme) {
			case CtrlMode.OVERLAY: 
				instructions = "Tap edges to change direction";
				instructions1 = "Tap center to build towers";
			case CtrlMode.GAMEPAD,CtrlMode.GAMEPAD_L:
				instructions = "Touch arrows to change direction";	
				instructions1 = "Touchtower to build towers";
			case CtrlMode.SWIPE:
				instructions = "Swipe to change direction";
				instructions1 = "Tap to build towers";
		}*/
		help1Text = new FlxTextField( -2, 0, screenWidth, instructions);
		var w1:FlxSprite = null, e1:FlxSprite = null, n1:FlxSprite = null, s1:FlxSprite = null;
		if(controlScheme==CtrlMode.OVERLAY) {
			w1 = new FlxSprite(0, 0);
			e1 = new FlxSprite(0, 0);
			n1 = new FlxSprite(0, 0);
			s1 = new FlxSprite(0, 0);
			w1.loadGraphic(AssetsLibrary.getFilename(Image.BIG_ARROW),true,false,7,7);
			w1.addAnimation("idle", [0]);
			w1.play("idle");
			e1.loadGraphic(AssetsLibrary.getFilename(Image.BIG_ARROW),true,false,7,7);
			e1.addAnimation("idle", [1]);
			e1.play("idle");
			n1.loadGraphic(AssetsLibrary.getFilename(Image.BIG_ARROW),true,false,7,7);
			n1.addAnimation("idle", [2]);
			n1.play("idle");
			s1.loadGraphic(AssetsLibrary.getFilename(Image.BIG_ARROW),true,false,7,7);
			s1.addAnimation("idle", [3]);
			s1.play("idle");
			w1.x = 1;
			w1.y = (screenHeight - w1.height) / 2 - AssetsLibrary.tileSize;
			help1.add(w1);			
			e1.x = AssetsLibrary.tileSize*(AssetsLibrary.levelW-1);
			e1.y = (screenHeight - w1.height) / 2 - AssetsLibrary.tileSize;
			help1.add(e1);
			n1.x = (AssetsLibrary.tileSize*AssetsLibrary.levelW-n1.width) /2;
			n1.y = 1;
			help1.add(n1);
			s1.x = n1.x;
			s1.y = AssetsLibrary.tileSize * AssetsLibrary.levelH - s1.height - 1;
			help1.add(s1);
		}
		#end
		
		help1Text.setFormat(AssetsLibrary.getFont().fontName,null,null,"center");
		help1Text.scrollFactor.x = help1Text.scrollFactor.y = 0;
		help1Text.y = screenHeight / 2 - help1Text.height + AssetsLibrary.tileSize +1;
		help1.add(help1Text);
		
		var help2Bg = new FlxSprite(0, 0);
		help2Bg.makeGraphic(screenWidth, screenHeight, 0x88000000);
		help2.add(help2Bg);
		
		#if keyboard
		help2Text = new FlxTextField(0, 0, screenWidth, "Space bar to build towers");
		#else
		help2Text = new FlxTextField(0, 0, screenWidth, instructions1);
		if(controlScheme==CtrlMode.OVERLAY) {
			var w2 = new FlxSprite(0, 0);
			var e2 = new FlxSprite(0, 0);
			var n2 = new FlxSprite(0, 0);
			var s2 = new FlxSprite(0, 0);
			w2.loadGraphic(AssetsLibrary.getFilename(Image.BIG_ARROW),true,false,7,7);
			w2.addAnimation("idle", [1]);
			w2.play("idle");
			e2.loadGraphic(AssetsLibrary.getFilename(Image.BIG_ARROW),true,false,7,7);
			e2.addAnimation("idle", [0]);
			e2.play("idle");
			n2.loadGraphic(AssetsLibrary.getFilename(Image.BIG_ARROW),true,false,7,7);
			n2.addAnimation("idle", [3]);
			n2.play("idle");
			s2.loadGraphic(AssetsLibrary.getFilename(Image.BIG_ARROW),true,false,7,7);
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
		}
		#end
		
		
		help2Text.setFormat(AssetsLibrary.getFont().fontName,null,null,"center");
		help2Text.scrollFactor.x = help2Text.scrollFactor.y = 0;
		help2Text.y = screenHeight / 2 - help2Text.height + AssetsLibrary.tileSize +1;
		help2.add(help2Text);
				
		powerupIndicator = new Hash();
		powerupIndicator.set(Type.enumConstructor(PowerupType.CASHFORKILLS), new PowerupIndicator(Image.CASH));
		powerupIndicator.set(Type.enumConstructor(PowerupType.SHOTGUN), new PowerupIndicator(Image.SHOTGUN));
		powerupIndicator.set(Type.enumConstructor(PowerupType.HASTE), new PowerupIndicator(Image.HASTE));
		powerupIndicator.set(Type.enumConstructor(PowerupType.CONFUSION), new PowerupIndicator(Image.CONFUSION));
		powerupIndicator.set(Type.enumConstructor(PowerupType.FREEZE), new PowerupIndicator(Image.FREEZE));			
			
			
		Actuate.defaultEase = Linear.easeNone;
		
		//Log.setColor(0xFFFFFF);
		#if keyboard
		FlxG.mouse.show();
		#end
	
		FlxG.bgColor = Colors.BLACK;
		
		//cursor = new Cursor();
		newLevel();
		level.player.setClickMap();
		//add(cursor);
		
		var zoom = 3;
		
		levelCounter = Utils.newTextField(0*zoom, 1, "Level " + levelNumber, Colors.LGREEN);
		#if keyboard
		FlxG._game.addChildAt(levelCounter, index);
		#else
		// does this fix anything?
		Lib.current.addChild(levelCounter);
		#end
		
		timeCounter = Utils.newTextField(zoom * screenWidth / 5, 1, "1:30", Colors.ORANGE);
		FlxG._game.addChildAt(timeCounter, index);
		
		coinCounter = Utils.newTextField(zoom * screenWidth / 6 * 2, 1, "$: " + AssetsLibrary.towerCost, Colors.LBLUE);
		FlxG._game.addChildAt(coinCounter, index);
		
		ghostCounter = Utils.newTextField(zoom * screenWidth / 6 * 3, 1, "Kills: 0", Colors.PINK);
		FlxG._game.addChildAt(ghostCounter, index);
		
		towerCounter = Utils.newTextField(zoom * screenWidth / 6 * 4.5, 1, "Towers: 0", Colors.YELLOW);
		FlxG._game.addChildAt(towerCounter, index);
		
		FlxG.worldBounds.x -= 50; 
		FlxG.worldBounds.y -= 50;
		FlxG.worldBounds.width += 100; 
		FlxG.worldBounds.height += 100;
		
		add(help1); 
		
		var gap = screenWidth - AssetsLibrary.levelW * AssetsLibrary.tileSize;
		
		FlxG.camera.scroll.y = -AssetsLibrary.tileSize * 1.5;
		FlxG.camera.scroll.x = -gap/2;
			
		FlxG.camera.setZoom(zoom);
		
	}
	
	function newLevel():Void {
		levelNumber++;
		if (startingLevel > levelNumber)
			levelNumber = startingLevel;
		
		#if keyboard
		spawnRate = 4 / levelNumber;
		#else
		spawnRate = 6 / levelNumber;
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
		
		bg = FlxGridOverlay.create(AssetsLibrary.tileSize, AssetsLibrary.tileSize, Std.int(level.width), Std.int(level.height), false, true, c0, c1);
		
		#if !flash
		var aCoin = cast(level.coins.members[0],Coin);
		
		// game
		TileSheetManager.setTileSheetIndex(level.getTileSheetIndex(), 0);
		TileSheetManager.setTileSheetIndex(bg.getTileSheetIndex(), 0);
		TileSheetManager.setTileSheetIndex(aCoin.getTileSheetIndex(), TileSheetManager.getMaxIndex());
		TileSheetManager.setTileSheetIndex(level.player.getTileSheetIndex(), TileSheetManager.getMaxIndex());
		TileSheetManager.setTileSheetIndex(level.player.arrow.getTileSheetIndex(), TileSheetManager.getMaxIndex());
		
		// ui
		for (h in help1.members) {
			TileSheetManager.setTileSheetIndex(cast(h,FlxSprite).getTileSheetIndex(), TileSheetManager.getMaxIndex());
		}
		for (h in help2.members) {
			TileSheetManager.setTileSheetIndex(cast(h,FlxSprite).getTileSheetIndex(), TileSheetManager.getMaxIndex());
		}
		
		
		#end
		
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
		
		for (i in powerupIndicator) {
			i.visible = false;
			add(i);
		}
		
			
		if(towerCounter!=null) {
			updateCounters();
		}
		
		if(AssetsLibrary.debug) {
			counter = 0;
		} else {
			counter = -3;
		}
	}
	
	
	function updateTime() {
		var min = Std.int(level.player.time) % 60;	
		var sec = Std.int(level.player.time);
		var dec = level.player.time-sec;
		timeCounter.text = (Std.int(sec / 60)) + ":" ;
		if (min < 10) 
			timeCounter.text += "0";
			
		timeCounter.text += min;
	}
	
	function updateCounters() {
		updateTime();
		ghostCounter.text = "Kills: "+level.player.kills;
		levelCounter.text = "Level " + levelNumber;
		coinCounter.text= "$: " + level.player.coins;
		towerCounter.text = "Towers: " + level.towers.length;
	}
	
	var up:FlxPoint;
	var ticks = 0;
	override public function update() {
		
		super.update();
		
		ticks++;
		if(ticks>=10) {
			updateCounters();
			ticks = 0;
		}
		
		if (level.player.time < 10) {
			var sec = Std.int(level.player.time);
			var dec = level.player.time-sec;
			if (dec < 0.5) {
				timeCounter.textColor = Colors.RED;
			} else {
				timeCounter.textColor = Colors.ORANGE;
			}
			if (sec != level.player.lastbeep) {
				level.player.lastbeep = sec;
				var s = Sound.TIMER;
				Utils.play(AssetsLibrary.getSound(s));
			}
			
		}
		if (help < 3) {
			if (FlxG.mouse.justPressed() || FlxG.keys.justReleased("SPACE") || FlxG.keys.justReleased("ENTER") ) {
				if (help == 1) {
					help = 2;
					remove(help1);
					help1Text.kill();
					add(help2);
				} else {
					help = 3;
					remove(help2);
					help2Text.kill();
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
				if (pu.life <= 0) {
					pu.remove();
				} else {
					if (pu.life <= 3) {
						pu.play("blink");
					}
				}
			}
			
		//check if active powerups need to stop being active
		var j = 0;
		for (p in level.activePowerups.keys()) {
			
			var t = level.activePowerups.get(p);
			var pu = powerupIndicator.get(p);
			t-= FlxG.elapsed;
			if (t <= 0) { 
				pu.visible = false;
				level.activePowerups.remove(p);
			} else {
				if (t <= 3) {
					pu.play("blink");
				}
				level.activePowerups.set(p, t);
				pu.visible = true;
				pu.y = j * 10;
				j++;
			}
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
		Utils.play(AssetsLibrary.getSound(Sound.GHOST_HIT));
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
		Utils.play(AssetsLibrary.getSound(Sound.DEATH));
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
		var coin = cast(c, Coin);
		Utils.play(AssetsLibrary.getSound(coin.snd));
		
		level.freePos.insert(0,new FlxPoint(Std.int(c.x/AssetsLibrary.tileSize),Std.int(c.y/AssetsLibrary.tileSize)));
		level.coins.remove(c, true);
		level.player.coins += coin.value;
			
		coinCounter.text = "$: " + level.player.coins;
		if (level.coins.length % 15 == 0) {
			addPowerup();
		}
		if (level.coins.length < 1) {
			newLevel();
		}
		
		if (coin.value > 1) {
			showInfoText("$" + coin.value + "!", c.x, c.y, 4*AssetsLibrary.tileSize, 0, Colors.LBLUE );
		}
	}
	
	function addPowerup() {
		var pu,pup, pl:FlxPoint, cnt = 0;
		pl = new FlxPoint(level.player.tileX,level.player.tileY);
		do { 
			cnt++;
			pup = level.freePos[Utils.randomIntInRange(0, level.freePos.length) - 1];
		} while (pl != pup && cnt <= 10);
		if (pup != null) {
			pu = level.spawnPowerup(pup);
			Utils.play(AssetsLibrary.getSound(Sound.POWERUP));
			add(level.powerupEffect);
			level.powerupEffect.explode(pu.x, pu.y);
		}
	}
	
	function pickUpPowerup(p:FlxObject, c:FlxObject) {	
		Utils.play(AssetsLibrary.getSound(Sound.CASH_REGISTER));
		var cc:Powerup = cast(c, Powerup);
		
		showInfoText(cc.text, cc.x, cc.y, 0, 0, cc.getColor());
		if (cc.type == PowerupType.INSTATOWER) {
			level.player.coins+= AssetsLibrary.towerCost;							
			level.player.spawnTower();
		} else {
			powerupIndicator.get(Type.enumConstructor(cc.type)).play("not blink");
			level.activePowerups.set(Type.enumConstructor(cc.type), cc.duration);
			
			if (cc.type == PowerupType.CONFUSION) {
				for (i in level.ghosts.members) {
					var g = cast(i, Ghost);
					g.stopFollowingPath(false, true);
				}
				
			}
		}
		level.powerups.remove(cc, true);
		cc.remove();
	}
	
	function showInfoText(text:String, x:Float, y:Float, destX:Float, destY:Float, color:Int) {
		var powerupInfo = Utils.newText(0, 0, "a",Colors.LGREEN, Std.int(FlxG.width - level.width - 8));
		#if flash
		powerupInfo.visible=true;
		#else
		powerupInfo.setVisibility(true);
		#end
		powerupInfo.text = text;
		powerupInfo.x = x;
		powerupInfo.y = y;
		powerupInfo.setColor(color & 0x00ffffff);
		Actuate.tween(powerupInfo, 1, { x: destX, y: destY });
		Actuate.timer(1).onComplete(hideInfoText, [powerupInfo, false] );
	}
	
	function hideInfoText(info:FlxTextField, visible:Bool) {
		if (members == null) {
			info.destroy();
			return;
		}
		
		#if flash
		info.visible=visible;
		#else
		info.setVisibility(visible);
		#end
		if (!visible && info!=null ) {
			remove(info);
			info.kill();
			// todo - check that not .destroy()-ing doesn't leak memory
		}
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
		//levelCounter.destroy();
		
		#if !keyboard
		Lib.current.removeChild(levelCounter);
		#end
		levelCounter = null;
		//coinCounter.destroy();
		coinCounter = null;
		//ghostCounter.destroy();
		ghostCounter = null;
		//towerCounter.destroy();
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
		for (i in powerupIndicator.keys()) {
			powerupIndicator.get(i).destroy();
			powerupIndicator.remove(i); 
		}
		
		powerupIndicator = null;
	}
	
}

enum CtrlMode {
	OVERLAY;
	GAMEPAD;
	GAMEPAD_L;
	SWIPE;	
}

