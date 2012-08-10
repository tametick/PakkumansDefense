package states;

import data.Library;
import nme.display.Bitmap;
import nme.Lib;
import org.flixel.FlxG;
import org.flixel.FlxPoint;
import org.flixel.FlxState;
import org.flixel.FlxText;

class BasicState extends FlxState {
	static var settings:Bitmap;
	static var mouseIndex:Int;
	
	override public function create() {
		super.create();
		
		if(settings==null) {
			settings = new Bitmap(Library.getImage(Image.SETTINGS));
			settings.width *= 2;
			settings.height *= 2;
			settings.y = 320 - settings.height - 4;
			settings.x = 480 - settings.width - 4;
			mouseIndex = FlxG._game.getChildIndex(FlxG._game._mouse);
		}
		
		if(!Std.is(this,GameState)) {
			FlxG._game.addChildAt(settings, mouseIndex);
		}
	}
	
	var mousePoint:FlxPoint;
	override public function update() {
		super.update();
		
		mousePoint = FlxG.mouse.getScreenPosition(null, mousePoint);
		if (FlxG.mouse.justPressed()) {
			var x = mousePoint.x * FlxG.camera.getScale().x; 
			var y = mousePoint.y * FlxG.camera.getScale().y;
			if (x > settings.x && x < settings.x + settings.width && y > settings.y && y < settings.y + settings.height) {
				FlxG.mouse.reset();
				trace(1);
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