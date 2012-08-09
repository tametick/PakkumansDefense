package world;
import data.Library;
import org.flixel.FlxPoint;
import utils.Colors;

class Coin extends WarpSprite {
	public var type:CoinType;
	public var snd:Sound;
	public function new(level:Level, start:FlxPoint, ?typ:CoinType = null ) {
		if (typ == null) {
			typ = CoinType.NORMAL;
		}
		
		super(level);
		type = typ;
		switch(type) {
			case NORMAL:
				makeGraphic(2, 2, Colors.BLUEGRAY);
				snd = Sound.MONEY;
			case BIG:
				loadGraphic(Library.getFilename(Image.TOWER));
				snd = Sound.MONEY;
		}
		
		
		setPosition(start);
		start = null;
	}
	
}

enum CoinType {
	NORMAL;
	BIG;
}