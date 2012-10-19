package model.pieces
{

	public class PiecesDataSource
	{

		private static var instance:PiecesDataSource;
		
		private var piecesArray:Array = new Array();
		private var availablePieces:Array = new Array();
		
		private var noOfPieces:int=0;
		private var usedPieces:int=0;

		public static function getInstance():PiecesDataSource
		{
			if (instance == null)
			{
				instance = new PiecesDataSource(new SingletonBlocker());
			}
			return instance;
		}
		
		public function PiecesDataSource(p_key:SingletonBlocker):void
		{
			if (p_key == null)
			{
				throw new Error("Error: Instantiation failed: Use SingletonDemo.getInstance() instead of new.");
			}
		}
		
		public function deinit():void 
		{
			availablePieces = new Array();
			
			noOfPieces=0;
			usedPieces=0;
			initPieces();
		}
		
		public function test():void {
			var totalNumberOfPieces:int=0;
			for(var i:int=0;i<piecesArray.length;i++) {
				totalNumberOfPieces += piecesArray[i].noOfUnits;
			}
		}
		
		public function getPiecesForDisplay():Array {
			return piecesArray;
		}
		
		public function addPiece(piece:Piece):void 
		{
			piecesArray.push(piece);
		}
		
		public function initPieces():void 
		{
			for(var i:int=0;i<piecesArray.length;i++) 
				availablePieces[i] = piecesArray[i];
		}
		
		public function piecesLeft():Boolean 
		{
			//usedPieces==156
			if(usedPieces==156) return false;
			else return true;
		}
		
		public function getRandomUsablePiece():Piece 
		{
			if (availablePieces.length != 0) 
			{
				var randomPiece:int = Math.ceil(Math.random()*availablePieces.length-1);
				return availablePieces[randomPiece];
			}
			else return null;
		}
		
		public function usePiece(pieceId:String):void {
			usedPieces+=2;
			for(var i:int=0;i<availablePieces.length;i++) {			
				if(availablePieces[i].id == pieceId) {
				availablePieces[i].noOfUnits -= 2;
				if(availablePieces[i].noOfUnits == 0) availablePieces.splice(i,1);
				}
			}
			
			
		}
		
		
	}
}

internal class SingletonBlocker {};