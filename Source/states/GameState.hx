package states;

import data.Library;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.plugin.photonstorm.FlxGridOverlay;
import utils.Colors;
import world.Coin;
import world.Level;
import world.Player;

class GameState extends FlxState {
	var level:Level;
	var player:Player;
	var ghosts:FlxGroup;
	var coins:FlxGroup;
	
	var coinCounter:FlxText;
	
	override public function create():Void {
		FlxG.mouse.show();
		FlxG.bgColor = Colors.BLACK;
		FlxG.fade(0, 0.5, true, null, true);
		
		level = new Level();
		add(FlxGridOverlay.create(Library.tileSize, Library.tileSize, Std.int(level.width), Std.int(level.height), false, true, Colors.DBLUE, Colors.DGREEN));
		add(level);
		
		var playerStart = level.getFreeTile();
		
		coins = new FlxGroup();
		var map = level.getData();
		var coinStart = new FlxPoint();
		var x = 0;
		var y = 0;
		for (mi in 0...map.length) {
			if (x >= Library.levelW) {
				x = 0;
				y++;
			}
			
			if (map[mi] == 0 && !(x==playerStart.x && y==playerStart.y)) {
				coinStart.x = x;
				coinStart.y = y;
				coins.add(new Coin(coinStart));
			}
			
			x++;
		}
		coinStart = null;
		map = null;
		add(coins);
		
		player = new Player(playerStart);
		add(player);
		
		ghosts = new FlxGroup();
		
		FlxG.camera.scroll.y = FlxG.camera.scroll.x = -Library.tileSize / 2;
		
		coinCounter = new FlxText(level.width + 8, 8, Std.int(FlxG.width - level.width - 8), "$: 0");
		coinCounter.scrollFactor.x = 0;
		coinCounter.scrollFactor.y = 0;
		add(coinCounter);
	}
	
	override public function update() {
		super.update();
		
		FlxG.collide(level, player);
		FlxG.collide(level, ghosts);
		FlxG.overlap(player, coins, pickUpCoin);
	}
	
	function pickUpCoin(p:Player, c:Coin) {
		coins.remove(c);
		player.coins++;
		coinCounter.text = "$: " + player.coins;
	}
}