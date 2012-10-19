package util 
{
	import starling.errors.AbstractClassError;
	public class Constants 
	{
		public function Constants() {	throw new AbstractClassError();	}
		
		public static const STAGE_WIDTH:int  = 800;  //320
        public static const STAGE_HEIGHT:int = 480;  //240
        
        public static const ASPECT_RATIO:Number = 480 / 800; // Stage width / stage height
		
		//Mobile constants
		public static var ZOOM_ENABLED:Boolean = false;
		public static var TOUCH_ENABLED:Boolean = false;
		
		
		//TODO: REMOVE - DEBUG
		public static var DEBUG_COUNTER:int = 0;
	}

}