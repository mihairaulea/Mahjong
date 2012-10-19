package view.screens 
{
	import feathers.controls.Button;
	import feathers.controls.Screen;
	import feathers.controls.ScreenHeader;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.core.FeathersControl;
	import flash.text.TextFormat;
	import starling.display.DisplayObject;
	import starling.events.Event;

	public class HowTo extends Screen 
	{
		private static const ON_BACK:String = "onBack";
		
		private var _backButton:Button;
		private var _header:ScreenHeader;
		
		private var _instructions1:TextFieldTextRenderer;
		private var _instructions2:TextFieldTextRenderer;
		private var _instructions3:TextFieldTextRenderer;
		
		public function HowTo() 
		{
			super();
		}
		
		override protected function initialize():void
		{
			this._backButton = new Button();
			this._backButton.label = "Back";
			this._backButton.onRelease.add(backButton_onRelease);

			this._header = new ScreenHeader();
			this._header.title = "How To Play";
			this.addChild(this._header);
			this._header.leftItems = new <DisplayObject>
			[
				this._backButton
			];
			
			const FontNames:String = "Helvetica Neue,Helvetica,Arial,_sans";
			const textColor:uint = 0xe5e5e5;
			
			this._instructions1 = FeathersControl.defaultTextRendererFactory();
			this._instructions1.text = "IN  WORLD  MAHJONG,  YOU  CAN  REMOVE  ANY  2  TILES  THAT DISPLAY THE SAME SYMBOL";
			this._instructions1.wordWrap = true;
			addChild(DisplayObject(this._instructions1));
			
			this._instructions2 = FeathersControl.defaultTextRendererFactory();
			this._instructions2.text = "HOWEVER, IN ORDER TO OBTAIN A LARGER SCORE, REMOVE ONLY FREE PIECES.";
			this._instructions2.wordWrap = true;
			addChild(DisplayObject(this._instructions2));
			
			this._instructions3 = FeathersControl.defaultTextRendererFactory();
			this._instructions3.text = "A PIECE IS FREE IF IT'S LEFT OR RIGHT IS AN EMPTY SPACE.";
			this._instructions3.wordWrap = true;
			addChild(DisplayObject(this._instructions3));
			
			// handles the back hardware key on android
			this.backButtonHandler = this.onBackButton;			
		}
		
		override protected function draw():void
		{
			const spacingY:Number = this.originalHeight * 0.1 * this.dpiScale;
			
			this._header.width = this.actualWidth;
			this._header.validate();
			
			const displayTextInstructions1:FeathersControl = FeathersControl(this._instructions1);
			displayTextInstructions1.setSize(this.actualWidth / 2, this.actualHeight / 6);
			displayTextInstructions1.validate();
			
			const displayTextInstructions2:FeathersControl = FeathersControl(this._instructions2);
			displayTextInstructions2.setSize(this.actualWidth / 2, this.actualHeight / 6);
			displayTextInstructions2.validate();
			
			const displayTextInstructions3:FeathersControl = FeathersControl(this._instructions3);
			displayTextInstructions3.setSize(this.actualWidth / 2, this.actualHeight / 6);
			displayTextInstructions3.validate();
			
			displayTextInstructions1.x = (this.actualWidth - displayTextInstructions1.width) / 2;
			displayTextInstructions1.y = this._header.height + spacingY;
			displayTextInstructions2.x = (this.actualWidth - displayTextInstructions2.width) / 2;
			displayTextInstructions2.y = displayTextInstructions1.y + displayTextInstructions1.height + spacingY;
			displayTextInstructions3.x = (this.actualWidth - displayTextInstructions3.width) / 2;
			displayTextInstructions3.y = displayTextInstructions2.y + displayTextInstructions2.height + spacingY;
		}
		
		private function backButton_onRelease(button:Button):void
		{
			this.onBackButton();
		}
		
		private function onBackButton():void
		{
			this.dispatchEvent(new Event(ON_BACK));
		}
	}

}