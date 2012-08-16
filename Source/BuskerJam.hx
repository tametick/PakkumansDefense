import data.Library;
import nme.display.Bitmap;
import nme.events.Event;
import nme.Lib;
import states.BasicState;
import states.SettingsState;

import flash.events.MouseEvent;
import org.flixel.FlxGame;
import states.GameState;
import states.HighScoreState;
import states.LevelSelectState;
import states.MenuState;


class BuskerJam extends FlxGame {	
	public static var returnToState:Class<BasicState>;
	
	public static function main () {
		Lib.current.addChild (new BuskerJam());
		Lib.current.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, nothing);
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
	
	override private function update():Void {
		super.update();
	}
}