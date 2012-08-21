package ui;
import data.AssetsLibrary;
import data.Image;
import org.flixel.FlxSprite;


class Tick extends Selectable  {
	override private function initGraphics(){
		var inactive = new FlxSprite(0,0,AssetsLibrary.getFilename(Image.TICK));
		var active = new FlxSprite(0, 0, AssetsLibrary.getFilename(Image.TICK_SELECTED));
		
		loadGraphic(inactive, active);
	}
}