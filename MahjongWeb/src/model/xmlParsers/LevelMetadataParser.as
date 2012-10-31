package model.xmlParsers {
	
	import flash.net.*;
	import starling.events.*;
	import model.levelSelector.*;
	import flash.external.*;
	import model.GameConstants;
	
	public class LevelMetadataParser extends EventDispatcher {
		
		private var request:URLRequest;
		private var xmlLoader:URLLoader;
		private var xmlData:XML;
				
		public static var XML_LOADED:String="xmlLoaded";
		public static var XML_PARSED:String="xmlParsed";
		
		private var levelSelectorDataSource:LevelSelectorDataSource = LevelSelectorDataSource.getInstance();
		
		private var fakeXML:String = "";
		
		public function LevelMetadataParser() {
			
		}
		
		public function initLoader():void {
			initFakeXML();
			xmlLoaded();
		}
		
		private function xmlLoaded():void 
		{
			xmlData = new XML(fakeXML);
			dispatchEvent(new Event(LevelMetadataParser.XML_LOADED));
			parseXML();
		}
		
		public function parseXML():void 
		{
			var levelsList:XMLList = xmlData.child("level");
			for each(var level:XML in levelsList) {
				var levelItem:LevelSelectorItem = new LevelSelectorItem();
				levelItem.levelName = (level.attribute("name"));
				levelItem.levelCategory = (level.attribute("category"));
				//levelItem.levelXMLURL = (GameConstants.GAME_RESOURCES + level.attribute("url"));
				//levelItem.levelPrintscreenURL = (GameConstants.GAME_RESOURCES + level.attribute("printscreen"));
				levelSelectorDataSource.addLevel(levelItem);
			}
			dispatchEvent(new Event(LevelMetadataParser.XML_PARSED));
		}
		
		private function initFakeXML():void
		{
			fakeXML = "<levels>";
			fakeXML +=	"<level name =\"1\" category = \"easy\" url=\"/lib/metadata/levels/easy/1.xml\" printscreen = \"/levels/1.png\" ></level>"
						+ "<level name =\"2\" category = \"medium\" url=\"/lib/metadata/levels/easy/2.xml\" printscreen = \"/levels/2.png\"></level>"
						+ "<level name =\"3\" category = \"medium\" url=\"/lib/metadata/levels/easy/3.xml\" printscreen = \"/levels/3.png\"></level>"
						+ "<level name =\"4\" category = \"medium\" url=\"/lib/metadata/levels/easy/4.xml\" printscreen = \"/levels/4.png\"></level>"
						+ "<level name =\"5\" category = \"medium\" url=\"/lib/metadata/levels/easy/5.xml\" printscreen = \"/levels/5.png\"></level>"
						+ "<level name =\"6\" category = \"easy\" url=\"/lib/metadata/levels/easy/6.xml\" printscreen = \"/levels/6.png\"></level>"
						+ "<level name =\"7\" category = \"hard\" url=\"/lib/metadata/levels/easy/7.xml\" printscreen = \"/levels/7.png\"></level>"
						+ "<level name =\"8\" category = \"hard\" url=\"/lib/metadata/levels/easy/8.xml\" printscreen = \"/levels/8.png\"></level>"
						+ "<level name =\"9\" category = \"hard\" url=\"/lib/metadata/levels/medium/1.xml\" printscreen = \"/levels/9.png\" ></level>"
						+ "<level name =\"10\" category = \"medium\" url=\"/lib/metadata/levels/medium/2.xml\" printscreen = \"/levels/10.png\"></level>"
						+ "<level name =\"11\" category = \"easy\" url=\"/lib/metadata/levels/medium/3.xml\" printscreen = \"/levels/11.png\"></level>"
						+ "<level name =\"12\" category = \"easy\" url=\"/lib/metadata/levels/medium/4.xml\" printscreen = \"/levels/12.png\"></level>"
						+ "<level name =\"13\" category = \"easy\" url=\"/lib/metadata/levels/medium/5.xml\" printscreen = \"/levels/13.png\"></level>"
						+ "<level name =\"14\" category = \"medium\" url=\"/lib/metadata/levels/medium/6.xml\" printscreen = \"/levels/14.png\"></level>"
						+ "<level name =\"15\" category = \"hard\" url=\"/lib/metadata/levels/medium/7.xml\" printscreen = \"/levels/15.png\"></level>"
						+ "<level name =\"16\" category = \"medium\" url=\"/lib/metadata/levels/medium/8.xml\" printscreen = \"/levels/16.png\"></level>"
						+ "<level name =\"17\" category = \"hard\" url=\"/lib/metadata/levels/hard/1.xml\" printscreen = \"/levels/17.png\" ></level>"
						+ "<level name =\"18\" category = \"easy\" url=\"/lib/metadata/levels/hard/2.xml\" printscreen = \"/levels/18.png\"></level>"
						+ "<level name =\"19\" category = \"easy\" url=\"/lib/metadata/levels/hard/3.xml\" printscreen = \"/levels/19.png\"></level>"
						+ "<level name =\"20\" category = \"hard\" url=\"/lib/metadata/levels/hard/4.xml\" printscreen = \"/levels/20.png\"></level>"
						+ "<level name =\"21\" category = \"hard\" url=\"/lib/metadata/levels/hard/5.xml\" printscreen = \"/levels/21.png\"></level>"
					+ "</levels>";
		}
		
	}
	
}