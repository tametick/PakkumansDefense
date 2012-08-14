package data;

import nme.Assets;
import nme.media.Sound;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.text.Font;

class Library {
	public static inline var tileSize = 8;
	public static inline var levelW = 15;
	public static inline var levelH = 11;
	
	public static inline var towerCost = 20;
	
	public static inline var debug = false; 
	
	static var assets:Hash<Dynamic> = new Hash<Dynamic>();
	
	public static function getImage(i:Image):BitmapData {
		var name = Library.getFilename(i);
		return Assets.getBitmapData(name);
	}
		
	public static function getFont():Font {
		var name = "eight2empire";
		if (!assets.exists(name)){
			assets.set(name, Assets.getFont("assets/"+name+".ttf"));
		}
		return cast(assets.get(name), Font);
	}
	
	public static function getSound(s:Sound):nme.media.Sound {
		var name = Library.getFilename(s);
		if (!assets.exists(name)){
			assets.set(name, Assets.getSound(name));
		}
		return cast(assets.get(name), nme.media.Sound);
	}
	
	public static function getMusic(s:Music):nme.media.Sound {
		var name = Library.getFilename(s);
		if (!assets.exists(name)){
			assets.set(name, Assets.getSound(name));
		}
		return cast(assets.get(name), nme.media.Sound);
	}
		
	public static function getFilename(i:Dynamic):String {
		var suffix = "";
		if (Type.getEnum(i) == Image) {
			suffix = ".png";
		} else if (Type.getEnum(i) == Sound) {
			suffix = ".mp3";
		} else if (Type.getEnum(i) == Music) {
			suffix = ".mp3";
		}
	
		return "assets/" + Type.enumConstructor(i).toLowerCase() + suffix;
	}
	
}

enum Image {
	BG;
	HUD_OVERLAY;
	BUTTONS_OVERLAY_T;
	BUTTONS_OVERLAY_T2;
	BUTTONS_OVERLAY_T2R;
	HIGHSCORE;
	LEVEL_SELECT;
	CURSOR;
	GHOST;
	PAKKU;
	ARROW;
	BIG_ARROW;
	TOWER;
	BUTTON;
	BUTTON_ACTIVE;
	TICK;
	TICK_SELECTED;
	RADIO;
	RADIO_SELECTED;
	CLICK_MAP;
	CLICK_MAP_PAD;
	CLICK_MAP_PAD_L;
	CASH;
	FREEZE;
	SHOTGUN;
	FRUIT;
	HASTE;
	SETTINGS;
}

enum Sound {
	CLICK;
	CASH_REGISTER;
	GHOST_HIT;
	MONEY;
	TOWER_SHOT;
	DEATH;
	POWERUP;
	ERROR;
	FRUIT;
}

enum Music {
	THEME;
	MENU;
}