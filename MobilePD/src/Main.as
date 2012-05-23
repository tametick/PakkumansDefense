package 
{
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	public class Main extends Sprite 
	{
		[Embed(source = "loading.png")] var Loading:Class;
		[Embed(source = "pd.swf", mimeType = "application/octet-stream")] var Game:Class;
		
		var loading:Bitmap;
		public function Main():void 
		{
			loading = new Loading();
			addChild(loading);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			// entry point		
			var mLoader:Loader = new Loader();
			var ctx:LoaderContext = new LoaderContext();
			ctx.allowCodeImport = true;
			mLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
			mLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			mLoader.loadBytes(new Game(), ctx);
		}

		private function onCompleteHandler(loadEvent:Event):void
		{
			var cnt:DisplayObject = loadEvent.currentTarget.content;
			removeChild(loading);
			addChild(cnt);
		}
		
		private function onProgressHandler(mProgress:ProgressEvent):void
		{
			// might need this?
			var percent:Number = mProgress.bytesLoaded / mProgress.bytesTotal;
		}
		
		private function deactivate(e:Event):void 
		{
			// auto-close
			NativeApplication.nativeApplication.exit();
		}
		
	}
	
}