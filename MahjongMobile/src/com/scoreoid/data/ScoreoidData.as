package com.scoreoid.data 
{
	
	public class ScoreoidData 
	{
		
		public function ScoreoidData() 
		{
			
		}
		
		public static function getDataForScoreoid(year:String,month:String,day:String):String
		{
			return year + "-" + month + "-" + day;
		}
		
	}

}