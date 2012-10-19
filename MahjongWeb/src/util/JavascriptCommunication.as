package util
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.utils.Timer;
	
	public class JavascriptCommunication extends EventDispatcher
	{
		public static var JAVASCRIPT_READY:String="javascriptReady";
		public static var errorMessage:String;
		public static var JAVASCRIPT_ERROR:String="javascriptError";
		
		
		public function JavascriptCommunication()
		{
			
		}
		
		public function init():void {
			if (ExternalInterface.available) {
				try {
					if (checkJavaScriptReady()) {
						javascriptReady();
						//addCallbacks();
					} else {
						var readyTimer:Timer = new Timer(100, 0);
						readyTimer.addEventListener(TimerEvent.TIMER, timerHandler);
						readyTimer.start();
					}
				} catch (error:SecurityError) {
					errorMessage=error.message;
					dispatchEvent(new Event(JavascriptCommunication.JAVASCRIPT_ERROR));
				} catch (error:Error) {					
					errorMessage=error.message;
					dispatchEvent(new Event(JavascriptCommunication.JAVASCRIPT_ERROR));
				}
			}
		}
		
		private function javascriptReady():void {			
			callJavascriptFunctions();
			dispatchEvent(new Event(JavascriptCommunication.JAVASCRIPT_READY));
		}
		
		private function addCallbacks():void {
		
		}
		
		private function callJavascriptFunctions():void {
			//ExternalInterface.call( "btReady" );
		}
		
		private function checkJavaScriptReady():Boolean {
			var isReady:Boolean = ExternalInterface.call("isReady");
			return isReady;
		}
		
		private function timerHandler(event:TimerEvent):void {
			var isReady:Boolean = checkJavaScriptReady();
			ExternalInterface.call("debug","timerHandler");
			if (isReady) {
				Timer(event.target).stop();		
				javascriptReady();
			}
		}
		
		
	}
}