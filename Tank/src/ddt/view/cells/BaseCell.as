package ddt.view.cells
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.utils.getTimer;
	
	import game.crazyTank.view.common.LoadingAsset;
	
	import road.ui.manager.TipManager;
	
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.interfaces.IDragable;
	import ddt.manager.DragManager;
	import ddt.view.bagII.GoodsTipPanel;
	import ddt.view.infoandbag.CellEvent;
	
	[Event(name="change",type="flash.events.Event")]
	[Event(name="lockChanged",type="ddt.view.infoandbag.CellEvent")]
	public class BaseCell extends Sprite implements ICell
	{
		public var mouseSilenced:Boolean = false;//鼠标静默，禁用所有点击声音。
		public var showTips:Boolean=true;
		protected var _bg:Sprite;
		protected var _loadingasset:MovieClip;
		protected var _info:ItemTemplateInfo;
		protected var _pic:Sprite;
		protected var _smallPic:Sprite;
		protected var _showLoading:Boolean;
		
		private var _contentcreator:CellContentCreator;
		protected var _contentWidth:Number;
		protected var _contentHeight:Number;
		private var _allowDrag:Boolean;
		protected var _tip:GoodsTipPanel;
		private var _bagLocked : Boolean = false;
		
		
		public function BaseCell(bg:Sprite,info:ItemTemplateInfo = null,showLoading:Boolean = true)
		{
			super();
			_bg = bg;
			_showLoading = showLoading;
			createChildren();
			initEvent();
			this.info = info;
			_allowDrag = true;
			
			
		}
		
		protected function createChildren():void
		{
			addChildAt(_bg,0);
			_bg["figure_pos"].alpha = 0;
			_contentWidth = _bg["figure_pos"].width;
			_contentHeight = _bg["figure_pos"].height;
			_contentcreator = new CellContentCreator();
		}
		
		protected function initEvent():void
		{
			addEventListener(MouseEvent.CLICK,onMouseClick);
			addEventListener(MouseEvent.ROLL_OUT,onMouseOut);
			addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
		}
		
		protected function removeEvent():void
		{
			removeEventListener(MouseEvent.CLICK,onMouseClick);
			removeEventListener(MouseEvent.ROLL_OUT,onMouseOut);
			removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
		}
		
		public function get allowDrag():Boolean
		{
			return _allowDrag;
		}
		
		public function set allowDrag(value:Boolean):void
		{
			_allowDrag = value;
		}
		
		override public function get width():Number
		{
			return _bg.width;
		}
		
		override public function get height():Number
		{
			return _bg.height;
		}
		
		public function getBg():Sprite
		{
			return _bg;
		}
		
		public function set info(value:ItemTemplateInfo):void
		{
			if(_info == value && !_info)return;
			if(_info)
			{
				clearCreatingContent();
				if(_pic && _pic.parent)
					_pic.parent.removeChild(_pic);
				_pic = null;
				clearLoading();
				locked = false;
			}
			_info = value;
			if(_info)
			{
				if(_showLoading)createLoading();
				_pic = createContent();
				addChild(_pic);
			}
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get info():ItemTemplateInfo
		{
			return _info;
		}
		
		protected function createLoading():void
		{
			if(_loadingasset == null) {
				_loadingasset = new LoadingAsset();
			}
			updateSizeII(_loadingasset);
			addChild(_loadingasset);
		}
		
		private function clearLoading():void
		{
			if(_loadingasset && _loadingasset.parent)
				_loadingasset.parent.removeChild(_loadingasset);
			_loadingasset = null;
		}
		
		
		private function updateSizeII(sp:Sprite):void {
			if(sp && _bg && _bg["figure_pos"])
			{
				sp.width = _bg["figure_pos"].width + _bg["figure_pos"].width/6;
				sp.height = _bg["figure_pos"].height + _bg["figure_pos"].height/3;
				sp.x = _bg["figure_pos"].x; 
				sp.y = _bg["figure_pos"].y;
//				if(sp.width >= _contentWidth)
//				{
//					sp.width = _contentWidth + 6;
//					sp.x = _bg["figure_pos"].x;
//				}
//				else
//				{
//					sp.x = _bg["figure_pos"].x;//Math.abs(sp.width - _contentWidth) / 2 + _bg["figure_pos"].x;
//				}
//				if(sp.height >= _contentHeight)
//				{
//					sp.height = _contentHeight + 15;
//					sp.y = _bg["figure_pos"].y;
//				}
//				else
//				{
//					sp.y = Math.abs(sp.height - _contentHeight) / 2 + _bg["figure_pos"].y;
//				}
			}
		}
		
		protected function updateSize(sp:Sprite):void
		{
			if(sp && _bg && _bg["figure_pos"])
			{
				if(sp.width >= _contentWidth)
				{
					sp.width = _contentWidth -2;
					sp.x = _bg["figure_pos"].x;
				}
				else
				{
					sp.x = Math.abs(sp.width - _contentWidth) / 2 + _bg["figure_pos"].x;
				}
				if(sp.height >= _contentHeight)
				{
					sp.height = _contentHeight - 2;
					sp.y = _bg["figure_pos"].y;
				}
				else
				{
					sp.y = Math.abs(sp.height - _contentHeight) / 2 + _bg["figure_pos"].y;
				}
			}
		}
		
		public function getContent():Sprite
		{
			return _pic;
		}
		
		public function getSmallContent():Sprite
		{
			if(_smallPic == null)
			{
				_smallPic = createSmallContent();
			}
			return _smallPic;
		}
		
		protected function createContent():Sprite
		{
			return _contentcreator.createContent(_info,createContentComplete);
		}
		
		protected function createSmallContent():Sprite
		{
			return _contentcreator.createContent(_info,createSmallContentComplete);
		}
		
		protected function clearCreatingContent():void
		{
			_contentcreator.clearLoader();
		}
		
		public function setColor(color:*):Boolean
		{
			return _contentcreator.setColor(color);
		}
		
		public function get editLayer():int
		{
			return _contentcreator.editLayer;
		}
		
		/**
		 * 此方法内不可对加载对象进行操作
		 * 
		 */		
		protected function createContentComplete():void
		{
			clearLoading();
			updateSize(_pic);
		}
		
		protected function createSmallContentComplete():void
		{
			_smallPic.width = _smallPic.height = 40;
		}
			
		public function dragDrop(effect:DragEffect):void {}
		public function dragStart():void 
		{
			if(_info && !locked && stage && _allowDrag)
			{
				if(DragManager.startDrag(this,_info,createDragImg(),stage.mouseX,stage.mouseY,DragEffect.MOVE))
				{
					locked = true;
					
				}
			}
		}
		public function dragStop(effect:DragEffect):void
		{
			if(effect.action == DragEffect.NONE)
			{
				locked = false;
			}
		}
		public function getSource():IDragable{ return this};
		
		protected function createDragImg():DisplayObject
		{
			if(_pic && _pic.width > 0 && _pic.height > 0)
			{
				var img:Bitmap = new Bitmap(new BitmapData(_pic.width / _pic.scaleX,_pic.height / _pic.scaleY,true,0x00000000));
				img.bitmapData.draw(_pic);
				return img;
			}
			return null;
		}
		
		private var _locked:Boolean
		public function set locked(value:Boolean):void
		{
			if(_locked == value) return;
			_locked = value;
			updateLockState();
			
			if(_info is InventoryItemInfo)
			{
				_info["lock"] = _locked;
			}
			
			dispatchEvent(new CellEvent(CellEvent.LOCK_CHANGED));
		}
		
		public function get locked():Boolean
		{
			return _locked;
		}
		public function set bagLocked(b : Boolean) : void
		{
			_bagLocked = b;
		}
		public function get bagLocked() : Boolean
		{
			return _bagLocked;
		}
		private function updateLockState():void
		{
			if(_locked)
			{
				this.filters = [new ColorMatrixFilter([0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0])];
			}
			else
			{
				this.filters = [];
			}
		}
		
		protected function onMouseClick(evt:MouseEvent):void
		{
			TipManager.setCurrentTarget(null,null);
		}
		
		protected function onMouseOver(evt:MouseEvent):void
		{
			if(showTips)
			{
				if(_bg["cover_area"] != null){
					var hitArea:Sprite = _bg["cover_area"];
				}else{
					hitArea = _bg["figure_pos"];
				}
				_tip = createTipRender(hitArea);
				if(_tip) _tip.updatePosition(hitArea);
				TipManager.setCurrentTarget(hitArea,_tip,6,6);
				//}
			}
		}
		
		public function get Tip():GoodsTipPanel
		{
			return this._tip;
		}
		
		public function showMouseOver(evt:MouseEvent, offsetX:int, offsetY:int):void
		{
			if(showTips)
			{
				if(_bg["cover_area"] != null){
					var hitArea:Sprite = _bg["cover_area"];
				}else{
					hitArea = _bg["figure_pos"];
				}
				_tip = createTipRender(hitArea);
				if(_tip) _tip.updatePosition(hitArea);
				TipManager.setCurrentTarget(hitArea,_tip,offsetX,offsetY);
				//}
			}
		}
		
		protected function onMouseOut(evt:MouseEvent):void
		{
			if(_tip)
			{
				_tip.dispose();
			}
			_tip = null;
			TipManager.setCurrentTarget(null,null);
		}
		
		protected function createTipRender(dis:DisplayObject):GoodsTipPanel
		{
			if(_info)
			{
				return new GoodsTipPanel(_info);
			}else
			{
				return null;
			}
		}
		/**灰显该网格**/
		public function set grayFilters(b : Boolean) : void
		{
			if(b)
			{
				this.filters = [new ColorMatrixFilter([0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0])];
			}
			else
			{
				this.filters = null;
			}
		}
		
		
		public function dispose():void
		{
			removeEvent();
			
			if(_bg != null)
			{
				if(_bg.parent)_bg.parent.removeChild(_bg);
			}
			_bg = null;
			
			clearLoading();
			
			clearCreatingContent();
			
			if(_contentcreator)
				_contentcreator.dispose();
			_contentcreator = null;
			
			if(_tip)
				_tip.dispose();
			_tip = null;
			
			if(_pic && _pic.parent)
				_pic.parent.removeChild(_pic);
			_pic = null;
			
			if(_smallPic && _smallPic.parent)
				_smallPic.parent.removeChild(_smallPic);
			_smallPic = null;
			_info = null;
			if(parent)parent.removeChild(this);
		}
	}
}