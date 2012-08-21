package world;
import data.Library;
import data.Image;
import org.flixel.FlxG;
import org.flixel.FlxPoint;
import utils.Colors;

class Powerup extends WarpSprite {
    public var type:PowerupType;
	public var life:Float;
	public var duration:Float;
	public var text:String;
	
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
				text = "Frozen!";
				#if keyboard
				duration = 4; 
				#else
				duration = 6; 
				#end
			case CASHFORKILLS: 
				clr = Colors.LGREEN; 
				img = Image.CASH; 
				text = "Money on kills!";
				#if keyboard
				duration = 4; 
				#else
				duration = 6; 
				#end
			case SHOTGUN:
				clr = Colors.RED; 
				img = Image.SHOTGUN; 
				text = "Shotguns!";
				#if keyboard
				duration = 4; 
				#else
				duration = 6; 
				#end
				
			case HASTE:
				clr = Colors.PINK;
				img = Image.HASTE;
				text = "Speed!";
				#if keyboard
				duration = 4; 
				#else
				duration = 6; 
				#end
			case CONFUSION:
				clr = Colors.GRAY;
				img = Image.CONFUSION;
				text = "Confusion!";
				#if keyboard
				duration = 4; 
				#else
				duration = 6; 
				#end
			case INSTATOWER:
				text = "Tower!";
				clr = Colors.ORANGE;
				img = Image.INSTATOWER;
				duration = 0;
			}
		
		loadGraphic(Library.getFilename(img),true, 8, 8);
		addAnimation("not blink", [0, 0], 0);
		addAnimation("blink", [0, 1], 3);
		
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
	HASTE;
	CONFUSION;
	INSTATOWER;
}