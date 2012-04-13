package states;

import com.eclecticdesignstudio.motion.Actuate;
import org.flixel.FlxG;
import org.flixel.FlxState;
import org.flixel.FlxText;
import data.Library;
import org.flixel.plugin.photonstorm.FlxGridOverlay;
import utils.Colors;

class MenuState extends FlxState {
	var title:FlxText;
	var text:FlxText;

	override public function create():Void {
		FlxG.mouse.show();
		
		FlxG.fade(0, 0.5, true, null, true);
		
		add(FlxGridOverlay.create(Library.tileSize, Library.tileSize, -1, -1, false, true, Colors.BLACK, Colors.BROWN));

		title = new FlxText(0, FlxG.height / 4, FlxG.width, "Pakkuman's Defense");
		title.setSize(16);
		title.setColor(Colors.ORANGE);
		title.setFont(Library.getFont().fontName);
		title.setAlignment("center");
		add(title);

		
		text = new FlxText(0, FlxG.height / 2, FlxG.width, "Click to Start");
		text.setColor(Colors.ORANGE);
		text.setFont(Library.getFont().fontName);
		text.setAlignment("center");
		add(text);
		
		toggleText();
	}
	
	function toggleText() {
		if (members == null)
			return;
		
		if (text.alpha == 0)
			text.alpha = 1;
		else
			text.alpha = 0;

		Actuate.timer(0.5).onComplete(toggleText);
	}
	
	override public function update():Void {
		super.update();
		
		if (FlxG.mouse.justPressed() && active) {
			active = false;
			FlxG.fade(0, 0.5);
			Actuate.timer(0.5).onComplete(FlxG.switchState, [new GameState()]);
		}
	}
	
	override public function destroy():Void {
		super.destroy();
		
		text.destroy();
		text = null;
	}
}