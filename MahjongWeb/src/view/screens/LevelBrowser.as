package view.screens 
{
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PageIndicator;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.controls.Screen;
	import feathers.controls.ScreenHeader;
	import feathers.controls.Scroller;
	import feathers.controls.TabBar;
	import feathers.core.FeathersControl;
	import feathers.core.ITextRenderer;
	import feathers.data.ListCollection;
	import feathers.display.Image;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.TiledRowsLayout;
	import feathers.text.BitmapFontTextFormat;
	import model.levelSelector.LevelSelectorDataSource;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import starling.events.Event;
	import starling.text.BitmapFont;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import view.data.GameData;
	
	import starling.display.DisplayObject;
	
	import util.Assets;
	
	public class LevelBrowser extends Screen 
	{				
		private var _header:ScreenHeader;
		private var _backButton:Button;
		private var _tabBar:TabBar;
		private var _font:BitmapFont;
		private var _list:List;
		private var _pageIndicator:PageIndicator;
		
		private static const ON_BACK:String = "onBack";
		private static const ON_GAME:String = "onGame";
		
		private var levelsArray:Array = new Array();
		private var easyLevels:ListCollection;
		private var mediumLevels:ListCollection;
		private var hardLevels:ListCollection;
		
		protected var _gameData:GameData;
		
		public function LevelBrowser() 
		{
			super();
		}
		
		override protected function initialize():void
		{
			this._tabBar = new TabBar();
			this.defineCollections();
			
			this._tabBar.onChange.add(tabBar_onChange);
			this.addChild(this._tabBar);

			const listLayout:TiledRowsLayout = new TiledRowsLayout();
			listLayout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			listLayout.useSquareTiles = false;
			listLayout.tileHorizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			
			this._list = new List();
			this._list.dataProvider = easyLevels;
			this._list.layout = listLayout;
			this._list.scrollerProperties.snapToPages = true;
			this._list.scrollerProperties.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_NONE;
			this._list.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_ON;
			this._list.itemRendererFactory = tileListItemRendererFactory;
			this._list.onScroll.add(list_onScroll);
			this._list.onChange.add(list_onChange);
			this.addChild(this._list);
			
			const normalSymbolTexture:Texture = util.Assets.getAssetsTexture("pageTemplate");
			const selectedSymbolTexture:Texture = util.Assets.getAssetsTexture("pageSelected");
			
			const pageIndicatorLayout:HorizontalLayout = new HorizontalLayout();
			pageIndicatorLayout.gap = 3;
			pageIndicatorLayout.paddingTop = pageIndicatorLayout.paddingRight = pageIndicatorLayout.paddingBottom =
				pageIndicatorLayout.paddingLeft = 6;
			
			this._pageIndicator = new PageIndicator();
			this._pageIndicator.normalSymbolFactory = function():Image
			{
				return new Image(normalSymbolTexture);
			}
			this._pageIndicator.selectedSymbolFactory = function():Image
			{
				return new Image(selectedSymbolTexture);
			}
			this._pageIndicator.layout = pageIndicatorLayout;
			this._pageIndicator.maximum = 1;
			this.addChild(this._pageIndicator);

			this._backButton = new Button();
			this._backButton.label = "Back";
			this._backButton.onRelease.add(backButton_onRelease);

			this._header = new ScreenHeader();
			this._header.title = "Level Browser";
			this.addChild(this._header);
			this._header.leftItems = new <DisplayObject>
			[
				this._backButton
			];
				
			// handles the back hardware key on android
			this.backButtonHandler = this.onBackButton;
		}

		override protected function draw():void
		{
			this._header.width = this.actualWidth;
			this._header.validate();

			this._tabBar.width = this.actualWidth;
			this._tabBar.validate();
			this._tabBar.y = this.actualHeight - this._tabBar.height;
			
			this.layout();
		}

		protected function layout():void
		{
			const actualHeight:Number = this.stage.stageHeight - _header.height - _tabBar.height;
			
			this._pageIndicator.validate();
			this._pageIndicator.y = this.stage.stageHeight - this._pageIndicator.height - this._tabBar.height;
			
			const shorterSide:Number = Math.min(this.stage.stageWidth, actualHeight);
			const layout:TiledRowsLayout = TiledRowsLayout(this._list.layout);
			layout.paddingRight = layout.paddingBottom = layout.paddingLeft = shorterSide * 0.06;
			layout.paddingTop = shorterSide * 0.06 + this._header.height;
			layout.gap = shorterSide * 0.04;

			this._list.itemRendererProperties.gap = shorterSide * 0.01;

			this._list.width = this.stage.stageWidth;
			this._list.height = this._pageIndicator.y;
			this._list.validate();

			this._pageIndicator.maximum = Math.ceil(this._list.maxHorizontalScrollPosition / this._list.width) + 1;
			this._pageIndicator.validate();
			this._pageIndicator.x = (this.stage.stageWidth - this._pageIndicator.width) / 2;
		}
		
		private function backButton_onRelease(button:Button):void
		{
			this.onBackButton();
		}
		
		private function onBackButton():void
		{
			this.dispatchEvent(new Event(ON_BACK));
		}

		private function tabBar_onChange(tabBar:TabBar):void
		{
			this._list.dataProvider = levelsArray[this._tabBar.selectedIndex];
			this.invalidate();
		}

		protected function tileListItemRendererFactory():IListItemRenderer
		{
			const renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
			renderer.labelField = "label";
			renderer.iconTextureField = "texture";
			renderer.iconPosition = Button.VERTICAL_ALIGN_TOP;
			return renderer;
		}
		
		protected function list_onScroll(list:List):void
		{
			this._pageIndicator.selectedIndex = list.horizontalPageIndex;
		}
		
		protected function list_onChange(list:List):void
		{
			if (this._list.selectedIndex != -1)
			{
				this._gameData.id = _list.selectedItem.levelId;
				this.dispatchEvent(new Event(ON_GAME));
			}
			this._list.selectedIndex = -1;
			
		}
		
		public function set gameData(value:GameData):void
		{
			this._gameData = value;
		}
		
		public function get gameData():GameData
		{
			return this._gameData;
		}
		
		private function defineCollections():void
		{
			this._tabBar.dataProvider = new ListCollection(
			[
				{ label: "Easy" },
				{ label: "Medium" },
				{ label: "Hard" },
			]);
			
			easyLevels = new ListCollection(
			[
				{ label: "1", texture: util.Assets.getLevelsTexture("1"), levelId:1 },
				{ label: "2", texture: util.Assets.getLevelsTexture("6"), levelId:6 },
				{ label: "3", texture: util.Assets.getLevelsTexture("11"), levelId:11 },
				{ label: "4", texture: util.Assets.getLevelsTexture("12"), levelId:12 },
				{ label: "5", texture: util.Assets.getLevelsTexture("13"), levelId:13 },
				{ label: "6", texture: util.Assets.getLevelsTexture("18"), levelId:18 },
				{ label: "7", texture: util.Assets.getLevelsTexture("19"), levelId:19 }
			]);
			
			mediumLevels = new ListCollection(
			[
				{ label: "8", texture: util.Assets.getLevelsTexture("2"), levelId:2 },
				{ label: "9", texture: util.Assets.getLevelsTexture("3"), levelId:3 },
				{ label: "10", texture: util.Assets.getLevelsTexture("4"), levelId:4 },
				{ label: "11", texture: util.Assets.getLevelsTexture("5"), levelId:5 },
				{ label: "12", texture: util.Assets.getLevelsTexture("14"), levelId:14 },
				{ label: "13", texture: util.Assets.getLevelsTexture("16"), levelId:16 }
				
			]);
			
			hardLevels = new ListCollection(
			[
				{ label: "14", texture: util.Assets.getLevelsTexture("7"), levelId:7 },
				{ label: "15", texture: util.Assets.getLevelsTexture("8"), levelId:8 },
				{ label: "16", texture: util.Assets.getLevelsTexture("9"), levelId:9 },
				{ label: "17", texture: util.Assets.getLevelsTexture("10"), levelId:10 },
				{ label: "18", texture: util.Assets.getLevelsTexture("15"), levelId:15 },
				{ label: "19", texture: util.Assets.getLevelsTexture("17"), levelId:17 },
				{ label: "20", texture: util.Assets.getLevelsTexture("20"), levelId:20 },
				{ label: "21", texture: util.Assets.getLevelsTexture("21"), levelId:21 }
			]);
			
			levelsArray.push(easyLevels, mediumLevels, hardLevels);
		}
	}

}