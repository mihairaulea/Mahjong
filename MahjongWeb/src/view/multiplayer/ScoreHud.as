package view.multiplayer 
{
	import com.greensock.TweenMax;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	import flash.events.TimerEvent;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;

	public class ScoreHud extends Sprite
	{
		private var _separator:Quad;
		private var _playerQuad:Quad;
		private var _enemyQuad:Quad;
		
		private var _playerScore:TextFieldTextRenderer;
		private var _displayPlayerScore:DisplayObject;
		private var _enemyScore:TextFieldTextRenderer;
		private var _displayEnemyScore:DisplayObject;
		
		private var _pointDim:Number;
		private var _maxWidth:Number;
		private var _maxScore:int;
		
		private var _playerScoreInt:int;
		private var _enemyScoreInt:int;
		private var _finalPlayerScore:int;
		private var _finalEnemyScore:int;
		
		private var _scoreTimer:Timer;
		
		public function ScoreHud() { }
		
		public function init(maxScore:int, maxWidth:Number, height:Number):void
		{
			_maxScore = maxScore;
			_maxWidth = maxWidth;
			_pointDim = maxWidth * 0.01;
			
			_separator = new Quad(_pointDim, height, 0xC52126);
			_separator.x = - _separator.width * .5;
			addChild(_separator);
			
			_playerQuad = new Quad(_pointDim, height, 0x038249);
			_playerQuad.x = - maxWidth * .5;
			addChild(_playerQuad);
			
			_playerScore = new TextFieldTextRenderer();
			var playerScoreFormat = new TextFormat("trajanPro", 12, 0x038249, false, null, null, null, null, "center");
			_playerScore.embedFonts = true;
			_playerScore.textFormat = playerScoreFormat;
			_playerScore.text = "0";
			_playerScore.validate();
			
			_displayPlayerScore = DisplayObject(this._playerScore);
			addChild(_displayPlayerScore);
			_displayPlayerScore.x = _playerQuad.x + _playerQuad.width - _displayPlayerScore.width * .5;
			_displayPlayerScore.y = _playerQuad.height;
			
			_enemyQuad = new Quad(_pointDim, height, 0x2A3B92);
			_enemyQuad.x = maxWidth * .5- _enemyQuad.width;
			addChild(_enemyQuad);
			
			_enemyScore = new TextFieldTextRenderer();
			var enemyScoreFormat = new TextFormat("trajanPro", 12, 0x2A3B92, false, null, null, null, null, "center");
			_enemyScore.embedFonts = true;
			_enemyScore.textFormat = enemyScoreFormat;
			_enemyScore.text = "0";
			
			_displayEnemyScore = DisplayObject(this._enemyScore);
			addChild(_displayEnemyScore);
			_displayEnemyScore.x = _enemyQuad.x - _enemyScore.width * .5;
			_displayEnemyScore.y = _enemyQuad.height;
		}
		
		public function updateScorePos():void
		{
			var playerWidth:Number = (_playerScoreInt / _maxScore) * _pointDim * 100;
			var enemyWidth:Number = (_enemyScoreInt / _maxScore) * _pointDim * 100;
			var playerTextPos:Number = - _maxWidth * .5 + playerWidth;
			var enemyPos:Number = _maxWidth * .5 - enemyWidth;
			var enemyTextPos:Number = enemyPos;
			
			if (_playerScoreInt > 0 )
			{
				TweenMax.to(_playerQuad, 0.5, { width: playerWidth } );
				TweenMax.to(_displayPlayerScore, 0.5, { x: playerTextPos });
			}
			
			if (_enemyScoreInt > 0 )
			{
				TweenMax.to(_enemyQuad, 0.5, { width: enemyWidth, x: enemyPos } );
				//_enemyQuad.x = _maxWidth * .5 - _enemyQuad.width;
				TweenMax.to(_displayEnemyScore, 0.5, { x: enemyTextPos } );
			}
			
		}
		
		public function updateScoreText():void
		{			
			if ((_playerScoreInt > 0 && _playerScoreInt != int(_playerScore.text)) || (_enemyScoreInt > 0 && _enemyScoreInt != int(_enemyScore.text)))
				setPoints(_playerScoreInt, _enemyScoreInt);
		}
		
		private function setPoints(playerScore:int,enemyScore:int):void
		{
			this._finalPlayerScore = playerScore;
			this._finalEnemyScore = enemyScore;
			if (!this._scoreTimer)
			{
				this._scoreTimer = new Timer(2);
				this._scoreTimer.addEventListener(TimerEvent.TIMER, timerTickPoints);
			}
			
			this._scoreTimer.start();
		}
		
		private function timerTickPoints(e:TimerEvent):void
		{
			if ( int(_playerScore.text) < _finalPlayerScore ) 
			{
				_playerScore.text = String(int(_playerScore.text) + 1);
				//this._textScoreLabel.text = "Score: " + String(currentScore);
			}
			else if ( int(_enemyScore.text) < _finalEnemyScore )
			{
				_enemyScore.text = String(int(_enemyScore.text) + 1);
			}
			else
				_scoreTimer.stop();
			
		}
		
		public function calcPoints(timeRemoved:int, player:Boolean):void
		{
			var maxPredictedTime:int = 60;
			var penalty : int = 20;
			
			if(player)
				_playerScoreInt += 20 - penalty *  sigmoid( timeRemoved / maxPredictedTime);
			else
				_enemyScoreInt += 20 - penalty *  sigmoid( timeRemoved / maxPredictedTime);
			
		}
		
		private function sigmoid(x:Number):Number
		{
			return 1 / ( 1 + Math.pow(Math.E, -x));
		}
		
	}

}