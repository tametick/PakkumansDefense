package states;

import com.eclecticdesignstudio.motion.Actuate;
import data.Library;
import data.Score;
import org.flixel.FlxG;
import org.flixel.FlxSave;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.plugin.photonstorm.FlxGridOverlay;
import utils.Colors;

class HighScoreState extends BasicState {
	public static var mostRecentScore:Score;
	static var scoresToShow = 16;
	
	var scores:FlxSave;
	var title:FlxText;
	override public function create() {
		FlxG.fade(0, 0.5, true, null, true);
		
		add(new FlxSprite(0,0,Library.getFilename(Image.HIGHSCORE)));
		
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
		
		
		title = newText(0, Library.tileSize, FlxG.width, "High Scores",Colors.WHITE,"center");
		title.setSize(16);
		
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
				
			newText(0, y, FlxG.width, pos+".", color);
			newText(15, y, FlxG.width, "Level: " + s.level, color);
			newText(95, y, FlxG.width, "Money: " + s.money, color);
			newText(185, y, FlxG.width, "Kills: " + s.kills, color);
			
				
			y += Library.tileSize;
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
		
		if ((FlxG.mouse.justPressed()||(FlxG.keys.justReleased("SPACE"))) && active) {
			active = false;
			FlxG.fade(0, 0.5);
			Actuate.timer(0.5).onComplete(FlxG.switchState, [new MenuState()]);
		}
	}
	
	override public function destroy() {
		super.destroy();
		
		scores.close();
	}
}