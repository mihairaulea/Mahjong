package model {
	
	public class BonusManager {		
		
		public function BonusManager() {
			
		}
		
		public static function getScoreBonusForTime(time:int):int {
			if (time < GameConstants.TIME_INTERVAL_1) return GameConstants.TIME_BONUS_0;
			else if (time >= GameConstants.TIME_INTERVAL_1 && time < GameConstants.TIME_INTERVAL_2) return GameConstants.TIME_BONUS_1;
			 else if (time >= GameConstants.TIME_INTERVAL_2 && time < GameConstants.TIME_INTERVAL_3) return GameConstants.TIME_BONUS_2;
			   else if (time >= GameConstants.TIME_INTERVAL_3) return GameConstants.TIME_BONUS_3;
		    return 0;
		}
		
		public static function getScoreBonusForScore(time:int):int {
			if (time < GameConstants.SCORE_INTERVAL_1) return GameConstants.SCORE_BONUS_0;
			else if (time >= GameConstants.SCORE_INTERVAL_1 && time < GameConstants.SCORE_INTERVAL_2) return GameConstants.SCORE_BONUS_1;
			 else if (time >= GameConstants.SCORE_INTERVAL_2 && time < GameConstants.SCORE_INTERVAL_3) return GameConstants.SCORE_BONUS_2;
			   else if (time >= GameConstants.SCORE_INTERVAL_3) return GameConstants.SCORE_BONUS_3;
			return 0;
		}
		
		public static function getStatForScore(score:int):String {
			if (score < 4500) return "ROOKIE";
			 else if (score >= 4500 && score < 7000) return "APPRENTICE";
			  else if (score >= 7000 && score < 10000) return "EXPERIMENTED";
			   else if (score >= 10000 && score < 20000) return "EXPERT";
			    else return "GOD";
		}
		
	}
	
}