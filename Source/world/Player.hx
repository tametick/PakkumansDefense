package world;

import com.eclecticdesignstudio.motion.Actuate;
import data.Library;
import org.flixel.FlxG;
import org.flixel.FlxObject;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import world.Splosion;
import utils.Colors;
import utils.Utils;

class Player extends WarpSprite {
	public var coins:Int;
	public var kills:Int;
	public var arrow:FlxSprite;
	
	var isMoving:Bool;
	var facingNext:Int;
	var bloodSplosion:Splosion;
	
	public function new(level:Level, start:FlxPoint) {
		super(level);
		
		loadGraphic(Library.getFilename(Image.PAKKU), true, true, 5, 5);
		addAnimation("walk", [0, 1], 5);
		play("walk");
		setColor(Colors.YELLOW);
		
		arrow = new FlxSprite();
		arrow.loadGraphic(Library.getFilename(Image.ARROW), true, false, 16, 16);
		arrow.addAnimation("N", [0]);
		arrow.addAnimation("S", [1]);
		arrow.addAnimation("W", [2]);
		arrow.addAnimation("E", [3]);
		arrow.setColor(Colors.YELLOW);
		
		setPosition(start);
		start = null;
		bloodSplosion = new Splosion(Colors.YELLOW);
		
		coins = 20;
	}
	
	public function explode() {
		visible = false;
		bloodSplosion.explode(x,y);
	}
	
	override public function draw() {
		super.draw();
		arrow.x = x - 5;
		arrow.y = y - 5;
	}
	
	override public function update() {
		super.update();

		// change facing according to keyboard input
		if (FlxG.keys.A || FlxG.keys.LEFT) {
			facingNext = FlxObject.LEFT;
			arrow.play("W");
		} if (FlxG.keys.D || FlxG.keys.RIGHT) {
			facingNext = FlxObject.RIGHT;
			arrow.play("E");
		} if (FlxG.keys.S || FlxG.keys.DOWN) {
			facingNext = FlxObject.DOWN;
			arrow.play("S");
		} if (FlxG.keys.W || FlxG.keys.UP) {
			facingNext = FlxObject.UP;
			arrow.play("N");
		}
		
		if (!isMoving) {
			var oldFacing = facing;
			facing = facingNext;
			
			var hasMoved = move();
			if (!hasMoved) {
				facing = oldFacing;
				move();
			}
		}
	}

	private function move():Bool {
		var tileX = Utils.pixelToTile(x);
		var tileY = Utils.pixelToTile(y);
		// move forward
		if(facing== FlxObject.LEFT && level.isFree(tileX-1,tileY)) {
			startMoving(-1,0);
		} else if(facing== FlxObject.RIGHT && level.isFree(tileX+1,tileY)) {
			startMoving(1,0);
		} else if(facing== FlxObject.DOWN && level.isFree(tileX,tileY+1)) {
			startMoving(0,1);
		} else if(facing== FlxObject.UP && level.isFree(tileX,tileY-1)) {
			startMoving(0,-1);
		} else {
			return false;
		}
		
		return true;
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