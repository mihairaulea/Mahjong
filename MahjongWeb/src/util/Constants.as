package util 
{
	import starling.errors.AbstractClassError;
	public class Constants 
	{
		public function Constants() {	throw new AbstractClassError();	}
		
		public static const STAGE_WIDTH:int  = 800;  //320
        public static const STAGE_HEIGHT:int = 480;  //240
        
        public static const ASPECT_RATIO:Number = STAGE_HEIGHT / STAGE_WIDTH;
		
		//TODO: REMOVE - DEBUG
		public static var DEBUG_COUNTER:int = 0;
	}

}