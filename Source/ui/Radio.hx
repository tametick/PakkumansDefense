package ui;
import data.Library;
import org.flixel.FlxSprite;


class Radio extends Selectable {
	var group:List<Radio>;
	
	public function new(group:List<Radio>,x:Float, y:Float, cb:Dynamic, defaultvalue:Bool, ?width:Int = 16, ?height:Int = 16) {
		super(x, y, cb, defaultvalue, width, height);
		this.group = group;
	}
	
	override private function initGraphics(){
		var inactive = new FlxSprite(0,0,Library.getFilename(Image.RADIO));
		var active = new FlxSprite(0, 0, Library.getFilename(Image.RADIO_SELECTED));
		
		loadGraphic(inactive, active);
	}
	
	override public function setTicked(t:Bool, ?noSound:Bool = false) {
		super.setTicked(t, noSound);
		
		//...
	}
}