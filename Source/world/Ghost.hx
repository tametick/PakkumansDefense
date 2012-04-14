package world;

import org.flixel.FlxG;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import data.Library;
import org.flixel.FlxU;
import utils.Colors;

class Ghost extends WarpSprite {
	var type:GhostType;
	
	public function new(level:Level, start:FlxPoint, type:String) {
		super(level);
		this.type = Type.createEnum(GhostType, type);
		
		loadGraphic(Library.getFilename(Image.GHOST), true, true, 5, 5);
		addAnimation("walk", [0, 1], 5);
		play("walk");
		setColor(Reflect.field(Colors, type));
		
		setPosition(start);
		start = null;
		
		counter = 0;
	}
	
	var counter:Float;
	var p0:FlxPoint;
	var p1:FlxPoint;

	override public function update() {
		super.update();
		
		if (p0 == null) {
			p0 = new FlxPoint();
			p1 = new FlxPoint();
		}
		
		// only calculate AI every 1 second
		counter += FlxG.elapsed;
		if (counter >= 1 && pathSpeed == 0) {
			counter = 0;
			
			p0.x = level.player.x + level.player.width/2;
			p0.y = level.player.y + level.player.height/2;
			p1.x = x + width/2;
			p1.y = y + height/2;
			
			// if close to player, target them
			if (FlxU.getDistance(p0, p1) < 7 * Library.tileSize) {
				var path = level.findPath(p1, p0);
				if(path!=null)
					followPath(path, 20);
			}
			
			// otherwise go randomly 
		}

		
		

	}
}

enum GhostType {
	RED;
	PINK;
	LBLUE;
	ORANGE;
}