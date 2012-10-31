package view.util 
{
	import starling.display.Sprite;
	import starling.events.Event;
	import flash.errors.IllegalOperationError;
	import starling.display.DisplayObject;
	import view.screens.Game;
	import view.screens.Highscores;
	import view.screens.Victory;
	
	
	public class ContentRequester
	{
		private var _screenInstance:DisplayObject;
		
		public function ContentRequester(screen:Object, events:Object = null, initializer:Object = null) 
		{
			this.screen = screen;
			this.events = events ? events : { };
			this.initializer = initializer ? initializer : { };
		}
		
		public var screen:Object;
		public var events:Object;
		public var initializer:Object;
		public var init:Boolean = false;
		
		internal function getScreen():DisplayObject
		{
			if (this.initializer)
			{
				for (var property:String in this.initializer)
				{
					this._screenInstance[property] = this.initializer[property];
				}
			}
			
			return this._screenInstance;
		}
		
		internal function getGame():DisplayObject
		{
			if (this.initializer)
			{
				for (var property:String in this.initializer)
				{
					this._screenInstance[property] = this.initializer[property];
				}
			}
			
			(this._screenInstance as Game).initNewGame();
			return this._screenInstance;
		}
		
		internal function getVictory():DisplayObject
		{
			if (this.initializer)
			{
				for (var property:String in this.initializer)
				{
					this._screenInstance[property] = this.initializer[property];
				}
			}
			
			(this._screenInstance as Victory).initVictory();
			return this._screenInstance;
		}
		
		internal function getHighScores():DisplayObject
		{
			if (this.initializer)
			{
				for (var property:String in this.initializer)
				{
					this._screenInstance[property] = this.initializer[property];
				}
			}
			
			(this._screenInstance as Highscores).updateList();
			return this._screenInstance;
		}
		
		internal function initScreen():DisplayObject
		{
			var screenInstance:DisplayObject;
			if (this.screen is Class)
			{
				var ScreenType:Class = Class(this.screen);
				screenInstance = new ScreenType();
				this._screenInstance = screenInstance;
				screenInstance.visible = false;
			}
			else if (this.screen is DisplayObject)
			{
				screenInstance = DisplayObject(this.screen);
				this._screenInstance = screenInstance;
				screenInstance.visible = false;
			}
			else
			{
				throw  new IllegalOperationError("ScreenNavigatorItem \"screen\" must be a Class or a display object.");
			}
			
			return screenInstance;
		}		
	}

}