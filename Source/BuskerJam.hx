import data.Library;
import nme.display.Bitmap;
import nme.events.Event;
import nme.events.TouchEvent;
import nme.Lib;
import utils.Colors;
#if keyboard
import nme.display.Sprite;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFieldAutoSize;
import nme.net.URLRequest;
#end
import nme.ui.Multitouch;
import nme.ui.MultitouchInputMode;
import org.flixel.FlxG;
import org.flixel.FlxPoint;
import states.BasicState;
import states.SettingsState;

import flash.events.MouseEvent;
import org.flixel.FlxGame;
import states.GameState;
import states.HighScoreState;
import states.LevelSelectState;
import states.MenuState;
import world.Player;

import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

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
		Lib.current.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, nothing,false,0,true);
		
		multiTouchSupported = Multitouch.supportsTouchEvents;
		if (multiTouchSupported){
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			Lib.current.stage.addEventListener(TouchEvent.TOUCH_BEGIN, touchBegin,false,0,true);
			Lib.current.stage.addEventListener(TouchEvent.TOUCH_MOVE, touchMove,false,0,true);
			
			Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler,false,0,true);
		}
		
		#if keyboard
		var buySprite = new Sprite();
		buySprite.buttonMode = true;
		buySprite.addEventListener(MouseEvent.CLICK, clickBuy, false, 0, true);
		
		label = new TextField();
		var format = new TextFormat();
		
		format.font = "eight2empire";
		format.size = 24;
		format.underline = true;
		label.defaultTextFormat = format;
		label.selectable = false;
		
		label.autoSize = TextFieldAutoSize.LEFT;
		label.text = "Now out for Android!";
		
		label.textColor = 0xBC6DBC;

		buySprite.addChild(label);		
		Lib.current.stage.addChild(buySprite);
		
		buySprite.x = 0;
		buySprite.y = 320-26;

		format = null;
		#end
	}
	static function nothing(e:Event) {	}
	
	public function new() {
		if(Library.debug) {
			super(240, 160, GameState, 2, 30, 30);
			forceDebugger = true;
		} else {
			super(240, 160, MenuState, 2, 30, 30);
		}
	}
		
	static function touchBegin(e:TouchEvent):Void {  
		if (Std.is(FlxG.state, GameState))	{					
			var g = cast(FlxG.state, GameState);
			if (g.help < 3) {
				return;
			}	
			var pl=g.level.player;
			pl.touch=pl.getCommand(e.stageX, e.stageY);
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
	
	static function keyHandler(event:KeyboardEvent):Void {
		switch (event.keyCode){
			case Keyboard.BACK:
				backButton = true;
				event.preventDefault();
			case Keyboard.MENU:
				menuButton = true;
		}
	}
	
	#if keyboard
	static function clickBuy(e : Event) {
		var request : URLRequest = new URLRequest("https://play.google.com/store/apps/details?id=air.com.tametick.cardinalquest");
		Lib.getURL(request);
		request = null;
	}
	#end

}