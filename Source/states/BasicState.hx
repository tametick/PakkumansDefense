package states;

import data.AssetsLibrary;
#if flash
import flash.desktop.NativeApplication;
#end
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.Lib;
import org.flixel.FlxG;
import org.flixel.FlxPoint;
import org.flixel.FlxState;
import org.flixel.FlxTextField;
import data.Image;

class BasicState extends FlxState {
	static var settings:Bitmap;
	static var settingsBmp:BitmapData;
	static var okBmp:BitmapData;
	static var mouseIndex:Int;
	
	var inited:Bool;
	public static var centered:Bool = false;
	
	override public function create() {
		inited = false;
		mouseIndex = FlxG._game.getChildIndex(FlxG._game._mouse);
		super.create();
		
		if(settings==null) {
			settings = new Bitmap(settingsBmp = AssetsLibrary.getImage(Image.SETTINGS));
			settings.width *= 2;
			settings.height *= 2;
			settings.y = 320 - settings.height - 4;
			settings.x = 480 - settings.width - 4;
			okBmp = AssetsLibrary.getImage(Image.SETTINGS_OK);
		}
		
		if(! (Std.is(this,GameState) || Std.is(this,HighScoreState)) ) {
			FlxG._game.addChildAt(settings, mouseIndex);
		}
	}
	
	public function init() {
		#if !desktop
		if(!centered) {
			centered = true;
			
			var w = Lib.current.stage.stageWidth;
			var h = Lib.current.stage.stageHeight;
			var ratio = w / h;
			
			if (ratio < 480/320) {
				// black bars on top & buttom
				var totalHeight = 480 / ratio;
				var barHeight = (totalHeight - 320) / 2;
				FlxG._game.y = barHeight;
			} else {
				// black bars on left and right
				var totalWidth = 320 * ratio;
				var barWidth = (totalWidth - 480) / 2;
				FlxG._game.x = barWidth;
			}
		}
		#end
	}
	
	var mousePoint:FlxPoint;
	override public function update() {
		super.update();
		if (!inited) {
			init();
			inited = true;
		}
		
		settings.visible = false;
		if ( Std.is(this, GameState) || Std.is(this, HighScoreState) ) {
			return;
		} else if (Std.is(this, SettingsState)) {
			settings.bitmapData = okBmp;
		} else {
			settings.bitmapData = settingsBmp;
		}
		settings.visible = true;
		
		if (BuskerJam.backButton) {
			if (Std.is(this, MenuState)) {
				#if flash
				NativeApplication.nativeApplication.exit();
				#end
				#if android
				Lib.exit();
				#end
			} else if (Std.is(this, HighScoreState)) {
				
			} else 	{
				BuskerJam.backButton = false;
				goBack();
			}
		} else if (settingsButtonPressed() || BuskerJam.menuButton ) {
			BuskerJam.menuButton  = false;
			if (Std.is(this, SettingsState)) {
				goBack();
			} else {
				BuskerJam.returnToState = Type.getClass(this);
				FlxG.switchState(new SettingsState());
			}
		}
		
	}
	
	function goBack() {
		var s = BuskerJam.returnToState;
		if (s == null) {
			s = MenuState;
		}
		BuskerJam.returnToState = null;
		FlxG.switchState(Type.createInstance(s, []));
	}

	
	function settingsButtonPressed():Bool {
		if (!FlxG.mouse.justPressed()) {
			return false;
		}
		
		mousePoint = FlxG.mouse.getScreenPosition(null, mousePoint);
		
		var x = mousePoint.x * FlxG.camera.getScale().x; 
		var y = mousePoint.y * FlxG.camera.getScale().y;
		if (x > settings.x && x < settings.x + settings.width && y > settings.y && y < settings.y + settings.height) {
			FlxG.mouse.reset(); 
			return true;
		}
		
		return false;
	}
}