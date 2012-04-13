package world;

import flash.geom.Point;

class MazeGenerator {

	static inline var NORTH = "N";
	static inline var SOUTH = "S";
	static inline var EAST = "E";
	static inline var WEST = "W";
	
	var moves : Array<Int>;
	public var height : Int;
	public var width : Int;
	public var start : Point;
	public var maze : Array<Array<Bool>>;
	public function new(width : Int, height : Int) {
		this.height = height;
		this.width = width;
		start = new Point(1, 1);
	}

	public function initMaze() : Void {
		maze = [];
		var x : Int = 0;
		while(x < width) {
			maze[x] = [];
			var y : Int = 0;
			while(y < height) {
				maze[x][y] = true;
				y++;
			}
			x++;
		}
		maze[Std.int(start.x)][Std.int(start.y)] = false;
	}

	public function createMaze() : Void {
		var back : Int;
		var move : Int;
		var possibleDirections : String;
		var posX = Std.int(start.x);
		var posY = Std.int(start.y);
		
		moves = new Array<Int>();
		moves.push(posY + (posX * height));
		while(moves.length>0) {
			possibleDirections = "";
			if((posX + 2 < width) && (maze[posX + 2][posY] == true) && (posX + 2 != 0) && (posX + 2 != width - 1))  {
				possibleDirections += SOUTH;
			}
			if((posX - 2 >= 0) && (maze[posX - 2][posY] == true) && (posX - 2 != 0) && (posX - 2 != width - 1))  {
				possibleDirections += NORTH;
			}
			if((posY - 2 >= 0) && (maze[posX][posY - 2] == true) && (posY - 2 != 0) && (posY - 2 != height - 1))  {
				possibleDirections += WEST;
			}
			if((posY + 2 < height) && (maze[posX][posY + 2] == true) && (posY + 2 != 0) && (posY + 2 != height - 1))  {
				possibleDirections += EAST;
			}
			if(possibleDirections.length > 0)  {
				move = randInt(0, (possibleDirections.length - 1));
				var _sw0_ = (possibleDirections.charAt(move));
				switch(_sw0_) {
				case NORTH:
					maze[posX - 2][posY] = false;
					maze[posX - 1][posY] = false;
					posX -= 2;
				case SOUTH:
					maze[posX + 2][posY] = false;
					maze[posX + 1][posY] = false;
					posX += 2;
				case WEST:
					maze[posX][posY - 2] = false;
					maze[posX][posY - 1] = false;
					posY -= 2;
				case EAST:
					maze[posX][posY + 2] = false;
					maze[posX][posY + 1] = false;
					posY += 2;
				}
				moves.push(posY + (posX * height));
			}

			else  {
				back = moves.pop();
				posX = Std.int(back / height);
				posY = back % height;
			}

		}

	}

	function randInt(min : Int, max : Int) : Int {
		return Std.int((Math.random() * (max - min + 1)) + min);
	}

}

