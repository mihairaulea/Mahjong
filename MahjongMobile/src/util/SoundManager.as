package util 
{
	
	import com.greensock.events.TweenEvent;
	import com.greensock.plugins.ScrollRectPlugin;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.media.*;
	import flash.utils.Timer;
	
	public class SoundManager 
	{	
		private static var instance:SoundManager;
		private static var allowInstantiation:Boolean;
		
		private var ambientSound:AmbientSound = new AmbientSound();
		private var ambientSoundChannel:SoundChannel = new SoundChannel();	
		private var isAmbinetSoundPlaying:Boolean = false;
		
		private var selectSound:SelectSound = new SelectSound();
		private var selectSoundChannel:SoundChannel = new SoundChannel();
		private var rejectSound:RejectSound = new RejectSound();
		private var rejectSoundChannel:SoundChannel = new SoundChannel();
		private var victorySound:VictorySound = new VictorySound();
		private var victorySoundChannel : SoundChannel = new SoundChannel();

		private var ambientTransform:SoundTransform;
		private var effectsTransform:SoundTransform;
		
		private var soundRefreshTimer : Timer;
		
		private var hasBeenInit:Boolean = false;
				
		
		public function SoundManager() 
		{
			if (!allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use SoundManager.getInstance() instead of new.");
			}
		}
		
		public function init():void 
		{
			if (hasBeenInit == false) 
			{
				ambientTransform = new SoundTransform();
				effectsTransform = new SoundTransform();

				timerTick(null);
				soundRefreshTimer = new Timer(500);
				soundRefreshTimer.addEventListener(TimerEvent.TIMER, timerTick);
				soundRefreshTimer.start();
				hasBeenInit = true;
			}
		}
		
		public function stopTimer():void 
		{
			soundRefreshTimer.stop();
		}
		
		private function timerTick(e:Event):void 
		{ 
			if (SoundGlobalVariables.PLAY_AMBIENT == true) playAmbientSound();
			else stopAmbientSound();
			
			//if (SoundGlobalVariables.PLAY_SOUND_EFFECTS) 
			//{
				//selectSoundChannel.soundTransform.volume = SoundGlobalVariables.SOUND_EFFECTS_VOLUME;
				//rejectSoundChannel.soundTransform.volume = SoundGlobalVariables.SOUND_EFFECTS_VOLUME;
				//victorySoundChannel.soundTransform.volume = SoundGlobalVariables.SOUND_EFFECTS_VOLUME;
			//}
			//else 
			//{	
			//	selectSoundChannel.soundTransform.volume = 0;
			//	rejectSoundChannel.soundTransform.volume = 0;
			//	victorySoundChannel.soundTransform.volume = 0;
			//}
		}
		
		public function playAmbientSound():void 
		{
			if (isAmbinetSoundPlaying == false) {
				ambientTransform.volume = SoundGlobalVariables.AMBIENT_SOUND_VOLUME;
				ambientSoundChannel = ambientSound.play(0, 100);
				ambientSoundChannel.soundTransform = ambientTransform;
				isAmbinetSoundPlaying = true;
			}
		}
		
		public function stopAmbientSound():void 
		{
			if (isAmbinetSoundPlaying == true) 
			{
				ambientSoundChannel.stop();
				isAmbinetSoundPlaying = false;
			}
		}
		
		public function playSelectSound():void 
		{
			if (SoundGlobalVariables.PLAY_SOUND_EFFECTS) 
			{
				effectsTransform.volume = SoundGlobalVariables.SOUND_EFFECTS_VOLUME;
				selectSoundChannel = selectSound.play(0, 0, effectsTransform);
			}
		}
		
		public function playDenySound():void 
		{
			if (SoundGlobalVariables.PLAY_SOUND_EFFECTS) 
			{
				effectsTransform.volume = SoundGlobalVariables.SOUND_EFFECTS_VOLUME;
				rejectSoundChannel = rejectSound.play(0,0,effectsTransform);
			}
		}
		
		public function playVictorySound():void 
		{
			if (SoundGlobalVariables.PLAY_SOUND_EFFECTS) 
			{
				effectsTransform.volume = SoundGlobalVariables.SOUND_EFFECTS_VOLUME;
				victorySoundChannel = victorySound.play(0,0,effectsTransform);
			}
		}

		public static function getInstance():SoundManager 
		{
			if (instance == null) 
			{
				allowInstantiation = true;
				instance = new SoundManager();
				allowInstantiation = false;
			}
		return instance;
		}
		
		public function setAmbientPlay(value:Boolean):void
		{
			SoundGlobalVariables.PLAY_AMBIENT = value;
		}
		
		public function setAmbientSoundVolume(value:int):void
		{
			SoundGlobalVariables.AMBIENT_SOUND_VOLUME = value / 100;
			ambientTransform.volume = value / 100;
			ambientSoundChannel.soundTransform = ambientTransform;
		}
		
		public function setEffectsPlay(value:Boolean):void
		{
			SoundGlobalVariables.PLAY_SOUND_EFFECTS = value;
		}
		
		public function setEffectsSoundVolume(value:int):void
		{
			SoundGlobalVariables.SOUND_EFFECTS_VOLUME = value / 100;
			effectsTransform.volume = value / 100;
			selectSoundChannel.soundTransform = effectsTransform;
			victorySoundChannel.soundTransform = effectsTransform;
			
		}
		
	}
	
}