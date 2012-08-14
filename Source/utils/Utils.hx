package utils;

import data.Library;
import nme.media.Sound;
import org.flixel.FlxG;
import org.flixel.FlxPoint;

class Utils {
	public static function next<T>(a:Array<T>, i:T):T {
		for (index in 0...a.length) {
			if (a[index] == i) {
				if (index == a.length-1) {
					return a[0];
				} else {
					return a[index+1];
				}
			}
		}
		return null;
	}
	
	public static function play(snd:nme.media.Sound) {
		if(Library.sounds) {
			FlxG.play(snd);
		}
	}
	public static function playMusic(mus:nme.media.Sound) {
		var vol = 0.0;
		if(Library.music) {
			vol = 1;
		}
		
		FlxG.playMusic(mus,vol);
	}
	
	public static function dist(a:Float, b:Float) {
		return Math.abs(a - b);
	}
	
	public static function allExcept<T>(a:Array<T>, i:T):Array<T> {
		var aa = a.copy();
		aa.remove(i);
		return aa;
	}
	
	inline public static function get<T>(map:Array<T>, width:Int, x:Float, y:Float):T {
		return map[Std.int(y) * width + Std.int(x)];
	}
	inline public static function set<T>(map:Array<T>, width:Int, x:Float, y:Float, val:T) {
		map[Std.int(y) * width + Std.int(x)] = val;
	}
	
	public static inline function randomInt(max:Int):Int {
		return Std.random(max);
	}
	
	public static function randomIntInRange(min:Int, max:Int):Int {
		return Math.round(Math.random() * (max-min))+min;
	}
	
	public static function randomElement<T>(arr : Array<T>) : T	{
		return arr[Std.random(arr.length)];
	}
	
	public static function clampToRange(i:Float, min:Float, max:Float):Float {
		if (i < min)
			return min;
		if (i > max)
			return max;
		return i;
	}
	
	static var line:List<FlxPoint> = new List();
	public static function getLine(src:FlxPoint, dest:FlxPoint, isBlocking:FlxPoint->Bool):List<FlxPoint> {
		line.clear();
		var steepness = (dest.x - src.x) / (dest.y - src.y);
		var x = src.x;
		var y = src.y;
		var pos:FlxPoint;
		if (Math.abs(steepness) < 1) {
			
			if(dest.y>y){
				while (y < dest.y + 1) {
					pos = new FlxPoint(x, y);
					line.add(pos);
					if (isBlocking(pos))
						break;
					pos = null;
					x += steepness;
					y++;
				}
			} else {
				while (y > dest.y-1) {
					pos = new FlxPoint(x, y);
					line.add(pos);
					if (isBlocking(pos))
						break;
					pos = null;
					x -= steepness;
					y--;
				}
			}
		} else {
			steepness = 1 / steepness;
			if(dest.x>x){
				while (x < dest.x + 1) {
					pos = new FlxPoint(x, y);
					line.add(pos);
					if (isBlocking(pos))
						break;
					pos = null;
					y += steepness;
					x++;
				}
			} else {
				while (x > dest.x - 1) {
					pos = new FlxPoint(x, y);
					line.add(pos);
					if (isBlocking(pos))
						break;
					pos = null;
					y -= steepness;
					x--;
				}
			}
		}
		
		pos = null;
		isBlocking = null;
		
		return line;
	}

	public static function exists<T>(arr : Array<T>, ?value : T, ?f : T -> Bool) {
		if (null != f) {
			for (v in arr)
				if (f(v))
					return true;
		} else {
			for (v in arr)
				if (v == value)
					return true;
		}
		return false;
	}
	
	public static function convertMatrixToArray(mat:Array<Array<Int>>):Array<Int> {
		var arr = [];
		for (y in 0...mat.length)	{
			arr = arr.concat(mat[y]);
		}
		return arr;
	}
	
	public static inline function getPositionSnappedToGrid(p:Float):Int {
		return pixelToTile(p)*Library.tileSize;
	}

	public static inline function pixelToTile(p:Float):Int {
		return Std.int(p / Library.tileSize);
	}
	
	public static inline function convertPixelToTilePosition(pos:FlxPoint) {
		pos.x = pixelToTile(pos.x);
		pos.y = pixelToTile(pos.y);
	}
	
	public static function range(a:Int, b:Int):Array<Int> {
		var arr = [];
		for (n in a...b)
			arr.push(n);
		return arr;
	}
	
}