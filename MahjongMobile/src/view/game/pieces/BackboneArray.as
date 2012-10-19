package view.game.pieces 
{
	import flash.sampler.NewObjectSample;
	import model.levelGenerator.PointWherePlaced;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class BackboneArray extends Sprite
	{
		private const _piecesCount:int = 43;
		private const _pairCount:int = 30;
		
		private var _piecesArray:Array;
		private var _eventArray:Array; 
		
		// Sprite pools
		private var _inactivePieces:Sprite;
		private var _activePieces:Sprite;
		
		public function BackboneArray() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			this._piecesArray = new Array();
			this._eventArray = new Array();
			this._inactivePieces = new Sprite();
			this._activePieces = new Sprite();
			
			this.addChild(_inactivePieces);
			this.addChild(_activePieces);
			
			for (var i:int = 0; i < _piecesCount; i++)
			{
				_piecesArray.push(new Array());
				for (var j:int = 0; j < _pairCount; j++)
				{
					var pieceVisual:PieceVisual = new PieceVisual(i+1);
					pieceVisual.hidePiece();
					this._inactivePieces.addChild(pieceVisual);
					
					_piecesArray[i].push(pieceVisual);
				}
			}
			
			this._inactivePieces.flatten();
		}
				
		public function getPieces():Array
		{
			return this._piecesArray;
		}
		
		public function reset():void
		{
			for (var i:int = 0; i < _piecesArray.length; i++)
				for each(var piece:PieceVisual in _piecesArray[i])
				{
					piece.x = -100;
					piece.y = -100;
					piece.placed = false;
					piece.hidePiece();
					this._inactivePieces.addChild(piece);
				}
		}
		
		public function placePiece(id:int, pointWherePlaced:PointWherePlaced):PieceVisual
		{
			id--;
			var c:int = 0;
			var pieceVisual:PieceVisual = _piecesArray[id][c];
			while (pieceVisual.placed == true)
			{
				c++;
				pieceVisual = _piecesArray[id][c];
			} 
			
			//pieceVisual = _piecesArray[id][c];
			
			this._activePieces.addChild(pieceVisual);
			
			pieceVisual.pointWherePlaced.x = pointWherePlaced.x;
			pieceVisual.pointWherePlaced.y = pointWherePlaced.y;
			pieceVisual.pointWherePlaced.z = pointWherePlaced.z;
			
			pieceVisual.x = pieceVisual.width * pointWherePlaced.z * 0.9 + pieceVisual.width * pointWherePlaced.x / 12;
			pieceVisual.y = pieceVisual.height * pointWherePlaced.y * 0.9 + pieceVisual.height * pointWherePlaced.x / 20;
			
			this._activePieces.setChildIndex(pieceVisual, _activePieces.numChildren - 1);
			pieceVisual.showPiece();
			pieceVisual.placed = true;
			return pieceVisual;
		}
	}

}