package world;
import data.Library;
import org.flixel.FlxTilemap;


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
	
}