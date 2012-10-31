package view.util 
{
	import feathers.controls.*;
	import feathers.core.FeathersControl;
	import flash.errors.IllegalOperationError;
	import flash.geom.Rectangle;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.ResizeEvent;
	
	import view.screens.*; 
	
	public class ContentManipulator extends FeathersControl 
	{
		private var _activeScreenID:String;
		public function get activeScreenID():String { return this._activeScreenID; }
	
		private var _activeScreen:DisplayObject;
		public function get activeScreen():DisplayObject { return this._activeScreen; }

		private var _clipContent:Boolean = false;
		public function get clipContent():Boolean { return this._clipContent; }
		public function set clipContent(value:Boolean):void
		{
			if(this._clipContent == value)
			{
				return;
			}
			this._clipContent = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		public var transition:Function = defaultTransition;
		
		// Screen variables
		private var _screens:Object = { };
		private var _screensDisplay:Object = { };
		private var _screenActivePool:Object = { };
		private var _screenEvents:Object = { };
		public var defaultScreenID:String;
		
		private var _transitionIsActive:Boolean = false;
		private var _previousScreenInTransitionID:String;
		private var _previousScreenInTransition:DisplayObject;
		private var _nextScreenID:String = null;
		private var _clearAfterTransition:Boolean = false;
		
		private var _onChange:Signal = new Signal(ContentManipulator);
		public function get onChange():ISignal { return this._onChange; }
		
		private var _onClear:Signal = new Signal(ContentManipulator);
		public function get onClear():ISignal { return this._onClear; }
		
		public function ContentManipulator()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function showScreen(id:String):DisplayObject
		{
			if(!this._screens.hasOwnProperty(id))
			{
				throw new IllegalOperationError("Screen with id '" + id + "' cannot be shown because it has not been defined.");
			}

			if(this._activeScreenID == id)
			{
				return this._activeScreen;
			}

			if(this._transitionIsActive)
			{
				this._nextScreenID = id;
				this._clearAfterTransition = false;
				return null;
			}

			this._previousScreenInTransition = this._activeScreen;
			this._previousScreenInTransitionID = this._activeScreenID;
			
			const item:ContentRequester = ContentRequester(this._screens[id]);
			
			if (id == "game")
			{
				if (_screenActivePool[id] == false)
					this.addChild(_screensDisplay[id]);
				_screenActivePool[id] = true;				
				this._activeScreen = item.getGame();
				this._activeScreenID = id;
			}
			else if (id == "victory")
			{
				this._activeScreen = item.getVictory();
				this._activeScreenID = id;
			}
			else if (id == "highscores")
			{
				this._activeScreen = item.getHighScores();
				this._activeScreenID = id;
			}
			else
			{
				this._activeScreen = item.getScreen();
				this._activeScreenID = id;
			}
			
			if(_screenActivePool[id] == false)
			{
				this.addChild(_screensDisplay[id]);
				_screenActivePool[id] = true;
			}
			
			// Unflatten new screen
			(this._activeScreen as Screen).unflatten();
			
			this._activeScreen.visible = true;
			
			this._transitionIsActive = true;
			this.transition(this._previousScreenInTransition, this._activeScreen, transitionComplete);

			this.invalidate(INVALIDATION_FLAG_SELECTED);
			this._onChange.dispatch(this);
			return this._activeScreen;
		}
		
		public function showDefaultScreen():DisplayObject
		{
			if(!this.defaultScreenID)
			{
				throw new IllegalOperationError("Cannot show default screen because the default screen ID has not been defined.");
			}
			return this.showScreen(this.defaultScreenID);
		}
		
		public function clearScreen():void
		{
			if(this._transitionIsActive)
			{
				this._nextScreenID = null;
				this._clearAfterTransition = true;
				return;
			}

			this.clearScreenInternal(true);
			this._onClear.dispatch(this);
		}
		
		private function clearScreenInternal(displayTransition:Boolean):void
		{
			if(!this._activeScreen)
			{
				return;
			}

			const item:ContentRequester = ContentRequester(this._screens[this._activeScreenID]);
			const events:Object = item.events;
			const savedScreenEvents:Object = this._screenEvents[this._activeScreenID];
			for(var eventName:String in events)
			{
				var signal:ISignal = this._activeScreen.hasOwnProperty(eventName) ? (this._activeScreen[eventName] as ISignal) : null;
				var eventAction:Object = events[eventName];
				if(eventAction is Function)
				{
					if(signal)
					{
						signal.remove(eventAction as Function);
					}
					else
					{
						this._activeScreen.removeEventListener(eventName, eventAction as Function);
					}
				}
				else if(eventAction is String)
				{
					var eventListener:Function = savedScreenEvents[eventName] as Function;
					if(signal)
					{
						signal.remove(eventListener);
					}
					else
					{
						this._activeScreen.removeEventListener(eventName, eventListener);
					}
				}
			}

			if(displayTransition)
			{
				this._transitionIsActive = true;
				this._previousScreenInTransition = this._activeScreen;
				this._previousScreenInTransitionID = this._activeScreenID;
				this.transition(this._previousScreenInTransition, null, transitionComplete);
			}
			this._screenEvents[this._activeScreenID] = null;
			this._activeScreen = null;
			this._activeScreenID = null;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}
		
		public function addScreen(id:String, item:ContentRequester):void
		{
			if(this._screens.hasOwnProperty(id))
			{
				throw new IllegalOperationError("Screen with id '" + id + "' already defined. Cannot add two screens with the same id.");
			}

			if(!this.defaultScreenID)
			{
				this.defaultScreenID = id;
			}

			this._screens[id] = item;
			this._screensDisplay[id] = item.initScreen();
			this._screenActivePool[id] = false;
			
			
			this._activeScreen = this._screensDisplay[id];
			
			const events:Object = item.events;
			const savedScreenEvents:Object = {};
			for(var eventName:String in events)
			{
				var signal:ISignal = this._activeScreen.hasOwnProperty(eventName) ? (this._activeScreen[eventName] as ISignal) : null;
				var eventAction:Object = events[eventName];
				if(eventAction is Function)
				{
					if(signal)
					{
						signal.add(eventAction as Function);
					}
					else
					{
						this._activeScreen.addEventListener(eventName, eventAction as Function);
					}
				}
				else if(eventAction is String)
				{
					var eventListener:Function = this.createScreenListener(eventAction as String);
					if(signal)
					{
						signal.add(eventListener);
					}
					else
					{
						this._activeScreen.addEventListener(eventName, eventListener);
					}
					savedScreenEvents[eventName] = eventListener;
				}
				else
				{
					throw new TypeError("Unknown event action defined for screen:", eventAction.toString());
				}				
			}

			this._screenEvents[id] = savedScreenEvents;
			
			item.init = true;
		}
		
		public function removeScreen(id:String):void
		{
			if(!this._screens.hasOwnProperty(id))
			{
				throw new IllegalOperationError("Screen '" + id + "' cannot be removed because it has not been added.");
			}
			delete this._screens[id];
		}
		
		override public function dispose():void
		{
			this._onChange.removeAll();
			this._onClear.removeAll();
			super.dispose();
		}
		
		override protected function draw():void
		{
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			const selectionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			if(sizeInvalid || selectionInvalid)
			{
				if(this.activeScreen)
				{
					this.activeScreen.width = this.actualWidth;
					this.activeScreen.height = this.actualHeight;
				}
			}
			if(stylesInvalid || sizeInvalid)
			{
				if(this._clipContent)
				{
					var scrollRect:Rectangle = this.scrollRect;
					if(!scrollRect)
					{
						scrollRect = new Rectangle();
					}
					scrollRect.width = this.actualWidth;
					scrollRect.height = this.actualHeight;
					this.scrollRect = scrollRect;
				}
				else
				{
					this.scrollRect = null;
				}
			}
		}
		
		protected function autoSizeIfNeeded():Boolean
		{
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}
			var newWidth:Number = this.explicitWidth;
			if(needsWidth)
			{
				newWidth = this.stage.stageWidth;
			}

			var newHeight:Number = this.explicitHeight;
			if(needsHeight)
			{
				newHeight = this.stage.stageHeight;
			}

			return this.setSizeInternal(newWidth, newHeight, false);
		}
		
		private function defaultTransition(oldScreen:DisplayObject, newScreen:DisplayObject, completeHandler:Function):void
		{
			//in short, do nothing
			completeHandler();
		}
		
		private function transitionComplete():void
		{
			if(this._previousScreenInTransition)
			{
				const item:ContentRequester = this._screens[this._previousScreenInTransitionID];
				//this.removeChild(this._previousScreenInTransition, !(item.screen is DisplayObject));
				this._previousScreenInTransition.visible = false;

				// Flatten old screen 
				(this._previousScreenInTransition as Screen).flatten();
				
				this._previousScreenInTransition = null;
				this._previousScreenInTransitionID = null;
			}
			this._transitionIsActive = false;

			if(this._clearAfterTransition)
			{
				this.clearScreen();
			}
			else if(this._nextScreenID)
			{
				this.showScreen(this._nextScreenID);
			}

			this._nextScreenID = null;
			this._clearAfterTransition = false;
		}
		
		private function createScreenListener(screenID:String):Function
		{
			const self:ContentManipulator = this;
			const eventListener:Function = function(...rest:Array):void
			{
				self.showScreen(screenID);
			}

			return eventListener;
		}
		
		protected function onAddedToStage(event:Event):void
		{
			//this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
		}
		
		protected function stage_resizeHandler(event:ResizeEvent):void
		{
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}
	}

}