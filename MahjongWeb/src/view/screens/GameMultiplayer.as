package view.screens 
{
	import com.greensock.TweenMax;
	import feathers.controls.Button;
	import feathers.controls.Screen;
	import feathers.controls.ScreenHeader;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.FeathersControl;
	import feathers.core.ITextRenderer;
	import flash.text.TextFormat;
	import model.GameConstants;
	import model.NetworkCommunication;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import util.SoundManager;
	import view.multiplayer.PiecesManagerMp;
	import view.game.pieces.PieceVisual;

	public class GameMultiplayer extends Screen
	{
		private static const ON_LEAVE:String = "onLeave";
		private static const ON_VICTORY:String = "onVictory";
		
		//HUD
		private var _header:ScreenHeader;
		private var _leaveButton:Button;
		private var _textScore:ITextRenderer;
		private var _textTime:ITextRenderer;
		private var _bonusLabel:TextFieldTextRenderer;
		private var _displayBonusLabel:DisplayObject;
		private var _connectionLabel:TextFieldTextRenderer;
		private var _displayConnectionLabel:DisplayObject;
		
		//Logic
		private var piecesManager:PiecesManagerMp;
		
		//Pieces visual
		private var _separatorX:Number;
		private var _separatorY:Number;
		private var _piecesMaxWidth:Number;
		private var _piecesMaxHeight:Number;
		private var _displacementX:Number;
		private var _displacementY:Number;
		
		//Sound
		private var soundManager:SoundManager = SoundManager.getInstance();
		
		//Networking
		private var networkCommunication:NetworkCommunication;
		
		public function GameMultiplayer() 
		{
			super();
		}
		
		override protected function initialize():void
		{
			this._leaveButton = new Button();
			this._leaveButton.label = "Leave";
			this._leaveButton.onRelease.add(leaveButton_onRelease);
			
			this._textScore = FeathersControl.defaultTextRendererFactory();
			this._textScore.text = "Score: 0";
			
			this._textTime = FeathersControl.defaultTextRendererFactory();
			this._textTime.text = "Time left: 1:00";
			
			this._connectionLabel = new TextFieldTextRenderer();
			var connectionFormat = new TextFormat("trajanPro", 16, 0xC52126, true);
			this._connectionLabel.embedFonts = true;
			this._connectionLabel.textFormat = connectionFormat;
			this._connectionLabel.text = "Connecting to server"; 
			addChild(this._connectionLabel);
			this._connectionLabel.validate();
			
			this._bonusLabel = new TextFieldTextRenderer();
			var bonusFormat = new TextFormat("trajanPro", 24, 0xC52126, true);
			this._bonusLabel.embedFonts = true;
			this._bonusLabel.textFormat = bonusFormat;
			this._bonusLabel.text = "Bonus +" + String( GameConstants.MAHJONG_CLASSIC_BONUS ); 
			
			this._header = new ScreenHeader();
			this._header.title = "";
			this.addChild(this._header);
			this._header.leftItems = new <DisplayObject>
			[
				this._leaveButton
			];
			this._header.rightItems = new <DisplayObject>
			[
				DisplayObject(this._textTime),
				DisplayObject(this._textScore)
			];
			
			piecesManager = new PiecesManagerMp();
			addChild(piecesManager);
			
			// Add networking events
			networkCommunication = NetworkCommunication.getInstance();
			networkCommunication.addEventListener(NetworkCommunication.START_GAME, opponentFoundHandler);
			networkCommunication.addEventListener(NetworkCommunication.NEW_WAVE, newWaveHandler);
		}
		
		override protected function draw():void
		{
			var pieceDim:PieceVisual = new PieceVisual(1);
			pieceDim.pieceId = 1;
			
			this._header.width = this.actualWidth;
			this._header.gap = this.originalWidth * 0.1 * this.dpiScale;
			this._header.paddingRight = this.originalWidth * 0.15 * this.dpiScale;
			this._header.validate();
			
			this._separatorX = this.originalWidth * 0.0001 * this.dpiScale;
			this._separatorY = this.originalHeight * 0.0001 * this.dpiScale;
			this._displacementX = this.originalWidth * 0.0005 * this.dpiScale;
			this._displacementY = this.originalWidth * 0.0005 * this.dpiScale;;
			this._piecesMaxWidth = pieceDim.width * 18 * 0.9 + this._separatorX * 17 + this._displacementX * 5;
			this._piecesMaxHeight = pieceDim.height * 8 + this._separatorY * 7 + this._displacementY * 5;
			
			this._displayBonusLabel = DisplayObject(this._bonusLabel);
			this._displayBonusLabel.alpha = 0;
			addChild(this._displayBonusLabel);
			
			this._displayConnectionLabel = DisplayObject(this._connectionLabel);
			this._displayConnectionLabel.x = (this.actualWidth - this._displayConnectionLabel.width) * .5;
			this._displayConnectionLabel.y = (this.actualHeight - this._displayConnectionLabel.height) * .5;
			
			isConnectedHandler(null);
			
			this.piecesManager.x = (this.actualWidth - _piecesMaxWidth) / 2; 
			trace(_piecesMaxWidth, piecesManager.x)
			this.piecesManager.y = this._header.height;
		}
		
		public function startConnection():void
		{
			// Try to connect to the server here
		}
		
		private function isConnectedHandler(e:Event):void
		{
			// Now connected, find opponent
			this._connectionLabel.text = "Finding opponent. Please wait";
			this._connectionLabel.validate();
			this._displayConnectionLabel.x = (this.actualWidth - this._displayConnectionLabel.width) * .5;
			
			networkCommunication.findOpponent();
		}
		
		private function opponentFoundHandler(e:Event):void
		{
			// Opponent in room get ready to start game when tween is done
			this._connectionLabel.text = "Opponent found. Get Ready!";
			this._connectionLabel.validate();
			this._displayConnectionLabel.x = (this.actualWidth - this._displayConnectionLabel.width) * .5;
			
			TweenMax.to(this._displayConnectionLabel, 1, { alpha:0, onComplete:startGame } );
		}
		
		private function startGame():void
		{
			// Game will now start
			updateHUD();
			var testArray:Array = new Array();
			
			for (var i:int = 0; i < 16; i++)
			{
				var pv1:PieceVisual = new PieceVisual(1);
				pv1.pieceUniqueId = i;
				testArray.push(pv1);
			}
			
			var testLayout:int = 1;
			
			piecesManager.placeWave(testArray, testLayout);
			newWaveHandler(null);
		}
		
		public function newWaveHandler(e:Event):void
		{
			
			var testArray:Array = new Array();
			
			for (var i:int = 0; i < 16; i++)
			{
				var pv1:PieceVisual = new PieceVisual(1);
				pv1.pieceUniqueId = i;
				testArray.push(pv1);
			}
			
			piecesManager.placeWave(testArray, 2);
		}
		
		public function updateHUD():void
		{
			
		}
		
		private function pieceBurnedHandler(e:Event):void
		{
			
		}
		
		private function bonusForClassic(event:Event):void
		{
			this._displayBonusLabel.alpha = 1;
			this._displayBonusLabel.x = this.actualWidth - this._displayBonusLabel.width - this._separatorX * 120;
			this._displayBonusLabel.y = this.actualHeight - this._displayBonusLabel.height - this._separatorY * 20;
			
			const endTweenPosition = this._displayBonusLabel.y - this._displayBonusLabel.height;
			TweenMax.to(this._displayBonusLabel, 1.2, { alpha:0, y:endTweenPosition } );
		}
		
		private function leaveButton_onRelease(button:Button):void
		{
			dispatchEvent(new Event(ON_LEAVE));
		}
	}

}