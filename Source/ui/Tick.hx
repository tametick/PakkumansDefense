package ui;
import data.Library;
import org.flixel.FlxSprite;
import org.flixel.plugin.photonstorm.FlxButtonPlus;

class Tick extends FlxButtonPlus {
	var cb:Dynamic;
	var ticked:Bool;
	
	public function new(x:Float, y:Float, cb:Dynamic, ?width:Int = 16, ?height:Int = 16) {
		super(Std.int(x), Std.int(y), null, null, null, width, height);
		this.cb = cb;
		setOnClickCallback(click);
		
		var inactive = new FlxSprite(0,0,Library.getFilename(Image.TICK));
		var active = new FlxSprite(0, 0, Library.getFilename(Image.TICK_SELECTED));
		
		loadGraphic(inactive, active);
		
		setTicked(true);
	}
	
	public function setTicked(t:Bool) {
		if (ticked=t) {
			_status = FlxButtonPlus.HIGHLIGHT;
			buttonNormal.visible = false;
			buttonHighlight.visible = true;
		} else {
			_status = FlxButtonPlus.NORMAL;
			buttonNormal.visible = true;
			buttonHighlight.visible = false;
		}
	}
	
	function click() {
		setTicked(!ticked);
		if(cb!=null) {
			Reflect.callMethod(this, cb, []);
		}
	}
}