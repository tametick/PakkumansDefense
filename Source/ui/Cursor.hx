package ui;

import data.Library;
import org.flixel.FlxSprite;
import data.Image;

class Cursor extends FlxSprite {
	public function new() {
		super();
		loadGraphic(Library.getFilename(Image.CURSOR));
	}
}