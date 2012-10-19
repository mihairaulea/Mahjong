package model.xmlParsers {
	
	import flash.net.*;
	import starling.events.*;
	import model.levelSelector.*;
	import model.levelsMatrixes.LevelMatrix;
	
	
	public class LevelParser extends EventDispatcher {
		
		private var request:URLRequest;
		private var xmlLoader:URLLoader ;
		private var xmlData:XML;
		public var levelId:String;
		public var levelMatrix:LevelMatrix = new LevelMatrix();
				
		public static var XML_LOADED:String="xmlLoaded";
		public static var XML_PARSED:String="xmlParsed";
		
		private var fakeXML:String = "";
		private var levelXML:LevelXML = new LevelXML();
		
		public function LevelParser() {
			
		}
		
		public function initLoader(xmlUrlPath:String, levelIdParam:String):void 
		{
			this.levelId = levelIdParam;
			initFakeXML(levelIdParam);
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
			var layersList:XMLList = xmlData.child("layer");
			
			for each(var layer:XML in layersList) {
				levelMatrix.addLayer(parseLayer(layer));
			}
			dispatchEvent(new Event(LevelParser.XML_PARSED));
		}
		
		private function parseLayer(layer:XML):Array {
			var rows:XMLList = layer.child("row");
			//trace(rows.length()+" numarul de randuri din layer");
			var layerArray:Array = new Array(rows.length());
			var contor:int=0;
			for each(var row:XML in rows) {
				var rowArray:Array = parseRow(row);
				layerArray[contor] = (rowArray);
				contor++;
			}
			return layerArray;
		}
		
		private function parseRow(row:String):Array {
			return row.split(" ");
		}
		
		private function initFakeXML(levelIdParam:String):void
		{
			fakeXML = levelXML.levelArray[int(levelIdParam) -1];
		}
		
	}
	
}