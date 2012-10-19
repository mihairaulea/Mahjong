package view.util 
{
	import feathers.motion.GTween;
	import com.gskinner.motion.easing.Sine;
	import starling.display.DisplayObject;
	
	public class ContentTransition 
	{
		private var _navigator:ContentManipulator;
		private var _stack:Vector.<Class> = new <Class>[];
		private var _activeTransition:GTween;
		private var _savedCompleteHandler:Function;
		
		public var duration:Number = 0.4;
		public var ease:Function = Sine.easeInOut;
		
		public function ContentTransition(contentManipulator:ContentManipulator, quickStack:Class = null) 
		{
			if (!contentManipulator)
			{
				throw new ArgumentError("Content manipulator cannot be null");
			}
			
			this._navigator = contentManipulator;
			if (quickStack)
			{
				this._stack.push(quickStack);
			}
			this._navigator.transition = this.onTransition;
		}
		
		public function clearStack():void
		{
			this._stack.length = 0;
		}
		
		private function onTransition(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
		{
			if (!oldScreen || !newScreen)
			{
				if (newScreen)
				{
					newScreen.x = 0;
				}
				if (oldScreen)
				{
					oldScreen.x = 0;
				}
				onComplete();
				return;
			}
			
			if (this._activeTransition)
			{
				this._activeTransition.paused = true;
				this._activeTransition = null;				
			}
			
			this._savedCompleteHandler = onComplete;
			
			var NewScreenType:Class = Object(newScreen).constructor;
			var stackIndex:int = this._stack.indexOf(NewScreenType);
			var targetX:Number;
			var activeTransition_onChange:Function;
			if (stackIndex < 0)
			{
				var OldScreenType:Class = Object(oldScreen).constructor;
				this._stack.push(OldScreenType);
				oldScreen.x = 0;
				newScreen.x = this._navigator.width;
				activeTransition_onChange = this.activeTransitionPush_onChange;				
			}
			else
			{
				this._stack.length = stackIndex;
				oldScreen.x = 0;
				newScreen.x = -this._navigator.width;
				activeTransition_onChange = this.activeTransitionPop_onChange;
			}
			this._activeTransition = new GTween(newScreen, this.duration,
			{
				x: 0
			},
			{
				data: oldScreen,
				ease: this.ease,
				onChange: activeTransition_onChange,
				onComplete: activeTransition_onComplete
			});
		}
		
		private function activeTransitionPush_onChange(tween:GTween):void
		{
			var newScreen:DisplayObject = DisplayObject(tween.target);
			var oldScreen:DisplayObject = DisplayObject(tween.data);
			oldScreen.x = newScreen.x - this._navigator.width;
		}

		private function activeTransitionPop_onChange(tween:GTween):void
		{
			var newScreen:DisplayObject = DisplayObject(tween.target);
			var oldScreen:DisplayObject = DisplayObject(tween.data);
			oldScreen.x = newScreen.x + this._navigator.width;
		}

		private function activeTransition_onComplete(tween:GTween):void
		{
			this._activeTransition = null;
			if(this._savedCompleteHandler != null)
			{
				this._savedCompleteHandler();
			}
		}
		
		
	}

}