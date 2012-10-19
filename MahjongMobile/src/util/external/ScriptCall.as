package util.external {
	
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequestMethod;
	
	public class ScriptCall extends EventDispatcher {
				
		public static var SERVER_ADDRESS:String = "";
				
		public function ScriptCall() {
			
		}
		
		public function sendToServer() {
			var loaderServerSide:URLLoader=new URLLoader();
			var request:URLRequest=new URLRequest(ScriptCall.SERVER_ADDRESS);
			var vars:URLVariables=new URLVariables();
			vars.categorie=idProdus;
			loaderServerSide.dataFormat=URLLoaderDataFormat.TEXT;
			request.method=URLRequestMethod.GET;
			request.data=vars;
			loaderServerSide.addEventListener(Event.COMPLETE, handleProdusComplete);
			loaderServerSide.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loaderServerSide.load(request);
		}
		
	}
	
}