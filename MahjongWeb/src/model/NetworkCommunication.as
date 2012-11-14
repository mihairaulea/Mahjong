package model 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import starling.events.Event;
	import starling.events.EventDispatcher;

	public class NetworkCommunication extends EventDispatcher
	{
		private static var instance:NetworkCommunication;
				
		public static const NEW_WAVE:String = "newWave";
		public static const START_GAME:String = "startGame";
		public static const OPPONENT_FOUND:String = "opponentFound";
		public static const CONNECTION_STARTED:String = "connectionStarted";
		public static const TIMER_TICK:String = "timerTick";
		public static const PIECE_BURNED:String = "pieceBurned";
		
		public var placementArray:Array;
		public var p1Score:int;
		public var p2Score:int;
		public var secondsLeft:int;
		public var playerAction:Boolean;
		
		private var waveTimer:Timer;
		
		public function NetworkCommunication(p_key:SingletonBlocker) 
		{
			if (p_key == null)
				throw new Error("Error: Instantiation failed: Use PiecesManager.getInstance() instead of new.");
		}
		
		public static function getInstance():NetworkCommunication
		{
			if (instance == null)
			{
				instance = new NetworkCommunication(new SingletonBlocker());
			}
			return instance;
		}
		
		public function init():void
		{
			this.placementArray = new Array();
			this.p1Score = 0;
			this.p2Score = 0;
			this.secondsLeft = 80;
			
			waveTimer = new Timer(1000);
			waveTimer.addEventListener(TimerEvent.TIMER, onWaveTimerTick);
		}
		
		public function connectToServer()
		{
			//dispatchEvent(new Event(NetworkCommunication.CONNECTION_STARTED));
		}
		
		public function findOpponent():void
		{
			dispatchEvent(new Event(NetworkCommunication.OPPONENT_FOUND));
		}
		
		public function startGame():void
		{
			dispatchEvent(new Event(NetworkCommunication.START_GAME));
			this.init()
			waveTimer.start();
		}
		
		private function onWaveTimerTick(e:TimerEvent):void
		{
			this.secondsLeft--;
			
			if(secondsLeft % 10 == 0)
				generateNewWave();
				
			dispatchEvent(new Event(NetworkCommunication.TIMER_TICK));
			
			if (secondsLeft % 5 == 0)
			{
				playerAction = !playerAction;
				dispatchEvent(new Event(NetworkCommunication.PIECE_BURNED));
			}
		}
		
		private function generateNewWave():void
		{
			dispatchEvent(new Event(NetworkCommunication.NEW_WAVE));
		}
		
		private function getPoints(timeRemoved:int):int 
		{
			return this.p1Score;
		}
		
		private function sigmoid(x:Number):Number
		{
			return 1 / ( 1 + Math.pow(Math.E, -x));
		}
	}

}

internal class SingletonBlocker { };