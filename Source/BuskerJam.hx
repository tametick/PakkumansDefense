import data.AssetsLibrary;
import haxe.Log;
import nme.display.Bitmap;
import nme.display.StageAlign;
import nme.events.Event;
import nme.events.TouchEvent;
import nme.Lib;
import utils.Colors;
#if keyboard
import nme.display.Sprite;
import nme.text.TextField;
import nme.net.URLRequest;
#end
import nme.ui.Multitouch;
import nme.ui.MultitouchInputMode;
import org.flixel.FlxG;
import org.flixel.FlxPoint;
import states.BasicState;
import states.SettingsState;

import nme.events.MouseEvent;
import org.flixel.FlxGame;
import states.GameState;
import states.HighScoreState;
import states.LevelSelectState;
import states.MenuState;
import world.Player;

import nme.events.KeyboardEvent;
import nme.ui.Keyboard;

class BuskerJam extends FlxGame {	
	public static var returnToState:Class<BasicState>;
	public static var touchPoints:Array<FlxPoint>;
	public static var multiTouchSupported;
	public static var menuButton;
	public static var backButton;
	
	#if keyboard
	public static var label:TextField;
	#end
	
	public static function main () {		
		Lib.current.addChild (new BuskerJam());
	}
	static function nothing(e:Event) {	}
	
	private function init(e) {
		Lib.current.stage.align = StageAlign.BOTTOM_RIGHT;
		
		multiTouchSupported = nme.ui.Multitouch.supportsTouchEvents;
		
		if (multiTouchSupported) {
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			Lib.current.stage.addEventListener(TouchEvent.TOUCH_BEGIN, touchBegin,false,0,true);
			Lib.current.stage.addEventListener(TouchEvent.TOUCH_MOVE, touchMove,false,0,true);
			Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler, false, 0, true);
			Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, stopKey,false,0,true);

		}
		#if keyboard
		Lib.current.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, nothing,false,0,true);
		
		var buySprite = new Sprite();
		buySprite.buttonMode = true;
		buySprite.addEventListener(MouseEvent.CLICK, clickBuy, false, 0, true);
		
		label = utils.Utils.newTextField("Now out for Android!",24, 0xBC6DBC, true);

		buySprite.addChild(label);		
		Lib.current.stage.addChild(buySprite);
		
		buySprite.x = 0;
		buySprite.y = 320-26;
		#end
		
		
		#if iphone
		Lib.current.stage.removeEventListener(Event.RESIZE, init);
		#else
		removeEventListener(Event.ADDED_TO_STAGE, init);
		#end
	}
	
	public function new() {		
		#if iphone
		Lib.current.stage.addEventListener(Event.RESIZE, init);
		#else
		addEventListener(Event.ADDED_TO_STAGE, init);
		#end
		SettingsState.initSettings();

		if(AssetsLibrary.debug) {
			super(240, 160, GameState, 2, 30, 30);
			forceDebugger = true;
		} else {
			super(240, 160, MenuState, 2, 30, 30);
		}
		
	}
		
	static function touchBegin(e:TouchEvent):Void {  
		if (Std.is(FlxG.state, GameState))	{
			var g = cast(FlxG.state, GameState);
			var pl = g.level.player;
			pl.x = 0; pl.y = 0;
			
			if (g.help < 3) {
				return;
			}	
			
			pl.touch = pl.getCommand(e.stageX, e.stageY);
			
		}
	}
	
	
	static function touchMove(e:TouchEvent):Void {
		if (Std.is(FlxG.state, GameState)) {
			var g = cast(FlxG.state, GameState);
			if (g.help < 3) {
				return;
			}
			
			var pl=g.level.player;
			var command = pl.getCommand(e.stageX, e.stageY);
			
			if (command != Command.TOWER) {
				pl.touch = command;
				pl.executeCurrentCommand();
			}
		}
	}
	
	static function stopKey(event:KeyboardEvent):Void {
		if (event.keyCode == 27 ) {
			event.stopImmediatePropagation();
			event.stopPropagation();
			event.keyCode = -1;
		}
	}
	
	static function keyHandler(event:KeyboardEvent):Void {
		#if android
		switch (event.keyCode){
			case 27:
				backButton = true;
				event.stopImmediatePropagation();
				event.stopPropagation();
			case 0x01000012:
				menuButton = true;
		}
		#end
	}
	
	
	
	#if keyboard
	static function clickBuy(e : Event) {
		var request : URLRequest = new URLRequest("https://play.google.com/store/apps/details?id=air.tametick.pakkuman");
		Lib.getURL(request);
		request = null;
	}
	#end

}