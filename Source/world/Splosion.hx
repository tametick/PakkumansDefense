package world;

import org.flixel.FlxEmitter;
import org.flixel.FlxG;
import org.flixel.FlxObject;
import org.flixel.FlxParticle;
import org.flixel.FlxPoint;

class Splosion extends FlxEmitter {
	static var maxV = new FlxPoint(50,50);
	public function new(color:Int, x:Int = 0, y:Int = 0, size:Int = 20) {
		super(x, y, size);
		
		gravity = 200;
		lifespan = 0.5;
		
		initParticles(color, size);
	}
	
	function initParticles(color:Int, quantity:Int):FlxEmitter{
		maxSize = quantity;
		setRotation(720, 720);
		var particle:FlxParticle;
		var i:Int = 0;
		while (i < quantity) {
			particle = new FlxParticle();
			particle.makeGraphic(1, 1, color);
			particle.allowCollisions = FlxObject.NONE;
			particle.exists = false;
			particle.maxVelocity = maxV;
			add(particle);
			particle.updateTileSheet();
			i++;
		}
		return this;
	}
	
	public function explode(pixelX:Float, pixelY:Float) {
		FlxG.state.add(this);
		x = pixelX;
		y = pixelY;
		for(p in 0...maxSize) {
			emitParticle();
		}
	}
	
	override public function destroy() {
		FlxG.state.remove(this);
		super.destroy();
	}
}