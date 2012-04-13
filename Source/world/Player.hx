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
		
		makeGraphic(Library.tileSize-3, Library.tileSize-3, Colors.YELLOW);
	}
	
	override public function update() {
		super.update();
		
		velocity.x = 0;
		velocity.y = 0;
		
		// change direction according to keyboard input
		if (FlxG.keys.A || FlxG.keys.LEFT) {
			facing = FlxObject.RIGHT;
			velocity.x = -Library.speedNormal;			
		} 
		if (FlxG.keys.D || FlxG.keys.RIGHT) {
			facing = FlxObject.LEFT;
			velocity.x = Library.speedNormal;
		} 
		if (FlxG.keys.S || FlxG.keys.DOWN) {
			facing = FlxObject.DOWN;
			velocity.y = Library.speedNormal;
		} 
		if (FlxG.keys.W || FlxG.keys.UP) {
			facing = FlxObject.UP;
			velocity.y = -Library.speedNormal;
		}
	}
}