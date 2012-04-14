package world;

import data.Library;
import org.flixel.FlxG;
import org.flixel.FlxObject;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import utils.Colors;

class Player extends WarpSprite {
	public var coins:Int;
	
	public function new(level:Level, start:FlxPoint) {
		super(level);
		
		makeGraphic(Library.tileSize-4, Library.tileSize-4, Colors.YELLOW);
		
		setPosition(start);
		start = null;
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