package world;
import data.Library;
import org.flixel.FlxPoint;
import states.GameState;
import utils.Colors;
import org.flixel.FlxG;


class Coin extends WarpSprite {
	public var value:Int;
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
				value = 1;
			case BIG:
				loadGraphic(Library.getFilename(Image.FRUIT));
				snd = Sound.FRUIT;
				switch (cast(FlxG.state,GameState).levelNumber % 3) {
					case 0:
						setColor(Colors.PINK);
					case 1:
						setColor(Colors.ORANGE);
					case 2:
						setColor(Colors.RED);
				}
				value = 10;
		}
		
		
		setPosition(start);
		start = null;
	}
	
}

enum CoinType {
	NORMAL;
	BIG;
}