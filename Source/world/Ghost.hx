package world;

import com.eclecticdesignstudio.motion.Actuate;
import org.flixel.FlxG;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import data.Library;
import org.flixel.FlxU;
import utils.Colors;
import states.GameState;

class Ghost extends WarpSprite {
	var type:GhostType;
	var bloodSplosion:Splosion;
	
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
		bloodSplosion = new Splosion(Reflect.field(Colors, type));
	}
	
	public function explode() {
		visible = false;
		bloodSplosion.explode(x, y);
	}
	
	override public function destroy() {
		bloodSplosion.destroy();
		bloodSplosion = null;
		super.destroy();
	}
	
	override public function kill() {
		bloodSplosion.kill();
		super.kill();
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
		if(!level.activePowerups.exists("FREEZE")){
		// only calculate AI every 1 second
			counter += FlxG.elapsed;
			if (counter >= 1 && pathSpeed == 0) {
				counter = 0;
			
				p0.x = level.player.x + level.player.width/2;
				p0.y = level.player.y + level.player.height/2;
				p1.x = x + width/2;
				p1.y = y + height/2;
			
				// target player 
				var path = level.findPath(p1, p0);
				if(path!=null)
					followPath(path, 20,0,false,true);
			}
		} else {
			stopFollowingPath(false,true);
		}
	}
}

enum GhostType {
	RED;
	PINK;
	LBLUE;
	ORANGE;
}