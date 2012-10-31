/**
  Copyright (c) 2012, Scoroeid 
  All rights reserved.

  Redistribution and use in source and binary forms, with or without 
  modification, are permitted provided that the following conditions are
  met:

  * Redistributions of source code must retain the above copyright notice, 
    this list of conditions and the following disclaimer.
  
  * Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the 
    documentation and/or other materials provided with the distribution.
  
  * Neither the name of Scoreoid nor the names of its 
    contributors may be used to endorse or promote products derived from 
    this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  
  DOCUMENTATION AT: http://wiki.scoreoid.net/
  
  * @Author		Makai Media Inc.
  * @version	1.0.0
  * @Language   AS3
  * Date: 9/26/12
  
  * Simple CSharp Score Request Class (WP7 & Windows 8).    
**/

package  com.scoreoid
{

	import com.hurlant.crypto.Crypto;
	import com.hurlant.crypto.symmetric.ICipher;
	import com.hurlant.crypto.symmetric.IPad;
	import com.hurlant.crypto.symmetric.PKCS5;
	import com.hurlant.util.Base64;
	import com.hurlant.util.Hex;
	import flash.events.EventDispatcher;

	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import com.scoreoid.data.ScoreoidCredentials;

	public class ScoreoidEncryption extends EventDispatcher {

		private var _apikey:String = ScoreoidCredentials.apikey;
		private var _gameID:String = ScoreoidCredentials.gameID;
		private var type:String = 'simple-des-ecb';
		private var _key:ByteArray;
		
		private var callbackFunction:Function;

		public function ScoreoidEncryption() {
			_key= Hex.toArray(Hex.fromString(ScoreoidCredentials.key));//Can only be 8 characters
		}

		public function sendData(url:String,callbackFunction:Function, params:Object=null):void {
			var variables:URLVariables = new URLVariables();
			variables.api_key = _apikey;
			variables.game_id = _gameID;
			variables.response = "JSON"
			
			this.callbackFunction = callbackFunction;
			
			if (params) {
				for (var prop in params) {
					variables[prop] = params[prop];
					trace(prop + " - " + params[prop]);
				}
			}

			trace(variables.toString());
			
			var requestData:URLVariables = new URLVariables();
			requestData.data = encrypt(variables.toString());//
			var myEncryptedString:String = requestData.data;

			var request:URLRequest = new URLRequest(url);
			var requestVar:URLVariables = new URLVariables();
			requestVar.game_id = _gameID;
			requestVar.s = myEncryptedString;
			request.data = requestVar;
			request.method = URLRequestMethod.POST;

			var urlLoader:URLLoader = new URLLoader();
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			urlLoader.load(request);
		}

		private function httpStatusHandler( e:HTTPStatusEvent ):void
		{
			//trace("[Scoreoid] httpStatusHandler:" + e);
		}
		
		private function securityErrorHandler( e:SecurityErrorEvent ):void
		{
			trace("[Scoreoid] securityErrorHandler:" + e);
		}
		
		private function ioErrorHandler( e:IOErrorEvent ):void
		{
			trace("[Scoreoid] ioErrorHandler: " + e);
		}
		
		private function loaderCompleteHandler(event:Event):void
		{
			//
			callbackFunction.call( null, decrypt(event.target.data) as String);
		}

		private function encrypt(txt:String = ''):String 
		{
			var data:ByteArray = Hex.toArray(Hex.fromString(txt));
			var pad:IPad = new PKCS5();
			var mode:ICipher = Crypto.getCipher(type,_key,pad);
			pad.setBlockSize(mode.getBlockSize());
			mode.encrypt(data);
			return Base64.encodeByteArray(data);
		}

		private function decrypt(txt:String = ''):String
		{
			var data:ByteArray = Base64.decodeToByteArray(txt);
			var pad:IPad = new PKCS5();
			var mode:ICipher = Crypto.getCipher(type,_key,pad);
			pad.setBlockSize(mode.getBlockSize());
			mode.decrypt(data);
			return Hex.toString(Hex.fromArray(data));
		}
	}
}
