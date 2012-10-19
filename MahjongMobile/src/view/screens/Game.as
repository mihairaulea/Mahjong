package view.screens 
{
	import com.greensock.TweenMax;
	import feathers.controls.Button;
	import feathers.controls.Screen;
	import feathers.controls.ScreenHeader;
	import feathers.core.FeathersControl;
	import feathers.core.ITextRenderer;
	import feathers.display.Image;
	import feathers.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.sampler.NewObjectSample;
	import flash.utils.Timer;
	import model.BonusManager;
	import model.levelGenerator.LevelGenerator;
	import model.levelsMatrixes.LevelMatrix;
	import model.levelsMatrixes.LevelMatrixDataSource;
	import model.pieces.Piece;
	import model.pieces.PiecesDataSource;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.textures.Texture;
	import util.Constants;
	import view.data.GameData;
	import view.game.pieces.PiecesManager;
	import model.xmlParsers.PiecesParser;
	import model.GameConstants;
	import view.game.pieces.PieceVisual;
	import util.SoundManager;
	import view.game.TouchSheet;
	
	public class Game extends Screen 
	{
		private static const ON_BACK:String = "onBack";
		private static const ON_RESET:String = "onReset";
		private static const ON_VICTORY:String = "onVictory";
		//private static const ON_SETTINGS:String = "onSettings";
		
		//HUD 
		private var _header:ScreenHeader;
		private var _backButton:Button;
		private var _resetButton:Button;
		//private var _hintButton:Button;
		private var _textPiecesLabel:ITextRenderer;
		private var _textScoreLabel:ITextRenderer;
		private var _textPieces:ITextRenderer;
		private var _textScore:ITextRenderer;
		private var _textTime:ITextRenderer;
		private var _bonusLabel:ITextRenderer;
		private var _displayBonusLabel:FeathersControl;
		
		//HUD vars
		private var gameTimer:Timer;
		private var scoreTimer:Timer;
		private var finalScore:int = 0;
		private var currentScore:int = 0;
		private var noOfSeconds:int;
		
		protected var _gameData:GameData;
		private var piecesManager:PiecesManager;
		
		//Pieces 
		private var _separatorX:Number;
		private var _separatorY:Number;
		private var _piecesMaxWidth:Number;
		private var _piecesMaxHeight:Number;
		private var _displacementX:Number;
		private var _displacementY:Number;
		
		// Mobile only
		private var touchSheet:TouchSheet;
		private var piecesMask:Rectangle;
		
		//Level generator
		private var _levelGenerator:LevelGenerator = new LevelGenerator();
		
		private var soundManager:SoundManager = SoundManager.getInstance();
		
		public function Game() 
		{
			super();
		}
		
		override protected function initialize():void
		{	
			
			this._backButton = new Button();
			this._backButton.label = "Back";
			this._backButton.onRelease.add(backButton_onRelease);
			
			this._resetButton = new Button();
			this._resetButton.label = "Reset";
			this._resetButton.onRelease.add(resetButton_onRelease);
			
			this._textPiecesLabel = FeathersControl.defaultTextRendererFactory();
			this._textPiecesLabel.text = "Pieces left: ";
			
			this._textPieces = FeathersControl.defaultTextRendererFactory();
			this._textPieces.text = "0";
			
			this._textScoreLabel = FeathersControl.defaultTextRendererFactory();
			this._textScoreLabel.text = "Score: ";
			
			this._textScore = FeathersControl.defaultTextRendererFactory();
			this._textScore.text = "0";
			
			this._textTime = FeathersControl.defaultTextRendererFactory();
			this._textTime.text = "Time: 0:00";
			
			this._bonusLabel = FeathersControl.defaultTextRendererFactory();
			this._bonusLabel.text = "Bonus +250";
			
			this._header = new ScreenHeader();
			this._header.title = "";
			this.addChild(this._header);
			this._header.leftItems = new <DisplayObject>
			[
				this._backButton
			];
			this._header.rightItems = new <DisplayObject>
			[
				DisplayObject(this._textPiecesLabel),
				DisplayObject(this._textPieces),
				DisplayObject(this._textTime),
				DisplayObject(this._textScoreLabel),
				DisplayObject(this._textScore),
				this._resetButton
			];
			
			this.initHUD();
			
			this.backButtonHandler = this.onBackButton;
			
			piecesManager = new PiecesManager();			
			piecesManager.addEventListener(PiecesManager.BONUS_FOR_CLASSIC, bonusForClassic);
			piecesManager.addEventListener(PiecesManager.PIECES_REMOVED, piecesRemovedHandler);
			this.addChild(piecesManager);
			
			// Mobile only - zoom parameters
			touchSheet = new TouchSheet(piecesManager);
			this.addChild(touchSheet);
		}
		
		override protected function draw():void
		{	
			
			this._header.width = this.actualWidth;
			this._header.gap = this.originalWidth * 0.1 * this.dpiScale;
			this._header.validate();
			
			this._separatorX = this.originalWidth * 0.0001 * this.dpiScale;
			this._separatorY = this.originalHeight * 0.0001 * this.dpiScale;
			this._displacementX = this.originalWidth * 0.0005 * this.dpiScale;
			this._displacementY = this.originalWidth * 0.0005 * this.dpiScale;;
			
			this._displayBonusLabel = FeathersControl(this._bonusLabel);
			this._displayBonusLabel.alpha = 0;
			addChild(this._displayBonusLabel);
			this._displayBonusLabel.validate();
			
			// Mobile only masking
			piecesMask = new Rectangle();
			this.piecesMask.x = 0;
			this.piecesMask.y = this._header.height;
			this.piecesMask.width = this.actualWidth;
			this.piecesMask.height = this.actualHeight - this._header.height;
			
			this.piecesManager.centerManager();
			
			if(this.piecesManager.width > (this.actualWidth * 0.8))
			{
					this.piecesManager.width = Math.round(this.actualWidth * 0.8);
					this.piecesManager.scaleY = this.piecesManager.scaleX;
			}
			
			this.piecesManager.x = this.actualWidth / 2;
			this.piecesManager.y = this.actualHeight / 2 + this._header.height;
			
			this.piecesManager.clipRect = piecesMask;
		}
		
		private function resetPiecesPosition():void
		{	
			// Mobile only
			//this.piecesManager.centerManager();
			
			if (Constants.ZOOM_ENABLED == true)
				this.piecesManager.scaleX = this.piecesManager.scaleY = 1;
			
			this.piecesManager.x = this.actualWidth / 2;
			this.piecesManager.y = this.actualHeight / 2 + this._header.height;
		}
		
		private function loadPieces():void
		{
			if (_gameData.piecesInit == false)
			{
				var piecesParser:PiecesParser = new PiecesParser();
				piecesParser.addEventListener(PiecesParser.PIECES_PARSED, piecesParsed);
				piecesParser.initLoader();
			}
			else 
				constructLevel();
		}
		
		private function piecesParsed(e:Event):void
		{
			var piecesDataSource:PiecesDataSource = PiecesDataSource.getInstance();
			piecesDataSource.initPieces();
		}
		
		public function initNewGame():void
		{
			// Generate level

			// Mobile
			resetPiecesPosition();
			if(Constants.ZOOM_ENABLED == true)
				touchSheet.enable();
			else
				touchSheet.disable();
				
			this.loadPieces();
			deinit();
			constructLevel();
		}
		
		private function constructLevel():void
		{	
			_gameData.piecesInit = true;
			
			var piecesDataSource:PiecesDataSource = PiecesDataSource.getInstance();
			
			var levelMatrixDataSource:LevelMatrixDataSource = LevelMatrixDataSource.getInstance();		
			
			this._levelGenerator.init( levelMatrixDataSource.getLevelMatrix(gameData.id.toString()).levelArray );
						
			while (piecesDataSource.piecesLeft())
			{
				var piece:Piece = piecesDataSource.getRandomUsablePiece();				

				if (piece != null)
				{
					//placeArray = 
					this._levelGenerator.placePiece(piece.id);
					piecesDataSource.usePiece(piece.id);
				} else 
				{
					trace("Piece is null!");
					break;
				}
				
			}
			
			piecesManager.init(this._levelGenerator.generatedLevel);
			
			//HUD
			this.resetHUD();
			this.setPoints(piecesManager.points);
			this._textPieces.text = piecesManager.noOfPieces.toString();
			//piecesManager.loadMoves(moves);
		}
		
		private function piecesRemovedHandler(event:Event):void
		{
			this._textPieces.text = piecesManager.noOfPieces.toString();
			this.setPoints(piecesManager.getPoints( noOfSeconds ));
			if (piecesManager.didWin() == true) 
			{
				gameWon();
				this.gameData.score = this._textScore.text;
				this.gameData.time = this._textTime.text;
				this.gameData.rank = BonusManager.getScoreBonusForScore(int(this._textScore.text)).toString();
				dispatchEvent(new Event(ON_VICTORY));
			}
		}
		
		private function bonusForClassic(event:Event):void
		{
			trace("BONUS");
			//Animation
			
			this._displayBonusLabel.alpha = 1;
			this._displayBonusLabel.x = this.actualWidth - this._displayBonusLabel.width - this._separatorX * 100;
			this._displayBonusLabel.y = this.actualHeight - this._displayBonusLabel.height - this._separatorY * 10;
			
			const endTweenPosition = this._displayBonusLabel.y - this._displayBonusLabel.height;
			TweenMax.to(this._displayBonusLabel, 0.8, { alpha:0, y:endTweenPosition } );
			
		}
		
		private function initHUD():void
		{
				startTime();
				//resetHUD();
		}
		
		private function resetHUD():void
		{
			this._textScore.text = "0";
			this._textPieces.text = "0";
			gameTimer.stop();
			gameTimer.removeEventListener(TimerEvent.TIMER, timerTick);
			noOfSeconds = 0;	
			startTime();
		}
		
		private function startTime():void
		{
			gameTimer = new Timer(1000);
			gameTimer.addEventListener(TimerEvent.TIMER, timerTick);
			gameTimer.start();
		}
		
		private function timerTick(e:flash.events.Event):void
		{
			noOfSeconds++;
			var minutes:int = Math.floor(noOfSeconds / 60);
			var leftSeconds:int = noOfSeconds % 60;
			if (leftSeconds < 10) 
				this._textTime.text = "Time: " + minutes + ":0" + leftSeconds;
			else
				this._textTime.text = "Time: " + minutes + ":" + leftSeconds;
		}
		
		private function gameWon():void
		{
			soundManager.playVictorySound();
			gameTimer.stop();
		}
		
		private function setPoints(pointsAmount:int):void
		{
			scoreTimer = new Timer(2);
			scoreTimer.addEventListener(TimerEvent.TIMER, timerTickPoints);
			scoreTimer.start();
			this.finalScore = pointsAmount;
			
			if (this._textScore.text != "")
				currentScore = int(_textScore.text);
			else
				currentScore = 0;
		}
		
		private function timerTickPoints(e:TimerEvent):void
		{
			if (currentScore < finalScore) 
			{
				currentScore++;
				this._textScore.text = String(currentScore);
			}
			else
				scoreTimer.stop();
		}
		
		private function backButton_onRelease(button:Button):void
		{
			this.onBackButton();
		}
		
		private function onBackButton():void
		{
			deinit();
			this.dispatchEvent(new Event(ON_BACK));
		}
		
		private function resetButton_onRelease(button:Button):void
		{
			resetGameRequest();
		}
		
		private function resetGameRequest():void
		{
			deinit();
			resetPiecesPosition();
			constructLevel();
		}
		
		private function deinit():void
		{
			piecesManager.deinit();

			var piecesDataSource:PiecesDataSource = PiecesDataSource.getInstance();
			piecesDataSource.deinit();
			var levelMatrixDataSource:LevelMatrixDataSource = LevelMatrixDataSource.getInstance();
			levelMatrixDataSource.deinit();
			
			this._levelGenerator.deinit();
		}
		
		public function set gameData(value:GameData):void
		{
			this._gameData = value;
		}
		
		public function get gameData():GameData
		{
			return this._gameData;
		}
		
		public function get ActualHeight():Number
		{
			return this.actualHeight;
		}
		
		public function get ActualWidth():Number
		{
			return this.actualWidth;
		}
	}

}