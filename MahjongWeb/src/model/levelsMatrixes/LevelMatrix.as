package model.levelsMatrixes {
	
	public class LevelMatrix {
		
		public var levelArray:Array = new Array(); 
		
		public function LevelMatrix() {
			
		}
		
		public function addLayer(layerArray:Array):void {
			levelArray.push(layerArray);
		}		
	}
	
}