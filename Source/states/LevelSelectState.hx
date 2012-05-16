package states;

import com.eclecticdesignstudio.motion.Actuate;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxSave;
import org.flixel.FlxSprite;
import org.flixel.FlxText;
import org.flixel.plugin.photonstorm.FlxButtonPlus;
import org.flixel.plugin.photonstorm.FlxGridOverlay;
import data.Library;
import utils.Colors;

class LevelSelectState extends BasicState {
	static var levelsW = 8;
	static var levelsH = 5;

	var levels:FlxSave;
	var title:FlxText;
	var buttons:FlxGroup;
	
	override public function create() {
		FlxG.fade(0, 0.5, true, null, true);
		
		add(new FlxSprite(0,0,Library.getFilename(Image.LEVEL_SELECT)));
		GameState.startingLevel = 1;
		
		levels = new FlxSave();
		levels.bind("Levels");
		
		if (levels.data.highest == null) {
			levels.data.highest  = 1;
		}
		
		title = newText(0, Library.tileSize, FlxG.width, "Select Level",Colors.WHITE,"center");
		title.setSize(16);
		
		
		var shiftX = Std.int((FlxG.width - levelsW*24) / 2);
		var shiftY = 32;
		
		buttons = new FlxGroup(levelsH * levelsW);
		var inactive = new FlxSprite(0,0,Library.getFilename(Image.BUTTON));
		var active = new FlxSprite(0, 0, Library.getFilename(Image.BUTTON_ACTIVE));
		add(buttons);
		
		for (y in 0...levelsH) {
			for (x in 0...levelsW) {
				var l = y * levelsW + x + 1;
				if (l > levels.data.highest) {
					return;
				}
				
				var b = new FlxButtonPlus(shiftX + 24 * x, shiftY + 24 * y, click, [x, y], "" + l, 16, 16);
				b.loadGraphic(inactive, active);
				buttons.add(b);
			}
		}
	}
	
	function click(x:Int, y:Int) {
		if (active) {
			active = false;
			FlxG.fade(0, 0.5);
			GameState.startingLevel = 1+y*levelsW+x;
			
			Actuate.timer(0.5).onComplete(FlxG.switchState, [new GameState()]);
		}
	}
	
	override public function update():Void {
		super.update();
	}
	
	override public function destroy() {
		super.destroy();
		
		levels.close();
	}	
}