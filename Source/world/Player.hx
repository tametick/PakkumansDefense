package world;

import data.Library;
import org.flixel.FlxG;
import org.flixel.FlxObject;
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
	
	override public function update() {
		super.update();
		
		// change direction according to keyboard input
		if (FlxG.keys.A) {
			facing = FlxObject.RIGHT;
			velocity.x = -Library.speedNormal;
			velocity.y = 0;
			
		} else if (FlxG.keys.D) {
			facing = FlxObject.LEFT;
			velocity.x = Library.speedNormal;
			velocity.y = 0;
		} else if (FlxG.keys.S) {
			facing = FlxObject.DOWN;
			velocity.x = 0;
			velocity.y = Library.speedNormal;
		} else if (FlxG.keys.W) {
			facing = FlxObject.UP;
			velocity.x = 0;
			velocity.y = -Library.speedNormal;
		}
	}
}