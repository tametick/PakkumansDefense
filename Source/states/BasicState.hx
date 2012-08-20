package states;

import data.Library;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.Lib;
import org.flixel.FlxG;
import org.flixel.FlxPoint;
import org.flixel.FlxState;
import org.flixel.FlxText;

class BasicState extends FlxState {
	static var settings:Bitmap;
	static var settingsBmp:BitmapData;
	static var okBmp:BitmapData;
	static var mouseIndex:Int;
	
	override public function create() {
		super.create();
		
		if(settings==null) {
			settings = new Bitmap(settingsBmp = Library.getImage(Image.SETTINGS));
			settings.width *= 2;
			settings.height *= 2;
			settings.y = 320 - settings.height - 4;
			settings.x = 480 - settings.width - 4;
			mouseIndex = FlxG._game.getChildIndex(FlxG._game._mouse);
			okBmp = Library.getImage(Image.SETTINGS_OK);
		}
		
		if(! (Std.is(this,GameState) || Std.is(this,HighScoreState)) ) {
			FlxG._game.addChildAt(settings, mouseIndex);
		}
	}
	
	var mousePoint:FlxPoint;
	override public function update() {
		super.update();
		
		
		if ( Std.is(this, GameState) || Std.is(this, HighScoreState) ) {
			return;
		} else if (Std.is(this, SettingsState)) {
			settings.bitmapData = okBmp;
		} else {
			settings.bitmapData = settingsBmp;
		}
		
		mousePoint = FlxG.mouse.getScreenPosition(null, mousePoint);
		if (FlxG.mouse.justPressed()) {
			var x = mousePoint.x * FlxG.camera.getScale().x; 
			var y = mousePoint.y * FlxG.camera.getScale().y;
			if (x > settings.x && x < settings.x + settings.width && y > settings.y && y < settings.y + settings.height) {
				FlxG.mouse.reset();
				if (Std.is(this, SettingsState)) {
					var s = BuskerJam.returnToState;
					if (s == null) {
						s = MenuState;
					}
					BuskerJam.returnToState = null;
					FlxG.switchState(Type.createInstance(s, []));
				} else {
					BuskerJam.returnToState = Type.getClass(this);
					FlxG.switchState(new SettingsState());
				}
			}	
		}
	}
	
	function newText(x:Float, y:Float, w:Int, text:String, color:Int, ?alignment:String=null) {
		var text = new FlxText(x,y,w,text);
		text.setColor(color);
		text.setFont(Library.getFont().fontName);
		if(alignment!=null)
		text.setAlignment(alignment);
		add(text);
		
		return text;
	}	
}