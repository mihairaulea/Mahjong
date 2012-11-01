package view.screens 
{
	import feathers.controls.Screen;
	import feathers.display.Image;
	import starling.events.Event;
	
	import feathers.controls.Screen;
	import feathers.controls.ScreenHeader;
	import feathers.controls.Button;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import util.Assets;
	
	public class FirstScreen extends Screen 
	{	
		public function FirstScreen() 
		{
			super();
		}
		
		private static const LABELS:Vector.<String> = new <String>
		[
			"Play",
			"Multiplayer",
			"High Scores",
			"Options",
			"Credits"
		];
		
		private static const EVENTS:Vector.<String> = new <String>
		[
			"onLevelBrowser",
			"onMultiplayer",
			"onHighscores",
			"onOptions",
			"onCredits"
		];
		
		private var _buttons:Vector.<Button> = new <Button>[];
		private var _buttonMaxWidth:Number = 0;
		private var _buttonMaxHeight:Number = 0;
		
		private var _logoImage:Image;
		private var _flagImage:Image;
		private var _flagImage2:Image;
		
		override protected function initialize():void
		{
			const buttonCount:int = LABELS.length;
			for (var i:int = 0; i < buttonCount; i++)
			{
				var label:String = LABELS[i];
				var event:String = EVENTS[i];
				var button:Button = new Button();
				button.label = label;
				button.height = 50;
				this.triggerSignalOnButtonRelease(button, event);
				addChild(button);
				this._buttons.push(button);
				button.validate();
				this._buttonMaxWidth = Math.max(this._buttonMaxWidth, button.width);
				this._buttonMaxHeight = Math.max(this._buttonMaxHeight, button.height);
				
				this._logoImage = new Image(util.Assets.getAssetsTexture("logo"));
				this._flagImage = new Image(util.Assets.getAssetsTexture("menuFlag"));
				this._flagImage2 = new Image(util.Assets.getAssetsTexture("menuFlag"));
			}
		}
		
		override protected function draw():void
		{
			const margin:Number = this.originalHeight * 0.06 * this.dpiScale;
			const spacingX:Number = this.originalHeight * 0.06 * this.dpiScale;
			const spacingY:Number = this.originalHeight * 0.06 * this.dpiScale;
			
			const contentMaxWidth:Number = this.actualWidth - 2 * margin;
			const contentMaxHeight:Number = this.actualHeight - 2 * margin;
			const buttonCount:int = _buttons.length;
			var verticalButtonCount:int = 1;
			var verticalButtonCombinedHeight:Number = this._buttonMaxHeight;
			while((verticalButtonCombinedHeight + this._buttonMaxHeight + spacingY) <= contentMaxHeight)
			{
				verticalButtonCombinedHeight += this._buttonMaxHeight + spacingY;
				verticalButtonCount++;
				if(verticalButtonCount == buttonCount)
					break;
				
			}
			
			addChild(this._logoImage);
			this._logoImage.x = (this.actualWidth - _logoImage.width) / 2;
			this._logoImage.y = 10;			
			
			const startY:Number = (this.actualHeight - verticalButtonCombinedHeight - this._logoImage.height) / 2 + this._logoImage.height;
			var positionX:Number = (this.actualWidth - this._buttonMaxWidth) / 2;
			var positionY:Number = startY;
			for (var i:int = 0; i < buttonCount; i++)
			{
				var button:Button = this._buttons[i];
				button.width = this._buttonMaxWidth;
				button.x = positionX;
				button.y = positionY;
				positionY += this._buttonMaxHeight + spacingY;
				if (positionY + this._buttonMaxHeight > margin + contentMaxHeight)
				{
					positionY = startY;
					positionX += this._buttonMaxWidth + spacingX;
				}	
			}
			
			addChild(this._flagImage);
			this._flagImage.x = (this.actualWidth - this._buttonMaxWidth) / 2 - this._flagImage.width - spacingX * 2;
			this._flagImage.y = 0;
			
			addChild(this._flagImage2);
			this._flagImage2.x = (this.actualWidth + this._buttonMaxWidth) / 2 + spacingX * 2;
			this._flagImage2.y = 0;
			
		}

		private function triggerSignalOnButtonRelease(button:Button, event:String):void
		{
			button.onRelease.add(function(button:Button):void
			{
				dispatchEvent(new Event(event));
			});

		}

	}

}