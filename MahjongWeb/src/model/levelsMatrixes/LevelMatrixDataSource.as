package model.levelsMatrixes
{
	public class LevelMatrixDataSource
	{

		private static var instance:LevelMatrixDataSource;
		
		private var levels:Object = new Object();

		public static function getInstance():LevelMatrixDataSource
		{
			if (instance == null)
			{
				instance = new LevelMatrixDataSource(new SingletonBlocker());
			}
			return instance;
		}
		
		public function LevelMatrixDataSource(p_key:SingletonBlocker):void
		{
			if (p_key == null)
			{
				throw new Error("Error: Instantiation failed: Use LevelMatrixDataSource.getInstance() instead of new.");
			}
		}
		
		public function addLevelMatrix(levelMatrix:LevelMatrix,levelId:String):void {
			levels[levelId] = levelMatrix;
		}
		
		public function getLevelMatrix(levelId:String):LevelMatrix {
			return levels[levelId];
		}
		
		public function deinit():void {
			
		}
		
		
	}
}

internal class SingletonBlocker {};