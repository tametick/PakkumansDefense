package states;
import data.Library;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxSave;
import org.flixel.FlxSprite;
import org.flixel.FlxText;
import ui.Radio;
import ui.Tick;
import utils.Colors;
import states.GameState;

class SettingsState extends BasicState {
	var title:FlxText;
	var buttons:FlxGroup;
	var labels:FlxGroup;
	
	var overlayRadio:Radio;
	var overlayTick:Tick;
	var dpadRadio:Radio;
	var dpadTick:Tick;
	
	public static var settings:FlxSave;
	
	override public function create() {
		super.create();
		
		
		trace(GameState.controlScheme);
		
		if (GameState.controlScheme == null) {
			settings.data.controlScheme = Type.enumConstructor(CtrlMode.OVERLAY);
		}
		
		if (settings.data.blend==null) {
			settings.data.blend = false;
		}
		settings.flush();
		
		#if keyboard
		FlxG.mouse.show();
		#end
		
		FlxG.fade(0, 0.5, true, null, true);
		add(new FlxSprite(0, 0, Library.getFilename(Image.LEVEL_SELECT)));
		
		var y:Float = Library.tileSize;
		
		title = newText(0, y, FlxG.width, "Settings",Colors.WHITE,"center");
		title.setSize(16);
		
		labels = new FlxGroup();
		buttons = new FlxGroup();
		
		
		var x = 100;
		#if !keyboard
		x -= 25;
		#end
		
		var music = newText(x, y += title.height + Library.tileSize, FlxG.width, "Music", Colors.YELLOW);
		music.setSize(16);
		labels.add(music);
		var musicTick = new Tick(x - 24, y, function() { Library.setMusic(!Library.music); }, Library.music );
		buttons.add(musicTick);
		
		var sounds = newText(x, y += music.height, FlxG.width, "Sounds", Colors.YELLOW);
		sounds.setSize(16);
		labels.add(sounds);
		var soundTick = new Tick(x - 24, y, function() { Library.setSounds(!Library.sounds); }, Library.sounds );
		buttons.add(soundTick);
		
		
		#if !keyboard
		var controlRadios = new List<Radio>();
		
		var ctrlOverlay = newText(x, y +=  music.height, FlxG.width, "Controller overlay", Colors.BLUEGRAY);
		ctrlOverlay.setSize(16);
		labels.add(ctrlOverlay );
		overlayRadio = new Radio(controlRadios, x - 24, y, overlayCB, GameState.controlScheme==CtrlMode.OVERLAY);
		buttons.add(overlayRadio);
		
		var ctrlOverlayBlend = newText(x+32, y += music.height, FlxG.width, "Blend overlay", Colors.YELLOW);
		ctrlOverlayBlend.setSize(16);
		labels.add(ctrlOverlayBlend);
		
		overlayTick = new Tick(x +32 - 24, y, blendOverlayCB, settings.data.blend);
		blendOverlayCB(overlayTick.ticked);
		
		buttons.add(overlayTick);
				
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
		
		
		dpadTick.owner = dpadRadio;
		overlayTick.owner = overlayRadio;
		
		controlRadios.add(overlayRadio);
		controlRadios.add(dpadRadio);
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