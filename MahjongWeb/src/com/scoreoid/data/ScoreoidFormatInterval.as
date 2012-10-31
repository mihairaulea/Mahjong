package com.scoreoid.data 
{
	/**
	 * ...
	 * @author Mihai Raulea
	 */
	public class ScoreoidFormatInterval 
	{
		
		public function ScoreoidFormatInterval() 
		{
			
		}
		
		public static function getDataInInterval(startIndex:int, endIndex:int)
		{
			return (String)(startIndex) + "," + (String)(endIndex);
		}
		
	}

}