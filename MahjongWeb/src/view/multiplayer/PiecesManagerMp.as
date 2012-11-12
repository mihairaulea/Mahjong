package view.multiplayer 
{
	import starling.display.Sprite;
	import starling.display.DisplayObject;
	import starling.utils.Color
	import starling.events.Event;
	import util.*;
	import view.game.pieces.*;
	import model.levelGenerator.PointWherePlaced;
	import flash.utils.ByteArray;
	import model.GameConstants;
	
	public class PiecesManagerMp extends Sprite
	{
		public static const PIECES_REMOVED:String = "piecesRemoved";
		public static const BONUS_FOR_CLASSIC:String = "bonusForClassic";
		
		private var _piecesArray:Array;
		private var _backboneArray:BackboneArray;
		
		// TODO: Delete
		private var noOfPiecesSelected:int = 0;
		private var selectedPieces:Array = new Array();
		
		private var noOfPiecesPlaced:int = 0;
		public var noOfPieces:int = 0;
		public var rewardPointForFreePos:int = 0;
		
		public function PiecesManagerMp() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this._backboneArray = BackboneArray.getInstance();
			addChild(_backboneArray);
		}
		
		public function init():void
		{
			
		}
		
		// TODO: Delete
		private function pieceBurnedHandler(e:Event):void
		{
			noOfPieces--;
			dispatchEvent(new Event(PiecesManager.PIECES_REMOVED));
		}
		
		// TODO: Delete
		private function arePiecesFree(piece1:PieceVisual, piece2:PieceVisual ):Boolean
		{
			var isFree1:Boolean = isPieceFree(piece1.pointWherePlaced.x,piece1.pointWherePlaced.y,piece1.pointWherePlaced.z);
			var isFree2:Boolean = isPieceFree(piece2.pointWherePlaced.x,piece2.pointWherePlaced.y,piece2.pointWherePlaced.z);

			return isFree1 && isFree2;
		}
		
		// TODO: Delete
		private function isPieceFree(x:int,y:int,z:int):Boolean
		{
			if (z + 1 < piecesArray[x][y].length)
				if (piecesArray[x][y][z + 1] == -1)
					return true;
					
			if (z == piecesArray[x][y].length - 1)
				return true;

			if (z - 1 > 0)
				if (piecesArray[x][y][z - 1] == -1)
					return true;
					
			if (z - 1 == 0)
				return true;

			return false;
		}
		
		// TODO: Delete
		private function checkPiecesSame():Boolean
		{
			var areSame:Boolean = false;
			if (selectedPieces[0].pieceId == selectedPieces[1].pieceId && selectedPieces[0] != selectedPieces[1])
				areSame = true;

			return areSame;
		}
		
		public function deinit():void {
			_backboneArray.reset();
			
			noOfPiecesPlaced = 0;
			noOfPieces = 0;
			
			piecesArray.splice(0,piecesArray.length);
			
			noOfPiecesSelected = 0;
			selectedPieces.splice(0, selectedPieces.length);
			noOfPiecesPlaced = 0;		    
		}
		
		// --------------------------------------------------------------------
		// MULTIPLAYER
		// --------------------------------------------------------------------
		
		// !!!
		public function placeWave(placementArray:Array):void
		{
			//TODO: Dont forget to add events to pieces if events dont exist!!
			removePreviousWave();
			
			this.piecesArray = placementArray;
			
			var depth:int = 0;
			for (var i:int=placementArray.length-1; i>=0; i--)
			{
				for (var j:int=placementArray[i].length-1; j>=0; j--)
				{	
					for (var k:int=0; k<placementArray[i][j].length; k++)
					{
						if (placementArray[i][j][k] != 0 && placementArray[i][j][k] != -1)
						{
							noOfPieces++;
							this.piecesArray[i][j][k] = _backboneArray.placePiece(placementArray[i][j][k],
								new PointWherePlaced(i, j, k));
							if (!((this.piecesArray[i][j][k] as PieceVisual).hasEventListener(PieceVisual.REQUEST_SELECT)))
								PieceVisual(this.piecesArray[i][j][k]).addEventListener(PieceVisual.REQUEST_SELECT, requestSelectHandler);
							if (!((this.piecesArray[i][j][k] as PieceVisual).hasEventListener(PieceVisual.PIECE_BURNED)))
								PieceVisual(this.piecesArray[i][j][k]).addEventListener(PieceVisual.PIECE_BURNED, pieceBurnedHandler);
							noOfPiecesPlaced++;
						}
					}
				}
			}
			
		}
		
		private function removePreviousWave():void
		{
			// Remove all pieces from the board 
			
		}
		
		private function requestSelectHandler(e:Event):void
		{	
			
		}
		
		public function burnPieces(piecesIds:Array):void
		{
			
		}
		
		public function selectPiece(pieceId:int):void
		{
			
		}
	}

}