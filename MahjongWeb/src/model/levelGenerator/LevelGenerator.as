package model.levelGenerator {
	
		
	public class LevelGenerator {
		
		public var generatedLevel:Array = new Array();
		public var moves:Array = new Array();
						
		private var workLayer:int = 0;
						
		public function LevelGenerator() {
			
		}
		
		public function init(levelArray:Array):void 
		{	
			for (var i:int = 0; i < levelArray.length; i++) {
				generatedLevel[i] = new Array();
				for (var j:int = 0; j < levelArray[i].length; j++) {
					generatedLevel[i][j] = new Array();
					for (var k:int = 0; k < levelArray[i][j].length; k++) {
						generatedLevel[i][j][k] = levelArray[i][j][k];
					}
				}
			}
		}
		
		public function placePiece(pieceId:String):Array {
					
			var wherePlacedArray:Array = new Array(2);
			
			if(isLayerFull()==true) {workLayer++;}
			
			if(workLayer <= generatedLevel.length) {
				
			var wherePlaced:PointWherePlaced = new PointWherePlaced(0,0);
			wherePlaced = placeFirstPieceFromPairOnLevel(pieceId);
			var wherePlaced2:PointWherePlaced = new PointWherePlaced(0,0);
			wherePlaced2 = placeSecondPieceFromPairOnLevel(pieceId, wherePlaced);
			
			wherePlacedArray[0] =wherePlaced;
			wherePlacedArray[1] =wherePlaced2;
			
			moves.push(wherePlacedArray);
			
			}
			
			return wherePlacedArray;
		}
		
		private function placeFirstPieceFromPairOnLevel(pieceId:String):PointWherePlaced {
			var wherePlaced:PointWherePlaced =new PointWherePlaced(0,0);
			
			wherePlaced = getFreePosition();
			
			if(wherePlaced!=null) generatedLevel[wherePlaced.x][wherePlaced.y][wherePlaced.z] = pieceId;			
			return wherePlaced;
		}
		
		private function placeSecondPieceFromPairOnLevel(pieceId:String, pointWherePlacedFirst:PointWherePlaced):PointWherePlaced {
			var wherePlaced:PointWherePlaced =new PointWherePlaced(0,0);
			
			wherePlaced = getFreePosition();
						
			if(wherePlaced!=null) generatedLevel[wherePlaced.x][wherePlaced.y][wherePlaced.z] = pieceId;			
			return wherePlaced;
		}
		
		private function doesRowHaveFreePosition(layer:int, row:int):Boolean 
		{
			for(var i:int=0;i<generatedLevel[layer][row].length;i++) {
				if(generatedLevel[layer][row][i] == 0 && ( generatedLevel[layer][row][i+1] == 0 || generatedLevel[layer][row][i-1]==0) ) return true;
			}
			return false;
		}
		
		private function getFreePosition(wherePlacedFirst:PointWherePlaced = null):PointWherePlaced 
		{	
			var contingentBlocksArray:Array = new Array();
			
			for(var k:int=0;k<generatedLevel[workLayer].length;k++)
					 contingentBlocksArray.push( getContingentBlocks( workLayer, k, generatedLevel[workLayer][k] ) );
				
			var goodBlocks:Array = new Array();
			
			for(var i:int=0;i<contingentBlocksArray.length;i++) {
				for(var j:int=0;j<contingentBlocksArray[i].length;j++) {
				if(checkBlockForFreePos(contingentBlocksArray[i][j]) == true) goodBlocks.push(contingentBlocksArray[i][j]);
				}
			}
			
			if(goodBlocks.length == 0) return null;
			var chosenBlockRow:int = Math.floor(Math.random() * goodBlocks.length);						
			var point:PointWherePlaced  = getPosToPlacePiece(goodBlocks[chosenBlockRow]);
			
			return point;
		}
		
		public function getContingentBlocks(layer:int, row:int, rowArray:Array):Array 
		{
			var returnArray:Array = new Array();
			
				var isSaved:Boolean = false;
				var contor:int = 0;
                
				if(rowArray[i] != -1) returnArray[contor] = new Array();
					else contor = -1;
				
			for(var i:int=0;i<rowArray.length;i++) {
				if(rowArray[i] == 0) { if(isSaved==true) { contor++;returnArray[contor] = new Array();returnArray[contor].splice(0, returnArray[contor].length);}isSaved = false; returnArray[contor].push( new PointWherePlaced(layer, row, i) );}
				else { if(isSaved == false) {isSaved = true;} }
			}
			
			return returnArray;
		}
		
		private function checkBlockForFreePos(contingentBlockArray:Array):Boolean 
		{
			var valueToTheLeft:int = -888;
			var valueToTheRight:int = -888;
			var above:int = -888;
		
			for (var i:int = 0; i < contingentBlockArray.length; i++) 
			{		
				var layer:int = contingentBlockArray[i].x;
				var row:int = contingentBlockArray[i].y;
				var column:int = contingentBlockArray[i].z;
				
				if( column -1 >= 0) 
						 valueToTheLeft = generatedLevel[layer][row][column -1];
					else valueToTheLeft = -888;
										
				if(column + 1 < generatedLevel[layer][row].length ) 
						 valueToTheRight = generatedLevel[layer][row][column + 1];
					else valueToTheRight = -888;
					
				if( layer + 1 < generatedLevel.length ) 
						 above = generatedLevel[layer + 1][row][column ];
					else above = 0;
					
				if(valueToTheLeft != -888) if(  (valueToTheLeft == 0 || valueToTheLeft == -1) && (above == 0 || above == -1) ) return true;
				if(valueToTheRight != -888) if(  (valueToTheRight == 0 || valueToTheRight == -1) && (above == 0 || above == -1) ) return true;
			}
				return false;
		}
		
		private function getPosToPlacePiece(blockArray:Array):PointWherePlaced 
		{
			if(blockArray == null) trace("block array is null");
			
			var placed:Boolean  = false;
			
			var middle:int = Math.floor(blockArray.length-1/2);
			var leftOrRight:int = Math.ceil(Math.random()*2);
			
			var point:PointWherePlaced;
			
			if(leftOrRight==1) {
				point = goLeft(blockArray, middle);
				if(point!=null) placed=true;
			}
			else if(leftOrRight==2) {
				point = goRight(blockArray, middle);
				if(point!=null) placed=true;				
			}
			
			if(placed==false) if(leftOrRight==1) point =  goRight(blockArray, middle);
			if(placed==false) if(leftOrRight==2) point = goLeft(blockArray, middle);
			if(point==null) trace("point is null");
			
			return point;	
		}
		
		private function goLeft(blockArray:Array, middle:int):PointWherePlaced 
		{
			for(var i:int=middle;i>=0;i--) {
					var layer:int = blockArray[i].x;
					var row:int = blockArray[i].y;
					var column:int = blockArray[i].z;
					if( generatedLevel[layer][row][column] == 0) return blockArray[i];
				}
			return null;
		}
		
		private function goRight(blockArray:Array, middle:int):PointWherePlaced 
		{
			for(var j:int=middle;j<blockArray.length;j++) {
					var layer:int = blockArray[j].x;
					var row:int = blockArray[j].y;
					var column:int = blockArray[j].z;
					if( generatedLevel[layer][row][column] == 0) return blockArray[j];
				}
			return null;
		}
		
		private function isLayerFull():Boolean 
		{
			var isFull:Boolean = true;
			for(var i:int=0;i<generatedLevel[workLayer].length;i++)
				for(var j:int=0;j<generatedLevel[workLayer][i].length;j++) {
					if( generatedLevel[workLayer][i][j] == 0) isFull = false;
				}			
			return isFull;
		}
		
		public function test():void 
		{
			var string:String="";
			for(var i:int=0;i<generatedLevel.length;i++) {
				for(var j:int=0;j<generatedLevel[i].length;j++) {
					string = "";
					for(var k:int=0;k<generatedLevel[i][j].length;k++) {
						string += generatedLevel[i][j][k]+" ";
					}
				}
			}
		}
		
		public function deinit():void {
			workLayer = 0;
		}
		
	}
	
}