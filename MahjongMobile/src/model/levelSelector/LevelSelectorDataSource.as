package model.levelSelector
{
	public class LevelSelectorDataSource
	{

		private static var instance:LevelSelectorDataSource;
		
		private var levels:Object = new Object();
		

		public static function getInstance():LevelSelectorDataSource
		{
			if (instance == null)
			{
				instance = new LevelSelectorDataSource(new SingletonBlocker());
			}
			return instance;
		}
		
		public function LevelSelectorDataSource(p_key:SingletonBlocker):void
		{
			if (p_key == null)
			{
				throw new Error("Error: Instantiation failed: Use SingletonDemo.getInstance() instead of new.");
			}
		}
		
		public function addLevel(levelItem:LevelSelectorItem):void 
		{
			levels[levelItem.levelName+"@"+levelItem.levelCategory] = levelItem;
		}
		
		public function getLevels():Array {
			var result:Array = new Array();
			for each(var obj:LevelSelectorItem in levels) {
				result.push(obj);
			}
			return result;
		}
		
		public function getLevelsForCategory(categoryString:String):Array {
			var arrayCategoryLevels:Array = new Array();
			for each(var obj:LevelSelectorItem in levels) {
				if(obj.levelCategory == categoryString) {
					arrayCategoryLevels.push(obj);
				}
			}
			trace("getLevelsForCategory " + categoryString +" returns an array with " + arrayCategoryLevels.length + " elements");
			return arrayCategoryLevels;		
			
		}
		
	}
}

internal class SingletonBlocker {};