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
		#if keyboard
		life = 4;
		#else
		life = 6; 
		#end
        type = Type.createEnum(PowerupType, FlxG.getRandom(Type.getEnumConstructs(PowerupType)));
		
		var clr:Int, img:Image;
		switch(type) {
			case FREEZE: 
				clr = Colors.LBLUE; 
				img = Image.FREEZE; 
				#if keyboard
				duration = 4; 
				#else
				duration = 6; 
				#end
			case CASHFORKILLS: 
				clr = Colors.GREEN; 
				img = Image.CASH; 
				#if keyboard
				duration = 4; 
				#else
				duration = 6; 
				#end
			case SHOTGUN:
				clr = Colors.RED; 
				img = Image.SHOTGUN; 
				#if keyboard
				duration = 4; 
				#else
				duration = 6; 
				#end
			}
		
		loadGraphic(Library.getFilename(img));
		setColor(clr);
		if(start!=null){
			setPosition(start);
		}
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
	SHOTGUN;
}