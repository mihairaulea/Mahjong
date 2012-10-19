package model.xmlParsers {
	
	import flash.net.*;
	import starling.events.*;
	import model.pieces.*;
	import model.*;
	
	public class PiecesParser extends EventDispatcher 
	{
		public static var PIECES_PARSED:String="piecesParsed";
		
		public var picesDataSource:PiecesDataSource = PiecesDataSource.getInstance();
		
		public function PiecesParser() {
			
		}
		
		public function initLoader():void {
			parsePieces();
		}
		
		public function parsePieces():void 
		{
			for (var i:int = 1; i < 11; i++)
			{
				var piece:Piece = new Piece();
				piece.id = i.toString();
				piece.noOfUnits = 4;
				piece.url = i.toString();
				picesDataSource.addPiece(piece);
			}
			
			for (var j:int = 11; j < 19; j++)
			{
				var piece2:Piece = new Piece();
				piece2.id = j.toString();
				piece2.noOfUnits = 2;
				piece2.url = j.toString();
				picesDataSource.addPiece(piece2);
			}			
			
			for (var k:int = 19; k < 44; k++)
			{
				var piece3:Piece = new Piece();
				piece3.id = k.toString();
				piece3.noOfUnits = 4;
				piece3.url = k.toString();
				picesDataSource.addPiece(piece3);
			}			
			

			picesDataSource.test();

			dispatchEvent(new Event(PIECES_PARSED));
		}
		
	}
	
}