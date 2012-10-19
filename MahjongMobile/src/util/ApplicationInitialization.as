package util
{
	import flash.display.LoaderInfo;
	import flash.external.*;
	
	public class ApplicationInitialization
	{
		public var initialized:Boolean=false;
		
		/*public var memberID:String;
		public var gameID:String;
		public var language:String;
		public var factor:String;
		public var exitURL:String;
		public var timestamp:String;*/
		
		public function ApplicationInitialization()
		{
			
		}
		
		public function getFlashVars(loaderInfo:LoaderInfo):Boolean {
			/*
			try 
			{
				var keyStr:String;
				var valueStr:String;
				var paramObj:Object = loaderInfo.parameters;
				trace("iterating over flashvars!");
				for (keyStr in paramObj) 
				{
					//ExternalInterface.call("debug","Field " +keyStr+" has value "+paramObj[keyStr]);
					switch (keyStr) 
					{
						case "memberID":
						{
							AppConstants.MEMBER_ID = paramObj[keyStr];
							break;
						}
						case "gameID": {
							AppConstants.GAME_ID = paramObj[keyStr];
							break;
						}
						case "language":
						{
							AppConstants.LANGUAGE = paramObj[keyStr];
							break;
						}
						case "factor": 
						{
							AppConstants.FACTOR = (paramObj[keyStr]);
							break;
						}
						case "exitURL": {
							AppConstants.EXIT_URL = (paramObj[keyStr]);
							break;
						}
						case "timestamp": {
							AppConstants.TIMESTAMP = (paramObj[keyStr]);
							break;
						}
					}
							
					}
				
				
				initialized=true;
			} 
			
			catch (error:Error) 
			{
				trace("error with rootvars");
				ExternalInterface.call("debug","error with rootvars " +error.message);
				initialized=false;
			}
			
			return initialized;
			*/
			return true;
		}
		
	}
}