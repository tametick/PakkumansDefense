package ui;

import data.Library;
import org.flixel.FlxSprite;


class Cursor extends FlxSprite {
	public function new() {
		super();
		loadGraphic(Library.getFilename(CURSOR));
	}
}