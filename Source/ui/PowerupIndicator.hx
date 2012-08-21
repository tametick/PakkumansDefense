package ui;
import data.Library;
import data.Image;
import nme.display.BitmapData;
import org.flixel.FlxSprite;
import utils.Colors;

class PowerupIndicator extends FlxSprite
{
	public function new(img:Image) 
	{	super();
		loadGraphic(Library.getFilename(img), true, true, 8, 8);
		addAnimation("not blink", [0, 0], 0);
		addAnimation("blink", [0, 1], 3);
		var clr;
		switch(img) {
			case Image.FREEZE: 
				clr = Colors.LBLUE; 
			case Image.CASH: 
				clr = Colors.LGREEN; 
			case Image.SHOTGUN:
				clr = Colors.RED; 				
			case Image.HASTE:
				clr = Colors.PINK;
			case Image.CONFUSION:
				clr = Colors.GRAY;
			default:
				clr = Colors.ORANGE;
			}
		setColor(clr);
	}
	
}