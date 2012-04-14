package world;

import com.eclecticdesignstudio.motion.Actuate;
import data.Library;
import org.flixel.FlxG;
import org.flixel.FlxObject;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import utils.Colors;
import utils.Utils;

class Player extends WarpSprite {
	public var coins:Int;
	public var kills:Int;
	var isMoving:Bool;
	
	public function new(level:Level, start:FlxPoint) {
		super(level);
		
		loadGraphic(Library.getFilename(Image.PAKKU), true, true, 5, 5);
		addAnimation("walk", [0, 1], 5);
		play("walk");
		setColor(Colors.YELLOW);
		
		setPosition(start);
		start = null;
	}
	
	override public function update() {
		super.update();

		if (!isMoving) {
			var tileX = Utils.pixelToTile(x);
			var tileY = Utils.pixelToTile(y);
			
			// change facing according to keyboard input
			if ((FlxG.keys.A||FlxG.keys.LEFT||FlxG.keys.justPressed("A")||FlxG.keys.justPressed("LEFT")) && level.isFree(tileX-1,tileY)) {
				facing = FlxObject.LEFT;
			} if ((FlxG.keys.D||FlxG.keys.RIGHT||FlxG.keys.justPressed("D")||FlxG.keys.justPressed("RIGHT")) && level.isFree(tileX+1,tileY)) {
				facing = FlxObject.RIGHT;
			} if ((FlxG.keys.S||FlxG.keys.DOWN||FlxG.keys.justPressed("S")||FlxG.keys.justPressed("DOWN")) && level.isFree(tileX,tileY+1)) {
				facing = FlxObject.DOWN;
			} if ((FlxG.keys.W||FlxG.keys.UP||FlxG.keys.justPressed("W")||FlxG.keys.justPressed("UP")) && level.isFree(tileX,tileY-1)) {
				facing = FlxObject.UP;
			}
			
			// move forward
			if(facing== FlxObject.LEFT && level.isFree(tileX-1,tileY)) {
				startMoving(-1,0);
			} else if(facing== FlxObject.RIGHT && level.isFree(tileX+1,tileY)) {
				startMoving(1,0);
			} else if(facing== FlxObject.DOWN && level.isFree(tileX,tileY+1)) {
				startMoving(0,1);
			} else if(facing== FlxObject.UP && level.isFree(tileX,tileY-1)) {
				startMoving(0,-1);
			}
		}		
			
	}
	
	function startMoving(dx:Int, dy:Int) {
		isMoving = true;
		var duration = 0.2;
		
		var rawX = this.x + dx * Library.tileSize;
		var rawY = this.y + dy * Library.tileSize;
		
		var xShift = (Library.tileSize-width) / 2;
		var yShift = (Library.tileSize-height) / 2;
		var nextPixelX = rawX<0?rawX:Utils.getPositionSnappedToGrid(rawX) + xShift;
		var nextPixelY = rawY<0?rawY:Utils.getPositionSnappedToGrid(rawY) + yShift;
		
		// move
		Actuate.tween(this, duration, {x: nextPixelX, y: nextPixelY}).onComplete(stopped);
	}
	
	public function stopped() {
		isMoving = false;
		
		
	}
}