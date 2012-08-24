package data;

import nme.Assets;
import nme.media.Sound;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.text.Font;
import org.flixel.FlxG;
import org.flixel.FlxSave;
import states.SettingsState;
import states.GameState;
import data.Image;
import data.Music;
import data.Sound;

class AssetsLibrary {
	public static inline var tileSize = 8;
	public static inline var levelW = 15;
	public static inline var levelH = 11;
	
	public static inline var towerCost = 20;
	public static inline var levelTime = 90;
	
	public static inline var defaultCtrl = CtrlMode.GAMEPAD;
	
	public static inline var debug = false; 
	
	public static var music= true;
	public static var sounds = true;
	public static function setMusic(active:Bool) {
		if (FlxG.music == null) {
			return;
		}
		
		SettingsState.settings.data.music = music = active;
		
		if (music) {
			FlxG.music.volume = 1.0;
		} else {
			FlxG.music.volume = 0;
		}
	}
	public static function setSounds(active:Bool) {
		SettingsState.settings.data.sounds = sounds = active;
	}
	
	static var assets:Hash<Dynamic> = new Hash<Dynamic>();
	
	public static function getImage(i:Image):BitmapData {
		var name = AssetsLibrary.getFilename(i);
		return Assets.getBitmapData(name);
	}
		
	public static function getFont():Font {
		var name = "eight2empire";
		if (!assets.exists(name)){
			assets.set(name, Assets.getFont("assets/"+name+".ttf"));
		}
		return cast(assets.get(name), Font);
	}
	
	#if flash
	public static function getSound(s:data.Sound):nme.media.Sound {
		var name = AssetsLibrary.getFilename(s);
		if (!assets.exists(name)){
			assets.set(name, Assets.getSound(name));
		}
		return cast(assets.get(name), nme.media.Sound);
	}

	#else
	public static function getSound(s:data.Sound):String {
		return AssetsLibrary.getFilename(s);
	}
	#end
	
	#if flash
	public static function getMusic(s:Music):nme.media.Sound {
		var name = AssetsLibrary.getFilename(s);
		if (!assets.exists(name)){
			assets.set(name, Assets.getSound(name));
		}
		return cast(assets.get(name), nme.media.Sound);
	}
	#else
	public static function getMusic(s:Music):String {
		return AssetsLibrary.getFilename(s);
	}
	#end
		
	public static function getFilename(i:Dynamic):String {
		var prefix = "assets/";
		var suffix = "";
		if (Type.getEnum(i) == data.Image) {
			suffix = ".png";
		} else if (Type.getEnum(i) == data.Sound) {
			prefix = "sounds/";
			#if flash
			suffix = ".mp3";
			#else
			suffix = ".wav";
			#end
		} else if (Type.getEnum(i) == data.Music) {
			suffix = ".mp3";
		}
	
		return prefix + Type.enumConstructor(i).toLowerCase() + suffix;
	}
	
}





