package view.screens 
{
	import feathers.controls.Button;
	import feathers.controls.Screen;
	import feathers.controls.ScreenHeader;
	import feathers.controls.Slider;
	import feathers.controls.ToggleSwitch;
	import feathers.core.ITextRenderer;
	import feathers.core.FeathersControl;
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	import util.SoundManager;
	import util.SoundGlobalVariables;
	
	public class Options extends Screen 
	{
		private static const ON_BACK:String = "onBack";
		
		public function Options() 
		{
			super();
		}
		
		private var _backButton:Button;
		private var _header:ScreenHeader;
		
		private var _sliderMusic:Slider;
		private var _toggleMusic:ToggleSwitch;
		private var _valueMusic:ITextRenderer;
		private var _textMusic:ITextRenderer;
		
		private var _sliderSound:Slider;
		private var _toggleSound:ToggleSwitch;
		private var _valueSound:ITextRenderer;
		private var _textSound:ITextRenderer;
		
		private var soundManager:SoundManager = SoundManager.getInstance();
		
		override protected function initialize():void
		{
			this._toggleMusic = new ToggleSwitch();
			this._toggleMusic.isSelected = SoundGlobalVariables.PLAY_AMBIENT;
			this._toggleMusic.onChange.add(toggleMusic_onChange);
			this.addChild(_toggleMusic);
			
			this._toggleSound = new ToggleSwitch();
			this._toggleSound.isSelected = SoundGlobalVariables.PLAY_SOUND_EFFECTS;
			this._toggleSound.onChange.add(toggleSound_onChange);
			this.addChild(_toggleSound);
			
			this._sliderMusic = new Slider();
			this._sliderMusic.minimum = 0;
			this._sliderMusic.maximum = 100;
			this._sliderMusic.value = SoundGlobalVariables.AMBIENT_SOUND_VOLUME * 100;
			this._sliderMusic.step = 1;
			this._sliderMusic.page = 10;
			this._sliderMusic.liveDragging = true;
			this._sliderMusic.onChange.add(sliderMusic_onChange);
			this.addChild(this._sliderMusic);
			
			this._valueMusic = FeathersControl.defaultTextRendererFactory();
			this._valueMusic.text = this._sliderMusic.value.toString();
			this.addChild(DisplayObject(this._valueMusic));
			
			this._textMusic = FeathersControl.defaultTextRendererFactory();
			this._textMusic.text = "Music:";
			this.addChild(DisplayObject(this._textMusic));
			
			this._sliderSound = new Slider();
			this._sliderSound.minimum = 0;
			this._sliderSound.maximum = 100;
			this._sliderSound.value = SoundGlobalVariables.SOUND_EFFECTS_VOLUME * 100;
			this._sliderSound.step = 1;
			this._sliderSound.page = 10;
			this._sliderSound.liveDragging = true;
			this._sliderSound.onChange.add(sliderSound_onChange);
			this.addChild(this._sliderSound);
			
			this._valueSound = FeathersControl.defaultTextRendererFactory();
			this._valueSound.text = this._sliderSound.value.toString();
			this.addChild(DisplayObject(this._valueSound));
			
			this._textSound = FeathersControl.defaultTextRendererFactory();
			this._textSound.text = "Sounds:";
			this.addChild(DisplayObject(this._textSound));
			
			this._backButton = new Button();
			this._backButton.label = "Back";
			this._backButton.onRelease.add(backButton_onRelease);

			this._header = new ScreenHeader();
			this._header.title = "Options";
			this.addChild(this._header);
			this._header.leftItems = new <DisplayObject>
			[
				this._backButton
			];
			
			// handles the back hardware key on android
			this.backButtonHandler = this.onBackButton;
		}
		
		override protected function draw():void
		{
			const spacingX:Number = this.originalWidth * 0.02 * this.dpiScale;
			const spacingY:Number = this.originalHeight * 0.06 * this.dpiScale;
			
			this._header.width = this.actualWidth;
			this._header.validate();
			
			this._toggleMusic.validate();
			this._sliderMusic.validate();
			const displayValueMusic:FeathersControl = FeathersControl(this._valueMusic);
			displayValueMusic.validate();
			const displayTextMusic:FeathersControl = FeathersControl(this._textMusic);
			displayTextMusic.validate();
			
			this._toggleSound.validate();
			this._sliderSound.validate();
			const displayValueSound:FeathersControl = FeathersControl(this._valueSound);
			displayValueSound.validate();
			const displayTextSound:FeathersControl = FeathersControl(this._textSound);
			displayTextSound.validate();
			
			const lineHeight:Number = Math.max(this._sliderMusic.height, this._toggleMusic.height)
			const contentHeight:Number = 2 * (lineHeight + spacingY); 
			const contentWidth:Number = Math.max(this._sliderMusic.width + this._toggleMusic.width  + 2 * spacingX
				,this._sliderSound.width + this._toggleSound.width);
			
			this._toggleMusic.x = (this.actualWidth - contentWidth) / 2;
			this._toggleMusic.y = (this.actualHeight - contentHeight) / 2;
			this._sliderMusic.x = this._toggleMusic.x + this._toggleMusic.width + spacingX;
			this._sliderMusic.y = this._toggleMusic.y + this._toggleMusic.height / 2 - this._sliderMusic.height / 2;
			displayValueMusic.x = this._sliderMusic.x + this._sliderMusic.width + spacingX;
			displayValueMusic.y = this._sliderMusic.y + (this._sliderMusic.height - displayValueMusic.height) / 2;
			displayTextMusic.x = this._toggleMusic.x - displayTextMusic.width - spacingX;
			displayTextMusic.y = this._sliderMusic.y + (this._sliderMusic.height - displayValueMusic.height) / 2;
			
			this._toggleSound.x = this._toggleMusic.x;
			this._toggleSound.y = this._toggleMusic.y + this._toggleMusic.height + spacingY;
			this._sliderSound.x = this._sliderMusic.x;
			this._sliderSound.y = this._toggleSound.y + this._toggleSound.height / 2 - this._sliderMusic.height / 2;
			displayValueSound.x = this._sliderSound.x + this._sliderSound.width + spacingX;
			displayValueSound.y = this._sliderSound.y + (this._sliderSound.height - displayValueSound.height) / 2;
			displayTextSound.x = this._toggleSound.x - displayTextSound.width - spacingX;
			displayTextSound.y = this._sliderSound.y + (this._sliderSound.height - displayValueSound.height) / 2;
			
		}
		
		private function toggleMusic_onChange(toggleSwitch:ToggleSwitch):void
		{
			soundManager.setAmbientPlay(this._toggleMusic.isSelected);
		}
		
		private function toggleSound_onChange(toggleSwitch:ToggleSwitch):void
		{
			soundManager.setEffectsPlay(this._toggleSound.isSelected);
		}
		
		private function sliderMusic_onChange(slider:Slider):void
		{
			this._valueMusic.text = this._sliderMusic.value.toString();
			soundManager.setAmbientSoundVolume(this._sliderMusic.value);
		}
		
		private function sliderSound_onChange(slider:Slider):void
		{
			this._valueSound.text = this._sliderSound.value.toString();
			soundManager.setEffectsSoundVolume(this._sliderSound.value);
			
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