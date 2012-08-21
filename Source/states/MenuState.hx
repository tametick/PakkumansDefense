package states;

import com.eclecticdesignstudio.motion.Actuate;
import org.flixel.FlxG;
import org.flixel.FlxSave;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import data.AssetsLibrary;
import org.flixel.plugin.photonstorm.FlxGridOverlay;
import utils.Colors;
import utils.Utils;
import data.Image;

class MenuState extends BasicState {
	var bg:FlxSprite;
	var text:FlxText;

	override public function create():Void {
		super.create();
		
		SettingsState.settings = new FlxSave();
		SettingsState.settings.bind("Settings");
		if (SettingsState.settings.data.music == null) {
			SettingsState.settings.data.music = true;
		}
		if (SettingsState.settings.data.sounds == null) {
			SettingsState.settings.data.sounds= true;
		}
		AssetsLibrary.music = SettingsState.settings.data.music;
		AssetsLibrary.sounds = SettingsState.settings.data.sounds;
		
		
		Utils.playMusic(AssetsLibrary.getMusic(MENU));
		
		#if keyboard
		FlxG.mouse.show();
		#end
		
		FlxG.fade(0, 0.5, true, null, true);
		
		bg = new FlxSprite(0, 0, AssetsLibrary.getFilename(Image.BG));
		add(bg);
		var t;
		#if keyboard
			t = "Click or press Space to Start";
		#else
			t = "Tap to Start";
		#end
		text = newText(0, FlxG.height / 2 + 20, FlxG.width, t,Colors.WHITE,"center");
		
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
		
		if ((FlxG.mouse.justPressed()||FlxG.keys.justReleased("SPACE")||(FlxG.keys.justReleased("ENTER"))) && active) {
			active = false;
			FlxG.fade(0, 0.5);
			Actuate.timer(0.5).onComplete(FlxG.switchState, [new LevelSelectState()]);
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