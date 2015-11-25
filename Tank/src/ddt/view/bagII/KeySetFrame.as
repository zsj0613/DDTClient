package ddt.view.bagII
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import game.crazyTank.view.bagII.KeySetNumberAccect;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HCheckBox;
	import road.ui.controls.SimpleGrid;
	import road.ui.controls.hframe.HBlackFrame;
	
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.manager.ItemManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.SharedManager;
	import ddt.view.items.ItemEvent;
	import ddt.view.items.PropItemView;

	public class KeySetFrame extends HBlackFrame
	{
		private var _list:SimpleGrid;
		private var _defaultSetPalel:KeyDefaultSetPanel

		private var _currentSet:KeySetItem;
		
		private var _tempSets:Dictionary;
		
		private var numberAccect:KeySetNumberAccect;
		
		private var autocheck:HCheckBox;											
		public function KeySetFrame()
		{
			
			super();
			setSize(385,120);
//			setSize(336,120);
			bottomHeight = 36;
			showClose = false;
			okFunction = okClick;
			cancelFunction = cancelClick;
			titleText = LanguageMgr.GetTranslation("ddt.view.bagII.KeySetFrame.titleText");
			//titleText = "快捷键设置";
			initContent();
			
		}
	
		private function initContent():void
		{
			numberAccect = new KeySetNumberAccect();
			
			_list = new SimpleGrid(44,54,8);
			_list.horizontalScrollPolicy = _list.verticalScrollPolicy = "off";
			_list.width = 377;//328 
			_list.height = 54;
			_list.marginHeight = 5;
			_list.marginWidth = 5;
			_list.x = 5;
			_list.y = 28;
			numberAccect.y = _list.y+5;
			numberAccect.x = 34;
			_tempSets = new Dictionary();
			for(var strpop:String in SharedManager.Instance.GameKeySets)
			{
				_tempSets[strpop] = SharedManager.Instance.GameKeySets[strpop];
			}
			
			
//			_tempSets = SharedManager.Instance.GameKeySets;
		
			creatCell();
			addChild(_list);
			addChild(numberAccect);
			_defaultSetPalel = new KeyDefaultSetPanel();
			_defaultSetPalel.visible = false;
			_defaultSetPalel.addEventListener(Event.SELECT,onItemSelected);
			_defaultSetPalel.addEventListener(Event.REMOVED_FROM_STAGE,__ondefaultSetRemove);
			
			
//			autocheck = new HCheckBox(LanguageMgr.GetTranslation("ddt.view.bagII.KeySetFrame.autocheck"));
//			//autocheck = new HCheckBox("自动补齐");
//			autocheck.fireAuto = true;
//			autocheck.x = 180;
//			autocheck.tips = LanguageMgr.GetTranslation("ddt.view.bagII.KeySetFrame.autocheck.tips");
//			//autocheck.tips = "打开该功能系统将为\n您自动填补空余快捷\n键上的道具";
//			autocheck.y = 80;
//			addChild(autocheck);
//			autocheck.selected = SharedManager.Instance.KeyAutoSnap;
			
		}
	
		private function okClick ():void
		{
			for(var strpop:String in _tempSets)
			{
				SharedManager.Instance.GameKeySets[strpop] = _tempSets[strpop];
			}
			
//			SharedManager.Instance.GameKeySets = _tempSets;
//			SharedManager.Instance.KeyAutoSnap = autocheck.selected;
			SharedManager.Instance.save();
			close();
		}
		
		private function onItemClick(e:ItemEvent):void
		{
			e.stopImmediatePropagation();
			SoundManager.instance.play("008");
			var tempCell:KeySetItem = e.currentTarget as KeySetItem;
			_currentSet = tempCell;
			
			if(_defaultSetPalel.parent)
			{
				removeChild(_defaultSetPalel);
			}
			_defaultSetPalel.visible = true;
			_currentSet.glow = true;
			_defaultSetPalel.x = e.currentTarget.x+2;
			_defaultSetPalel.y = _list.y-_defaultSetPalel.height;
			addChild(_defaultSetPalel);
			
		}
		
		private function cancelClick():void
		{
			close();
			_tempSets = new Dictionary();
			for(var strpop:String in SharedManager.Instance.GameKeySets)
			{
				_tempSets[strpop] = SharedManager.Instance.GameKeySets[strpop];
			}
//			autocheck.selected = SharedManager.Instance.KeyAutoSnap;
			creatCell();
		}
		
		private function __ondefaultSetRemove(e:Event):void
		{
			if(_currentSet)
			_currentSet.glow = false;
		}
		
		private function creatCell():void
		{
			clearItemList();
			for (var i:String in _tempSets)
			{
				var temp:ItemTemplateInfo = ItemManager.Instance.getTemplateById(_tempSets[i]);
				if(i == "9") return;
				if(temp)
				{
					var icon:KeySetItem = new KeySetItem(int(i),PropItemView.createView(temp.Pic,40,40));
					icon.addEventListener(ItemEvent.ITEM_CLICK,onItemClick);
					icon.setClick(true,false,true);
					_list.appendItem(icon);
				}
			}
		}
		
		private function clearItemList(delReference:Boolean = false):void
		{
			if(_list)
			{
				for each(var icon:KeySetItem in _list.items)
				{
					icon.removeEventListener(ItemEvent.ITEM_CLICK,onItemClick);
					icon.dispose();
					icon = null;
				}
				_list.clearItems();
				
				if(delReference)
				{
					if(_list.parent)
					{
						_list.parent.removeChild(_list);
					}
					
					_list = null;
				}
			}
		}
		
		override public function close():void
		{
			super.close();
			_defaultSetPalel.hide();
		}
		
		private function onItemSelected(e:Event):void
		{
			if(stage)
			{
				stage.focus = this;
			}
			var temp:ItemTemplateInfo = ItemManager.Instance.getTemplateById(_defaultSetPalel.selectedItemID);
			_currentSet.setItem(PropItemView.createView(temp.Pic,40,40),false);
			_tempSets[_currentSet.index] = _defaultSetPalel.selectedItemID;
		}
		
		override public function dispose():void
		{
			clearItemList(true);
			
//			if(autocheck && autocheck.parent) autocheck.parent.removeChild(autocheck);
////			if(autocheck) autocheck.dispose();
//			autocheck = null;
			_defaultSetPalel.removeEventListener(Event.SELECT,onItemSelected);
			_defaultSetPalel.removeEventListener(Event.REMOVED_FROM_STAGE,__ondefaultSetRemove);
			_defaultSetPalel.dispose();
			_defaultSetPalel = null;
			
			if(_currentSet)
			{
				_currentSet.removeEventListener(ItemEvent.ITEM_CLICK,onItemClick);
				_currentSet = null;
			}
			
			if(parent) parent.removeChild(this);
			super.dispose();
		}
		
		
	}
}