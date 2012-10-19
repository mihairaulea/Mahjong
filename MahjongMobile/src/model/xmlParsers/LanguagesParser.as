package model.xmlParsers {
	
	import flash.net.*;
	import flash.events.*;
	import model.levelSelector.*;
	import model.levelsMatrixes.LevelMatrix;
	import model.*;
	
	public class LanguagesParser extends EventDispatcher {
		
		private var request:URLRequest;
		private var xmlLoader:URLLoader ;
		private var xmlData:XML;
				
		public static var XML_LOADED:String="xmlLoaded";
		public static var XML_PARSED:String="xmlParsed";
		
		
		public function LanguagesParser() {
			
		}
		
		public function initLoader(xmlUrlPath:String):void 
		{
			request = new URLRequest(xmlUrlPath);
			xmlLoader = new URLLoader(request);
			xmlLoader.addEventListener(Event.COMPLETE, xmlLoaded);
		}
		
		private function xmlLoaded(e:Event):void 
		{
			xmlData = new XML(e.target.data);
			dispatchEvent(new Event(LanguagesParser.XML_LOADED));
			parseXML();
		}
		
		public function parseXML():void 
		{
			var layersList:XMLList = xmlData.children();
			for each(var layer:XML in layersList) {
				if(layer.name() == "back-to-main") {LanguageConstants.BACK_TO_MAIN = layer.text();}
				if(layer.name() == "coins-earned") LanguageConstants.COINS_EARNED= layer.text();
				if(layer.name() == "game-over") LanguageConstants.GAME_OVER= layer.text();
				if(layer.name() == "how-to-play") LanguageConstants.HOW_TO_PLAY= layer.text();
				if(layer.name() == "how-to-play-prompt") LanguageConstants.HOW_TO_PLAY_PROMPT= layer.text();
				if(layer.name() == "level-five") LanguageConstants.LEVEL_FIVE= layer.text();
				if(layer.name() == "level-four") LanguageConstants.LEVEL_FOUR= layer.text();
				if(layer.name() == "level-one") LanguageConstants.LEVEL_ONE= layer.text();
				if(layer.name() == "level-three") LanguageConstants.LEVEL_THREE= layer.text();
				if(layer.name() == "level-two") LanguageConstants.LEVEL_TWO= layer.text();
				if(layer.name() == "new-game") LanguageConstants.NEW_GAME= layer.text();
				if(layer.name() == "new-game-prompt") LanguageConstants.NEW_GAME_PROMPT= layer.text();
				if(layer.name() == "no") LanguageConstants.NO= layer.text();
				if(layer.name() == "points") LanguageConstants.POINTS= layer.text();
				if(layer.name() == "quit-game") LanguageConstants.QUIT_GAME= layer.text();
				if(layer.name() == "quit-game-prompt") LanguageConstants.QUIT_GAME_PROMPT= layer.text();
				if(layer.name() == "reset-game") LanguageConstants.RESET_GAME= layer.text();
				if(layer.name() == "yes") LanguageConstants.YES = layer.text();				
			}
			
			dispatchEvent(new Event(LanguagesParser.XML_PARSED));
		}
		
	}
	
}