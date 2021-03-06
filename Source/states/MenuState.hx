package states;

import com.eclecticdesignstudio.motion.Actuate;
import nme.Lib;
import org.flixel.FlxG;
import org.flixel.FlxSave;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxTextField;
import data.AssetsLibrary;
import org.flixel.plugin.photonstorm.FlxGridOverlay;
import utils.Colors;
import utils.Utils;
import data.Image;

class MenuState extends BasicState {
	var bg:FlxSprite;
	var text:FlxTextField;

	override public function create():Void {
		super.create();
		
		Utils.playMusic(AssetsLibrary.getMusic(MENU));		
		FlxG.fade(0, 0.5, true, null, true);
		
		bg = new FlxSprite(0, 0, AssetsLibrary.getFilename(Image.BG));
		add(bg);
		var t;
		#if keyboard
			t = "Click or press Space to Start";
		#else
			t = "Tap to Start";
		#end
		text = Utils.newText(0, FlxG.height / 2 + 20, t, Colors.WHITE, FlxG.width, "center");
		
		toggleText();
	}	
	
	override function init() {
		super.init();
		
		#if flash
		FlxG.mouse.show();
		var mouseIndex = FlxG._game.getChildIndex(FlxG._game._mouse);
		FlxG._game.addChildAt(BuskerJam.androidBuySprite, mouseIndex);
		FlxG._game.addChildAt(BuskerJam.amazonBuySprite, mouseIndex);
		FlxG._game.addChildAt(BuskerJam.blackberryBuySprite, mouseIndex);
		FlxG._game.addChildAt(BuskerJam.iosBuySprite, mouseIndex);
		#end
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
		#if flash
		FlxG._game.removeChild(BuskerJam.androidBuySprite);
		FlxG._game.removeChild(BuskerJam.amazonBuySprite);
		FlxG._game.removeChild(BuskerJam.blackberryBuySprite);
		FlxG._game.removeChild(BuskerJam.iosBuySprite);
		#end
		
		bg.destroy();
		bg = null;
		text.destroy();
		text = null;
		
		super.destroy();
	}
}