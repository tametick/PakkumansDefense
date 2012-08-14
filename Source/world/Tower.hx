package world;

import data.Library;
import world.Powerup;

import org.flixel.FlxG;
import org.flixel.FlxPoint;
import org.flixel.plugin.photonstorm.FlxWeapon;
import utils.Colors;
import utils.Utils;
import world.Level;

class Tower extends WarpSprite {
	public var weapon:FlxWeapon;
	var counter:Float;
	var fireRate:Float;
	var range:Float;
	
	public function new(level:Level, start:FlxPoint) {
		super(level);
		
		loadGraphic(Library.getFilename(Image.TOWER));
		setColor(Colors.YELLOW);
		
		counter = 0;
		setPosition(start);
		start = null;
		
		weapon = new FlxWeapon("towergun", this);
		weapon.makePixelBullet(10, 2, 2, Colors.YELLOW,Std.int(width/2));
		weapon.setBulletSpeed(50);
		weapon.setBulletLifeSpan(750);
		
		fireRate = 1;
		range = 3.5 * Library.tileSize;
	}
	
	override public function update() {
		super.update();
		
		counter += FlxG.elapsed;
		if (counter >= fireRate) {
			counter = 0;
			var target = level.getGhostInRange(this,range);
			if (target != null) {
				Utils.play(Library.getSound(Sound.TOWER_SHOT));
				var angle = Std.int(180 / Math.PI * Math.atan2(target.y - y, target.x - x));
				weapon.fireFromAngle(angle);
				
				if (level.activePowerups.exists(Type.enumConstructor(PowerupType.SHOTGUN))) {
					weapon.fireFromAngle(angle-20);
					weapon.fireFromAngle(angle+20);
				}
				
			}
		}
		
		if (level.activePowerups.exists(Type.enumConstructor(PowerupType.CASHFORKILLS))) {
			setColor(Colors.GREEN);
		} else if(level.activePowerups.exists(Type.enumConstructor(PowerupType.SHOTGUN))){
			setColor(Colors.RED);
		} else {
			setColor(Colors.YELLOW);
		}
	}
	
	override public function destroy() {
		super.destroy();
		
		weapon.destroy();
		weapon = null;
	}
	
}