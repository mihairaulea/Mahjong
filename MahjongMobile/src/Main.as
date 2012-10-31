package 
{
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import model.Highscores;
	import view.screens.Splash;
	
	import starling.core.Starling;
	import net.hires.debug.Stats;
	
	import util.Constants;
	
	public class Main extends Sprite 
	{
		private var starling:Starling;
		private var stats:Stats;
		
		// Splash
		private var splash:Splash;
		
		public function Main():void 
		{
			// Splash screen
			this.addEventListener(Event.ADDED_TO_STAGE, initSplash);
			
			// General properties
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			// Entry point
			//this.loaderInfo.addEventListener(Event.COMPLETE, loaderInfo_completeHandler);
		}
		
		private function initSplash(e:Event):void
		{
			var highscores:Highscores = Highscores.getInstance();
			highscores.submitScore("mihai", 1234566);
			
			/*
			this.removeEventListener(Event.ADDED_TO_STAGE, initSplash);
			
			splash = new Splash(loaderInfo_completeHandler, 3000, Splash.SCALE_MODE_NONE);
			addChild(splash);
			*/
		}
		
		//private function loaderInfo_completeHandler(event:Event):void
		private function loaderInfo_completeHandler():void
		{
			// General properties
			Starling.handleLostContext = true; // required on Android
			Starling.multitouchEnabled = true; // mobile devices
			
			// Debug stats
			//this.stats = new Stats();
			//this.addChild(stats);
			
			// Init starling
			this.starling = new Starling(MainInterface, this.stage);
			this.starling.simulateMultitouch = true; // Mobile testing
			this.starling.enableErrorChecking = false;
			this.starling.start();
			trace("got here 1");
			
			this.stage.addEventListener(Event.RESIZE, stage_resizeHandler, false, int.MAX_VALUE, true);
			this.stage.addEventListener(Event.DEACTIVATE, stage_deactivateHandler, false, 0, true);
		}
		
		private function stage_resizeHandler(event:Event):void
		{
			// Creating a suitable viewport
			var screenWidth:int = stage.fullScreenWidth;
			var screenHeight:int = stage.fullScreenHeight;
			var viewPort:Rectangle = new Rectangle();
			
			if (stage.fullScreenHeight / stage.fullScreenWidth < Constants.ASPECT_RATIO)
            {
                viewPort.height = screenHeight;
                viewPort.width  = int(viewPort.height / Constants.ASPECT_RATIO);
                viewPort.x = int((screenWidth - viewPort.width) / 2);
            }
            else
            {
                viewPort.width = screenWidth; 
                viewPort.height = int(viewPort.width * Constants.ASPECT_RATIO);
                viewPort.y = int((screenHeight - viewPort.height) / 2);
            }
			
			try
			{
				this.starling.viewPort = viewPort;
			}
			catch (error:Error) { }
			
		}
		
		private function stage_deactivateHandler(event:Event):void
		{
			this.starling.stop();
			this.stage.addEventListener(Event.ACTIVATE, stage_activateHandler, false, 0, true);
		}
		
		private function stage_activateHandler(event:Event):void
		{
			this.stage.removeEventListener(Event.ACTIVATE, stage_activateHandler);
			this.starling.start();
		}
	}
}