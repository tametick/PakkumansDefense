package states;

import data.Score;
import org.flixel.FlxSave;
import org.flixel.FlxState;

class HighScoreState extends FlxState {
	public static var mostRecentScore:Score;
	
	var scores:FlxSave;
	override public function create() {
		super.create();
		
		scores = new FlxSave();
		scores.bind("HighScores");
		
		if (scores.data.scores == null) {
			scores.data.scores = new Array<Score>();
		}
		
		
		scores.data.scores.push(mostRecentScore);
		
	}
	
	// >0 if x<y, <0 if x<y
	function scoreCompare(x:Score, y:Score) :Int {
		if (x.level < y.level) {
			return 1;
		} else (x.level > y.level) {
			return -1;
		} else {
			if (x.money < y.money) {
				return 1;
			} else (x.money > y.money) {
				return -1;
			} else {
				if (x.kills < y.kills) {
					return 1;
				} else (x.kills > y.kills) {
					return -1;
				} else {
					if (x.towers < y.towers) {
						return 1;
					} else (x.towers > y.towers) {
						return -1;
					} else {
						return 0;
					}
				}
			}
		}
	}
	
	override public function destroy() {
		super.destroy();
		
		scores.close();
	}
}