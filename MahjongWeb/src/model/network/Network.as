package model.network 
{

	import flash.display.MovieClip;
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.requests.*;
	import com.smartfoxserver.v2.entities.match.*;
	import com.smartfoxserver.v2.entities.data.*;
	import com.smartfoxserver.v2.entities.*;
	import com.smartfoxserver.v2.entities.variables.*;
	import com.smartfoxserver.v2.entities.invitation.*;
	import com.smartfoxserver.v2.requests.game.*;
	import flash.events.EventDispatcher;
	
	import com.smartfoxserver.v2.core.SFSBuddyEvent;
	import com.smartfoxserver.v2.requests.buddylist.*;
	
	import flash.events.MouseEvent;
	import com.smartfoxserver.v2.entities.managers.IRoomManager;
	import flash.events.Event;
	
	import com.smartfoxserver.v2.exceptions.SFSError;
	

	public class Network extends EventDispatcher
	{

		//L O B B Y   E V E N T S
		public static var CONNECTION_FAILURE:String="connectionFailure";
		
		public static var CONNECTION_LOST:String="connectionLost";
		
		public static var LOGIN_SUCCESFUL:String="loginSuccesful";
		
		public static var LOGIN_ERROR:String="loginError";
		
		public static var GROUP_SUBSCRIBED:String="groupSubscribed";
		public var currentRoomArray:Array=new Array();
		
		public static var ROOM_ADDED:String="roomAdded";
		//public var newRoom:GameRoomData=new GameRoomData();
		public var newRoom:Object=new Object();
		
		public static var ROOM_DELETED:String="roomDeleted";
		public var deletedRoomId:int;
		
		public static var USER_JOINED_ROOM:String="userJoinedRoom";
		public var userNameJoinedRoom:String;
		public var roomIdJoinedByUser:int;
		
		public static var USER_LEFT_ROOM:String="userLeftRoom";
		public var userNameLeftRoom:String;
		public var roomIdLeftByUser:int;
				
		public static var YOUR_LOBBY_ROOM_JOINED:String="roomJoined";
		public var currentUsersArray:Array = new Array();
		
		public static var GAME_ROOM_JOINED:String="gameRoomJoined";
		
		public static var ROOM_JOIN_ERROR:String="roomJoinError";
		public var roomJoinErrorMessage:String="";
		
		public static var PUBLIC_MESSAGE_RECEIVED:String="publicMessageReceived";
		public var publicMessageObject:Object = new Object();
		
		public static var PRIVATE_MESSAGE_RECEIVED:String="privateMessageReceived";
		public var privateMessageObject:Object = new Object();
		
		public static var BUDDY_ADDED:String = "buddyAdded";
		public var buddyAddedName:String;
		
		public static var BUDDY_ERROR:String = "buddyError";
		public var buddyErrorMessage:String;
		
		public static var GAME_INVITATION_RECEIVED:String="gameInvitationReceived";
		public var invitationReceived:Invitation;
		
		public static var LOBBY_CHANGED:String = "lobbyChanged";
		
		public var ZONE_NAME:String = "Mahjong";
				
		private var sfs:SmartFox;
		private var groupsSubscribed:Array=new Array();

		private var username:String="test"+Math.random()+Math.random();
		private var uniqueUserKey:String=null;
		private var network:String=null;
		private var imageURL:String=null;
		
		private var password:String="";
		private var email:String=null;
		
		private var dtdLogin:Boolean = false;
		private var dtdRegister:Boolean = false;
		private var socialNetworkLogin:Boolean = false;
		private var guestLogin:Boolean = false;
		
		public static var MAP_RECEIVED:String = "mapReceived";
		public var gameMap:Array = new Array();

		public function Network()
		{
			
		}
		
		public function setDTDLoginCredentials(user:String, pass:String) 
		{
			this.username = user;
			this.password = pass;
			dtdLogin = true;
		}
		
		public function setDTDRegisterCredentials(user:String, pass:String, email:String) 
		{
			this.username = user;
			this.password = pass;
			this.email = email;
			this.dtdRegister = true;
		}
		
		public function setOAuthLoginCredentials(user:String, network:String, uniqueUserK:String, imageURL:String) 
		{
			this.username = user;
			this.network = network;
			this.uniqueUserKey = uniqueUserK;
			this.imageURL = imageURL;
			socialNetworkLogin = true;
		}
		
		public function setGuestLogin() 
		{
			guestLogin = true;
		}
		
		public function init() {
			sfs = new SmartFox(false);
			sfs.connect("localhost",9933);
			// Turn on the debug feature
			//sfs.debug = false;
			// Add SFS2X event listeners
			sfs.addEventListener(SFSEvent.CONNECTION, onConnection);
			sfs.addEventListener(SFSEvent.CONNECTION_LOST, onConnectionLost);
			
			sfs.addEventListener(SFSEvent.LOGIN, onLogin);
			sfs.addEventListener(SFSEvent.LOGIN_ERROR, onLoginError);
			
			//sfs.addEventListener(SFSEvent.ROOM_FIND_RESULT, onRoomFindResult);
			//sfs.addEventListener(SFSEvent.USER_FIND_RESULT, onUserFindResult);
			
			sfs.addEventListener(SFSEvent.INVITATION, gameInvitationReceived);
			sfs.addEventListener(SFSEvent.INVITATION_REPLY, gameInvitationReplyReceived);
			sfs.addEventListener(SFSEvent.INVITATION_REPLY_ERROR, gameInvitationReplyError);
			
			sfs.addEventListener(SFSBuddyEvent.BUDDY_ADD, onBuddyAdded);
         	sfs.addEventListener(SFSBuddyEvent.BUDDY_ERROR, onBuddyError);
						
			//sfs.addEventListener(SFSEvent.ROOM_ADD, roomAddHandler);
			//sfs.addEventListener(SFSEvent.ROOM_REMOVE, roomRemoveHandler);
			
			sfs.addEventListener(SFSEvent.USER_ENTER_ROOM, userEnterRoomHandler);
			sfs.addEventListener(SFSEvent.USER_EXIT_ROOM, userExitRoomHandler);		
			
			sfs.addEventListener(SFSEvent.ROOM_JOIN, onJoin);
			sfs.addEventListener(SFSEvent.ROOM_JOIN_ERROR, onJoinError);
			
			sfs.addEventListener(SFSEvent.ROOM_GROUP_SUBSCRIBE, onGroupSubscribed);
         	sfs.addEventListener(SFSEvent.ROOM_GROUP_SUBSCRIBE_ERROR, onGroupSubscribeError);
			
			sfs.addEventListener(SFSEvent.ROOM_GROUP_UNSUBSCRIBE, onGroupUnsubscribed);
         	sfs.addEventListener(SFSEvent.ROOM_GROUP_UNSUBSCRIBE_ERROR, onGroupUnsubscribeError);
			
			sfs.addEventListener(SFSEvent.EXTENSION_RESPONSE, onExtensionResponse);
			
			sfs.addEventListener(SFSEvent.PUBLIC_MESSAGE, onPublicMessage);
			sfs.addEventListener(SFSEvent.PRIVATE_MESSAGE, onPrivateMessage);
			//doar de test
			sfs.addEventListener(SFSEvent.ROOM_ADD, onRoomCreated);
         	sfs.addEventListener(SFSEvent.ROOM_CREATION_ERROR, onRoomCreationError);
			
			sfs.addEventListener(SFSEvent.USER_VARIABLES_UPDATE, onUserVarsUpdate);
		}
		
		private function onConnection(e:SFSEvent)
		{
			if (e.params.success)
			{
				trace("Connection Success!");
				sendLoginRequest();
			}
			else
			{
				trace("Connection Failure: " + e.params.errorMessage);
				dispatchEvent(new Event(Network.CONNECTION_FAILURE));
			}

		}
		
		private function sendLoginRequest() {			
			var optionalParam:ISFSObject=new SFSObject();
			
			/*
			if(socialNetworkLogin==true) {
				optionalParam.putUtfString("loginMethod","oauth");
				username = username + "+++"+ network+"+++"+uniqueUserKey+"+++";
				optionalParam.putUtfString("psds",network+this.uniqueUserKey);
				optionalParam.putUtfString("imageURL",imageURL);
				}
			else {
				optionalParam.putUtfString("psds",password);
				if(dtdLogin==true) {optionalParam.putUtfString("loginMethod","dtd");}
				if(dtdRegister==true) {optionalParam.putUtfString("loginMethod","dtdRegister");optionalParam.putUtfString("email",this.email); }
				if(guestLogin == true) {username = "";password="";optionalParam.putUtfString("loginMethod","none");};
				}
			*/	
			password = "";
			
			sfs.send( new LoginRequest(username, password, ZONE_NAME, null));
		}

		private function onConnectionLost(e:SFSEvent)
		{
			trace("connection lost for reason"+e.params.reason);
			dispatchEvent(new Event(Network.CONNECTION_LOST));
		}
		
		private function onLogin(e:SFSEvent) {
			trace("logged in --------------------------");
			
			// dummy test
			sendNewGameRequest();
			
			var roomNameToJoin:String = "SnakeLimbo";//gameConventions.getDefaultLobbyRoomForGame(lobbyMode);
			var roomGroupToSubscribe:String = ""; //gameConventions.getDefaultGroupNameForGame(lobbyMode);
			
			//sfs.send(new SubscribeRoomGroupRequest(roomGroupToSubscribe));
			//sfs.send( new JoinRoomRequest("SnakeLimbo") );
			
			dispatchEvent(new Event(Network.LOGIN_SUCCESFUL));
		}
		
		private function onLoginError(e:SFSEvent) {
			trace("logged in error!");
			trace(e.params.errorMessage+" logged in error reason");
			dispatchEvent(new Event(Network.LOGIN_ERROR));
		}
		
		private function sendNewGameRequest()
		{
			sfs.send(new ExtensionRequest("newGameRequest"));
		}
		
		private function onJoin(evt:SFSEvent):void
		{
			var currentLobbyRoomName : String = "";//gameConventions.getDefaultLobbyRoomForGame(this.lobbyMode);
			trace(currentLobbyRoomName);
			
			var roomName:String = evt.params.room.name;
			var theSame:Boolean = ( roomName == currentLobbyRoomName );
			
			if(theSame) {
				trace("they are the same");
				var room:SFSRoom = evt.params.room as SFSRoom;
				trace(room.capacity+" room capacity");
				trace(room.groupId+" group id");
				trace(room.name+" room name");
				trace(room.userList+" player list length");
				//trebuie aranjat un pic in pula mea
				//currentUsersArray = room.userList;
				//
				trace(currentUsersArray.length+ " currentUsersArray.length");
				for(var i:int=0;i<currentUsersArray.length;i++) {
					var user:SFSUser = room.userList[i];
					var userInfo:Object = new Object();//UserInfo
					var userType:String = (user.getVariable("userType").getStringValue());
					userInfo.userType = userType;
					userInfo.username = user.name;
					if(userType == "oauth") {userInfo.iconURL = (user.getVariable("imageURL").getStringValue());}
					// user.getVariable("coins");
					userInfo.noOfCoins = 200;
					userInfo.rating = 1201;
					currentUsersArray.push(userInfo);
				}
				
				for(var i:int=0;i<currentUsersArray.length;i++) trace(currentUsersArray.name);
				
				//
				dispatchEvent(new Event(Network.YOUR_LOBBY_ROOM_JOINED));
			}
			
		}
 
		private function onJoinError(evt:SFSEvent):void
		{
    		trace("Join failed: " + evt.params.errorMessage);
			this.roomJoinErrorMessage = evt.params.errorMessage;
			dispatchEvent(new Event(Network.ROOM_JOIN_ERROR));
		}
		
		private function onPublicMessage(evt:SFSEvent):void
     	{
         var sender:SFSUser = evt.params.sender;
		 this.publicMessageObject.sender = sender.name;
		 this.publicMessageObject.mesaj  = evt.params.message;
         dispatchEvent(new Event(Network.PUBLIC_MESSAGE_RECEIVED));
		}
		
		private function onPrivateMessage(evt:SFSEvent):void {
			var sender:User = evt.params.sender;
			this.privateMessageObject.sender = sender.name;
			this.privateMessageObject.mesaj = evt.params.message;
			dispatchEvent(new Event(Network.PRIVATE_MESSAGE_RECEIVED));
		}
		
		private function roomAddHandler(e:SFSEvent) {
			var room:SFSRoom = e.params.room;
			newRoom.password = room.isPasswordProtected;
			newRoom.environment = room.getVariable("environment").getIntValue();
			newRoom.coins = room.getVariable("coins").getIntValue();
			newRoom.roomId = room.id;
			for(var i:int=0;i<room.playerList.length;i++) {
				var player:User = room.playerList[i];
				newRoom.playerArray[i] = player.name;
			}
			dispatchEvent(new Event(Network.ROOM_ADDED));
		}
		
		private function roomRemoveHandler(e:SFSEvent) {
			var room:SFSRoom = e.params.room;
			deletedRoomId = room.id;
			dispatchEvent(new Event(Network.ROOM_DELETED));
		}
		
		private function userEnterRoomHandler(evt:SFSEvent) {
			var room:Room = evt.params.room;
            var user:User = evt.params.user;
			
			userNameJoinedRoom = user.name;
		    roomIdJoinedByUser = room.id;		
			
			dispatchEvent(new Event(Network.USER_JOINED_ROOM));
		}
		
		private function userExitRoomHandler(evt:SFSEvent) {
			var room:Room = evt.params.room;
            var user:User = evt.params.user;
			
			userNameLeftRoom = user.name;
			roomIdLeftByUser = room.id;
			
			dispatchEvent(new Event(Network.USER_LEFT_ROOM));
		}
		
		private function unsubscribeAllGroups() {
			for(var i:int=0;i<groupsSubscribed.length;i++) 
				 sfs.send(new UnsubscribeRoomGroupRequest(groupsSubscribed[i]));
		}
		
		private function onGroupSubscribed(evt:SFSEvent):void
     	{
         	trace("Group subscribed. The following rooms are now accessible: " + evt.params.newRooms);
			groupsSubscribed.push(evt.params.groupId);
			
			currentRoomArray  = sfs.getRoomListFromGroup(evt.params.groupId);
			
			//test
			for(var i:int=0;i<currentRoomArray.length;i++) {
				var room:Room = currentRoomArray[i];
				trace(room.name+" numele camerei");
				trace(room.isGame+" is it game?");
				trace(room.isPasswordProtected+" is password protected?");
				trace(room.playerList.length);
			}
			
			dispatchEvent(new Event(Network.GROUP_SUBSCRIBED));
			
		}
     
     	private function onGroupSubscribeError(evt:SFSEvent):void
     	{
         	trace("Group subscription failed: " + evt.params.errorMessage);
     	}
		
		private function onGroupUnsubscribed(evt:SFSEvent):void
     	{
         	trace("Group unsubscribed: " + evt.params.groupId);
			for(var i:int=0;i<groupsSubscribed.length;i++) {
				if(groupsSubscribed.length == evt.params.groupId) groupsSubscribed.splice(i,1);
			}
     	}
     
     	private function onGroupUnsubscribeError(evt:SFSEvent):void
     	{
         	trace("Group unsubscribing failed: " + evt.params.errorMessage);
     	}
		
		private function onRoomCreated(evt:SFSEvent):void
     	{
         	trace("Room created: " + evt.params.room);
     	}
     
     	private function onRoomCreationError(evt:SFSEvent):void
     	{
         	trace("Room creation failed: " + evt.params.errorMessage);
     	}
		
		private function onUserVarsUpdate(evt:SFSEvent):void {
			trace("user vars updated!!!");
			var changedVars:Array = evt.params.changedVars as Array;
         	var user:User = evt.params.user as User;
			
			for(var i:int=0;i<changedVars.length;i++) {
				trace(changedVars[i]);
				var varObj:Object=user.getVariable(changedVars[i]);
				trace(varObj);
			}
		}
		
		private function onExtensionResponse(e:SFSEvent) {
			
			var responseParams:ISFSObject = e.params.params as SFSObject
			
			if (e.params.cmd == "map") 
			{
				var noOfPieces:int = responseParams.getInt("noOfPieces");
				gameMap.splice(0, gameMap.length);
				
				for (var i:int = 0; i < noOfPieces; i++)
				{
					gameMap[i] = new Object();
					gameMap[i].uniqueId = responseParams.getInt("uniqueValueId");
					gameMap[i].visualId = responseParams.getInt("visualId");
				}
				
				trace("MAP RECEIVED");
				dispatchEvent(new Event(Network.MAP_RECEIVED));
			}
			else
			if (e.params.cmd == "tick")
			{
				trace("tick");
			}
	
		}
		
		private function onBuddyAdded(evt:SFSEvent) {
			trace("This buddy was added:", evt.params.buddy.name);
		}
		
		private function onBuddyError(evt:SFSEvent) {
			trace("The following error occurred while executing a buddy-related request:", evt.params.errorMessage);
		}
		
		private function gameInvitationReceived(e:SFSEvent) {
			invitationReceived = e.params.invitation;

			trace("game invitation received:"+invitationReceived);
			trace(invitationReceived.id+" invitation id");
			trace(invitationReceived.invitee+" user invited to play");
			trace(invitationReceived.inviter+" user that invited");
			trace(invitationReceived.secondsForAnswer+" seconds for answer");
			var invitationParams:ISFSObject = invitationReceived.params;
			trace(invitationParams.getInt("coins") + " coins at stake");
			trace(invitationParams.getInt("environment") +" env. id where we would like to play");
			
			dispatchEvent(new Event(Network.GAME_INVITATION_RECEIVED));
		}
		
		private function gameInvitationReplyReceived(e:SFSEvent) {
			trace(e.params.invitee+" user who replied to the invitation");
			// e.params.reply == 0 > OK
			// e.params.reply == 1 > KO
			trace(e.params.reply+" reply code");
			trace(e.params.data+" not used for the time being");
			
			//dispatchEvent(new Event(Network.
		}
		
		private function gameInvitationReplyError(e:SFSEvent) {
			trace(e.params.errorMessage+" error message");
			trace(e.params.errorCode+" error code");
			
			//dispatchEvent(new Event(Network.
		}
		
		/*
		public function get lobbyMode() {
			return GameMode.CURRENT_GAME_MODE;
		}
		*/
		
		public function createRoomRequest(createRoom:Object) {				
			var params:ISFSObject = new SFSObject();
			
			params.putInt("coins", createRoom.coins);
			params.putInt("environment", createRoom.environment);
			params.putInt("numberOfPlayers", createRoom.numberOfPlayers);
			params.putBool("isPasswordProtected",createRoom.isPasswordProtected);
			if(createRoom.isPasswordProtected == true) params.putUtfString("password", createRoom.password);
			
			var cmd:String = "createGameRoom";//+lobbyMode;
			
			sfs.send(new ExtensionRequest(cmd,params));
		}
		
		public function joinRoom(roomId:int) {
			var cmd:String = "joinGameRoom";//+lobbyMode;
		}
		
		public function joinPasswordRoomRequest(joinRoomData:Object) {
			var cmd:String = "joinGameRoom";//+lobbyMode;
			
			var params:ISFSObject = new SFSObject();
			params.putInt("roomId", joinRoomData.roomId);
			params.putUtfString("password", joinRoomData.password);
			
			sfs.send(new ExtensionRequest(cmd, params));
		}
		
		public function joinRoomAsSpectatorRequest(roomId:int) {
			sfs.send(new JoinRoomRequest(roomId,null,NaN,true));
		}
		
		public function quickJoinGame() {
			var cmd:String = "quickJoinGame";// +lobbyMode;
			sfs.send(new ExtensionRequest(cmd));
		}
		
		public function inviteToGame(inviteToGameRoomData:Object) { // :GameRoomData
			//extension request, sa scot coins din cont
			removeCoins(inviteToGameRoomData.coins);
		    var usersToInvite:Array = new Array();
			usersToInvite.push(inviteToGameRoomData.userInvited);
			var obiect:SFSObject= new SFSObject();
			obiect.putInt( "coins", inviteToGameRoomData.coins);
			obiect.putInt("environment", inviteToGameRoomData.environment);
		
			sfs.send(new InviteUsersRequest(usersToInvite, 20, obiect));
		}
		
		//	0 - OK
		//	1 - KO
		public function respondToInviteGame(invitation:Invitation, invitationReply:int) {
			if(invitationReply == 0 ) removeCoins(invitation.params.getInt("coins"));
			sfs.send(new InvitationReplyRequest(invitation, invitationReply));
		}
		
		private function removeCoins(amount:int) {
			var param:ISFSObject = new SFSObject();
			param.putInt("coins", amount);
			//sfs.send(new ExtensionRequest("removeCoins",param);
		}
		
		public function sendPrivateMessage(toUser:String,mesaj:String) {
			var user:User = sfs.userManager.getUserByName(toUser);
         	sfs.send(new PrivateMessageRequest(mesaj, user.id));
		}
		
		public function sendPublicMessage(mesaj:String) {
			sfs.send(new PublicMessageRequest(mesaj));
		}
		
		public function addAsBuddy(playerName:String) {
			sfs.send(new AddBuddyRequest(playerName));
		}
		
	
}

}