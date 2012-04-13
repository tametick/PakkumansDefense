package states;

import com.eclecticdesignstudio.motion.Actuate;
import org.flixel.FlxG;
import org.flixel.FlxState;
import org.flixel.FlxText;
import data.Library;

class MenuState extends FlxState {
	var text:FlxText;

	override public function create():Void {
		FlxG.bgColor = 0xff0080C0;
		FlxG.mouse.show();
		
		FlxG.fade(0, 0.5, true, null, true);
		
		text = new FlxText(0, FlxG.height / 2 - 10, FlxG.width, "Click to Start");
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