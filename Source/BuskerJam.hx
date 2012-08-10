import data.Library;
import nme.display.Bitmap;
import nme.events.Event;
import nme.Lib;

import flash.events.MouseEvent;
import org.flixel.FlxGame;
import states.GameState;
import states.HighScoreState;
import states.LevelSelectState;
import states.MenuState;


class BuskerJam extends FlxGame {	
	static var settings:Bitmap;
	public static function main () {
		Lib.current.addChild (new BuskerJam());
		settings = new Bitmap(Library.getImage(Image.SETTINGS));
		settings.width *= 2;
		settings.height *= 2;
		settings.y = 320 - settings.height - 4;
		settings.x = 480 - settings.width - 4;
		Lib.current.addChild (settings);
		Lib.current.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, nothing);
	}
	static function nothing(e:Event) {	}
	
	public function new() {
		if(Library.debug) {
			super(240, 160, GameState, 2);
			forceDebugger = true;
		} else {
			super(240, 160, MenuState, 2);
		}
	}
	
	override private function update():Void {
		super.update();
	}
}