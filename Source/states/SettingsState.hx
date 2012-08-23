package states;
import data.AssetsLibrary;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxSave;
import org.flixel.FlxSprite;
import org.flixel.FlxTextField;
import ui.Radio;
import ui.Tick;
import utils.Colors;
import states.GameState;
import data.Image;

class SettingsState extends BasicState {
	var title:FlxTextField;
	var buttons:FlxGroup;
	var labels:FlxGroup;
	
	var overlayRadio:Radio;
	var overlayTick:Tick;
	var dpadRadio:Radio;
	var dpadTick:Tick;
	
	public static var settings:FlxSave;
	
	public static function initSettings() {
		SettingsState.settings = new FlxSave();
		SettingsState.settings.bind("Settings");
		if (SettingsState.settings.data.music == null) {
			SettingsState.settings.data.music = true;
		}
		if (SettingsState.settings.data.sounds == null) {
			SettingsState.settings.data.sounds= true;
		}
		AssetsLibrary.music = SettingsState.settings.data.music;
		AssetsLibrary.sounds = SettingsState.settings.data.sounds;
	}
	
	override public function create() {
		super.create();
		
		if (GameState.controlScheme == null) {
			settings.data.controlScheme = Type.enumConstructor(AssetsLibrary.defaultCtrl);
		}
		
		if (settings.data.blend==null) {
			settings.data.blend = false;
		}
		settings.flush();
		
		#if keyboard
		FlxG.mouse.show();
		#end
		
		FlxG.fade(0, 0.5, true, null, true);
		add(new FlxSprite(0, 0, AssetsLibrary.getFilename(Image.LEVEL_SELECT)));
		
		var y:Float = AssetsLibrary.tileSize;
		
		title = newText(0, y, FlxG.width, "Settings",Colors.WHITE,"center");
		title.setSize(16);
		
		labels = new FlxGroup();
		buttons = new FlxGroup();
		
		
		var x = 100;
		#if !keyboard
		x -= 25;
		#end
		
		var music = newText(x, y += title.height + AssetsLibrary.tileSize, FlxG.width, "Music", Colors.YELLOW);
		music.setSize(16);
		labels.add(music);
		var musicTick = new Tick(x - 24, y, function() { AssetsLibrary.setMusic(!AssetsLibrary.music); }, AssetsLibrary.music );
		buttons.add(musicTick);
		
		var sounds = newText(x, y += music.height, FlxG.width, "Sounds", Colors.YELLOW);
		sounds.setSize(16);
		labels.add(sounds);
		var soundTick = new Tick(x - 24, y, function() { AssetsLibrary.setSounds(!AssetsLibrary.sounds); }, AssetsLibrary.sounds );
		buttons.add(soundTick);
		
		
		#if !keyboard
		var controlRadios = new List<Radio>();
		
		var ctrlDPad = newText(x, y += music.height, FlxG.width, "Virtual game-pad", Colors.BLUEGRAY);
		ctrlDPad.setSize(16);
		labels.add(ctrlDPad );
		dpadRadio= new Radio(controlRadios, x - 24, y, dpadCB, GameState.controlScheme==CtrlMode.GAMEPAD || GameState.controlScheme==CtrlMode.GAMEPAD_L);
		buttons.add(dpadRadio);
		
		
		var ctrlDPasLeft = newText(x+32, y += music.height, FlxG.width, "Left-handed", Colors.YELLOW);
		ctrlDPasLeft.setSize(16);
		labels.add(ctrlDPasLeft);
		dpadTick = new Tick(x +32 - 24, y, dpadCBLeft, GameState.controlScheme==CtrlMode.GAMEPAD_L);
		buttons.add(dpadTick);
		
		var ctrlOverlay = newText(x, y +=  music.height, FlxG.width, "Controller overlay", Colors.BLUEGRAY);
		ctrlOverlay.setSize(16);
		labels.add(ctrlOverlay );
		overlayRadio = new Radio(controlRadios, x - 24, y, overlayCB, GameState.controlScheme==CtrlMode.OVERLAY);
		buttons.add(overlayRadio);
		
		var ctrlOverlayBlend = newText(x+32, y += music.height, FlxG.width, "Blend overlay", Colors.YELLOW);
		ctrlOverlayBlend.setSize(16);
		labels.add(ctrlOverlayBlend);
		
		overlayTick = new Tick(x +32 - 24, y, blendOverlayCB, settings.data.blend);
		if(GameState.controlScheme==OVERLAY){
			blendOverlayCB(overlayTick.ticked);
		}
		
		buttons.add(overlayTick);
				
		
		
		
		dpadTick.owner = dpadRadio;
		overlayTick.owner = overlayRadio;
		
		controlRadios.add(dpadRadio);
		controlRadios.add(overlayRadio);
		#end
		
		
		add(labels);
		add(buttons);
	}
	
	
	#if !keyboard
	function overlayCB(val:Bool) { 
		if(val) {
			GameState.initController(CtrlMode.OVERLAY);
			settings.data.controlScheme = Type.enumConstructor( CtrlMode.OVERLAY);
			settings.flush();
		}
	}
	function blendOverlayCB(val:Bool) { 
		overlayCB(true);
		GameState.setControllerVisiblity(!val, true);
	}
	function dpadCB(val:Bool) { 
		if (val) {
			dpadCBLeft(dpadTick.ticked);
		}
		GameState.setControllerVisiblity(true, true);
	}
	function dpadCBLeft(val:Bool) { 
		if(val) {
			GameState.initController(CtrlMode.GAMEPAD_L);
			settings.data.controlScheme = Type.enumConstructor( CtrlMode.GAMEPAD_L);
		} else {
			GameState.initController(CtrlMode.GAMEPAD);
			settings.data.controlScheme = Type.enumConstructor( CtrlMode.GAMEPAD);
		}
		settings.flush();
		GameState.setControllerVisiblity(true, true);
		
	}
	#end
	
	
	override public function destroy() {
		remove(labels);
		remove(buttons);
		
		labels.destroy();
		labels = null;
		buttons.destroy();
		buttons = null;
		
		super.destroy();
		
	}
}