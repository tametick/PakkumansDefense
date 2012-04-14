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
		makeGraphic(Library.tileSize-4, Library.tileSize-4, Reflect.field(Colors,type));
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