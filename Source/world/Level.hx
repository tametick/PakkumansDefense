package world;
import data.Library;
import org.flixel.FlxG;
import org.flixel.FlxPoint;
import org.flixel.FlxTilemap;
import utils.Utils;


class Level extends FlxTilemap{
	public function new() {
		super();
		
		var mazeGenerator = new MazeGenerator(Library.levelW, Library.levelH);
		mazeGenerator.initMaze();
		mazeGenerator.createMaze();
		
		var tilesIndex = [];
		for (y in 0...Library.levelH) {
			for (x in 0...Library.levelW) {
				tilesIndex.push(mazeGenerator.maze[x][y]?1:0);
			}
		}
		
		loadMap(FlxTilemap.arrayToCSV(tilesIndex, Library.levelW), FlxTilemap.imgAuto, 8, 8, FlxTilemap.AUTO);
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
	
	public function countEmpty():Int {
		var map = getData();
		var empty = 0;
		
		for (tile in map) {
			if (tile == 0)
				empty++;
		}
		
		return empty;
	}
}