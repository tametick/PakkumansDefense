package world;

import air.update.events.StatusFileUpdateErrorEvent;
import com.eclecticdesignstudio.motion.Actuate;
import data.Library;
import nme.display.Bitmap;
import nme.Lib;
import nme.ui.Multitouch;
import nme.ui.MultitouchInputMode;
import org.flixel.FlxG;
import org.flixel.FlxObject;
import org.flixel.FlxPoint;
import org.flixel.FlxRect;
import org.flixel.FlxSprite;
import org.flixel.plugin.photonstorm.FlxBar;
import states.GameState;
import world.Splosion;
import utils.Colors;
import utils.Utils;
import nme.display.BitmapData;
import world.Powerup;
import flash.events.TransformGestureEvent;

class Player extends WarpSprite {
	public var coins:Int;
	public var kills:Int;
	public var arrow:FlxSprite;
	public var time:Float;
	public var lastbeep:Int;
	static var clickMap:BitmapData;
	
	private var thinking:Bool;
	private var delay:Int;
	public var touch:Command = null;
	private var plTouching:Bool;
	
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
		
		if(GameState.controlScheme == CtrlMode.SWIPE){
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			Lib.current.addEventListener(TransformGestureEvent.GESTURE_SWIPE , swipe);
		}
		
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
		
	//	powerupIndicator = new FlxBar(0, 0, FlxBar.FILL_LEFT_TO_RIGHT, 64, 4, level, "activepowerups[0]");
	//	powerupIndicator.trackParent(0, -5);
	}
	
	public function setClickMap() {		
		var clkMap;
		switch(GameState.controlScheme) {
			default:
				clkMap = Image.CLICK_MAP;
			case CtrlMode.GAMEPAD:
				clkMap = Image.CLICK_MAP_PAD;
			case CtrlMode.GAMEPAD_L:
				clkMap = Image.CLICK_MAP_PAD_L;
		}
		clickMap = Library.getImage(clkMap);
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
	

	
	public function getCommand( x:Float, y:Float ):Command {
		var ix:Int, iy:Int;
		if(BuskerJam.multiTouchSupported){
			ix = Std.int(x/460*160);
			iy = Std.int(y / 320 * 106);
		} else {
			ix = Std.int(x);
			iy=Std.int(y);
		
		}
		
		var color = clickMap.getPixel(ix, iy);
		
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
				if(GameState.controlScheme == CtrlMode.OVERLAY) {
					if ( FlxG.mouse.screenX < 0) {
						return LEFT;
					} else if ( FlxG.mouse.screenY < 0) {
						return UP;
					} else if ( FlxG.mouse.screenX > 160) {
						return RIGHT;
					} else if ( FlxG.mouse.screenY > 106) {
						return DOWN;
					}
				}
		}
		return null;
	}
	
	
	override public function update() {
		super.update();
		
		if (cast(FlxG.state, GameState).help < 3)
			return;
		
		time -= FlxG.elapsed;
		if (time <= 0) {
			cast(FlxG.state, GameState).gameOver();
		}
		if (thinking) {
			if (delay >= 3) {
				spawnTower();
				delay = 0;
			} else {
				delay ++;
			}
		}
		
		
			resolveSingleTouch();// leaving this here because of xperia play controls needing keyboard;
		
		
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
		
		if (level.activePowerups.exists(Type.enumConstructor(PowerupType.HASTE))) {
			setColor(Colors.PINK);
		} else {
			setColor(Colors.YELLOW);
		}
	}

	private function resolveSingleTouch() {
		var s = cast(FlxG.state, GameState);
		var tempx=FlxG.mouse.screenX;
		var tempy=FlxG.mouse.screenY;
		if(GameState.controlScheme!=CtrlMode.SWIPE){
			if (FlxG.mouse.justPressed()) {
				plTouching = true;
				
				 if(touch!=null){
					s.setHighlighted(touch);
				 }
			} else if (FlxG.mouse.justReleased()) {
				plTouching = false;
				var touch2 = getCommand(tempx,tempy);
				if(touch2!=null){
					s.setUnhighlighted(touch2);
				}
			}
			
			if (plTouching) {
				 touch = getCommand(tempx,tempy);
			}
		} else {
			if (FlxG.mouse.justPressed() && touch == null) {
				touch = TOWER;
			}
		}
		
		resolveTouch();
	}
	
	public function resolveTouch() {
		// change facing according to keyboard input
		if (FlxG.keys.justPressed("A") || FlxG.keys.justPressed("LEFT") || touch==LEFT) {
			facingNext = FlxObject.LEFT;
			arrow.play("W");
			touch = null;
		} if (FlxG.keys.justPressed("D") || FlxG.keys.justPressed("RIGHT") || touch==RIGHT) {
			facingNext = FlxObject.RIGHT;
			arrow.play("E");
			touch = null;
		} if (FlxG.keys.justPressed("S") || FlxG.keys.justPressed("DOWN") || touch==DOWN) {
			facingNext = FlxObject.DOWN;
			arrow.play("S");
			touch = null;
		} if (FlxG.keys.justPressed("W") || FlxG.keys.justPressed("UP") || touch==UP) {
			facingNext = FlxObject.UP;
			arrow.play("N");
			touch = null;
		} if (FlxG.keys.justPressed("SPACE") || FlxG.keys.justPressed("ENTER") || touch == TOWER) {
			if (level.player.coins >= Library.towerCost || Library.debug) {
				spawnTower();
				
			} else {
				Utils.play(Library.getSound(Sound.ERROR));
			}
			touch = null;
		}
	}
	public function swipe(e:TransformGestureEvent){
		if (e.offsetX == 1) {
			touch = RIGHT; 
		} else
		if (e.offsetX == -1) {
			touch = LEFT; 
		} else
		if (e.offsetY == 1) {
			touch = DOWN; 
		} else
		if (e.offsetY == -1) {
			touch = UP; 
		} else {
			touch = TOWER;
		}
		
	}
	public function spawnTower() {
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
						Utils.play(Library.getSound(Sound.CASH_REGISTER));
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
		if (level.activePowerups.exists(Type.enumConstructor(PowerupType.HASTE))) {
		 duration /= 2;
		}
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