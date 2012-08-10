package states;
import data.Library;
import org.flixel.FlxG;
import org.flixel.FlxSprite;

class SettingsState extends BasicState {
	override public function create() {
		FlxG.fade(0, 0.5, true, null, true);
		add(new FlxSprite(0,0,Library.getFilename(Image.LEVEL_SELECT)));
	}
	
	override public function update() {
		super.update();
		
		if (FlxG.mouse.justPressed()) {
			var s = BuskerJam.returnToState;
			BuskerJam.returnToState = null;
			FlxG.switchState(Type.createInstance(s, []));
		}
	}
}