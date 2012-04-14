package world;

import data.Library;
import org.flixel.FlxG;
import org.flixel.FlxPoint;
import org.flixel.plugin.photonstorm.FlxWeapon;
import utils.Colors;

class Tower extends WarpSprite {
	public var weapon:FlxWeapon;
	var counter:Float;
	var fireRate:Float;
	var range:Float;
	
	public function new(level:Level, start:FlxPoint) {
		super(level);
		
		makeGraphic(Library.tileSize-2, Library.tileSize-2, Colors.YELLOW);
		
		counter = 0;
		setPosition(start);
		start = null;
		
		weapon = new FlxWeapon("towergun", this);
		weapon.makePixelBullet(10, 2, 2, Colors.LBROWN);
		weapon.setBulletSpeed(50);
		
		fireRate = 1;
		range = 3.5 * Library.tileSize;
		
		
	}
	
	override public function update() {
		super.update();
		
		counter += FlxG.elapsed;
		if (counter >= fireRate) {
			counter = 0;
			var target = level.getGhostInRange(this,range);
			if(target != null) {
				weapon.fireAtTarget(target);
			}
		}
	}
	
	override public function destroy() {
		super.destroy();
		
		weapon.destroy();
		weapon = null;
	}
	
}