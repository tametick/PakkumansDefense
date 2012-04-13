import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.geom.Rectangle;
import nme.Lib;
import nme.ui.Mouse;


class Preloader extends NMEPreloader {
	public function new() {
		var w = Lib.current.stage.stageWidth;
		var h = Lib.current.stage.stageHeight;
		
		#if flash
		Lib.current.stage.fullScreenSourceRect = new Rectangle(0, 0, w, h);
		Lib.current.stage.color = 0;
		#end
		Lib.current.stage.align = StageAlign.TOP;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;

		Mouse.hide();
		
		/* if you want a custom "loading..." background image
		var bg:Bitmap = new Bitmap(new Bg(120, 80));
		bg.width = w;
		bg.height = h;
		addChild(bg);
		*/
		super();
	}
}

//@:bitmap("loading.png") class Bg extends BitmapData {}