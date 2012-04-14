package world;

import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import data.Library;
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
	}
}

enum GhostType {
	RED;
	PINK;
	LBLUE;
	ORANGE;
}