package world;
import data.Library;
import org.flixel.FlxG;
import org.flixel.FlxPoint;
import org.flixel.FlxTilemap;
import utils.Utils;


class Level extends FlxTilemap{
	public function new() {
		super();
		
		var w = Library.levelW;
		var h = Library.levelH;
		
		var mazeGenerator = new MazeGenerator(w, h);
		mazeGenerator.initMaze();
		mazeGenerator.createMaze();
		
		// generate basic maze
		var tilesIndex = [];
		for (y in 0...h) {
			for (x in 0...w) {
				var tile = mazeGenerator.maze[x][y]?1:0;
				tilesIndex.push(tile);
			}
		}
		
		// generate some empty lines
		var y = Utils.randomIntInRange(2, Std.int(h / 3));
		clearHorizontalLine(tilesIndex, y);
		clearHorizontalLine(tilesIndex, h - y - 1);

		var x = Utils.randomIntInRange(2, Std.int(w / 3));
		clearVerticalLine(tilesIndex, x);
		clearVerticalLine(tilesIndex, w - x - 1);
		
		loadMap(FlxTilemap.arrayToCSV(tilesIndex, w), FlxTilemap.imgAuto, 8, 8, FlxTilemap.AUTO);
	}
	
	function clearHorizontalLine(tilesIndex:Array<Int>, y:Int) {
		for (x in 0...Library.levelW) {
			Utils.set(tilesIndex, Library.levelW, x, y, 0);
		}
	}
	
	function clearVerticalLine(tilesIndex:Array<Int>, x:Int) {
		for (y in 0...Library.levelH) {
			Utils.set(tilesIndex, Library.levelW, x, y, 0);
		}
	}
	
	public function getFreeTile():FlxPoint {
		var x = 0;
		var y = 0;
		var map = getData();
		
		do {
			x = Utils.randomInt(Library.levelW);
			y = Utils.randomInt(Library.levelH);			
		} while (Utils.get(map, Library.levelW, x, y) != 0);
		
		return new FlxPoint(x, y);
	}
}