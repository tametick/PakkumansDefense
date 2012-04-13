package world;
import data.Library;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import utils.Colors;

class Coin extends FlxSprite {

	public function new(start:FlxPoint) {
		super();
		
		makeGraphic(2, 2, Colors.BLUEGRAY);
		
		x = start.x * Library.tileSize + (Library.tileSize-width)/2;
		y = start.y * Library.tileSize + (Library.tileSize-height)/2;
	}
	
}