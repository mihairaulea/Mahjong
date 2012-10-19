package  
{
	import feathers.controls.Button;
	import feathers.text.BitmapFontTextFormat;
	import flash.display.Bitmap;
	import model.Model;
	import starling.core.Starling;
	import util.Constants;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.BitmapFont;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	import util.Assets;
	
	import view.View;
	
	public class MainInterface extends Sprite
	{		
		private var viewComponent:View = new View();
		private var modelComponent:Model = new Model();
		
		public function MainInterface() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			init();
			
		}
		
		private function init():void
		{	
			// Setting stage size - do test
			stage.stageWidth = Constants.STAGE_WIDTH;
			stage.stageHeight = Constants.STAGE_HEIGHT;
			
			// ContentScaleFactor based on stage size and viewport size
			util.Assets.contentScaleFactor = Starling.current.contentScaleFactor;
			
			// Prepare sound/bitmap font/font assest
			util.Assets.prepareSounds();
			util.Assets.loadBitmapFonts();
			
			// Init model component
			modelComponent.addEventListener(Model.DATA_READY, dataReadyHandler);
			modelComponent.init();
		}
		
		private function dataReadyHandler(event:Event):void
		{
			this.addChild(viewComponent);
			trace("got here 2");
		}
	}

}