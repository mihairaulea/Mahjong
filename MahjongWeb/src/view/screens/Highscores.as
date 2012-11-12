package view.screens 
{
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.controls.ScreenHeader;
	import feathers.data.ListCollection;
	import starling.display.DisplayObject;
	import starling.events.Event;

	import model.highscores.HighscoresModel;
	
	public class Highscores extends Screen
	{
		private static const ON_BACK:String = "onBack";
		
		// List settings 
		public var isSelectable:Boolean = true;
		public var hasElasticEdges:Boolean = true;
		
		private var _list:List;
		private var _header:ScreenHeader;
		private var _backButton:Button;
		
		private var _items:Array;
		
		var highscoresModel:HighscoresModel = HighscoresModel.getInstance();
		
		public function Highscores() 
		{
			super();
		}
		
		override protected function initialize():void
		{
			highscoresModel.addEventListener(HighscoresModel.HIGHSCORES_RETRIEVED, highscoresReceivedFromNetwork);
			_items = new Array();
			
			// Debug
			/*
			for(var i:int = 0; i < 100; i++)
			{
				var item:Object = {text: "Item " + (i + 1).toString()};
				_items.push(item);
			}
			*/
			
			this._list = new List();
			this._list.dataProvider = new ListCollection(_items);
			this._list.typicalItem = { text: "Default text lenght here" };
			this._list.isSelectable = this.isSelectable;
			this._list.scrollerProperties.hasElasticEdges = this.hasElasticEdges;
			this._list.itemRendererProperties.labelField = "text";
			this._list.itemRendererProperties.horizontalAlign = "center";
			this._list.onChange.add(list_onChange);
			addChildAt(this._list, 0);
			
			
			this._backButton = new Button();
			this._backButton.label = "Back";
			this._backButton.onRelease.add(backButton_onRelease);
			
			this._header = new ScreenHeader();
			this._header.title = "Highscores";
			addChild(this._header);
			this._header.leftItems = new <DisplayObject> 
			[
				this._backButton
			];
			
			this.backButtonHandler = this.onBackButton;
		}
		
		override protected function draw():void
		{
			this._header.width = this.actualWidth;
			this._header.validate();

			
			this._list.y = this._header.height;
			this._list.width = this.actualWidth;
			this._list.height = this.actualHeight - this._list.y;
		}
		
		public function updateList():void
		{
			highscoresModel.retrieveTopScores();
		}
		
		private function highscoresReceivedFromNetwork(e:Event)
		{
			this._items = highscoresModel.highscoresArray;
			this._list.dataProvider = new ListCollection(_items);
			this._list.invalidate();
		}
		
		private function backButton_onRelease(button:Button):void
		{
			this.onBackButton();
		}
		
		private function onBackButton():void
		{
			this.dispatchEvent(new Event(ON_BACK));
		}
		
		private function list_onChange(list:List):void
		{
			trace("List onChange:", this._list.selectedIndex);
		}
		
	}

}