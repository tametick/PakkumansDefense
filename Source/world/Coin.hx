package world;
import data.Library;
import org.flixel.FlxPoint;
import utils.Colors;

class Coin extends WarpSprite {

	public function new(level:Level, start:FlxPoint) {
		super(level);
		
		makeGraphic(2, 2, Colors.BLUEGRAY);
		
		setPosition(start);
		start = null;
	}
	
}