package ddt.view.colorEditor
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import road.manager.SoundManager;
	import road.ui.controls.SimpleGrid;
	
	import ddt.data.ColorEnum;
	import tank.shop.ColorEditorAsset;
	
	[Event(name="change",type="flash.events.Event")]
	public class ColorEditor extends ColorEditorAsset
	{
		private var _colors:Array;
		private var _skins:Array;
		private var _colorsArr:Array;
		private var _skinsArr:Array;
		private var _colorlist:SimpleGrid;
		private var _skincolorlist:SimpleGrid;
		
		public function ColorEditor()
		{
			_colors = ColorEnum.COLORS;
			_skins = ColorEnum.SKIN_COLORS;
			
			_colorsArr = new Array();
			_skinsArr = new Array();
			_colorlist = new SimpleGrid(16,16,14);
			_skincolorlist = new SimpleGrid(16,16,14);
			_colorlist.cellPaddingHeight = _colorlist.cellPaddingWidth = _skincolorlist.cellPaddingHeight = _skincolorlist.cellPaddingWidth = 1;
			_colorlist.marginHeight = _colorlist.marginWidth = _skincolorlist.marginHeight = _skincolorlist.marginWidth = 0;
			_colorlist.height = _skincolorlist.height = color_mask.height;
			_colorlist.width = _skincolorlist.width = color_mask.width;
			_colorlist.x = _skincolorlist.x = 5;
			_colorlist.y = _skincolorlist.y = 27;
			addChild(_colorlist);
			addChild(_skincolorlist);
			colorpanel_bg.gotoAndStop(1);
			
			//更新按钮状态
			colorselected_btn.mouseEnabled = true;
			skinselected_btn.mouseEnabled = true;
			colorselected_btn.addEventListener(MouseEvent.CLICK,__colorEditClick);
			skinselected_btn.addEventListener(MouseEvent.CLICK,__skinEditClick);
			colorEditable = false;
			skinEditable = false;
			
			initColors();
		}
		
		private function initColors():void
		{
			for(var i:int = 0; i <_colors.length; i ++)
			{
				var ci:ColorItem = new ColorItem(_colors[i]);
				_colorsArr.push(ci);
				_colorlist.appendItem(ci);
				ci.addEventListener(MouseEvent.MOUSE_DOWN,__colorItemClick);
			}
			for(var j:int = 0 ; j < _skins.length; j++)
			{
				var si:ColorItem = new ColorItem(_skins[j]);
				_skinsArr.push(si);
				_skincolorlist.appendItem(si);
				si.addEventListener(MouseEvent.MOUSE_DOWN,__skinItemClick);
			}
		}
			
		public function get colorEditable():Boolean
		{
			return colorselected_btn.mouseEnabled;
		}
		
		public function set colorEditable(value:Boolean):void
		{
			if(colorselected_btn.mouseEnabled != value)
			{
				colorselected_btn.mouseEnabled = value;
				colorselected_btn.buttonMode = value;
				if(value)
				{
					colorselected_btn.alpha = 0;
				}
				else
				{
					colorselected_btn.alpha = 0.5;
					if(_colorlist.visible)
					{
						_colorlist.visible = false;
						color_mask.visible = true;
					}
				}
			}
		}
		
		public function get skinEditable():Boolean
		{
			return skinselected_btn.mouseEnabled;
		}
		
		public function set skinEditable(value:Boolean):void
		{
			if(skinselected_btn.mouseEnabled != value)
			{
				skinselected_btn.mouseEnabled = value;
				skinselected_btn.buttonMode = value;
				if(value)
				{
					skinselected_btn.alpha = 0;
				}
				else
				{
					skinselected_btn.alpha = 0.5;
					if(_skincolorlist.visible)
					{
						_skincolorlist.visible = false;
						color_mask.visible = true;
					}
				}
			}
		}
		
		public function editColor(color:int = -1):void
		{
			if(colorEditable)
			{
				colorpanel_bg.gotoAndStop(1);
				selectedColor = color;
				_colorlist.visible = true;
				_skincolorlist.visible = false;
				color_mask.visible = false;
			}
		}
		
		public function editSkin(skin:int = -1):void
		{
			if(skinEditable)
			{
				selectedSkin = skin;
				colorpanel_bg.gotoAndStop(2);
				_colorlist.visible = false;
				_skincolorlist.visible = true;
				color_mask.visible = false;
			}
		}
		
		/**
		 * 当前选择的颜色类型 
		 * @return 1 颜色 2 皮肤
		 * 
		 */		
		public function selectedType():int
		{
			return colorpanel_bg.currentFrame;
		}

		private var _selectedColor:int;
		public function get selectedColor():int
		{
			return _selectedColor;
		}
		
		public function set selectedColor(value:int):void
		{
			if(value != _selectedColor && colorEditable)
			{
				_selectedColor = value;
				_colorlist.selectedIndex = _colors.indexOf(value);
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		private var _selectedSkin:int;
		
		public function get selectedSkin():int
		{
			return _selectedSkin;
		}
		public function set selectedSkin(value:int):void
		{
			if(value != _selectedSkin && skinEditable)
			{
				_selectedSkin = value;
				_skincolorlist.selectedIndex = _skins.indexOf(value);
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		public function resetColor():void
		{
			_selectedColor = -1;
		}
		
		public function resetSkin():void
		{
			_selectedSkin = -1;
			_skincolorlist.selectedIndex = _skins.indexOf(_selectedSkin);
		}
		
		private function __colorItemClick(event:Event):void
		{
			SoundManager.Instance.play("047");
			var item:ColorItem = event.currentTarget as ColorItem;
			selectedColor = item.getColor();
		}
		
		private function __skinItemClick(event:Event):void
		{
			SoundManager.Instance.play("047");
			var item:ColorItem = event.currentTarget as ColorItem;
			selectedSkin = item.getColor();
		}
		
		private function __colorEditClick(event:Event):void
		{
			SoundManager.Instance.play("047");
			editColor(selectedColor);
		}
		
		private function __skinEditClick(event:Event):void
		{
			SoundManager.Instance.play("047");
			editSkin(selectedSkin);
		}
		
		public function dispose():void
		{
			colorselected_btn.removeEventListener(MouseEvent.CLICK,__colorEditClick);
			skinselected_btn.removeEventListener(MouseEvent.CLICK,__skinEditClick);
			colorselected_btn = null;
			skinselected_btn = null;
			for(var i:int = 0; i <_colors.length; i ++)
			{
				_colorsArr[i].removeEventListener(MouseEvent.MOUSE_DOWN,__colorItemClick);
				_colorsArr[i].dispose();
				_colorsArr[i] = null;
			}
			for(var j:int = 0; j < _skinsArr.length; j++)
			{
				_skinsArr[j].removeEventListener(MouseEvent.MOUSE_DOWN,__skinItemClick);
				_skinsArr[j].dispose();
				_skinsArr[j] = null;
			}
			if(_colorlist)
			{
				if(_colorlist.parent)
					_colorlist.parent.removeChild(_colorlist);
				_colorlist.clearItems();
			}
			_colorlist = null;
			
			if(_skincolorlist)
			{
				if(_skincolorlist.parent)
					_skincolorlist.parent.removeChild(_skincolorlist);
				_skincolorlist.clearItems();
			}
			_skincolorlist = null;
			
			_colors = null;
			_skins = null;
			
			if(parent)
				parent.removeChild(this);
		}
	}
}