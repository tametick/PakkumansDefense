package states;

import com.eclecticdesignstudio.motion.Actuate;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import data.Library;
import org.flixel.plugin.photonstorm.FlxGridOverlay;
import utils.Colors;

class MenuState extends BasicState {
	var bg:FlxSprite;
	var text:FlxText;

	override public function create():Void {
		if(FlxG.music==null)
			FlxG.playMusic(Library.getMusic(THEME));
		
		
		FlxG.mouse.show();
		
		FlxG.fade(0, 0.5, true, null, true);
		
		bg = new FlxSprite(0, 0, Library.getFilename(Image.BG));
		add(bg);
		
		text = newText(0, FlxG.height / 2 + 20, FlxG.width, "Click to Start",Colors.WHITE,"center");
		
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
		
		bg.destroy();
		bg = null;
		text.destroy();
		text = null;
	}
}