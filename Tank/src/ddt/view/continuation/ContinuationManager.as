package ddt.view.continuation
{
	/* import fl.controls.ScrollPolicy;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Dictionary;
	
//	import game.crazyTank.view.bagII.ContinuationBgAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.SimpleGrid;
	import road.ui.controls.hframe.HConfirmDialog; */
	import road.ui.controls.hframe.HConfirmFrame;
	/* import road.ui.manager.TipManager;
	import road.utils.ComponentHelper;
	
	import ddt.data.goods.InventoryItemInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.view.bagII.baglocked.BagLockedGetFrame; */
	
	public class ContinuationManager extends HConfirmFrame
	{
		/* private static var _instance:ContinuationManager;
		public var enableItems : Dictionary;
		
		private static function get instance():ContinuationManager
		{
			if(!_instance)
			{
				_instance = new ContinuationManager();
			}
			return _instance;
		}
		public static function switchVisible():void
		{
			if(instance.parent)
			{
				instance.parent.removeChild(instance);
//				removeEvent();
			}
			else
			{
				TipManager.AddTippanel(ContinuationManager.instance,true);
			}
		}
		private static const BETOOVERDUE:uint = 0;
		private static const HASOVERDUE:uint = 1;
		
		private var currentType:uint = 0;
		
		private var _bg:ContinuationBgAsset;
		private var _list:SimpleGrid;
		private var _data:Array;
		
		private var totalMoney:Number = 0;
		
		private var goSupplyBtn:HBaseButton;
		private var betoOverdue:MovieClip;
		private var hasOverdue:MovieClip;
		
		public function ContinuationManager()
		{
			this.blackGound = false;
			this.alphaGound = true;
			this.moveEnable = false;
			this.fireEvent = false;
			this.showBottom = false;
			this.showClose = true;
			this.buttonGape = 100;
			this.setContentSize(430,435);
			
			this.cancelFunction =__cancel; 
			this.okFunction =__confirm ;
			
			init();
			addEvent();
		}
		
		private function init():void
		{
			enableItems = new Dictionary(true);
			
			_bg = new ContinuationBgAsset();
			addContent(_bg,true);
			
			_list = new SimpleGrid(400,66); 
			_list.verticalScrollPolicy = ScrollPolicy.ON;
			_list.horizontalScrollPolicy = ScrollPolicy.OFF;
//			_list.verticalLineScrollSize = _list.verticalPageScrollSize = 64;
			ComponentHelper.replaceChild(_bg,_bg.list_pos,_list);
		
			betoOverdue = _bg.betoOverdue;
			betoOverdue.buttonMode = true;
			betoOverdue.gotoAndStop(2);
			hasOverdue = _bg.haveOverdue; 
			hasOverdue.buttonMode = true;
			hasOverdue.gotoAndStop(1);
			
			goSupplyBtn = new HBaseButton(_bg.flushAsset);
			goSupplyBtn.useBackgoundPos = true;
			_bg.addChild(goSupplyBtn);
			
			updateText();
		}
		
		private function getDate():void
		{
//			_data = PlayerManager.Instance.Self.Bag.findOvertimeItems();
			_data = PlayerManager.Instance.Self.findOvertimeItems();
			totalMoney = 0;
			
			updateText();
			updateList();
		}
		
		private function addEvent():void
		{
			betoOverdue.addEventListener(MouseEvent.CLICK,__typeClick);
			hasOverdue.addEventListener(MouseEvent.CLICK,__typeClick);
			
			goSupplyBtn.addEventListener(MouseEvent.CLICK,__fillClick);
		}
		private function removeEvent() : void
		{
			betoOverdue.removeEventListener(MouseEvent.CLICK,__typeClick);
			hasOverdue.removeEventListener(MouseEvent.CLICK,__typeClick);
			
			goSupplyBtn.removeEventListener(MouseEvent.CLICK,__fillClick);
		}
		
		private function __typeClick(event:MouseEvent):void
		{
			SoundManager.instance.play("008");
			if(event.currentTarget == betoOverdue)
			{
				currentType = BETOOVERDUE;
			}else
			{
				currentType = HASOVERDUE;
			}
			
			resetBtnState();
			(event.currentTarget as MovieClip).gotoAndStop(2);
			
			updateList();
		}
		
		private function __fillClick(evt:MouseEvent = null):void
		{
			SoundManager.instance.play("008");
			navigateToURL(new URLRequest(PathManager.solveFillPage()),"_blank");
		}
		
		private function resetBtnState():void
		{
			betoOverdue.gotoAndStop(1);
			hasOverdue.gotoAndStop(1);
		}
		
		private function updateList():void
		{
			_list.clearItems();
			var currentData:Array = _data[currentType];
//			var currentData:Array = _data;
			for(var i:uint = 0;i<currentData.length;i++)
			{
				
				var info : InventoryItemInfo = currentData[i] as InventoryItemInfo;
				if(enableItems[info.Place+"_"+info.BagType] != true)
				{
					var item:ContinuationItem = new ContinuationItem();
					item.info = info;
					item.addEventListener(Event.CHANGE,updateCost);
					item.addEventListener(Event.CLOSE, deleteItem);
					_list.appendItem(item);
				}
			}
			
			updateCost(null);
//			_list.getItems().length > 0 ? okBtnEnable = true : okBtnEnable = false;
		}
		private function deleteItem(evt : Event) : void
		{
			var item : ContinuationItem = evt.target as ContinuationItem;
			if(item.info is InventoryItemInfo)
			enableItems[item.info["Place"]+"_"+item.info["BagType"]] = true;
			_list.removeItem(item);
			item.removeEventListener(Event.CHANGE,updateCost);
			item.removeEventListener(Event.CLOSE, deleteItem);
			item.dispose();
			item = null;
			updateCost(null);
//			_list.getItems().length > 0 ? okBtnEnable = true : okBtnEnable = false;
			
		}
		override protected function __addToStage(e:Event):void
		{
			super.__addToStage(null);
			enableItems = new Dictionary(true);
			getDate();
		}
		
		public function updateCost(event:Event):void
		{
			totalMoney = 0;
			var arr:Array= _list.getItems();
			for(var i:uint =0;i<arr.length;i++)
			{
				var item:ContinuationItem = (arr[i] as ContinuationItem);
				if(item.type == 0)continue;
				totalMoney += item.info["Price" + item.type] * item.info["Agio" + item.type];
			}
			updateText();
		}
		
		public function updateText():void
		{
			_bg.needMoney_txt.text = String(totalMoney);
			_bg.money_txt.text = String(PlayerManager.Instance.Self.Money);
			totalMoney > 0 ? okBtnEnable = true : okBtnEnable = false;
		}
		
		private function __confirm():void
		{
			updateCost(null);
			if(totalMoney>PlayerManager.Instance.Self.Money)
			{
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.comon.lack"),true,__fillClick,cannelClick);
			}else if(totalMoney > 0)
			{
				if(PlayerManager.Instance.Self.bagLocked)
				{
					new BagLockedGetFrame().show();
					return;
				}
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.common.AddPricePanel.pay"),true,sendContinuation,cannelClick);
//				sendContinuation();
			}
		}
		
		private function cannelClick() : void
		{
			SoundManager.instance.play("008");
		}

		private function sendContinuation():void
		{
			
			var arr:Array= _list.getItems();
			var continuationItems:Array = [];
			for(var i:uint =0;i<arr.length;i++)
			{
				var item:ContinuationItem = (arr[i] as ContinuationItem);
				if(item.type == 0)continue;
				var info:InventoryItemInfo = item.info as InventoryItemInfo;
				
				continuationItems.push([info.BagType,info.Place,item.type,false]);
			}
			
			if(continuationItems.length > 0)
			{
				SocketManager.Instance.out.sendGoodsContinue(continuationItems);
			}
			
			super.hide();
		}
		
		private function __cancel():void
		{
			super.hide();
		} */
	}
}