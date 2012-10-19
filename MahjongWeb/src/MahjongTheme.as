package  
{
	import feathers.controls.Button;
	import feathers.controls.Callout;
	import feathers.controls.Check;
	import feathers.controls.PickerList;
	import feathers.controls.ProgressBar;
	import feathers.controls.Radio;
	import feathers.controls.Screen;
	import feathers.controls.ScreenHeader;
	import feathers.controls.Scroller;
	import feathers.controls.SimpleScrollBar;
	import feathers.controls.Slider;
	import feathers.controls.TabBar;
	import feathers.controls.TextInput;
	import feathers.controls.ToggleSwitch;
	import feathers.controls.popups.CalloutPopUpContentManager;
	import feathers.controls.popups.VerticalCenteredPopUpContentManager;
	import feathers.controls.renderers.BaseDefaultItemRenderer;
	import feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer;
	import feathers.controls.renderers.DefaultGroupedListItemRenderer;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.AddedWatcher;
	import feathers.core.FeathersControl;
	import feathers.core.PopUpManager;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.display.TiledImage;
	import feathers.layout.VerticalLayout;
	import feathers.skins.IFeathersTheme;
	import feathers.skins.ImageStateValueSelector;
	import feathers.skins.Scale9ImageStateValueSelector;
	import feathers.system.DeviceCapabilities;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	import starling.text.BitmapFont;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.ResizeEvent;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.text.TextField;
	
	import util.Assets;
	
	public class MahjongTheme extends AddedWatcher implements IFeathersTheme
	{

		// Font Constants & Variables
		protected static const HEADER_TEXT_COLOR:uint = 0xC52126;
		protected static const LIGHT_TEXT_COLOR:uint = 0xFFFFFF;
		protected static const DARK_TEXT_COLOR:uint = 0xC52126;
		protected static const BUTTON_TEXT_COLOR:uint = 0xC52126;
		protected static const SELECTED_TEXT_COLOR:uint = 0xFFFFFF;
		protected static const DISABLED_TEXT_COLOR:uint = 0x666666;

		protected var headerTextFormat:TextFormat;
		protected var uiDarkTextFormat:TextFormat;
		protected var uiLightTextFormat:TextFormat;
		protected var uiSelectedTextFormat:TextFormat;
		protected var largeDarkTextFormat:TextFormat;
		protected var largeLightTextFormat:TextFormat;
		protected var smallDarkTextFormat:TextFormat;
		protected var smallLightTextFormat:TextFormat;
		protected var uiDisabledTextFormat:TextFormat;
		protected var buttonDefaultTextFormat:TextFormat;
		
		// DPI Constants & Variables
		protected static const ORIGINAL_DPI_IPHONE_RETINA:int = 326;
		protected static const ORIGINAL_DPI_IPAD_RETINA:int = 264;

		// Sclae 9Grid Constants & Variables
		protected static const DEFAULT_SCALE9_GRID:Rectangle = new Rectangle(5, 5, 22, 22);
		protected static const BUTTON_SCALE9_GRID:Rectangle = new Rectangle(8, 8, 48, 48);
		protected static const ITEM_RENDERER_SCALE9_GRID:Rectangle = new Rectangle(13, 0, 3, 82);
		protected static const TAB_SCALE9_GRID:Rectangle = new Rectangle(14, 14, 36, 36);
		protected static const SLIDER_SCALE9_GRID:Rectangle = new Rectangle(2, 8, 24, 0);
		
		// Scale 3Grid Constants & Variables
		protected static const SLIDER_BAR_REGION1:int = 3;
		protected static const SLIDER_BAR_REGION2:int = 27;
		
		// Scale Normal Constants & Variables
		protected var scale:Number = 1;
		
		// Textures Constants & Variables
		// Background
		protected var primaryBackgroundTexture:Texture;
		protected var backgroundSkinTextures:Scale9Textures;
		protected var backgroundDisabledSkinTextures:Scale9Textures;
		
		// Button
		protected var buttonUpSkinTextures:Scale9Textures;
		protected var buttonDownSkinTextures:Scale9Textures;
		protected var buttonDisabledSkinTextures:Scale9Textures;
		protected var buttonSelectedUpSkinTextures:Scale9Textures;
		protected var buttonSelectedDisabledSkinTextures:Scale9Textures;
		
		// Picker List
		protected var pickerListButtonIconTexture:Texture;
		protected var pickerListItemSelectedIconTexture:Texture;
		
		// Tab
		protected var tabDownSkinTextures:Scale9Textures;
		protected var tabSelectedSkinTextures:Scale9Textures;
		
		// Item
		protected var itemRendererUpSkinTextures:Scale9Textures;
		protected var itemRendererSelectedSkinTextures:Scale9Textures;
		
		// Slider
		protected var sliderBackgroundSkinTextures:Scale9Textures;
		protected var sliderDisabledSkinTextures:Scale9Textures;
		
		// Thumb
		protected var toggleThumbSkinTextures:Texture;

		
		public static const COMPONENT_NAME_PICKER_LIST_ITEM_RENDERER:String = "feathers-mobile-picker-list-item-renderer";
		
		protected static function popUpOverlayFactory():DisplayObject
		{
			const quad:Quad = new Quad(100, 100, 0x1a1a1a);
			quad.alpha = 0.85;
			return quad;
		}		
		
		public function MahjongTheme(root:DisplayObjectContainer, scaleToDPI:Boolean = true) 
		{
			super(root)
			this._scaleToDPI = scaleToDPI;
			this.initialize();
		}
		
		protected var _originalDPI:int;
		public function get originalDPI():int
		{
			return this._originalDPI;
		}
		
		protected var _scaleToDPI:Boolean;
		public function get scaleToDPI():Boolean
		{
			return this._scaleToDPI;
		}
				
		protected var primaryBackground:TiledImage;
		protected var secondaryBackground:TiledImage;
		
		protected function initializeRoot():void
		{
			this.primaryBackground = new TiledImage(this.primaryBackgroundTexture);
			this.primaryBackground.width = root.stage.stageWidth;
			this.primaryBackground.height = root.stage.stageHeight;
			this.root.addChildAt(this.primaryBackground, 0);
			root.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
			root.addEventListener(Event.REMOVED_FROM_STAGE, root_removedFromStageHandler);
		}
		
		protected function initialize():void
		{
			// Scaling Stage and DPI
			
			this._originalDPI = DeviceCapabilities.dpi;
			if(this._scaleToDPI)
			{
				if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
				{
					this._originalDPI = ORIGINAL_DPI_IPAD_RETINA;
				}
				else
				{
					this._originalDPI = ORIGINAL_DPI_IPHONE_RETINA;
				}
			}

			// Background Initialization
			this.primaryBackgroundTexture = util.Assets.getAssetsTexture("grey");
			
			this.scale = DeviceCapabilities.dpi / this._originalDPI;
			
			if(root.stage)
			{
				this.initializeRoot();
			}
			else
			{
				root.addEventListener(Event.ADDED_TO_STAGE, root_addedToStageHandler);
			}
			
			// Text initialization
			FeathersControl.defaultTextRendererFactory = textRendererFactory;
			const fontNames:String = "trajanPro";
			
			this.headerTextFormat = new TextFormat(fontNames, Math.round(32 * this.scale), HEADER_TEXT_COLOR, true);
			this.uiDarkTextFormat = new TextFormat(fontNames, 24 * this.scale, DARK_TEXT_COLOR, true);
			this.uiLightTextFormat = new TextFormat(fontNames, 24 * this.scale, LIGHT_TEXT_COLOR, true);
			this.uiSelectedTextFormat = new TextFormat(fontNames, 24 * this.scale, SELECTED_TEXT_COLOR, true);
			this.uiDisabledTextFormat = new TextFormat(fontNames, 24 * this.scale, DISABLED_TEXT_COLOR, true);
			this.largeDarkTextFormat = new TextFormat(fontNames, 32 * this.scale, DARK_TEXT_COLOR);
			this.largeLightTextFormat = new TextFormat(fontNames, 32 * this.scale, LIGHT_TEXT_COLOR);
			this.smallDarkTextFormat = new TextFormat(fontNames, 16 * this.scale, DARK_TEXT_COLOR);
			this.smallLightTextFormat = new TextFormat(fontNames, 16 * this.scale, LIGHT_TEXT_COLOR);
			this.buttonDefaultTextFormat = new TextFormat(fontNames, 24 * this.scale, BUTTON_TEXT_COLOR, true);
			
			PopUpManager.overlayFactory = popUpOverlayFactory;
			Callout.stagePaddingTop = Callout.stagePaddingRight = Callout.stagePaddingBottom =
				Callout.stagePaddingLeft = 16 * this.scale;

			// Texture initialization
			const backgroundSkinTexture:Texture = util.Assets.getAssetsTexture("backgroundTemplate");
			const backgroundDownSkinTexture:Texture = util.Assets.getAssetsTexture("backgroundDown");
			const backgroundDisabledSkinTexture:Texture = util.Assets.getAssetsTexture("backgroundDisabled");
			const sliderBackgroundSkin:Texture = util.Assets.getAssetsTexture("sliderTemplate");
			
			this.backgroundSkinTextures = new Scale9Textures(backgroundSkinTexture, DEFAULT_SCALE9_GRID);
			this.backgroundDisabledSkinTextures = new Scale9Textures(backgroundDisabledSkinTexture, DEFAULT_SCALE9_GRID);

			this.buttonUpSkinTextures = new Scale9Textures(util.Assets.getAssetsTexture("btnTemplate"), BUTTON_SCALE9_GRID);
			this.buttonDownSkinTextures = new Scale9Textures(util.Assets.getAssetsTexture("btnDown"), BUTTON_SCALE9_GRID);
			this.buttonDisabledSkinTextures = new Scale9Textures(util.Assets.getAssetsTexture("btnDisabled"), BUTTON_SCALE9_GRID);
			this.buttonSelectedUpSkinTextures = new Scale9Textures(util.Assets.getAssetsTexture("btnDown"), BUTTON_SCALE9_GRID);
			this.buttonSelectedDisabledSkinTextures = new Scale9Textures(util.Assets.getAssetsTexture("btnDisabled"), BUTTON_SCALE9_GRID);
			
			this.toggleThumbSkinTextures = util.Assets.getAssetsTexture("thumbTemplate");
			
			this.sliderBackgroundSkinTextures = new Scale9Textures(sliderBackgroundSkin, SLIDER_SCALE9_GRID);
			this.sliderDisabledSkinTextures = new Scale9Textures(sliderBackgroundSkin, SLIDER_SCALE9_GRID);
			
			this.tabDownSkinTextures = new Scale9Textures(util.Assets.getAssetsTexture("tabDown"), TAB_SCALE9_GRID);
			this.tabSelectedSkinTextures = new Scale9Textures(util.Assets.getAssetsTexture("tabSelected"), TAB_SCALE9_GRID);
			
			
			// Functions initialization
			// ----------------------------------------------------------------------------------------------------------
			
			// Screen Button
			this.setInitializerForClassAndSubclasses(Screen, screenInitializer);
			this.setInitializerForClass(Button, buttonInitializer);
			
			// Picker Tab
			this.setInitializerForClass(Button, pickerListButtonInitializer, PickerList.DEFAULT_CHILD_NAME_BUTTON);
			this.setInitializerForClass(Button, tabInitializer, TabBar.DEFAULT_CHILD_NAME_TAB);
			
			// Nothing 
			this.setInitializerForClass(Button, nothingInitializer, SimpleScrollBar.DEFAULT_CHILD_NAME_THUMB);
			
			// Slider
			this.setInitializerForClass(Button, sliderThumbInitializer, Slider.DEFAULT_CHILD_NAME_THUMB);
			this.setInitializerForClass(Slider, sliderInitializer);
			this.setInitializerForClass(Button, sliderTrackInitializer, Slider.DEFAULT_CHILD_NAME_MINIMUM_TRACK);
			this.setInitializerForClass(Button, sliderTrackInitializer, Slider.DEFAULT_CHILD_NAME_MAXIMUM_TRACK);
			
			// Toggle
			this.setInitializerForClass(Button, toggleSwitchThumbInitializer, ToggleSwitch.DEFAULT_CHILD_NAME_THUMB);
			this.setInitializerForClass(ToggleSwitch, toggleSwitchInitializer);
			this.setInitializerForClass(Button, toggleSwitchTrackInitializer, ToggleSwitch.DEFAULT_CHILD_NAME_ON_TRACK);
			
			this.setInitializerForClass(TextInput, textInputInitializer);
			this.setInitializerForClass(ProgressBar, progressBarInitializer);
			
			// Header
			this.setInitializerForClass(ScreenHeader, screenHeaderInitializer);
			
			this.setInitializerForClass(DefaultListItemRenderer, itemRendererInitializer);
			this.setInitializerForClass(DefaultListItemRenderer, pickerListItemRendererInitializer, COMPONENT_NAME_PICKER_LIST_ITEM_RENDERER);
			
			this.setInitializerForClass(DefaultGroupedListItemRenderer, itemRendererInitializer);
			this.setInitializerForClass(DefaultGroupedListHeaderOrFooterRenderer, headerOrFooterRendererInitializer);
		}
		
		//Default text format 
		protected function textRendererFactory():TextFieldTextRenderer
		{
			const renderer:TextFieldTextRenderer = new TextFieldTextRenderer();
			renderer.embedFonts = true;
			renderer.textFormat = this.smallDarkTextFormat;
			return renderer;
		}
		
		protected function nothingInitializer(target:DisplayObject):void { }
		
		protected function screenInitializer(screen:Screen):void
		{
			screen.originalDPI = this._originalDPI;
		}
		
		// ------------------------------------------------------------------------------------------------------
		// Button
		// ------------------------------------------------------------------------------------------------------
		protected function simpleButtonInitializer(button:Button):void
		{
			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
			skinSelector.defaultValue = this.buttonUpSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.imageProperties =
			{
				width: this.scale,
				height: this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;

			button.minWidth = button.minHeight = this.scale;
			button.minTouchWidth = button.minTouchHeight = 88 * this.scale;
		}
		
		protected function buttonInitializer(button:Button):void
		{
			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
			skinSelector.defaultValue = this.buttonUpSkinTextures;
			skinSelector.defaultSelectedValue = this.buttonSelectedUpSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.setValueForState(this.buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
			skinSelector.imageProperties =
			{
				width: this.scale,
				height: this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;

			button.defaultLabelProperties.textFormat = this.buttonDefaultTextFormat;
			button.disabledLabelProperties.textFormat = this.buttonDefaultTextFormat;
			button.selectedDisabledLabelProperties.textFormat = this.buttonDefaultTextFormat;

			button.paddingTop = button.paddingBottom = 4 * this.scale;
			button.paddingLeft = button.paddingRight = 12* this.scale;
			button.gap = 6 * this.scale;
			button.minWidth = button.minHeight = 64 * this.scale;
			button.minTouchWidth = button.minTouchHeight = 88 * this.scale;
		}
		
		// ------------------------------------------------------------------------------------------------------
		//Picker list 
		// ------------------------------------------------------------------------------------------------------
		protected function pickerListButtonInitializer(button:Button):void
		{
			this.buttonInitializer(button);

			const defaultIcon:Image = new Image(this.pickerListButtonIconTexture);
			defaultIcon.scaleX = defaultIcon.scaleY = this.scale;
			button.defaultIcon = defaultIcon;

			button.gap = Number.POSITIVE_INFINITY;
			button.iconPosition = Button.ICON_POSITION_RIGHT;
		}
		
		protected function pickerListItemRendererInitializer(renderer:BaseDefaultItemRenderer):void
		{
			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
			skinSelector.defaultValue = this.buttonUpSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.imageProperties =
			{
				width: 88 * this.scale,
				height: 88 * this.scale,
				textureScale: this.scale
			};
			renderer.stateToSkinFunction = skinSelector.updateValue;

			const defaultSelectedIcon:Image = new Image(this.pickerListItemSelectedIconTexture);
			defaultSelectedIcon.scaleX = defaultSelectedIcon.scaleY = this.scale;
			renderer.defaultSelectedIcon = defaultSelectedIcon;
			
			// DEBUG
			defaultSelectedIcon.dispose();

			const defaultIcon:Quad = new Quad(defaultSelectedIcon.width, defaultSelectedIcon.height, 0xff00ff);
			defaultIcon.alpha = 0;
			renderer.defaultIcon = defaultIcon;

			renderer.defaultLabelProperties.textFormat = this.largeLightTextFormat;
			renderer.downLabelProperties.textFormat = this.largeDarkTextFormat;

			renderer.itemHasIcon = false;
			renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			renderer.paddingTop = renderer.paddingBottom = 8 * this.scale;
			renderer.paddingLeft = renderer.paddingRight = 32 * this.scale;
			renderer.gap = 12 * this.scale;
			renderer.minWidth = renderer.minHeight = 88 * this.scale;
			renderer.minTouchWidth = renderer.minTouchHeight = 88 * this.scale;
		}
		
		protected function pickerListInitializer(list:PickerList):void
		{
			if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				list.popUpContentManager = new CalloutPopUpContentManager();
			}
			else
			{
				const centerStage:VerticalCenteredPopUpContentManager = new VerticalCenteredPopUpContentManager();
				centerStage.marginTop = centerStage.marginRight = centerStage.marginBottom =
					centerStage.marginLeft = 24 * this.scale;
				list.popUpContentManager = centerStage;
			}

			const layout:VerticalLayout = new VerticalLayout();
			layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_BOTTOM;
			layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			layout.useVirtualLayout = true;
			layout.gap = 0;
			layout.paddingTop = layout.paddingRight = layout.paddingBottom =
				layout.paddingLeft = 0;
			list.listProperties.layout = layout;
			list.listProperties.@scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_ON;

			if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				list.listProperties.minWidth = 10 * this.scale;
				list.listProperties.maxHeight = 352 * this.scale;
			}
			else
			{
				const backgroundSkin:Scale9Image = new Scale9Image(this.backgroundDisabledSkinTextures, this.scale);
				backgroundSkin.width = 20 * this.scale;
				backgroundSkin.height = 20 * this.scale;
				list.listProperties.backgroundSkin = backgroundSkin;
				list.listProperties.paddingTop = list.listProperties.paddingRight =
					list.listProperties.paddingBottom = list.listProperties.paddingLeft = 8 * this.scale;
			}

			list.listProperties.itemRendererName = COMPONENT_NAME_PICKER_LIST_ITEM_RENDERER;
		}
		
		// --------------------------------------------------------------------------------------------------
		//Toggle
		// --------------------------------------------------------------------------------------------------
		protected function toggleSwitchTrackInitializer(track:Button):void
		{
			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
			skinSelector.defaultValue = this.backgroundSkinTextures;
			skinSelector.setValueForState(this.backgroundDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.imageProperties =
			{
				width: 120 * this.scale,
				height: 40 * this.scale,
				textureScale: this.scale
			};
			track.stateToSkinFunction = skinSelector.updateValue;
		}
		
		protected function toggleSwitchInitializer(toggle:ToggleSwitch):void
		{
			
			toggle.trackLayoutMode = ToggleSwitch.TRACK_LAYOUT_MODE_SINGLE;
			
			toggle.paddingLeft = 4 * this.scale;
			toggle.paddingRight = 4 * this.scale;
			
			toggle.defaultLabelProperties.textFormat = this.smallDarkTextFormat;
			toggle.onLabelProperties.textFormat = this.smallDarkTextFormat;
		}
		
		protected function toggleSwitchThumbInitializer( button:Button):void
		{
			const skinSelector:ImageStateValueSelector = new ImageStateValueSelector();
			skinSelector.defaultValue = this.toggleThumbSkinTextures;
			skinSelector.setValueForState(this.toggleThumbSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.toggleThumbSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.imageProperties =
			{
				width: 32 * this.scale,
				height: 32 * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;

			button.minWidth = button.minHeight = 32 * this.scale;
			button.minTouchWidth = button.minTouchHeight = 60 * this.scale;
		}

		// --------------------------------------------------------------------------------------------------
		//Slider
		// --------------------------------------------------------------------------------------------------
		protected function sliderTrackInitializer(track:Button):void
		{
			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
			
			skinSelector.defaultValue = sliderBackgroundSkinTextures;
			skinSelector.setValueForState(sliderBackgroundSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(sliderBackgroundSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.imageProperties =
			{
				textureScale: this.scale
			};
			track.stateToSkinFunction = skinSelector.updateValue;
		}
		
		protected function sliderInitializer(slider:Slider):void
		{
			slider.trackLayoutMode = Slider.TRACK_LAYOUT_MODE_STRETCH;

			if(slider.direction == Slider.DIRECTION_VERTICAL)
			{
				slider.width = 8 * this.scale;
				slider.height = 160 * this.scale;
			}
			else
			{
				slider.width = 160 * this.scale;
				slider.height = 8 * this.scale;
			}
			
			slider.maximumPadding = 4 * this.scale;
			slider.minimumPadding = 4 * this.scale;
		}
		
		protected function sliderThumbInitializer(button:Button):void
		{
			const skinSelector:ImageStateValueSelector = new ImageStateValueSelector();
			skinSelector.defaultValue = this.toggleThumbSkinTextures;
			skinSelector.setValueForState(this.toggleThumbSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.toggleThumbSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.imageProperties =
			{
				width: 32 * this.scale,
				height: 32 * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;

			button.minWidth = button.minHeight = 32 * this.scale;
			button.minTouchWidth = button.minTouchHeight = 60 * this.scale;
		}
		
		// -----------------------------------------------------------------------------------------------------
		//Tab bar
		// -----------------------------------------------------------------------------------------------------
		protected function tabInitializer(tab:Button):void
		{
			const defaultSkin:Quad = new Quad(32 * this.scale, 32 * this.scale, 0xC52126);
			tab.defaultSkin = defaultSkin;

			const downSkin:Scale9Image = new Scale9Image(this.tabDownSkinTextures, this.scale);
			tab.downSkin = downSkin;

			const defaultSelectedSkin:Scale9Image = new Scale9Image(this.tabSelectedSkinTextures, this.scale);
			tab.defaultSelectedSkin = defaultSelectedSkin;

			tab.defaultLabelProperties.textFormat = this.smallLightTextFormat;
			tab.downLabelProperties.textFormat = this.smallDarkTextFormat;
			tab.defaultSelectedLabelProperties.textFormat = this.smallDarkTextFormat;
			tab.disabledLabelProperties.textFormat = this.smallDarkTextFormat;
			tab.selectedDisabledLabelProperties.textFormat = this.smallDarkTextFormat;

			tab.minWidth = tab.minHeight = 32 * this.scale;
			tab.minTouchWidth = tab.minTouchHeight = 88 * this.scale;
		}
		
		// ---------------------------------------------------------------------------------------------------------
		//Header
		// ---------------------------------------------------------------------------------------------------------
		protected function headerOrFooterRendererInitializer(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			const defaultSkin:Quad = new Quad(32 * this.scale, 32 * this.scale, 0xFFFFFF);
			renderer.backgroundSkin = defaultSkin;

			renderer.contentLabelProperties.textFormat = this.headerTextFormat;
			renderer.paddingTop = renderer.paddingBottom = 5 * this.scale;
			renderer.paddingLeft = renderer.paddingRight = 5 * this.scale;
			renderer.minWidth = renderer.minHeight = 32 * this.scale;
			renderer.minTouchWidth = renderer.minTouchHeight = 44 * this.scale;
		}
		
		protected function screenHeaderInitializer(header:ScreenHeader):void
		{
			header.minWidth = 32 * this.scale;
			header.minHeight = 32 * this.scale;
			header.paddingTop = header.paddingRight = header.paddingBottom =
				header.paddingLeft = 5 * this.scale;

			header.titleProperties.textFormat = this.headerTextFormat;
		}
		
		protected function itemRendererInitializer(renderer:BaseDefaultItemRenderer):void
		{
			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
			skinSelector.defaultValue = this.buttonUpSkinTextures;
			skinSelector.defaultSelectedValue = this.buttonSelectedUpSkinTextures;
			skinSelector.setValueForState(this.buttonSelectedUpSkinTextures, Button.STATE_DOWN, false);
			skinSelector.imageProperties =
			{
				width: 88 * this.scale,
				height: 88 * this.scale,
				textureScale: this.scale
			};
			renderer.stateToSkinFunction = skinSelector.updateValue;

			renderer.defaultLabelProperties.textFormat = this.smallDarkTextFormat;
			renderer.downLabelProperties.textFormat = this.smallLightTextFormat;
			renderer.defaultSelectedLabelProperties.textFormat = this.smallDarkTextFormat;

			renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			renderer.paddingTop = renderer.paddingBottom = 8 * this.scale;
			renderer.paddingLeft = renderer.paddingRight = 32 * this.scale;
			renderer.gap = 12 * this.scale;
			renderer.minWidth = renderer.minHeight = 88 * this.scale;
			renderer.minTouchWidth = renderer.minTouchHeight = 88 * this.scale;
		}
		
		//Text input
		protected function textInputInitializer(input:TextInput):void
		{
			const backgroundSkin:Scale9Image = new Scale9Image(this.backgroundSkinTextures, this.scale);
			backgroundSkin.width = 264 * this.scale;
			backgroundSkin.height = 60 * this.scale;
			input.backgroundSkin = backgroundSkin;

			const backgroundDisabledSkin:Scale9Image = new Scale9Image(this.backgroundDisabledSkinTextures, this.scale);
			backgroundDisabledSkin.width = 264 * this.scale;
			backgroundDisabledSkin.height = 60 * this.scale;
			input.backgroundDisabledSkin = backgroundDisabledSkin;

			input.minWidth = input.minHeight = 60 * this.scale;
			input.minTouchWidth = input.minTouchHeight = 88 * this.scale;
			input.paddingTop = input.paddingBottom = 12 * this.scale;
			input.paddingLeft = input.paddingRight = 16 * this.scale;
			input.stageTextProperties.fontFamily = "Helvetica";
			input.stageTextProperties.fontSize = 64 * this.scale;
			input.stageTextProperties.color = DARK_TEXT_COLOR;
		}
		
		//Progress bar
		protected function progressBarInitializer(progress:ProgressBar):void
		{
			const backgroundSkin:Scale9Image = new Scale9Image(this.backgroundSkinTextures, this.scale);
			backgroundSkin.width = 240 * this.scale;
			backgroundSkin.height = 22 * this.scale;
			progress.backgroundSkin = backgroundSkin;

			const backgroundDisabledSkin:Scale9Image = new Scale9Image(this.backgroundDisabledSkinTextures, this.scale);
			backgroundDisabledSkin.width = 240 * this.scale;
			backgroundDisabledSkin.height = 22 * this.scale;
			progress.backgroundDisabledSkin = backgroundDisabledSkin;

			const fillSkin:Scale9Image = new Scale9Image(this.buttonUpSkinTextures, this.scale);
			fillSkin.width = 8 * this.scale;
			fillSkin.height = 22 * this.scale;
			progress.fillSkin = fillSkin;

			const fillDisabledSkin:Scale9Image = new Scale9Image(this.buttonDisabledSkinTextures, this.scale);
			fillDisabledSkin.width = 8 * this.scale;
			fillDisabledSkin.height = 22 * this.scale;
			progress.fillDisabledSkin = fillDisabledSkin;
		}
		
		protected function stage_resizeHandler(event:ResizeEvent):void
		{
			this.primaryBackground.width = event.width;
			this.primaryBackground.height = event.height;
		}

		protected function root_addedToStageHandler(event:Event):void
		{
			root.removeEventListener(Event.ADDED_TO_STAGE, root_addedToStageHandler);
			this.initializeRoot();
		}

		protected function root_removedFromStageHandler(event:Event):void
		{
			root.removeEventListener(Event.REMOVED_FROM_STAGE, root_removedFromStageHandler);
			root.stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
			this.root.removeChild(this.primaryBackground, true);
			this.primaryBackground = null;
		}
	}

}