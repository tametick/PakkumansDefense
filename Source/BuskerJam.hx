import nme.display.Bitmap;
import nme.events.Event;
import nme.Lib;
import org.flixel.FlxGame;
import states.GameState;
import states.MenuState;


class BuskerJam extends FlxGame {	
	public static function main () {
		Lib.current.addChild (new BuskerJam());
	}

	public function new() {
		//super(240, 160, MenuState, 3);
		super(240, 160, GameState, 3);
		
		forceDebugger = true;
	}
	
	override private function update():Void {
		super.update();
	}
}