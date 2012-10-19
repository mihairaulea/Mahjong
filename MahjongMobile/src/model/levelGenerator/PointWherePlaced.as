package model.levelGenerator {
	
	public class PointWherePlaced extends Object {
		
		// x - layer
		// y - row
		// z - column
		
		public var x:int;
		public var y:int;
		public var z:int;
				
		public function PointWherePlaced(xp:int, yp:int, zp:int = 0 ) 
		{
			this.x=xp;
			this.y=yp;
			this.z=zp;
		}
				
		public function isEqualTo(point2:PointWherePlaced):Boolean 
		{
			if( this.x == point2.x && this.y == point2.y && this.z == point2.z) return true;
			else return false;
		}
	}
	
	
}