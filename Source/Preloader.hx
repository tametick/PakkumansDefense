import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.geom.Rectangle;
import nme.Lib;
import nme.ui.Mouse;


class Preloader extends NMEPreloader {
	public function new() {
		var w = 480;
		var h = 320;
		
		#if flash
		Lib.current.stage.fullScreenSourceRect = new Rectangle(0, 0, w, h);
		Lib.current.stage.color = 0;
		#end
		Lib.current.stage.align = StageAlign.TOP;
		Lib.current.stage.scaleMode = StageScaleMode.EXACT_FIT;

		Mouse.hide();
		
		var bg:Bitmap = new Bitmap(new Bg(240, 160));
		bg.width = w;
		bg.height = h;
		addChild(bg);
		
		super();
	}
}

@:bitmap("loading.png") class Bg extends BitmapData {}