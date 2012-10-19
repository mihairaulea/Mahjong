package view 
{
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	import starling.display.Sprite;
	import starling.events.Event;
	import util.SoundManager;
	import view.screens.*;
	import view.util.ContentManipulator;
	import view.data.GameData;
	import com.gskinner.motion.easing.Cubic;
	import view.util.ContentRequester;
	import view.util.ContentTransition;

	
	public class View extends Sprite
	{
		private static const FIRST_SCREEN:String = "firstScreen";
		private static const GAME:String = "game";
		private static const OPTIONS:String = "options";
		private static const HOW_TO:String = "howTo";
		private static const CREDITS:String = "credits";
		private static const LEVEL_BROWSER:String = "levelBrowser";
		private static const VICTORY:String = "victory";
		
		private var theme:MahjongTheme;
		private var transitionManager:ContentTransition;
		private var navigator:ContentManipulator;
		
		private var _gameData:GameData = new GameData();
		
		private var soundManager:SoundManager;
		
		public function View()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			soundManager = SoundManager.getInstance();
			soundManager.init();
			soundManager.playAmbientSound();
			
			this.theme = new MahjongTheme(this.stage, false);
			this.navigator = new ContentManipulator();
			addChild(this.navigator);
			
			this.navigator.addScreen(FIRST_SCREEN, new ContentRequester(FirstScreen,
			{
				onLevelBrowser: LEVEL_BROWSER,
				onOptions: OPTIONS,
				onHowTo: HOW_TO,
				onCredits: CREDITS
			}));
						
			this.navigator.addScreen(LEVEL_BROWSER, new ContentRequester(LevelBrowser,
			{
				onBack: FIRST_SCREEN,
				onGame: GAME
			},
			{
				gameData: this._gameData
			}
			));
			this.navigator.addScreen(OPTIONS, new ContentRequester(Options,
			{
				onBack: FIRST_SCREEN
			}
			));
			
			this.navigator.addScreen(HOW_TO, new ContentRequester(HowTo,
			{
				onBack: FIRST_SCREEN
			}
			));
			
			this.navigator.addScreen(CREDITS, new ContentRequester(Credits,
			{
				onBack: FIRST_SCREEN
			}
			));
			
			this.navigator.addScreen(GAME, new ContentRequester(Game,
			{
				onBack: LEVEL_BROWSER,
				onVictory: VICTORY
			},
			{
				gameData: this._gameData
			}
			));
			
			this.navigator.addScreen(VICTORY, new ContentRequester(Victory,
			{
				onBack: LEVEL_BROWSER,
				onMenu: FIRST_SCREEN
			},
			{
				gameData: this._gameData
			}
			));
			
			this.navigator.showScreen(FIRST_SCREEN);

			this.transitionManager = new ContentTransition(this.navigator);
			this.transitionManager.duration = 0.4;
			this.transitionManager.ease = Cubic.easeOut;
		}
		
	}

}