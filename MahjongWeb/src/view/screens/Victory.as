package view.screens 
{
	import feathers.controls.Button;
	import feathers.controls.Screen;
	import feathers.controls.ScreenHeader;
	import feathers.core.FeathersControl;
	import feathers.core.ITextRenderer;
	import feathers.display.Image;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	import util.Assets;
	import view.data.GameData;
	
	public class Victory extends Screen 
	{
		
		private static const ON_BACK:String = "onBack";
		private static const ON_MENU:String = "onMenu";
		
		private var _gameData:GameData;
		
		private var _header:ScreenHeader;
		
		private var _backButton:Button;
		private var _menuButton:Button;
		private var _submitButton:Button;
		
		private var _victoryFlag:Image;
		private var _victoryFlag2:Image;
		
		private var _scoreLabel:ITextRenderer;
		private var _timeLabel:ITextRenderer;
		private var _rankLabel:ITextRenderer;
		
		private var particle:PDParticleSystem;
		private var particle2:PDParticleSystem;
		
		public function Victory() 
		{
			super();
		}
		
		override protected function initialize():void
		{
			this._scoreLabel = FeathersControl.defaultTextRendererFactory();
			this._scoreLabel.text = "Score: " + gameData.score;
			this.addChild(DisplayObject(this._scoreLabel));
			
			this._timeLabel = FeathersControl.defaultTextRendererFactory();
			this._timeLabel.text = gameData.time;
			this.addChild(DisplayObject(this._timeLabel));
			
			this._rankLabel = FeathersControl.defaultTextRendererFactory();
			this._rankLabel.text = "Rank: " + gameData.rank;
			this.addChild(DisplayObject(this._rankLabel));
			
			this._backButton = new Button();
			this._backButton.label = "Back";
			this._backButton.onRelease.add(backButton_onRelease);
			this._backButton.validate();
			
			this._menuButton = new Button();
			this._menuButton.label = "Main Menu";
			this._menuButton.onRelease.add(menuButton_onRelease);
			this._menuButton.validate();

			this._submitButton = new Button();
			this._submitButton.label = "Submit score";
			this._submitButton.onRelease.add(submitButton_onRelease);
			addChild(this._submitButton);
			this._submitButton.validate();	
			
			this._header = new ScreenHeader();
			this._header.title = "Victory!";

			this._header.leftItems = new <DisplayObject>
			[
				this._backButton
			];
			this._header.rightItems = new <DisplayObject>
			[
				this._menuButton
			];
				
			particle = new PDParticleSystem(Assets.getParticleXML("Victory"), 
				Assets.getTexture("VictoryParticleTexture"));
			particle2 = new PDParticleSystem(Assets.getParticleXML("Victory"), 
				Assets.getTexture("VictoryParticleTexture"));
			
			this._victoryFlag = new Image(util.Assets.getAssetsTexture("victoryFlag"));
			this._victoryFlag2 = new Image(util.Assets.getAssetsTexture("victoryFlag"));
				
			// handles the back hardware key on android
			this.backButtonHandler = this.onBackButton;
		}
		
		override protected function draw():void
		{
			addChild(this._victoryFlag);
			addChild(this._victoryFlag2);
			this.addChild(this._header);
			this.addChild(particle);
			this.addChild(particle2);
			Starling.juggler.add(particle);
			Starling.juggler.add(particle2);
			
			const spacingX:Number = this.originalWidth * 0.06 * this.dpiScale;
			const spacingY:Number = this.originalHeight * 0.06 * this.dpiScale;
			
			this._header.width = this.actualWidth;
			this._header.validate();
			
			const displayScoreText:FeathersControl = FeathersControl(this._scoreLabel);
			displayScoreText.validate();
			
			const displayTimeText:FeathersControl = FeathersControl(this._timeLabel);
			displayTimeText.validate();			
			
			const displayRankText:FeathersControl = FeathersControl(this._rankLabel);
			displayRankText.validate();
			
			const maxWidth:Number = Math.max(displayScoreText.width, displayTimeText.width, displayRankText.width);
			
			displayScoreText.x = (this.actualWidth - maxWidth) / 2;
			displayScoreText.y = spacingY + this._header.height;
			displayTimeText.x = displayScoreText.x;
			displayTimeText.y = displayScoreText.y + displayScoreText.height + spacingY;
			displayRankText.x = displayScoreText.x;
			displayRankText.y = displayTimeText.y + displayTimeText.height + spacingY;
			
			trace(_submitButton.width);
			this._submitButton.x = (this.actualWidth - _submitButton.width) * .5;
			this._submitButton.y = displayRankText.y + displayTimeText.height + spacingY;
			
			this._victoryFlag.x = (this.actualWidth - maxWidth) / 2 - this._victoryFlag.width - spacingX * 5;
			this._victoryFlag.y = 0;
			
			this._victoryFlag2.x = (this.actualWidth + maxWidth) / 2 + spacingX * 5;
			this._victoryFlag2.y = 0;
			
			particle.x = _victoryFlag.x + _victoryFlag.width / 2;
			particle.y = _victoryFlag.height;
			particle2.x = _victoryFlag2.x + _victoryFlag2.width / 2;
			particle2.y = _victoryFlag2.height;
			particle.start();
			particle2.start();
		}
		
		public function initVictory():void
		{
			if (particle != null && particle2 != null)
			{
				addChild(particle);
				addChild(particle2);
				Starling.juggler.add(particle);
				Starling.juggler.add(particle2);
				particle.start();
				particle2.start();
			}
			
			if (this._scoreLabel != null)
			{
				this._scoreLabel.text = "Score: " + gameData.score;
				this._timeLabel.text = gameData.time;
				this._rankLabel.text = "Rank: " + gameData.rank;
			}
		}
		
		public function set gameData(value:GameData):void
		{
			this._gameData = value;
		}
		
		public function get gameData():GameData
		{
			return this._gameData;
		}
		
		private function backButton_onRelease(button:Button):void
		{
			stopParticles();
			this.onBackButton();
		}
		
		private function menuButton_onRelease(button:Button):void
		{
			stopParticles();
			this.onMenuButton();
		}
		
		private function submitButton_onRelease(button:Button):void
		{
			stopParticles();
		}
		
		private function onBackButton():void
		{
			this.dispatchEvent(new Event(ON_BACK));
		}
		
		private function onMenuButton():void
		{
			this.dispatchEvent(new Event(ON_MENU));
		}
		
		private function stopParticles():void
		{
			particle.stop();
			particle2.stop()
			Starling.juggler.remove(particle);
			Starling.juggler.remove(particle2);
			removeChild(particle);
			removeChild(particle2);
		}
		
	}
}