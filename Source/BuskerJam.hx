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
	public static var androidBuySprite:Sprite;
	#end
	
	public static function main () {		
		Lib.current.addChild (new BuskerJam()); 
	}
	static function nothing(e:Event) {	}
	
	private static function init(e) {
		
		multiTouchSupported = nme.ui.Multitouch.supportsTouchEvents;
		
		if (multiTouchSupported) {
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			Lib.current.stage.addEventListener(TouchEvent.TOUCH_BEGIN, touchBegin);
			Lib.current.stage.addEventListener(TouchEvent.TOUCH_MOVE, touchMove);
		}
		
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, stopKey);
		
		#if keyboard
		Lib.current.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, nothing,false,0,true);
	
		androidBuySprite = new Sprite();
		androidBuySprite.buttonMode = true;
		androidBuySprite.addEventListener(MouseEvent.CLICK, clickBuy, false, 0, true);
		
		var label = new Bitmap(AssetsLibrary.getImage(data.Image.GET_IT_ON_PLAY));
		androidBuySprite.addChild(label);		
		androidBuySprite.x = 6;
		androidBuySprite.y = 320-label.height - 6;
		#end
		
		#if iphone
		Lib.current.stage.removeEventListener(Event.RESIZE, init);
		#else
		Lib.current.stage.removeEventListener(Event.ADDED_TO_STAGE, init);
		#end
		
		
	}
	
	public function new() {		
		
		
		SettingsState.initSettings();

		if(AssetsLibrary.debug) {
			super(240, 160, GameState, 2, 30, 30);
			forceDebugger = true;
		} else {
			super(240, 160, MenuState, 2, 30, 30);
		}
		
		
		#if iphone
		Lib.current.stage.addEventListener(Event.RESIZE, init);
		#else
		addEventListener(Event.ADDED_TO_STAGE, init);
		#end
		
	}
		
	static function touchBegin(e:TouchEvent):Void {  
		
		if (Std.is(FlxG.state, GameState))	{
			var g = cast(FlxG.state, GameState);
			var pl = g.level.player;
						
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
	
	static function stopKey(e:KeyboardEvent):Void {
		if (e.keyCode == 27 ) { 
			e.stopImmediatePropagation();
			e.stopPropagation();
		}
	}
	
	static function keyHandler(event:KeyboardEvent):Void {
		#if android
		
		switch (event.keyCode){
			case 27:
				backButton = true;
				event.stopImmediatePropagation();
				event.stopPropagation();
			//case 0x01000012: not picked up
			//	menuButton = true;
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