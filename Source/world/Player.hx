package world;

import data.Library;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import utils.Colors;

class Player extends FlxSprite {

	public function new(start:FlxPoint) {
		super();
		
		x = start.x * Library.tileSize;
		y = start.y * Library.tileSize;
		
		makeGraphic(Library.tileSize-2, Library.tileSize-2, Colors.YELLOW);
	}
	
}