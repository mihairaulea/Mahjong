package model.network 
{
	
	import flash.events.*;
	import flash.net.NetworkInfo;
	
	public class NetworkWrapper extends EventDispatcher
	{
		
		var network:Network = new Network();
		
		public function NetworkWrapper() 
		{
			
		}
		
		// requests to send
		public function startNetwork()
		{
			network.init();
		}
		
		
		// communication received
		private function addEventListeners()
		{
			network.addEventListener(Network.LOGIN_SUCCESFUL, loginSuccessHandler);
			network.addEventListener(Network.LOGIN_ERROR, loginErrorHandler);
			
			network.addEventListener(Network.GAME_ROOM_JOINED, gameRoomJoinedHandler);
			network.addEventListener(Network.MAP_RECEIVED, mapReceivedHandler);
			
			network.addEventListener(Network.GAME_TICK, gameTickReceived);
			
			network.addEventListener(Network.PIECES_BURNED, pieceBurnedHandler);
			network.addEventListener(Network.PIECE_SELECTED, pieceSelectedHandler);
			network.addEventListener(Network.PIECES_RELEASED, piecesReleasedHandler);
		}
		
		private function loginSuccessHandler(e:Event)
		{
			
		}
		
		private function loginErrorHandler(e:Event)
		{
			trace(network.loginErrorReason);
		}
		
		private function gameRoomJoinedHandler(e:Event)
		{
			
		}
		
		private function mapReceivedHandler(e:Event)
		{
			trace(network.gameMap);
			trace(network.waveNumber + " wave number");
		}
		
		private function gameTickReceived(e:Event)
		{
			
		}
		
		private function pieceBurnedHandler(e:Event)
		{
			
		}
		
		private function pieceSelectedHandler(e:Event)
		{
			
		}
		
		private function piecesReleasedHandler(e:Event)
		{
			
		}
		
	}

}