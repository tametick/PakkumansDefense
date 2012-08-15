package ui;

import data.Library;
import utils.Utils;
import org.flixel.plugin.photonstorm.FlxButtonPlus;

class Selectable extends FlxButtonPlus {

	var cb:Dynamic; 
	public var ticked:Bool;
	
	public var owner(default, setOwner):Selectable;
	function setOwner(o:Selectable):Selectable {
		owner = o;
		return o;
	}
	
	public function new(x:Float, y:Float, cb:Dynamic, defaultvalue:Bool, ?width:Int = 16, ?height:Int = 16) {
		super(Std.int(x), Std.int(y), null, null, null, width, height);
		this.cb = cb;
		setOnClickCallback(click);
		
		initGraphics();
		
		setTicked(defaultvalue, true);
	}
		
	function initGraphics() {
		throw "this should be overridden";
	}
	
	public function setTicked(t:Bool, ?noSound:Bool = false) {
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
			
			// don't check the parent if setting silently (normally that's just init code)
			if (owner != null) {
				if (!owner.ticked) {
					owner.setTicked(true, true);
				}
			}
		}
	}
	
	function click() {
		setTicked(!ticked);
		if(cb!=null) {
			Reflect.callMethod(this, cb, [ticked]);
		}
	}
}