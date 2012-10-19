package model {
		
	import starling.events.*;
	import util.*;
	import model.xmlParsers.*;
	import model.levelSelector.*;
	import model.levelsMatrixes.*;

		
	public class Model extends EventDispatcher {
		
		public static var DATA_READY:String="dataReady";
		private var noOfLevels:int;
		private var noOfLevelsParsed:int=0;
		
		public function Model() {	
			
		}
		
		public function init():void 
		{			
			initLevelMetadataParser();
		}
		
		private function initLevelMetadataParser():void 
		{
			var levelMetadataParser:LevelMetadataParser = new LevelMetadataParser();
			levelMetadataParser.addEventListener(LevelMetadataParser.XML_PARSED, xmlParsedHandler);			
			levelMetadataParser.initLoader();
		}
		
		private function xmlParsedHandler(e:Event):void 
		{			
			var levelDataSource :LevelSelectorDataSource = LevelSelectorDataSource.getInstance();
			
			var array:Array = levelDataSource.getLevels();
			noOfLevels = (array.length);
			for (var i:int = 0; i < array.length; i++) 
			{
				var levelParser:LevelParser = new LevelParser();
				levelParser.addEventListener(LevelParser.XML_PARSED, levelParsedHandler);
				levelParser.initLoader(array[i].levelXMLURL, array[i].levelName);
			}
			
		}
		
		private function levelParsedHandler(e:Event):void 
		{	
			var lp:LevelParser = (e.target) as LevelParser;
			var levelMatrixDataSource:LevelMatrixDataSource = LevelMatrixDataSource.getInstance();
			levelMatrixDataSource.addLevelMatrix(lp.levelMatrix, lp.levelId);
			noOfLevelsParsed++;
			if (noOfLevelsParsed == noOfLevels) 
				dispatchEvent(new Event(Model.DATA_READY));
		}
	}
	
}