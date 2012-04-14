package world;

import data.Library;
import org.flixel.FlxPoint;
import org.flixel.plugin.photonstorm.FlxWeapon;
import utils.Colors;

class Tower extends WarpSprite {
	var weapon:FlxWeapon;
	
	public function new(level:Level, start:FlxPoint) {
		super(level);
		
		makeGraphic(Library.tileSize-2, Library.tileSize-2, Colors.YELLOW);
		
		setPosition(start);
		start = null;
		
		weapon = new FlxWeapon("towergun", this);
	}
	
	override public function update() {
		super.update();
		
		// todo - shoot at enemies that are in range
	}
	
	override public function destroy() {
		super.destroy();
		
		weapon.destroy();
		weapon = null;
	}
	
}