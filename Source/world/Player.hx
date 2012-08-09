package world;

import air.update.events.StatusFileUpdateErrorEvent;
import com.eclecticdesignstudio.motion.Actuate;
import data.Library;
import org.flixel.FlxG;
import org.flixel.FlxObject;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import states.GameState;
import world.Splosion;
import utils.Colors;
import utils.Utils;
import nme.display.BitmapData;


class Player extends WarpSprite {
	public var coins:Int;
	public var kills:Int;
	public var arrow:FlxSprite;
	public var time:Float;
	
	static var clickMap:BitmapData;
	
	private var thinking:Bool;
	private var delay:Int;
	
	public var tileX:Int;
	public var tileY:Int;
	
	var isMoving:Bool;
	var facingNext:Int;
	var bloodSplosion:Splosion;
	
	override public function destroy() {
		super.destroy();
		if(arrow!=null)
			arrow.destroy();
		arrow = null;
		
		if(bloodSplosion!=null)
			bloodSplosion.destroy();
		bloodSplosion = null;
	}

	public function new(level:Level, start:FlxPoint) {
		super(level);
		
		loadGraphic(Library.getFilename(Image.PAKKU), true, true, 5, 5);
		addAnimation("walk", [0, 1], 5);
		play("walk");
		setColor(Colors.YELLOW);
		
		arrow = new FlxSprite();
		arrow.loadGraphic(Library.getFilename(Image.ARROW), true, false, 16, 16);
		arrow.addAnimation("N", [0]);
		arrow.addAnimation("S", [1]);
		arrow.addAnimation("W", [2]);
		arrow.addAnimation("E", [3]);
		arrow.setColor(Colors.YELLOW);
		
		setPosition(start);
		start = null;
		bloodSplosion = new Splosion(Colors.YELLOW);
		
		coins = 20;
		
		if(clickMap==null) {
			clickMap = Library.getImage(Image.CLICK_MAP);
		}
	}
	
	public function explode() {
		visible = false;
		bloodSplosion.explode(x,y);
	}
	
	override public function draw() {
		super.draw();
		arrow.x = x - 5;
		arrow.y = y - 5;
	}
	

	
	function getCommand():Command {
		var color = clickMap.getPixel(FlxG.mouse.screenX, FlxG.mouse.screenY);
		
		switch (color) {
			case 0xff00ff:
				return UP;
			case 0x0000ff:
				return RIGHT;
			case 0x00ffff:
				return DOWN;
			case 0xff0000:
				return LEFT;
			case 0xffffff:
				return TOWER;
			default:
				if ( FlxG.mouse.screenX < 0) return LEFT;
				if ( FlxG.mouse.screenY < 0) return UP;
				if ( FlxG.mouse.screenX > 160) return RIGHT;
				return DOWN;			
		}
		
	}
	
	
	override public function update() {
		super.update();
		if (cast(FlxG.state, GameState).help < 3)
			return;
		
		time -= FlxG.elapsed;
		if (time <= 0) {
			cast(FlxG.state, GameState).gameOver(null, null);
		}
		if (thinking) {
			if (delay >= 3) {
				spawnTower();
				delay = 0;
			} else {
				delay ++;
			}
		}
		
		var touch:Command = null;
		var s = cast(FlxG.state, GameState);
		if(FlxG.mouse.justPressed()) {
			 touch = getCommand();
			 s.setHighlighted(touch);
		} else if (FlxG.mouse.justReleased()) {
			s.setUnhighlighted(getCommand());
		}
		
		// change facing according to keyboard input
		if (FlxG.keys.A || FlxG.keys.LEFT || touch==LEFT) {
			facingNext = FlxObject.LEFT;
			arrow.play("W");
		} if (FlxG.keys.D || FlxG.keys.RIGHT || touch==RIGHT) {
			facingNext = FlxObject.RIGHT;
			arrow.play("E");
		} if (FlxG.keys.S || FlxG.keys.DOWN || touch==DOWN) {
			facingNext = FlxObject.DOWN;
			arrow.play("S");
		} if (FlxG.keys.W || FlxG.keys.UP || touch==UP) {
			facingNext = FlxObject.UP;
			arrow.play("N");
		} if (FlxG.keys.SPACE ||touch == TOWER) {
			if (level.player.coins >= Library.towerCost || Library.debug) {
				spawnTower();
			} else {
				FlxG.play(Library.getSound(Sound.ERROR));
			}
		}
		
		if (!isMoving) {
			var oldFacing = facing;
			facing = facingNext;
			
			var hasMoved = move();
			if (!hasMoved) {
				facing = oldFacing;
				move();
			}
		}
		
		tileX = Utils.pixelToTile(x);
		tileY = Utils.pixelToTile(y);
	}
	private function spawnTower() {
		thinking = false;
		
		for ( ii in tileY - 1... tileY + 2) {
			for ( jj in tileX - 1... tileX + 2) {
				var i = ii;
				var j = jj;
				
				if (j < 0) {
					j = Library.levelW - 1;
				} else if (j >= Library.levelW ) {
					j = 0;
				}
				
				if (i < 0) {
					i = Library.levelH - 1;
				} else if (i >= Library.levelH) {
					i = 0;
				}
				
				var fakeMouse:FlxPoint = new FlxPoint(j * Library.tileSize, i * Library.tileSize);
				var towerThere:Bool = false;
				
				for (k in level.towers.members) {
					var t = cast(k, Tower);
					if (Utils.pixelToTile(t.x) == j && Utils.pixelToTile(t.y) == i) {
						towerThere = true;
						break;
						}
					}
				
				if (!(j == tileX && i== tileY)) {
					if (!level.isFree(j, i) && !towerThere) {
						FlxG.play(Library.getSound(Sound.CASH_REGISTER));
						level.player.coins -= Library.towerCost;				
						cast(FlxG.state, GameState).coinCounter.text="$: " + level.player.coins;
						level.buildTower(fakeMouse);
						cast(FlxG.state, GameState).towerCounter.text = "Towers: " + level.towers.length;
						arrow.setColor(Colors.YELLOW);
						return;
					}
				}
			}
		}
		
		thinking = true;
		arrow.setColor(Colors.RED);
	}
		
	private function move():Bool {
		var tileX = Utils.pixelToTile(x);
		var tileY = Utils.pixelToTile(y);
		// move forward
		if(facing== FlxObject.LEFT && level.isFree(tileX-1,tileY)) {
			startMoving(-1,0);
		} else if(facing== FlxObject.RIGHT && level.isFree(tileX+1,tileY)) {
			startMoving(1,0);
		} else if(facing== FlxObject.DOWN && level.isFree(tileX,tileY+1)) {
			startMoving(0,1);
		} else if(facing== FlxObject.UP && level.isFree(tileX,tileY-1)) {
			startMoving(0,-1);
		} else {
			return false;
		}
		
		return true;
	}
	
	
	function startMoving(dx:Int, dy:Int) {
		isMoving = true;
		var duration = 0.2;
		
		var rawX = this.x + dx * Library.tileSize;
		var rawY = this.y + dy * Library.tileSize;
		
		var xShift = (Library.tileSize-width) / 2;
		var yShift = (Library.tileSize-height) / 2;
		var nextPixelX = rawX<0?rawX:Utils.getPositionSnappedToGrid(rawX) + xShift;
		var nextPixelY = rawY<0?rawY:Utils.getPositionSnappedToGrid(rawY) + yShift;
		
		// move
		Actuate.tween(this, duration, {x: nextPixelX, y: nextPixelY}).onComplete(stopped);
	}
	
	public function stopped() {
		isMoving = false;
		
		
	}
}

enum Command {
	UP;
	DOWN;
	LEFT;
	RIGHT;
	TOWER;
}