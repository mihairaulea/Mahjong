package view.game.pieces 
{
	import feathers.display.Image;
	import flash.geom.Point;
	import flash.sampler.NewObjectSample;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import model.levelGenerator.PointWherePlaced;
	import model.pieces.Piece;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.PDParticleSystem;
	import starling.utils.Color;
	import util.Assets;
	import util.Constants;
	
	import com.greensock.*;
	
	public class PieceVisual extends Sprite 
	{
		public static const REQUEST_SELECT:String = "requestSelect";
		public static const PIECE_BURNED:String = "pieceBurned";
		
		private var _pieceId:int;
		private var _pieceImage:Image;
		private var piece:Piece = new Piece();
		
		public var placed:Boolean = false;
		public var isSelected:Boolean = false;
		public var pointWherePlaced:PointWherePlaced = new PointWherePlaced(0, 0, 0);
		
		private var counter:int = 0;
		private var _button:Button;
		
		private var _burnParticle:PDParticleSystem;
		
		public function PieceVisual(pieceType:int) 
		{
			super();
			this._pieceId = pieceType;
			
			this._pieceImage = new Image(Assets.getAssetsTexture(this._pieceId.toString()));
			this.addChild(_pieceImage);
			this._pieceImage.color = Color.rgb(197,33,38);
			this._pieceImage.dispose();
			
			this._button = new Button(util.Assets.getAssetsTexture(this._pieceId.toString()));
			this._button.addEventListener(Event.TRIGGERED, onTrigger);
			this.addChild(_button);
			
			//this._burnParticle = new PDParticleSystem(Assets.getParticleXML("Burn"), Assets.getTexture("BurnParticleTexture"));
		}
		
		public function get pieceId():int 
		{
			return this._pieceId;
		}
		
		public function set pieceId(value:int):void
		{
			this._pieceId = value;
		}
		
		private function onTrigger(event:Event):void
		{
			this.dispatchEvent(new Event(PieceVisual.REQUEST_SELECT));
		}
		
		public function selectPiece():void
		{
			isSelected = true;
			this._button.blendMode = "multiply";
		}
		
		public function unselectPiece():void
		{
			isSelected = false;
			this._button.blendMode = "normal";
		}
		
		private function completeUnselect():void
		{
			this._button.blendMode = "normal";
		}
		
		public function burnPiece():void
		{	
			unselectPiece();
			placed = false;
			
			this._burnParticle = new PDParticleSystem(Assets.getParticleXML("Burn"), Assets.getTexture("BurnParticleTexture"));
			this._burnParticle.x = this.width / 2;
			this._burnParticle.y = this.height /4 * 3;
			addChild(this._burnParticle);
			setChildIndex(this._burnParticle, this.numChildren -1);
			
			Starling.juggler.add(this._burnParticle);
			this._burnParticle.start();
			TweenMax.to(this, 0.8, { alpha:0, onComplete: burnPieceComplete } );
		}
		
		private function burnPieceComplete():void
		{
			this.x = -100;
			this.y = -100;
			this.visible = false;
			this._burnParticle.stop();
			removeChild(this._burnParticle);
			//this._burnParticle = null;
			dispatchEvent(new Event(PieceVisual.PIECE_BURNED));
		}
		
		public function selectPieceForHint():void
		{
			
		}
		
		public function hidePiece():void
		{
			this.visible = false;
			this.placed = false;
		}
		
		public function showPiece():void
		{
			this.visible = true;
			this.alpha = 1;
			//this._pieceImage.color = Color.WHITE;
			this._button.blendMode = "normal";
		}
		
		override public function  hitTest(localPoint:Point, forTouch:Boolean = false):DisplayObject
		{
			if (forTouch && (!visible || !touchable)) return null;
			if (placed == true)
			{
				if (getBounds(this).containsPoint(localPoint))			
					return super.hitTest(localPoint, forTouch);
				else
					return null;
			}		
			else 
				return null;
		}
	}

}