package states;

import org.flixel.FlxG;
import org.flixel.FlxState;

class GameState extends FlxState {
	override public function create():Void {
		FlxG.fade(0, 0.5, true, null, true);
		
		FlxG.bgColor = 0xff008080;
	}
}