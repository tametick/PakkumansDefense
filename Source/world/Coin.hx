package world;
import org.flixel.FlxSprite;

class Coin extends FlxSprite {

	public function new() {
		super();
		
		x = start.x * Library.tileSize;
		y = start.y * Library.tileSize;
		
		makeGraphic(2, 2, Colors.YELLOW);
	}
	
}