package states;

import com.eclecticdesignstudio.motion.Actuate;
import data.Score;
import org.flixel.FlxG;
import org.flixel.FlxSave;
import org.flixel.FlxState;

class HighScoreState extends FlxState {
	public static var mostRecentScore:Score;
	static var scoresToShow = 10;
	
	var scores:FlxSave;
	override public function create() {
		super.create();
		
		scores = new FlxSave();
		scores.bind("HighScores");
		
		if (scores.data.scores == null) {
			scores.data.scores = new Array<Score>();
		}
		var sc:Array<Score> = scores.data.scores;
		
		sc.push(mostRecentScore);
		sc.sort(scoreCompare);
		
		if (sc.length > scoresToShow) {
			sc.splice(scoresToShow, sc.length-scoresToShow);
		}
		
		trace(sc);
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