package view.game 
{
	import feathers.controls.Screen;
    import flash.geom.Point;
	import view.screens.Game;
    
    import starling.display.DisplayObject;
    import starling.display.Sprite;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

	public class TouchSheet extends Sprite
	{
		private var _content:DisplayObject;
		
		public function TouchSheet(contents:DisplayObject=null) 
		{
            this._content = contents;			
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touches:Vector.<Touch> = event.getTouches(_content, TouchPhase.MOVED);
			
            if (touches.length == 1)
            {
                // one finger touching -> move
                var delta:Point = touches[0].getMovement(parent);
				if (checkBorders(delta.x, delta.y))
				{
					_content.x += delta.x;
					_content.y += delta.y;
				}
            }            
            else if (touches.length == 2)
            {
                // two fingers touching -> rotate and scale
                var touchA:Touch = touches[0];
                var touchB:Touch = touches[1];
                
                var currentPosA:Point  = touchA.getLocation(_content);
                var previousPosA:Point = touchA.getPreviousLocation(_content);
                var currentPosB:Point  = touchB.getLocation(_content);
                var previousPosB:Point = touchB.getPreviousLocation(_content);
                
                var currentVector:Point  = currentPosA.subtract(currentPosB);
                var previousVector:Point = previousPosA.subtract(previousPosB);
                
                //var currentAngle:Number  = Math.atan2(currentVector.y, currentVector.x);
                //var previousAngle:Number = Math.atan2(previousVector.y, previousVector.x);
                //var deltaAngle:Number = currentAngle - previousAngle;
                
				// update pivot point based on previous center
				var previousLocalA:Point  = touchA.getPreviousLocation(_content);
				var previousLocalB:Point  = touchB.getPreviousLocation(_content);
				//pivotX = (previousLocalA.x + previousLocalB.x) * 0.5;
				//pivotY = (previousLocalA.y + previousLocalB.y) * 0.5;
				
				// update location based on the current center
				// _content.x = currentPosA.x + currentPosB.x;
				// _content.y = currentPosA.y + currentPosB.y;
				
				// rotate
                //rotation += deltaAngle;

                // scale
                var sizeDiff:Number = (currentVector.length / previousVector.length - 1) / 2;
				if (_content.scaleX + sizeDiff >= 0.6 && _content.scaleX + sizeDiff <= 1.5)
				{
					_content.scaleX += sizeDiff;
					_content.scaleY += sizeDiff;
				}
				else if (_content.scaleX + sizeDiff >= 1.5)
				{
					_content.scaleX = _content.scaleY = 1.5;
				}
				else
				{
					_content.scaleX = _content.scaleY = 0.6;
				}
            }
            
            var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
            
            //if (touch && touch.tapCount == 2)
            //    parent.addChild(this); // bring self to front
            
            // enable this code to see when you're hovering over the object
            //touch = event.getTouch(this, TouchPhase.HOVER);            
            //alpha = touch ? 0.8 : 1.0;
        }
		
		private function checkBorders(deltaX:Number, deltaY:Number):Boolean
		{
			if(_content.x + deltaX > (parent as Game).ActualWidth)
				return false;
			if(_content.x + deltaX < parent.x)
				return false;
			if(_content.y + deltaY > (parent as Game).ActualHeight)
				return false;
			if(_content.y + deltaY < parent.y)			
				return false;
			
			return true;
		}
		
		public function disable():void
		{
			_content.removeEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		public function enable():void
		{
			_content.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
        public override function dispose():void
        {
            _content.removeEventListener(TouchEvent.TOUCH, onTouch);
            super.dispose();
        }
		
	}

}