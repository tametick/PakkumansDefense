package states;

import com.eclecticdesignstudio.motion.Actuate;
import data.AssetsLibrary;
import data.Score;
import org.flixel.FlxG;
import org.flixel.FlxSave;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxTextField;
import org.flixel.plugin.photonstorm.FlxGridOverlay;
import utils.Colors;
import data.Image;

class HighScoreState extends BasicState {
	public static var mostRecentScore:Score;
	static var scoresToShow = 16;
	
	var scores:FlxSave;
	var title:FlxTextField;
	override public function create() {
		super.create();
		
		FlxG.fade(0, 0.5, true, null, true);
		
		add(new FlxSprite(0,0,AssetsLibrary.getFilename(Image.HIGHSCORE)));
		
		scores = new FlxSave();
		scores.bind("HighScores");
		
		if (scores.data.scores == null) {
			scores.data.scores = new Array<Score>();
		}
		var sc:Array<Score> = scores.data.scores;
		if(mostRecentScore!=null) {
			sc.push(mostRecentScore);
		}
		sc.sort(scoreCompare);
		
		if (sc.length > scoresToShow) {
			sc.splice(scoresToShow, sc.length-scoresToShow);
		}
		
		
		title = utils.Utils.newText(0, AssetsLibrary.tileSize, "High Scores",Colors.WHITE,"center");
		title.setSize(16);
		#if !flash
		// bug, in other targets it doesn't calculate height properly
		title.height = 19.95;
		#end
		
		print(sc);
	}
	
	function print(scores:Array<Dynamic>) {		
		var y = title.y + title.height;
		
		var pos = 0;
		for (s in scores) {
			pos++;
			var color = Colors.WHITE;
			if (s == mostRecentScore)
				color = Colors.YELLOW;
				
			utils.Utils.newText(0, y, pos+".", color);
			utils.Utils.newText(15, y, "Level: " + s.level, color);
			utils.Utils.newText(95, y,  "Money: " + s.money, color);
			utils.Utils.newText(185, y, "Kills: " + s.kills, color);
			
				
			y += AssetsLibrary.tileSize;
		}
		
	}
	
	// >0 if x<y, <0 if x<y
	function scoreCompare(x:Dynamic, y:Dynamic) :Int {
		if (x.level != y.level) return x.level<y.level?1:-1;
		if (x.money != y.money) return x.money<y.money?1:-1;
		if (x.kills != y.kills) return x.kills<y.kills?1:-1;
		if (x.towers != y.towers) return x.towers<y.towers?1:-1;
		return 0;
	}
	
	override public function update():Void {		
		super.update();
		
		if ((BuskerJam.backButton||FlxG.mouse.justPressed()||(FlxG.keys.justReleased("SPACE")||(FlxG.keys.justReleased("ENTER")))) && active) {
			active = false;
			BuskerJam.backButton = false;
			FlxG.fade(0, 0.5);
			Actuate.timer(0.5).onComplete(FlxG.switchState, [new MenuState()]);
		}
	}
	
	override public function destroy() {
		super.destroy();
		
		scores.close();
	}
}