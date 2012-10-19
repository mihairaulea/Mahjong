package model.xmlParsers {
	
	import flash.net.*;
	import flash.events.*;
	import model.levelSelector.*;
	import model.levelsMatrixes.LevelMatrix;
	import model.*;
	import util.AppConstants;
	
	public class LanguageParser extends EventDispatcher {
		
		private var request:URLRequest;
		private var xmlLoader:URLLoader ;
		private var xmlData:XML;
		private var languageXMLURL:String;
				
		public static var XML_LOADED:String="xmlLoaded";
		public static var XML_PARSED:String="xmlParsed";
		
		var fakeXML:String = "";
		
		var languagesParser:LanguagesParser = new LanguagesParser();
		
		public function LanguageParser() {
			
		}
		
		public function initLoader(xmlUrlPath:String) {
			//initFakeXML();
			//trace(xmlUrlPath+" xml path for languages");
			request = new URLRequest(xmlUrlPath);
			xmlLoader = new URLLoader(request);
			xmlLoader.addEventListener(Event.COMPLETE, xmlLoaded);
		}
		
		private function xmlLoaded(e:Event) {
			//xmlData = new XML(e.target.data);
			dispatchEvent(new Event(LevelMetadataParser.XML_LOADED));
			parseXML();
		}
		
		public function parseXML() {
			var layersList:XMLList = xmlData.child("language");
			
			for each(var layer:XML in layersList) {
				if(layer.@name == AppConstants.LANGUAGE) {
					languageXMLURL = (layer.@url);
					break;
				}
			}
			//trace(languageXMLURL+" asta e null");
			languagesParser.addEventListener(LanguagesParser.XML_PARSED, xmlParsedHandler);
			languagesParser.initLoader(languageXMLURL);
		}
		
		private function xmlParsedHandler(e:Event) {
			dispatchEvent(new Event(LevelParser.XML_PARSED));
		}
		
	}
	
}