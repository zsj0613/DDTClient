package ddt.view.effort
{
	import fl.containers.ScrollPane;
	import fl.controls.ScrollPolicy;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import ddt.manager.LanguageMgr;
	import ddt.manager.SocketManager;
	import ddt.socket.GameSocketOut;
	import tank.view.effort.EffortCategoryTitleAsset;
	
	public class EffortCategoryTitleItem extends Sprite
	{
		private var _childList:Array;
		private var _isExpand :Boolean;
		private var _effortCategoryTitleAsset:EffortCategoryTitleAsset;
		private var _childItemPane:ScrollPane;
		private var _content:Sprite;
		private var _effortChildCategoryTitleArray:Array;
		public static const EXPAND:String = "Expand";
		public static const SHRINK:String = "shrink";
		
		public static const FULL       :String = LanguageMgr.GetTranslation("ddt.view.effort.EffortCategoryTitleItem.FULL");
		public static const INTEGRATION:String = LanguageMgr.GetTranslation("ddt.view.effort.EffortCategoryTitleItem.INTEGRATION");
		public static const PART       :String = LanguageMgr.GetTranslation("ddt.view.effort.EffortCategoryTitleItem.PART");
		public static const TASK       :String = LanguageMgr.GetTranslation("ddt.view.effort.EffortCategoryTitleItem.TASK");
		public static const DUNGEON    :String = LanguageMgr.GetTranslation("ddt.view.effort.EffortCategoryTitleItem.DUNGEON");
		public static const FIGHT      :String = LanguageMgr.GetTranslation("ddt.view.effort.EffortCategoryTitleItem.FIGHT");
		private var _currentType:int;
		public function EffortCategoryTitleItem(type:int)
		{
			_currentType = type;
			init();
			initEvent();
			initTitle();
		}
		
		private function init():void
		{
			this.buttonMode = true;
			_effortCategoryTitleAsset = new EffortCategoryTitleAsset();
			_effortCategoryTitleAsset.gotoAndStop(1);
			addChild(_effortCategoryTitleAsset);
			addList();
			_isExpand = false;
		}
		
		private function initEvent():void
		{
			_effortCategoryTitleAsset.addEventListener(MouseEvent.MOUSE_OVER  , __categoryOver);
			_effortCategoryTitleAsset.addEventListener(MouseEvent.MOUSE_OUT   , __categoryOut);
		}
		
		private function initTitle():void
		{
			var title:String = getTypeTitle(_currentType);
			_effortCategoryTitleAsset.select_txt.text = title;
			_effortCategoryTitleAsset.notSelect_txt.text = title;
			_effortCategoryTitleAsset.select_txt.mouseEnabled = false;
			_effortCategoryTitleAsset.notSelect_txt.mouseEnabled = false;
		}
		
		private function addList():void
		{
			if(!_childList)return;
			if(_childItemPane)
			{
				_childItemPane.source = null;	
			}else
			{
				_childItemPane = new ScrollPane();
				_childItemPane.horizontalScrollPolicy = ScrollPolicy.OFF;
				_childItemPane.verticalScrollPolicy   = ScrollPolicy.AUTO;
				_childItemPane.width				  = 220;
				_childItemPane.height				  = 200;
				_childItemPane.x = _effortCategoryTitleAsset.x
				_childItemPane.y = _effortCategoryTitleAsset.y + _effortCategoryTitleAsset.height;
				
			}
			_content = new Sprite();
			_effortChildCategoryTitleArray = [];
			for(var i:int = 0 ; i< _childList.length ; i++)
			{
				var effortChildCategoryTitleItem:EffortChildCategoryTitleItem = new EffortChildCategoryTitleItem();
				effortChildCategoryTitleItem.y = i*40;
				_content.addChild(effortChildCategoryTitleItem);
				_effortChildCategoryTitleArray.push(effortChildCategoryTitleItem);
			}
			_childItemPane.source = _content;
		}
		
		public function get contentHeight():int
		{
			if(!_childList)return _effortCategoryTitleAsset.height;
			if(!_isExpand)
			{
				return _effortCategoryTitleAsset.height;
			}else
			{
				var contentHeight:int = _effortCategoryTitleAsset.height;
				for(var i:int = 0 ; i< _childList.length ; i++)
				{
					contentHeight +=  (_effortChildCategoryTitleArray[i] as EffortChildCategoryTitleItem).height;
				}
				return contentHeight;
			}
		}
		
		private function getTypeTitle(value:int):String
		{
			switch(value)
			{
				case 0:
					return FULL;
					break;
				case 1:
					return PART;
					break;
				case 2:
					return TASK;
					break;
				case 3:
					return DUNGEON;
					break;
				case 4:
					return FIGHT;
					break;
				case 5:
					return INTEGRATION;
					break;
			}
			return "null";
		}
		
		public function __categoryClick(evt:Event):void
		{
			_isExpand = !_isExpand;
		}
		
		public function __categoryOver(evt:Event):void
		{
			if(_isExpand)
				_effortCategoryTitleAsset.gotoAndStop(4);	
			else
				_effortCategoryTitleAsset.gotoAndStop(2);
		}
		
		public function __categoryOut(evt:Event):void
		{
			if(_isExpand)
				_effortCategoryTitleAsset.gotoAndStop(3);
			else
				_effortCategoryTitleAsset.gotoAndStop(1);
		}
		
		public function get isExpand():Boolean
		{
			return _isExpand;
		}
		
		public function get currentType():int
		{
			return _currentType;
		}
		
		public function set ChildCategory(isExpand:Boolean):void
		{
			if(!_childItemPane)return;
			if(!isExpand)
			{
				_childItemPane.visible = false;
				if(_childItemPane.parent == this)
				{
					removeChild(_childItemPane);
				}
				_isExpand = false;
			}else
			{
				_childItemPane.visible = true;
				addChild(_childItemPane)
				_isExpand = true;
			}
		}
		
		public function set selectState(value:Boolean):void
		{
			_isExpand = value;
			updateSelectState();
		}
		
		public function updateSelectState():void
		{
			if(_isExpand)
			{
				_effortCategoryTitleAsset.gotoAndStop(3);
				_effortCategoryTitleAsset.select_txt.visible = true;
				_effortCategoryTitleAsset.notSelect_txt.visible = false;
			}
			else
			{
				_effortCategoryTitleAsset.gotoAndStop(1);
				_effortCategoryTitleAsset.select_txt.visible = false;
				_effortCategoryTitleAsset.notSelect_txt.visible = true;
			}
		}
		
		public function dispose():void
		{
			if(_effortCategoryTitleAsset)
			{
				_effortCategoryTitleAsset.removeEventListener(MouseEvent.CLICK       , __categoryClick);
				_effortCategoryTitleAsset.removeEventListener(MouseEvent.MOUSE_OVER  , __categoryOver);
				_effortCategoryTitleAsset.removeEventListener(MouseEvent.MOUSE_OUT   , __categoryOut);
				_effortCategoryTitleAsset.parent.removeChild(_effortCategoryTitleAsset);
				_effortCategoryTitleAsset = null;
			}
			if(_content)
			{
				_content.parent.removeChild(_content);
				_content = null;
			}
			if(_childItemPane)
			{
				_childItemPane.parent.removeChild(_childItemPane);
			}
			_childItemPane = null;
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
		}  

	}
}