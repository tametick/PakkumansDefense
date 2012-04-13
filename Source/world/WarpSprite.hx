package world;
import org.flixel.FlxSprite;

class WarpSprite extends FlxSprite{
	var level:Level;
	
	public function new(level:Level) {
		super();
		this.level = level;
	}
	
	override public function update() {
		super.update();
		
		if (x < 0) {
			x = level.width - width;
		}
		if (y < 0) {
			y = level.height - height;
		}
		
		if (x + width > level.width) {
			x = 0;
		}
		if (y + height > level.height) {
			y = 0;
		}
			
	}
	
}