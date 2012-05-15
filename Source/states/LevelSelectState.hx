package states;
import com.eclecticdesignstudio.motion.Actuate;
import data.Library;
import org.flixel.FlxG;
import org.flixel.FlxSave;
import org.flixel.FlxText;
import org.flixel.plugin.photonstorm.FlxGridOverlay;
import utils.Colors;

class LevelSelectState extends BasicState {
	static var levelsW = 8;
	static var levelsH = 8;

	
	var levels:FlxSave;
	var title:FlxText;
	override public function create() {
		FlxG.fade(0, 0.5, true, null, true);
		
		add(FlxGridOverlay.create(Library.tileSize, Library.tileSize, -1, -1, false, true, Colors.DBLUE, Colors.DGREEN));
		
		levels = new FlxSave();
		levels.bind("Levels");
		
		if (levels.data.highest == null) {
			levels.data.highest  = 1;
		}
		
		title = newText(0, Library.tileSize, FlxG.width, "Select Level",Colors.BLUEGRAY,"center");
		title.setSize(16);
	}
	
	override public function update():Void {
		super.update();
		
		if (FlxG.mouse.justPressed() && active) {
			active = false;
			FlxG.fade(0, 0.5);
			
			// todo
			GameState.startingLevel = 1;
			
			Actuate.timer(0.5).onComplete(FlxG.switchState, [new GameState()]);
		}
	}
	
	override public function destroy() {
		super.destroy();
		
		levels.close();
	}	
}