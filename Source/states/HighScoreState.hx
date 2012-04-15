package states;

import com.eclecticdesignstudio.motion.Actuate;
import data.Library;
import data.Score;
import org.flixel.FlxG;
import org.flixel.FlxSave;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.plugin.photonstorm.FlxGridOverlay;
import utils.Colors;

class HighScoreState extends FlxState {
	public static var mostRecentScore:Score;
	static var scoresToShow = 15;
	
	var scores:FlxSave;
	var title:FlxText;
	override public function create() {
		FlxG.fade(0, 0.5, true, null, true);
		
		add(FlxGridOverlay.create(Library.tileSize, Library.tileSize, -1, -1, false, true, Colors.DBLUE, Colors.DGREEN));
		
		scores = new FlxSave();
		scores.bind("HighScores");
		
		if (scores.data.scores == null) {
			scores.data.scores = new Array<Score>();
		}
		var sc:Array<Score> = scores.data.scores;
		if(mostRecentScore!=null) {
			sc.push(mostRecentScore);
		}
		//sc.sort(scoreCompare);
		
		if (sc.length > scoresToShow) {
			sc.splice(scoresToShow, sc.length-scoresToShow);
		}
		
		
		title = new FlxText(0, Library.tileSize, FlxG.width, "High Scores");
		title.setSize(16);
		title.setColor(Colors.BLUEGRAY);
		title.setFont(Library.getFont().fontName);
		title.setAlignment("center");
		add(title);
		
		print(sc);
	}
	
	function print(scores:Array<Dynamic>) {
		var y = title.y + title.height;
		var t:FlxText;
		var pos = 0;
		for (s in scores) {
			pos++;
			var color = Colors.BLUEGRAY;
			if (s == mostRecentScore)
				color = Colors.YELLOW;
				
			t = new FlxText(0, y, FlxG.width, pos+". "+scoreToString(s));
			t.setColor(color);
			t.setSize(8);
			t.setFont(Library.getFont().fontName);
			add(t);
				
			y += Library.tileSize;
		}
		
	}
	
	function scoreToString(s:Dynamic):String {
		var str = "Level: " + s.level;
		str = StringTools.rpad(str, " ", 30);
		
		str += "Money: " + s.money;
		str = StringTools.rpad(str, " ", 60);
		
		str +=  "Kills: " + s.kills;
		str = StringTools.rpad(str, " ", 90);
		
		return str;
	}
	
	// >0 if x<y, <0 if x<y
	function scoreCompare(x:Dynamic, y:Dynamic) :Int {
		if (x.level < y.level) {
			return 1;
		} else if (x.level > y.level) {
			return -1;
		} else {
			if (x.money < y.money) {
				return 1;
			} else if (x.money > y.money) {
				return -1;
			} else {
				if (x.kills < y.kills) {
					return 1;
				} else if (x.kills > y.kills) {
					return -1;
				} else {
					if (x.towers < y.towers) {
						return 1;
					} else if (x.towers > y.towers) {
						return -1;
					} else {
						return 0;
					}
				}
			}
		}
	}
	
	override public function update():Void {
		super.update();
		
		if (FlxG.mouse.justPressed() && active) {
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