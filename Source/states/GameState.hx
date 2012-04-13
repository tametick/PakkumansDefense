package states;

import data.Library;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.plugin.photonstorm.FlxGridOverlay;
import utils.Colors;
import world.Level;
import world.Player;

class GameState extends FlxState {
	var level:Level;
	var player:Player;
	var ghosts:FlxGroup;
	var coins:FlxGroup;
	
	override public function create():Void {
		FlxG.mouse.show();
		FlxG.bgColor = Colors.BLACK;
		FlxG.fade(0, 0.5, true, null, true);
		
		level = new Level();
		add(FlxGridOverlay.create(Library.tileSize, Library.tileSize, Std.int(level.width), Std.int(level.height), false, true, Colors.DBLUE, Colors.BLUE));
		add(level);
		
		var playerStart = level.getFreeTile();
		player = new Player(playerStart);
		add(player);
		
		coins = new FlxGroup();
		ghosts = new FlxGroup();
		
		var cs = level.countEmpty();
		for (c in 0...cs) {
			
		}
	}
	
	override public function update() {
		super.update();
		
		FlxG.collide(level, player);
		FlxG.collide(level, ghosts);
	}
}