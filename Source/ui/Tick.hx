package ui;
import data.Library;
import data.Image;
import org.flixel.FlxSprite;


class Tick extends Selectable  {
	override private function initGraphics(){
		var inactive = new FlxSprite(0,0,Library.getFilename(Image.TICK));
		var active = new FlxSprite(0, 0, Library.getFilename(Image.TICK_SELECTED));
		
		loadGraphic(inactive, active);
	}
}