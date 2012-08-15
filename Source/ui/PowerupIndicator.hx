package ui;
import data.Library;
import nme.display.BitmapData;
import org.flixel.FlxSprite;

class PowerupIndicator extends FlxSprite
{
	public function new(img:Image) 
	{	super();
		loadGraphic(Library.getFilename(img), true, true, 8, 8);
		addAnimation("not blink", [0, 0], 0);
		addAnimation("blink",[0, 1],3);
	}
	
}