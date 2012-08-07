package world;
import data.Library;
import org.flixel.FlxG;
import org.flixel.FlxPoint;
import utils.Colors;

class Powerup extends WarpSprite {
    public var type:PowerupType;
	public var life:Float;
	public var duration:Float;
	public function new(level:Level, start:FlxPoint) {
		super(level);
		life = 5; 
        type  = Type.createEnum(PowerupType,FlxG.getRandom(Type.getEnumConstructs(PowerupType)));

		//TODO diferent graphics and powerup names
		
		var clr:Int, img:Image;
		switch(type) {
			case FREEZE: clr = Colors.LBLUE; img = Image.FREEZE; duration = 5; 
			case CASHFORKILLS: clr = Colors.GREEN; img = Image.CASH; duration = 5; 
			}
		loadGraphic(Library.getFilename(img));
		
		setColor(clr);
		
		setPosition(start);
		start = null;
	}
	
	override public function update() {
		super.update();
		life -= FlxG.elapsed;
	}
	
	public function remove() {
		this.kill();
	}
}

enum PowerupType {
	FREEZE;
	CASHFORKILLS;
	}