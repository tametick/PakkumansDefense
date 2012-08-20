import data.Library;
import nme.display.Bitmap;
import nme.events.Event;
import nme.events.TouchEvent;
import nme.Lib;
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
	
	public static function main () {
		Lib.current.addChild (new BuskerJam());
		Lib.current.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, nothing,false,0,true);
		
		multiTouchSupported = Multitouch.supportsTouchEvents;
		if (multiTouchSupported){
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			Lib.current.stage.addEventListener(TouchEvent.TOUCH_BEGIN, touchBegin,false,0,true);
			Lib.current.stage.addEventListener(TouchEvent.TOUCH_MOVE, touchBegin,false,0,true);
			Lib.current.stage.addEventListener(TouchEvent.TOUCH_END, touchEnd, false, 0, true);
			
			Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler,false,0,true);
		}
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
			//pl.resolveTouch();
		}
	}
	
	static function touchEnd(e:TouchEvent):Void {   
	   var s = cast(FlxG.state, GameState);
		s.setUnhighlighted(TOWER);
		s.setUnhighlighted(UP);
		s.setUnhighlighted(DOWN);
		s.setUnhighlighted(LEFT);
		s.setUnhighlighted(RIGHT);
	}
	
	static function touchMove(e:TouchEvent):Void {   
		if (Std.is(FlxG.state, GameState))	{
			var g = cast(FlxG.state, GameState);
			if (g.help < 3) {
				return;
			}	
			var pl=g.level.player;
			pl.touch=pl.getCommand(e.stageX, e.stageY);
			if (pl.touch == Command.TOWER) {
				pl.touch = null;	
			} else {
				pl.executeCurrentCommand();
			}
			
		}
	}
	
	static function keyHandler(event:KeyboardEvent):Void {
            //trace("keyHandler: " + event.keyCode);
            switch (event.keyCode){
                case Keyboard.BACK:
					backButton = true;
                  //  trace("Back key is pressed.");
                    event.preventDefault();
                case Keyboard.MENU:
					menuButton = true;
                   // trace("Menu key is pressed.");
            }
         }
}