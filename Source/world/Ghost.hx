package world;
import org.flixel.FlxSprite;

/**
 * ...
 * @author 
 */

class Ghost extends WarpSprite {
	var type:GhostType;
	
	public function new(level:Level, type:GhostType) {
		super(level);
		
		this.type = type;
	}
	
	override public function removeMe() {
		level.ghosts.remove(this);
	}
	override public function addMe() {
		level.ghosts.add(this);
	}
}

enum GhostType {
	RED;
	PINK;
	LBLUE;
	ORANGE;
}