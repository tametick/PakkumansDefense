package world;

import org.flixel.FlxPoint;
import utils.Colors;

class Tower extends WarpSprite{

	public function new(level:Level, start:FlxPoint) {
		super(level);
		
		makeGraphic(Library.tileSize-2, Library.tileSize-2, Colors.YELLOW);
		
		setPosition(start);
		start = null;
	}
	
}