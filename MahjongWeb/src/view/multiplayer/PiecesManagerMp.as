package view.multiplayer 
{
	import com.greensock.TweenLite;
	import model.multiplayer.LayoutsData;
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
		public static const REQUEST_SELECT:String = "requestSelect";
		
		private var _piecesArray:Array;
		private var _backboneArray:BackboneArray;
		
		private var _placementArray:Array;
		private var _layoutArray:Array;
		
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
		
		public function deinit():void {
			_backboneArray.reset();
			
			noOfPiecesPlaced = 0;
			noOfPieces = 0;
			
			_piecesArray.splice(0,_piecesArray.length);
			
			noOfPiecesSelected = 0;
			selectedPieces.splice(0, selectedPieces.length);
			noOfPiecesPlaced = 0;		    
		}
		
		// --------------------------------------------------------------------
		// MULTIPLAYER
		// --------------------------------------------------------------------
		
		// !!!
		public function placeWave(placementArray:Array, layoutId:int):void
		{
			this._layoutArray = LayoutsData.getLayout(layoutId);
			this._placementArray = placementArray;
			
			removePreviousWave();
		}
		
		private function removePreviousWave():void
		{			
			if (_piecesArray != null)
			{
				for (var i:int = 0; i < _piecesArray.length; i++)
				{
					if (_piecesArray[i].placed == true)
					{
						_piecesArray[i].unselectPiece();
						_piecesArray[i].placed = false;
						PieceVisual(_piecesArray[i]).visible = false;
						
					}
				}
				
				deinit();
				placeNewWave();
			}
			else
			{
				placeNewWave();
			}
		}
		
		private function placeNewWave():void
		{
			this._piecesArray = new Array();
			
			for (var i:int = 0; i < _placementArray.length; i++)
			{
				this._piecesArray[i] = _backboneArray.placePiece((_placementArray[i] as PieceVisual).pieceId, _layoutArray[i]);
				if (!((_piecesArray[i] as PieceVisual).hasEventListener(PieceVisual.REQUEST_SELECT)))
					PieceVisual(_piecesArray[i]).addEventListener(PieceVisual.REQUEST_SELECT, requestSelectHandler);
				
				noOfPieces++;
				noOfPiecesPlaced++;
			}			

		}
		
		private function requestSelectHandler(e:Event):void
		{
			//PieceVisual(e.target)
			dispatchEvent(new Event(REQUEST_SELECT));
			
		}
		
		public function burnPieces(piecesIds:Array):void
		{
			for each(var id:int in piecesIds)
			{
				PieceVisual(_piecesArray[id]).burnPiece();
				noOfPiecesPlaced--;
			}
		}
		
		public function selectPiece(pieceId:int):void
		{
			PieceVisual(_piecesArray[pieceId]).selectPiece();
		}
	}

}