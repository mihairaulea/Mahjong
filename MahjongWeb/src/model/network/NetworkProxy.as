package model.network {
	
	import model.network.*;
	import model.DataObjectsForView.*;
	
	import flash.events.*;
	
	public class NetworkProxy 
	{
		public static const NAME:String = "RemoteDataProxy";
		
		private var network:Network = new Network();
		
		public function NetworkProxy() {
			super( NAME, new Object() );
			addEventListeners();
		}
		
		private function addEventListeners() {
			network.addEventListener(Network.CONNECTION_FAILURE, connectionFailureHandler);
			network.addEventListener(Network.CONNECTION_LOST, connectionLostHandler);
			network.addEventListener(Network.GAME_ROOM_JOINED, gameRoomJoinedHandler);
			network.addEventListener(Network.GROUP_SUBSCRIBED, groupSubscribedHandler);
			network.addEventListener(Network.LOGIN_ERROR, loginErrorHandler);
			network.addEventListener(Network.LOGIN_SUCCESFUL, loginSuccesfulHandler);
			network.addEventListener(Network.PRIVATE_MESSAGE_RECEIVED, privateMessageReceivedHandler);
			network.addEventListener(Network.PUBLIC_MESSAGE_RECEIVED, publicMessageReceviedHandler);
			network.addEventListener(Network.ROOM_ADDED, roomAddedHandler);
			network.addEventListener(Network.ROOM_DELETED, roomDeletedHandler);
			network.addEventListener(Network.USER_JOINED_ROOM, userJoinedRoomHandler);
			network.addEventListener(Network.USER_LEFT_ROOM, userLeftRoomHandler);
			network.addEventListener(Network.YOUR_LOBBY_ROOM_JOINED, yourLobbyRoomJoined);
			
			network.addEventListener(Network.GAME_INVITATION_RECEIVED, gameInvitationReceivedHandler);
		}
		
		public function loginAsGuest() {
			network.setGuestLogin();
			network.init();
		}
		
		public function loginAsDTDUser(user:String,pass:String) {
			network.setDTDLoginCredentials(user,pass);
			network.init();
			trace("am trimis login as DTD user");
		}
		
		public function loginSocialNetwork(user:String,socialNetwork:String,uniqueKey:String, imageURL:String) {
			network.setOAuthLoginCredentials(user, socialNetwork, uniqueKey, imageURL);
			network.init();
		}
		
		public function loginRegisterDTDUser(user:String,pass:String, email:String) {
			network.setDTDRegisterCredentials(user, pass, email);
			network.init();
		}
		
		private function connectionFailureHandler(e:Event) {
			var obiect:Object = new Object();
			obiect.mesaj = "Connection failed!";
			this.sendNotification(ApplicationFacade.ERROR_DISPLAY, obiect);
		}
		
		private function connectionLostHandler(e:Event) {
			var obiect:Object = new Object();
			obiect.mesaj = "Connection lost!";			
			this.sendNotification(ApplicationFacade.ERROR_DISPLAY, obiect);
		}
				
		private function gameRoomJoinedHandler(e:Event) {
			var obiect:Object = new Object();
			obiect.currentUsersArray = e.target.currentUsersArray;
			this.sendNotification(ApplicationFacade.USER_LIST_RECEIVED, obiect);
		}
		
		private function groupSubscribedHandler(e:Event) {
			this.sendNotification(ApplicationFacade.LOBBY_STARTUP);
			var object:Object = new Object();
			object.currentRoomArray = e.target.currentRoomArray;
			this.sendNotification(ApplicationFacade.ROOM_LIST_RECEIVED, object);
		}
		
		private function loginErrorHandler(e:Event) {
			var obiect:Object = new Object();
			obiect.mesaj = "Login error!";			
			this.sendNotification(ApplicationFacade.ERROR_DISPLAY, obiect);
		}
		
		private function loginSuccesfulHandler(e:Event) {
			
		}
		
		private function privateMessageReceivedHandler(e:Event) {
			//e.target.privateMessageObject.sender;
			//e.target.privateMessageObject.mesaj;
			sendNotification(ApplicationFacade.SEND_PRIVATE_MESSAGE, e.target.privateMessageObject);
		}
		
		private function publicMessageReceviedHandler(e:Event) {
			//e.target.publicMessageObject.sender;
			//e.target.publicMessageObject.mesaj;
			sendNotification(ApplicationFacade.PUBLIC_MESSAGE_RECEIVED, e.target.publicMessageObject);
		}
		
		private function roomAddedHandler(e:Event) {
			e.target.newRoom.password;
			e.target.newRoom.environment;
			e.target.newRoom.coins;
			e.target.newRoom.roomId;
			e.target.newRoom.playerArray.length;
			sendNotification(ApplicationFacade.ROOM_ADDED, e.target.newRoom);
		}
		
		private function roomDeletedHandler(e:Event) {
			e.target.deletedRoomId;
			sendNotification(ApplicationFacade.ROOM_REMOVED, e.target.deletedRoomId);
		}
		
		private function userJoinedRoomHandler(e:Event) {
			e.target.userNameJoinedRoom;
			e.target.roomIdJoinedByUser;
			var roomJoinObject:Object = new Object();
			roomJoinObject.userNameJoinedRoom = e.target.userNameJoinedRoom;
			roomJoinObject.roomIdJoinedByUser = e.target.roomIdJoinedByUser;
			sendNotification(ApplicationFacade.USER_ENTER_ROOM);
		}
		
		private function userLeftRoomHandler(e:Event) {
			e.target.userNameLeftRoom;
			e.target.roomIdLeftByUser;
		}
		
		private function yourLobbyRoomJoined(e:Event) {
			e.target.currentUsersArray;
		}
		
		private function gameInvitationReceivedHandler(e:Event) {
			e.target.invitationReceived;
		}
		
		public function createGame(createRoom:CreateGameRoomData) {
			network.createRoomRequest(createRoom);
		}
		
		public function quickJoinGame() {
			network.quickJoinGame();
		}
		
		public function joinGame(roomId:int) {
			network.joinRoom(roomId);
		}
		
		public function joinPassGame(joinRoomObj:JoinRoomData) {
			network.joinPasswordRoomRequest(joinRoomObj);
		}
		
		public function joinRoomAsSpectator(roomId:int) {
			network.joinRoomAsSpectatorRequest(roomId);
		}
		
		public function sendPublicMessage(mesaj:String) {
			network.sendPublicMessage(mesaj);
		}
		
		public function sendPrivateMessage(privateMessageObject:Object) {
			network.sendPrivateMessage(privateMessageObject.sendTo, privateMessageObject.messageToSend);
		}
		
		public function addAsBuddy(buddyName:String) {
			network.addAsBuddy(buddyName);
		}
		
		public function sendGameInvitation(gameInvitation:InviteToGameRoomData) {
			network.inviteToGame(gameInvitation);
		}
		
	}
	
}