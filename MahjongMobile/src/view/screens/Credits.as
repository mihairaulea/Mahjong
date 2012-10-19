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
	
	public class Credits extends Screen 
	{
		private static const ON_BACK:String = "onBack";
		
		private var _backButton:Button;
		private var _header:ScreenHeader;
		
		private var _textLine1:TextFieldTextRenderer;
		private var _textLine2:TextFieldTextRenderer;
		private var _textLine3:TextFieldTextRenderer;
		private var _textTitle:TextFieldTextRenderer;
		
		public function Credits() 
		{
			super();
		}
		
		override protected function initialize():void
		{
			this._backButton = new Button();
			this._backButton.label = "Back";
			this._backButton.onRelease.add(backButton_onRelease);

			this._header = new ScreenHeader();
			this._header.title = "Credits";
			this.addChild(this._header);
			this._header.leftItems = new <DisplayObject>
			[
				this._backButton
			];
			
			const FontNames:String = "Helvetica Neue,Helvetica,Arial,_sans";
			const textColor:uint = 0xe5e5e5;
			const titleColor:uint = 0xff9900;
			
			this._textTitle = FeathersControl.defaultTextRendererFactory();
			this._textTitle.text = "Team Members";
			this._textTitle.textFormat = new TextFormat(FontNames, Math.round(34 * this.dpiScale), titleColor, true);
			addChild(DisplayObject(this._textTitle));
			
			this._textLine1 = FeathersControl.defaultTextRendererFactory();
			this._textLine1.text = "Programming: Mihai Raulea - mihai.raulea@geekvillage.com";
			addChild(DisplayObject(this._textLine1));
			
			this._textLine2 = FeathersControl.defaultTextRendererFactory();
			this._textLine2.text = "Programming: Cojocea Sabin - cojoceasabin@gmail.com";
			addChild(DisplayObject(this._textLine2));
			
			this._textLine3 = FeathersControl.defaultTextRendererFactory();
			this._textLine3.text = "Graphics: Raluca Borangic - spiraluca@yahoo.com";
			addChild(DisplayObject(this._textLine3));
			
			// handles the back hardware key on android
			this.backButtonHandler = this.onBackButton;
		}
		
		override protected function draw():void
		{
			const spacingY:Number = this.originalHeight * 0.1 * this.dpiScale;
			
			this._header.width = this.actualWidth;
			this._header.validate();
			
			const displayTextTitle:FeathersControl = FeathersControl(this._textTitle);
			displayTextTitle.validate();
			const displayTextLine1:FeathersControl = FeathersControl(this._textLine1);
			displayTextLine1.validate();
			const displayTextLine2:FeathersControl = FeathersControl(this._textLine2);
			displayTextLine2.validate();
			const displayTextLine3:FeathersControl = FeathersControl(this._textLine3);
			displayTextLine3.validate();
			//const displayTextLine4:FeathersControl = FeathersControl(this._textLine4);
			
			
			const maxLineWidth:Number = Math.max(displayTextLine1.width, displayTextLine2.width, displayTextLine3.width);
			
			displayTextTitle.x = (this.actualWidth - displayTextTitle.width) / 2
			displayTextTitle.y = this._header.height + spacingY;
			displayTextLine1.x = (this.actualWidth - maxLineWidth) / 2;
			displayTextLine1.y = displayTextTitle.y + displayTextTitle.height + spacingY * 2;
			displayTextLine2.x = displayTextLine1.x + (maxLineWidth - displayTextLine2.width) / 2;
			displayTextLine2.y = displayTextLine1.y + displayTextLine1.height + spacingY;
			displayTextLine3.x = displayTextLine1.x + (maxLineWidth - displayTextLine3.width) / 2;
			displayTextLine3.y = displayTextLine2.y + displayTextLine2.height + spacingY;
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