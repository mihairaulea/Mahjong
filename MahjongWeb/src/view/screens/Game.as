package view.screens 
{
	import com.greensock.TweenMax;
	import feathers.controls.Button;
	import feathers.controls.Screen;
	import feathers.controls.ScreenHeader;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.FeathersControl;
	import feathers.core.ITextRenderer;
	import feathers.display.Image;
	import feathers.display.Sprite;
	import flash.events.TimerEvent;
	import flash.sampler.NewObjectSample;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import model.BonusManager;
	import model.levelGenerator.LevelGenerator;
	import model.levelsMatrixes.LevelMatrix;
	import model.levelsMatrixes.LevelMatrixDataSource;
	import model.pieces.Piece;
	import model.pieces.PiecesDataSource;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.textures.Texture;
	import view.data.GameData;
	import view.game.pieces.PiecesManager;
	import model.xmlParsers.PiecesParser;
	import model.GameConstants;
	import view.game.pieces.PieceVisual;
	import util.SoundManager;
	
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
		private var _textPiecesLabel:ITextRenderer;
		private var _textScoreLabel:ITextRenderer;
		private var _textTime:ITextRenderer;
		private var _bonusLabel:TextFieldTextRenderer;
		private var _displayBonusLabel:DisplayObject;
		
		
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
			this._textPiecesLabel.text = "Pieces left: 0";
			
			this._textScoreLabel = FeathersControl.defaultTextRendererFactory();
			this._textScoreLabel.text = "Score: 0";
			
			this._textTime = FeathersControl.defaultTextRendererFactory();
			this._textTime.text = "Time: 0:00";
			
			this._bonusLabel = new TextFieldTextRenderer();
			var bonusFormat = new TextFormat("trajanPro", 24, 0xC52126, true);
			this._bonusLabel.embedFonts = true;
			this._bonusLabel.textFormat = bonusFormat;
			this._bonusLabel.text = "Bonus +" +String( GameConstants.MAHJONG_CLASSIC_BONUS );
			
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
				DisplayObject(this._textTime),
				DisplayObject(this._textScoreLabel),
				this._resetButton
			];
			
			this.initHUD();
			
			this.backButtonHandler = this.onBackButton;
			
			piecesManager = new PiecesManager();			
			piecesManager.addEventListener(PiecesManager.BONUS_FOR_CLASSIC, bonusForClassic);
			piecesManager.addEventListener(PiecesManager.PIECES_REMOVED, piecesRemovedHandler);
			this.addChild(piecesManager);
		}
		
		override protected function draw():void
		{	
			var pieceDim:PieceVisual = new PieceVisual(1);
			pieceDim.pieceId = 1;
			
			this._header.width = this.actualWidth;
			this._header.gap = this.originalWidth * 0.1 * this.dpiScale;
			this._header.validate();
			
			this._separatorX = this.originalWidth * 0.0001 * this.dpiScale;
			this._separatorY = this.originalHeight * 0.0001 * this.dpiScale;
			this._displacementX = this.originalWidth * 0.0005 * this.dpiScale;
			this._displacementY = this.originalWidth * 0.0005 * this.dpiScale;;
			this._piecesMaxWidth = pieceDim.width * 18 + this._separatorX * 17 + this._displacementX * 5;
			this._piecesMaxHeight = pieceDim.height * 8 + this._separatorY * 7 + this._displacementY * 5;
			
			this._displayBonusLabel = DisplayObject(this._bonusLabel);
			this._displayBonusLabel.alpha = 0;
			addChild(this._displayBonusLabel);
			//this._displayBonusLabel.validate();
				
			if(this.piecesManager.width > (this.actualWidth * 0.8))
			{
				this.piecesManager.width = Math.round(this.actualWidth * 0.8);
				this.piecesManager.scaleY = this.piecesManager.scaleX;
			}
			
			this.piecesManager.x = (this.actualWidth - this.piecesManager.width) / 2;
			this.piecesManager.y = (this.actualHeight - this.piecesManager.height ) / 2 + this._header.height;
			
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
			this._textPiecesLabel.text = "Pieces left: " + piecesManager.noOfPieces.toString();
			//piecesManager.loadMoves(moves);
		}
		
		private function piecesRemovedHandler(event:Event):void
		{
			this._textPiecesLabel.text = "Pieces left: " + piecesManager.noOfPieces.toString();
			this.setPoints(piecesManager.getPoints( noOfSeconds ));
			if (piecesManager.didWin() == true) 
			{
				gameWon();
				this.gameData.score = this.finalScore.toString();
				this.gameData.time = this._textTime.text;
				this.gameData.rank = BonusManager.getStatForScore(this.finalScore);
				dispatchEvent(new Event(ON_VICTORY));
			}
		}
		
		private function bonusForClassic(event:Event):void
		{
			this._displayBonusLabel.alpha = 1;
			this._displayBonusLabel.x = this.actualWidth - this._displayBonusLabel.width - this._separatorX * 120;
			this._displayBonusLabel.y = this.actualHeight - this._displayBonusLabel.height - this._separatorY * 20;
			
			const endTweenPosition = this._displayBonusLabel.y - this._displayBonusLabel.height;
			TweenMax.to(this._displayBonusLabel, 1.2, { alpha:0, y:endTweenPosition } );
		}
		
		private function initHUD():void
		{
				startTime();
		}
		
		private function resetHUD():void
		{
			this._textPiecesLabel.text = "Pieces left: 0";
			this._textScoreLabel.text = "Score: 0";
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
			
			if (this._textScoreLabel.text == "Score: 0")
				currentScore = 0;
		}
		
		private function timerTickPoints(e:TimerEvent):void
		{
			if (currentScore < finalScore) 
			{
				currentScore += 1;
				this._textScoreLabel.text = "Score: " + String(currentScore);
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
	}

}