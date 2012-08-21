package ui;

import data.AssetsLibrary;
import org.flixel.FlxSprite;
import data.Image;

class Cursor extends FlxSprite {
	public function new() {
		super();
		loadGraphic(AssetsLibrary.getFilename(Image.CURSOR));
	}
}