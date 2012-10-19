package view.data 
{
	import view.game.pieces.PiecesManager;
	public class GameData 
	{
		//Game / Pieces
		public var id:int = 0;
		public var piecesInit:Boolean = false;
		//public var piecesManager:PiecesManager;
		
		//Victory
		public var score:String = "";
		public var time:String = "";
		public var rank:String = "";
		
		public function GameData() 
		{
			
		}
		
	}

}