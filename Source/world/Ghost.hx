package world;
import org.flixel.FlxSprite;

/**
 * ...
 * @author 
 */

class Ghost extends FlxSprite {
	var type:GhostType;
	
	public function new(type:GhostType) {
		super();
		
		this.type = type;
	}
	
}

enum GhostType {
	RED;
	PINK;
	LBLUE;
	ORANGE;
}