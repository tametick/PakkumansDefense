package states;

import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import world.Level;
import world.Player;

class GameState extends FlxState {
	var level:Level;
	var player:Player;
	var ghosts:FlxGroup;
	
	override public function create():Void {
		FlxG.bgColor = 0xff008080;
		FlxG.mouse.show();
		
		FlxG.fade(0, 0.5, true, null, true);
		
		level = new Level();
		add(level);
		
		var playerStart = level.getFreeTile();
		player = new Player(playerStart);
		add(player);
		
		
	}
}