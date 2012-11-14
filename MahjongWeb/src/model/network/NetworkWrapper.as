package model.network 
{
	
	import flash.events.*;
	import flash.net.NetworkInfo;
	import starling.events.*;
	
	public class NetworkWrapper extends starling.events.EventDispatcher
	{
		public static const CONNECTION_ERROR:String = "connectionError";
		public static const CONNECTION_STARTED:String = "connectionStarted";
		public static const OPPONENT_FOUND:String = "opponentFound";
		public static const NEW_WAVE:String = "newWave";
		public static const PIECE_SELECTED:String = "pieceSelected";
		public static const PIECES_UNSELECTED:String = "pieceUnselected";
		public static const PIECES_BURNED:String = "piecesBurned";
		public static const BONUS_FOR_CLASSIC:String = "bonusForClassic";
		
		var network:Network = new Network();
		
		public function NetworkWrapper() 
		{
			
		}
		
		// requests to send
		public function startNetwork():void
		{
			addEventListeners();
			network.init();
		}
		
		public function initiateGameRequest():void
		{
			//network.
		}
		
		public function selectPieceRequest(pieceId:int,userId:int):void
		{
			// Select piece
			//network.
		}
		
		// communication received
		private function addEventListeners()
		{
			network.addEventListener(Network.LOGIN_SUCCESFUL, loginSuccessHandler);
			network.addEventListener(Network.LOGIN_ERROR, loginErrorHandler);
			
			network.addEventListener(Network.GAME_ROOM_JOINED, gameRoomJoinedHandler);
			network.addEventListener(Network.MAP_RECEIVED, mapReceivedHandler);
			
			//network.addEventListener(Network.GAME_TICK, gameTickReceived);
			
			//network.addEventListener(Network.PIECES_BURNED, pieceBurnedHandler);
			//network.addEventListener(Network.PIECE_SELECTED, pieceSelectedHandler);
			//network.addEventListener(Network.PIECES_RELEASED, piecesReleasedHandler);
		}
		
		private function loginSuccessHandler(e:flash.events.Event):void
		{
			this.dispatchEvent(new starling.events.Event(CONNECTION_STARTED));
		}
		
		private function loginErrorHandler(e:flash.events.Event):void
		{
			trace(network.loginErrorReason);
			this.dispatchEvent(new starling.events.Event(CONNECTION_ERROR));
			
		}
		
		private function gameRoomJoinedHandler(e:flash.events.Event):void
		{
			this.dispatchEvent(new starling.events.Event(OPPONENT_FOUND));
		}
		
		private function mapReceivedHandler(e:flash.events.Event):void
		{
			trace(network.gameMap);
			trace(network.waveNumber + " wave number");
			this.dispatchEvent(new starling.events.Event(NEW_WAVE, false, { array: network.gameMap, layout: network.gameMap } ));
		}
		
		private function gameTickReceived(e:flash.events.Event):void
		{
			
		}
		
		private function pieceBurnedHandler(e:flash.events.Event):void
		{
			
		}
		
		private function pieceSelectedHandler(e:flash.events.Event):void
		{
			
		}
		
		private function piecesReleasedHandler(e:flash.events.Event):void
		{
			
		}
		
	}

}