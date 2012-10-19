package view.screens 
{
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.Timer;

	// Add a Splash Screen
			/*
			parameters are ("image URL", listener function, duration in millisecond to display, scaleMode)
			image URL and listener function are required
			duration and scaleMode are optional
					duration options:
							defaults to 1000 milliseconds
					scaleMode options:
							SCALE_MODE_NONE = default and should be obvious
							SCALE_MODE_STRETCH = scale to full width and height
							SCALE_MODE_ZOOM = scale to height
							SCALE_MODE_LETTERBOX = scale to width
	*/
	
	public class Splash extends Sprite
	{
		[Embed (source = "/assets/system/icon144.png")]
		private var SplashImage:Class;
		private var splashImage:Bitmap;
	
		public static const SCALE_MODE_NONE:String   = "none";
		public static const SCALE_MODE_ZOOM:String   = "zoom";
		public static const SCALE_MODE_LETTERBOX:String   = "letterbox";
		public static const SCALE_MODE_STRETCH:String   = "stretch";

		// Parameter Variables
		private var _listener:Function;
		private var _duration:int;
		private var _imageURL:String;
		private var _scaleMode:String;
		private var _whiteRect:Sprite;
		
		// For scaling purposes
		private var _currentHeight:Number;
		private var _currentWidth:Number;
		private var _percent:Number;

		// _timer for our duration
		private var _timer:Timer;

		// Constructor
		public function Splash(listener:Function, duration:int = 1000, scaleMode:String = Splash.SCALE_MODE_NONE)
		{
			// Set vars
			_duration = duration;
			_scaleMode = scaleMode;
			_listener = listener;
			// Listen for when this is added
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}

		// Init
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);

			// Load the image
			_whiteRect = new Sprite();
			splashImage = new SplashImage();
			addSplashImage();

			// Create a _timer for how long the Splash Screen stays on screen
			_timer = new Timer(_duration, 0);
			_timer.addEventListener(TimerEvent.TIMER, removeSplashScreen);
			_timer.start();
		}

		// Add the image to the stage
		public function addSplashImage():void
		{
			// Get and save the original width and height of the Image.
			_currentWidth = splashImage.width;
			_currentHeight = splashImage.height;

			// Run which function is set in the constructor
			switch (_scaleMode)
			{
				case SCALE_MODE_NONE:
					none();
					break;
				case SCALE_MODE_ZOOM:
					zoom();
					break;
				case SCALE_MODE_LETTERBOX:
					letterbox();
					break;
				case SCALE_MODE_STRETCH:
					stretch();
					break;

			}

			// Add the image to stage
			addChild(splashImage);
		}

		// None: doesn't scale the splash image
		private function none():void
		{
			imagePlacement();
		}

		// Zoom: scales the splash image based on the stage height
		private function zoom():void
		{
			splashImage.height = stage.stageHeight;
			_percent = _currentHeight / splashImage.height;
			splashImage.width = _currentWidth / _percent;
			imagePlacement();

		}

		// Letterbox: scales the splash image based on the stage width
		private function letterbox():void
		{
			splashImage.width = stage.stageWidth;
			_percent = _currentWidth / splashImage.width;
			splashImage.height = _currentHeight / _percent;
			imagePlacement();
		}

		// Stretch: scales both height and width to the stage width and height
		private function stretch():void
		{
			splashImage.width = stage.stageWidth;
			splashImage.height = stage.stageHeight;
			imagePlacement();
		}

		// Places the splash image in the center of the stage
		private function imagePlacement():void
		{
			var canvas:Graphics;
			canvas = _whiteRect.graphics;
			canvas.beginFill ( 0xFFFFFF);
			canvas.drawRect(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);
			canvas.endFill();
			addChild(_whiteRect);
			
			splashImage.x = (stage.fullScreenWidth - splashImage.width) * .5;
			splashImage.y = (stage.fullScreenHeight - splashImage.height) * .5;
			_listener.apply();
		}

		// Removes splash screen when _timer is done
		private function removeSplashScreen(e:TimerEvent):void
		{
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, removeSplashScreen);
			removeChild(splashImage);
            parent.removeChild(this);
		}
	}
}