package data;

import nme.Assets;
import nme.media.Sound;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.text.Font;

class Library {
	public static inline var tileSize = 8;
	public static inline var levelW = 19;
	public static inline var levelH = 19;
	
	
	static var assets:Hash<Dynamic> = new Hash<Dynamic>();
	
	public static function getImage(i:Image):BitmapData {
		return Assets.getBitmapData(Library.getFilename(i));
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
			suffix = ".wav";
		} else if (Type.getEnum(i) == Music) {
			suffix = ".mp3";
		}
	
		return "assets/" + Type.enumConstructor(i).toLowerCase() + suffix;
	}
	
}

enum Image {
	BG;
}

enum Sound {
	S;
}

enum Music {
	M;
}