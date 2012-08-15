package ui;
import data.Library;
import utils.Utils;
import org.flixel.FlxSprite;
import org.flixel.plugin.photonstorm.FlxButtonPlus;

class Radio extends FlxButtonPlus{
	var cb:Dynamic;
	var ticked:Bool;
	
	public function new(x:Float, y:Float, cb:Dynamic, defaultvalue:Bool, ?width:Int = 16, ?height:Int = 16) {
		super(Std.int(x), Std.int(y), null, null, null, width, height);
		this.cb = cb;
		setOnClickCallback(click);
		
		var inactive = new FlxSprite(0,0,Library.getFilename(Image.RADIO));
		var active = new FlxSprite(0, 0, Library.getFilename(Image.RADIO_SELECTED));
		
		loadGraphic(inactive, active);
		
		setTicked(defaultvalue,true);
	}
	
	public function setTicked(t:Bool, ?noSound:Bool=false) {
		if (ticked=t) {
			_status = FlxButtonPlus.HIGHLIGHT;
			buttonNormal.visible = false;
			buttonHighlight.visible = true;
		} else {
			_status = FlxButtonPlus.NORMAL;
			buttonNormal.visible = true;
			buttonHighlight.visible = false;
		}
		
		if(!noSound) {
			Utils.play(Library.getSound(CLICK));
		}
	}
	
	function click() {
		setTicked(!ticked);
		if(cb!=null) {
			Reflect.callMethod(this, cb, []);
		}
	}
	
}