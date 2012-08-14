package states;
import data.Library;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxText;
import ui.Tick;
import utils.Colors;

class SettingsState extends BasicState {
	var title:FlxText;
	var buttons:FlxGroup;
	var labels:FlxGroup;
	
	override public function create() {
		super.create();
		
		#if keyboard
		FlxG.mouse.show();
		#end
		
		FlxG.fade(0, 0.5, true, null, true);
		add(new FlxSprite(0, 0, Library.getFilename(Image.LEVEL_SELECT)));
		
		var y:Float = Library.tileSize;
		
		title = newText(0, y, FlxG.width, "Settings",Colors.WHITE,"center");
		title.setSize(16);
		
		labels = new FlxGroup();
		buttons = new FlxGroup();
		
		
		var x = 100;
		var music = newText(x, y += title.height + Library.tileSize, FlxG.width, "Music", Colors.WHITE);
		music.setSize(16);
		labels.add(music);
		var musicTick = new Tick(x - 24, y, null);
		buttons.add(musicTick);
		
		var sounds = newText(x, y += music.height, FlxG.width, "Sounds", Colors.WHITE);
		sounds.setSize(16);
		labels.add(sounds);
		var soundTick = new Tick(x - 24, y, null);
		buttons.add(soundTick);
		
		add(labels);
		add(buttons);
	}
	
	override public function destroy() {
		remove(labels);
		remove(buttons);
		
		labels.destroy();
		labels = null;
		buttons.destroy();
		buttons = null;
		
		super.destroy();
		
	}
}