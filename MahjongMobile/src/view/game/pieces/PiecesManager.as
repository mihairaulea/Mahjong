package view.game.pieces
{

	import flash.display3D.Context3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import com.greensock.*;
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.DisplayObject;
	import starling.errors.MissingContextError;
	import starling.utils.Color
	import starling.events.Event;
	import flash.events.TimerEvent;
	import util.*;

	import view.game.pieces.*;
	import model.levelGenerator.PointWherePlaced;
	import flash.utils.ByteArray;

	public class PiecesManager extends Sprite
	{		
		private var piecesArray:Array = new Array();
		private var _backboneArray:BackboneArray;
		
		private var noOfPiecesSelected:int = 0;
		private var selectedPieces:Array = new Array();

		private var noOfPiecesPlaced:int = 0;
		private var timer:Timer;
		private var moves:Array;
		private var movesIndex:int = 0;

		private var noOfErrors:int = 0;
		private var noOfDuplicates:int = 0;

		public var noOfPieces:int = 0;

		public var points:int = 0;
		public var rewardPointForFreePos:int = 0;
		
		private var scaleQuad:Quad;
		
		public static var PIECES_REMOVED:String = "piecesRemoved";
		public static var BONUS_FOR_CLASSIC:String = "bonusForClassic";
		
		private var soundManager:SoundManager = SoundManager.getInstance();

		public function PiecesManager()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			// Mobile only
			scaleQuad = new Quad(1, 1);
			addChild(scaleQuad);
			scaleQuad.alpha = 0;
			
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this._backboneArray = new BackboneArray();
			addChild(_backboneArray);
		}
		
		// Mobile only
		public function centerManager():void
		{
			_backboneArray.x = this.x - _backboneArray.width / 2;
			_backboneArray.y = this.y - _backboneArray.height / 2;
			
			scaleQuad.width = this.width;
			scaleQuad.height = this.height;
			scaleQuad.x = -scaleQuad.width/2;
			scaleQuad.y = -scaleQuad.height/2;
		}
		
		public function init(genLevel:Array):void
		{	
			//_backboneArray.reset();
			this.piecesArray = genLevel;
			
			var depth:int = 0;
			for (var i:int=genLevel.length-1; i>=0; i--)
			{
				for (var j:int=genLevel[i].length-1; j>=0; j--)
				{	
					for (var k:int=0; k<genLevel[i][j].length; k++)
					{
						if (genLevel[i][j][k] != 0 && genLevel[i][j][k] != -1)
						{
							noOfPieces++;
							this.piecesArray[i][j][k] = _backboneArray.placePiece(genLevel[i][j][k],
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

		private function clone(source:Object):*
		{
			var myBA:ByteArray = new ByteArray();
			myBA.writeObject(source);
			myBA.position = 0;
			return (myBA.readObject());
		}

		public function resetLevel():void
		{
			deinit();
		}

		public function getPoints(timeRemoved:int):int
		{
			points += 21 + 360 * 1 / (1.12 * timeRemoved);
			return points;
		}

		public function getHint():void
		{	
			for (var i:int=0; i<moves.length; i++)
			{
				var point1:PointWherePlaced = moves[i][0];
				var point2:PointWherePlaced = moves[i][1];
				if (piecesArray[point1.x][point1.y][point1.z] != -1 && piecesArray[point2.x][point2.y][point2.z] != -1)
				{
					//piecesArray[point1.x][point1.y][point1.z].transform.colorTransform = c;
					//piecesArray[point2.x][point2.y][point2.z].transform.colorTransform = c;
					i = moves.length;
				}
			}

		}

		public function loadMoves(moves:Array):void
		{
			this.moves = moves;
		}

		public function solveMahjong():void {
			if(moves!=null) {
				resetLevel();
			}
		}

		private function solve(moves:Array):void
		{

			if (moves != null)
			{
				timer = new Timer(100);
				timer.addEventListener(TimerEvent.TIMER, timerTick);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
				timer.start();
			}

		}

		private function timerTick(e:Event):void
		{
			if (movesIndex <= moves.length - 1)
			{
				var pointWherePlaced:PointWherePlaced = moves[movesIndex][0];
				var point2WherePlaced:PointWherePlaced = moves[movesIndex][1];
				removePiecesForSolve(pointWherePlaced, point2WherePlaced);
				movesIndex++;
			}
			else
			{
				timer.stop();
			}
		}

		private function timerCompleteHandler(e:Event):void
		{
			var noOfNotRemoved:int = 0;
			for (var i:int=0; i<piecesArray.length; i++)
			{
				for (var j:int=0; j<piecesArray[i].length; j++)
				{
					for (var k:int=0; k<piecesArray[i][j].length; k++)
					{
						if (piecesArray[i][j][k].alpha == 1)
						{
							noOfNotRemoved++;
						}
					}
				}

			}
		}

		private function removePiecesForSolve(point1:PointWherePlaced,point2:PointWherePlaced):void 
		{
			try
			{
				DisplayObject( piecesArray[point1.x][point1.y][point1.z] ).visible = false;
				DisplayObject( piecesArray[point2.x][point2.y][point2.z] ).visible = false;
			}
			catch (e:Error)
			{
				noOfErrors++;
			}
		}

		private function pieceBurnedHandler(e:Event):void
		{
			noOfPieces--;
			dispatchEvent(new Event(PiecesManager.PIECES_REMOVED));
		}

		private function requestSelectHandler(e:Event):void
		{
			
			trace("requesst select handler"); 
			
			noOfPiecesSelected++;
			
			if (noOfPiecesSelected < 2)
			{
				PieceVisual(e.target).selectPiece();
				selectedPieces.push(PieceVisual(e.target));
				soundManager.playSelectSound();
			}
			else
			{
				PieceVisual(e.target).selectPiece();
				selectedPieces.push(e.target);
				if (checkPiecesSame())
				{
					soundManager.playSelectSound();
					if (arePiecesFree(selectedPieces[0],selectedPieces[1]))
					{
						rewardPointForFreePos = 320;
						dispatchEvent(new Event(PiecesManager.BONUS_FOR_CLASSIC));
					}
					else
						rewardPointForFreePos = 0;
					
					points +=  rewardPointForFreePos;

					selectedPieces[0].burnPiece();
					var wherePlaced:PointWherePlaced = selectedPieces[0].pointWherePlaced;
					selectedPieces[1].burnPiece();
					var wherePlaced2:PointWherePlaced = selectedPieces[0].pointWherePlaced;

					piecesArray[wherePlaced.x][wherePlaced.y][wherePlaced.z] = -1;
					piecesArray[wherePlaced2.x][wherePlaced2.y][wherePlaced2.z] = -1;

					selectedPieces.splice(0, selectedPieces.length);
				}
				else
				{
					
					PieceVisual(selectedPieces[0]).unselectPiece();
					PieceVisual(selectedPieces[1]).unselectPiece();
					soundManager.playDenySound();
				}
				selectedPieces.splice(0,selectedPieces.length);
				noOfPiecesSelected = 0;
			}

		}


		private function arePiecesFree(piece1:PieceVisual, piece2:PieceVisual ):Boolean
		{
			var isFree1:Boolean = isPieceFree(piece1.pointWherePlaced.x,piece1.pointWherePlaced.y,piece1.pointWherePlaced.z);
			var isFree2:Boolean = isPieceFree(piece2.pointWherePlaced.x,piece2.pointWherePlaced.y,piece2.pointWherePlaced.z);

			return isFree1 && isFree2;
		}


		private function isPieceFree(x:int,y:int,z:int):Boolean
		{
			if (z + 1 < piecesArray[x][y].length)
			{
				if (piecesArray[x][y][z + 1] == -1)
				{
					return true;
				}
			}
			if (z == piecesArray[x][y].length - 1)
			{
				return true;
			}

			if (z - 1 > 0)
			{
				if (piecesArray[x][y][z - 1] == -1)
				{
					return true;
				}
			}
			if (z - 1 == 0)
			{
				return true;
			}

			return false;
		}

		private function checkPiecesSame():Boolean
		{
			var areSame:Boolean = false;
			if (selectedPieces[0].pieceId == selectedPieces[1].pieceId && selectedPieces[0] != selectedPieces[1])
			{
				areSame = true;
			}
			return areSame;
		}
		
		public function deinit():void {
			_backboneArray.reset();
			
			noOfPiecesPlaced = 0;
			noOfPieces = 0;
			
			piecesArray.splice(0,piecesArray.length);
			//piecesArray = new Array();
			
			noOfPiecesSelected = 0;
			selectedPieces.splice(0, selectedPieces.length);
			noOfPiecesPlaced = 0;
		    
			//moves.splice(0, moves.length);
			movesIndex = 0;

			points = 0;
		}
		
		public function didWin():Boolean {
			var result:Boolean = true;
			for (var i:int = 0; i < piecesArray.length; i++) 
				for (var j:int = 0; j < piecesArray[i].length; j++)
				 for (var k:int = 0; k < piecesArray[i][j].length; k++)
				 {
					if (piecesArray[i][j][k] != -1 && piecesArray[i][j][k] != 0 && PieceVisual(this.piecesArray[i][j][k]).visible == true) 
					{
						return false;
					}
				 }
			return result;
		}

		// Mobile only - masking the pieces manager for zoom
		private var mClipRect:Rectangle;
        
        public override function render(support:RenderSupport, alpha:Number):void
        {
            if (mClipRect == null) super.render(support, alpha);
            else
            {
                var context:Context3D = Starling.context;
                if (context == null) throw new MissingContextError();
                
                support.finishQuadBatch();
                context.setScissorRectangle(mClipRect);
                
                super.render(support, alpha);
                
                support.finishQuadBatch();
                context.setScissorRectangle(null);
            }
        }
        
        public override function hitTest(localPoint:Point, forTouch:Boolean=false):DisplayObject
        {
            // without a clip rect, the sprite should behave just like before
            if (mClipRect == null) return super.hitTest(localPoint, forTouch);
            
            // on a touch test, invisible or untouchable objects cause the test to fail
            if (forTouch && (!visible || !touchable)) return null;
            
            var scale:Number = Starling.current.contentScaleFactor;
            var globalPoint:Point = localToGlobal(localPoint);
            
            if (mClipRect.contains(globalPoint.x * contentScaleX, globalPoint.y * contentScaleY))
                return super.hitTest(localPoint, forTouch);
            else
                return null;
        }
        
        public function get clipRect():Rectangle
        {
            if (mClipRect)
            {
                var scaleX:Number = contentScaleX;
                var scaleY:Number = contentScaleY;
                
                return new Rectangle(mClipRect.x / scaleX, mClipRect.y / scaleY,
                    mClipRect.width / scaleX, mClipRect.height / scaleY);
            }
            else return null;
        }
        
        public function set clipRect(value:Rectangle):void
        {
            if (value)
            {
                var scaleX:Number = contentScaleX;
                var scaleY:Number = contentScaleY;
                
                if (mClipRect == null) mClipRect = new Rectangle();
                mClipRect.setTo(scaleX * value.x, scaleY * value.y,
                    scaleX * value.width, scaleY * value.height);
            }
            else mClipRect = null;
        }
        
        private function get contentScaleX():Number
        {
            var currentStarling:Starling = Starling.current;
            return currentStarling.viewPort.width / currentStarling.stage.stageWidth;
        }
        
        private function get contentScaleY():Number
        {
            var currentStarling:Starling = Starling.current;
            return currentStarling.viewPort.height / currentStarling.stage.stageHeight;
        }
	
	}
	
}