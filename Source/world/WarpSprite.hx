package world;
import data.AssetsLibrary;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;

class WarpSprite extends FlxSprite{
	public var level:Level;
	var enableCollisionsNextFrame:Bool;
	
	public function new(level:Level) {
		super();
		this.level = level;
	}
	
	override public function update() {
		super.update();
		if (enableCollisionsNextFrame) {
			enableCollisionsNextFrame = false;
			solid = true;
		}
		
		if (x < 0) {
			enableCollisionsNextFrame = true;
			solid = false;
			x = level.width - width;
		}
		if (y < 0) {
			enableCollisionsNextFrame = true;
			solid = false;
			y = level.height - height;
		}
		
		if (x + width > level.width) {
			enableCollisionsNextFrame = true;
			solid = false;
			x = 0;
		}
		if (y + height > level.height) {
			enableCollisionsNextFrame = true;
			solid = false;
			y = 0;
		}
	}
	
	override public function destroy() {
		super.destroy();
		level = null;
	}
	
		
	public function setPosition(start:FlxPoint) {
		x = start.x * AssetsLibrary.tileSize + (AssetsLibrary.tileSize-width)/2;
		y = start.y * AssetsLibrary.tileSize + (AssetsLibrary.tileSize-height)/2;		
	}
	
}