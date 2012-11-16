package model.multiplayer 
{
	import flash.geom.Point;
	import model.levelGenerator.PointWherePlaced;

	public class LayoutsData 
	{
		
		public function LayoutsData() { }
		
		private static var layoutArray:Array = new Array();
		private static var intermediateLayout:Array = new Array();
		private static var centerLayout:Array = new Array();
		private static var cornersLayout:Array = new Array();
		
		private static var init:Boolean = false;
		
		public static function getLayout(layoutId:int):Array
		{
			prepareLayouts();
			return layoutArray[layoutId] as Array;
		}
		
		private static function prepareLayouts():void
		{
			if (init == false)
			{
				init = true;
				
				centerLayout = [
					new PointWherePlaced(0, 5, 7),
					new PointWherePlaced(0, 5, 8),
					new PointWherePlaced(0, 5, 9),
					new PointWherePlaced(0, 5, 10),
					new PointWherePlaced(0, 4, 7),
					new PointWherePlaced(0, 4, 8),
					new PointWherePlaced(0, 4, 9),
					new PointWherePlaced(0, 4, 10),
					new PointWherePlaced(0, 3, 7),
					new PointWherePlaced(0, 3, 8),
					new PointWherePlaced(0, 3, 9),
					new PointWherePlaced(0, 3, 10),
					new PointWherePlaced(0, 2, 7),
					new PointWherePlaced(0, 2, 8),
					new PointWherePlaced(0, 2, 9),
					new PointWherePlaced(0, 2, 10),
					new PointWherePlaced(1, 4, 8),
					new PointWherePlaced(1, 4, 9),
					new PointWherePlaced(1, 3, 8),
					new PointWherePlaced(1, 3, 9)
				];
				
				intermediateLayout = [
					new PointWherePlaced(0, 1, 5),
					new PointWherePlaced(0, 1, 6),
					new PointWherePlaced(0, 4, 5),
					new PointWherePlaced(0, 4, 6),
					new PointWherePlaced(0, 7, 5),
					new PointWherePlaced(0, 7, 6),
					new PointWherePlaced(0, 1, 11),
					new PointWherePlaced(0, 1, 12),
					new PointWherePlaced(0, 4, 11),
					new PointWherePlaced(0, 4, 12),
					new PointWherePlaced(0, 7, 11),
					new PointWherePlaced(0, 7, 12),
					new PointWherePlaced(1, 1, 5),
					new PointWherePlaced(1, 1, 6),
					new PointWherePlaced(1, 7, 5),
					new PointWherePlaced(1, 7, 6),
					new PointWherePlaced(1, 1, 11),
					new PointWherePlaced(1, 1, 12),
					new PointWherePlaced(1, 7, 11),
					new PointWherePlaced(1, 7, 12)
				];

				
				cornersLayout = [
					new PointWherePlaced(0, 2, 0),
					new PointWherePlaced(0, 2, 1),
					new PointWherePlaced(0, 1, 0),
					new PointWherePlaced(0, 1, 1),
					new PointWherePlaced(0, 2, 16),
					new PointWherePlaced(0, 2, 17),
					new PointWherePlaced(0, 1, 16),
					new PointWherePlaced(0, 1, 17),
					new PointWherePlaced(0, 7, 0),
					new PointWherePlaced(0, 6, 0),
					new PointWherePlaced(0, 7, 1),
					new PointWherePlaced(0, 6, 1),
					new PointWherePlaced(0, 7, 16),					
					new PointWherePlaced(0, 7, 17),
					new PointWherePlaced(0, 6, 16),
					new PointWherePlaced(0, 6, 17),
					new PointWherePlaced(0, 5, 7),
					new PointWherePlaced(0, 4, 8),
					new PointWherePlaced(0, 3, 9),
					new PointWherePlaced(0, 2, 10)
				];
				
				layoutArray.push(centerLayout, intermediateLayout, cornersLayout);
			}
		}
		
	}

}