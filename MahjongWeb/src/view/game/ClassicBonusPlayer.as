package view.game {
	
	import flash.display.*;
	import flash.events.*;
	import com.greensock.*;
	import com.greensock.easing.*;
	
	public class ClassicBonusPlayer extends Sprite {
		
		private var clips:Array = new Array();
		private var clipId:int = 0;
		
		public function ClassicBonusPlayer() {
			this.x = 617;
			this.y = 455;
		}
		
		public function play() {
			var classicBonus:ClassicBonusClip = new ClassicBonusClip();
			addChild(classicBonus);
			classicBonus.scaleX = 0.2;
			classicBonus.scaleY = 0.2;
			classicBonus.rotation = 15;
			classicBonus.alpha = 0;
			clips[clipId] = classicBonus;
			clipId++;
			TweenMax.to(classicBonus, 0.3, { alpha:1 } );
			TweenMax.to(classicBonus, 1.2, { scaleX:1, scaleY:1, rotation:0, ease:Circ.easeOut, onComplete: fadeOut, onCompleteParams:[ clipId-1 ] } );
		}
		
		private function fadeOut(clipId:int) {
			TweenMax.to(clips[clipId], 2.9, { alpha:0, y: this.y - 200, onComplete:removeClip, onCompleteParams:[clipId] } );
		}
		
		private function removeClip(clipId:int) {
			//removeChild( clips[clipId]);
			//clips.splice(clipId, 1);
			for (var i:int = 0; i < clipId ; i++) {
				if (clips[i] is DisplayObject) { removeChild(clips[i]); clips[i] = null;}
			}
		}
		
		
	}
	
}