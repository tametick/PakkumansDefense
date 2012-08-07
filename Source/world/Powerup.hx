package world;
import data.Library;
import org.flixel.FlxG;
import org.flixel.FlxPoint;
import utils.Colors;

class Powerup extends WarpSprite {
    public var type:PowerupType;
	public function new(level:Level, start:FlxPoint) {
		super(level);
		 
        type  = Type.createEnum(PowerupType,FlxG.getRandom(Type.getEnumConstructs(PowerupType)));

		//TODO diferent graphics and powerup names
		
		var clr:Int, img:Image;
		switch(type) {
			default: clr = Colors.ORANGE; img = Image.TOWER;
			
			}
		loadGraphic(Library.getFilename(img));
		
		setColor(clr);
		
		setPosition(start);
		start = null;
	}
	
}

enum PowerupType {
	ONE;
	TWO;
	THREE;
	}