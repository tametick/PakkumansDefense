package states;

import org.flixel.FlxG;
import org.flixel.FlxState;
import world.Level;

class GameState extends FlxState {
	var level:Level;
	
	override public function create():Void {
		FlxG.bgColor = 0xff008080;
		FlxG.mouse.show();
		
		FlxG.fade(0, 0.5, true, null, true);
		
		level = new Level();
		add(level);
	}
}