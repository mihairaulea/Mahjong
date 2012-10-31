package model.highscores 
{
	
	import com.scoreoid.ScoreoidEncryption;
	import starling.events.EventDispatcher;
	import com.adobe.serialization.json.JSONCustom;
	
	public class HighscoresModel extends EventDispatcher
	{
		
		public static var instance:HighscoresModel;		
		private static var allowInstance:Boolean = false;
		
		public static var HIGHSCORES_RETRIEVED:String = "highscoresRetrieved";
		public var highscoresArray :Array = new Array();
		
		public static function getInstance():HighscoresModel
		{
			if (instance == null)
			{
				allowInstance = true;
				instance = new HighscoresModel();
				allowInstance = false;
			}
			return instance;
		}
		
		public function HighscoresModel():void 
		{
			if (!allowInstance) 
			{
			throw new Error("Error: Instantiation failed: Use HighscoresModel.getInstance() instead of new.");
			}
		}
		
		public function submitScore(username:String, score:int)
		{
			var scoreoidCommunication:ScoreoidEncryption = new ScoreoidEncryption();
			
			var requestObject:Object = new Object();
			requestObject.score = score;
			requestObject.username = username;
			
			scoreoidCommunication.sendData("https://www.scoreoid.com/api/getScores", scoreSubmited, requestObject);
		}
		
		private function scoreSubmited(scoreSubmitResult:String)
		{
			trace("score submited!!!!!  ");
			trace(scoreSubmitResult);
		}
		
		public function retrieveTopScores()
		{
			var scoreoidCommunication:ScoreoidEncryption = new ScoreoidEncryption();
			
			var requestObject:Object = new Object();
			requestObject.order_by = "score";
			requestObject.order = "desc";
			
			scoreoidCommunication.sendData("https://www.scoreoid.com/api/getScores", topScoresReceived, requestObject);
		}
		
		private function topScoresReceived(scoreResults:String)
		{
			highscoresArray.splice(0, highscoresArray.length);
			
			var object:Array = (JSONCustom.decode(scoreResults)) as Array;
			for (var i:int = 0; i < object.length; i++)
			{
				/*
				var object:Object = new Object();
				object.username = (object[i].Player.username);
				object.score = (object[i].Score.score);
				*/
				highscoresArray.push(object[i].Player.username+" :: "+object[i].Score.score);
			}
		}
		
		
	}

}