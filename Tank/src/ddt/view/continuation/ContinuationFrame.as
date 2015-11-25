package ddt.view.continuation
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.Shortcutpayasset;
	
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.SimpleGrid;
	import road.ui.controls.hframe.HAlertDialog;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.utils.ComponentHelper;
	
	import ddt.data.ItemPrice;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ShopIICarItemInfo;
	import ddt.data.player.PlayerPropertyEvent;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.ShopManager;
	import ddt.manager.SocketManager;
	import ddt.utils.LeavePage;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;

	public class ContinuationFrame extends HConfirmFrame
	{
		private var _shortcutpay:Shortcutpayasset;
		private var _list:SimpleGrid;
		private var data:Array;
		private var fill_btn:HBaseButton;
		private var price:ItemPrice;
		public function ContinuationFrame()
		{
			super();
			init();
		}
		private function init():void
		{
			_shortcutpay=new Shortcutpayasset();
			fill_btn=new HBaseButton(_shortcutpay.pay_btn);
			_shortcutpay.addChild(fill_btn);
			addChild(_shortcutpay);
			okLabel=LanguageMgr.GetTranslation("ddt.view.common.AddPricePanel.xu");
			fireEvent=true;
			buttonGape=100;
			moveEnable = false;
			setSize(457,539);
			
			_list = new SimpleGrid(380,66);
			addChild(_list);
			ComponentHelper.replaceChild(_shortcutpay,_shortcutpay.list_pos,_list);
			_list.horizontalScrollPolicy = ScrollPolicy.OFF;
			_list.verticalScrollPolicy = ScrollPolicy.ON;
			_list.verticalLineScrollSize = 64;
			
			okFunction = __onOkClick;
			
			fill_btn.addEventListener(MouseEvent.CLICK,__onFillBtnClick);
			this.closeCallBack=__onClose;
			this.cancelFunction=__onClose;
			__onPlayerPropertyChange(null);
		}
		
		override protected function __closeClick(e:MouseEvent):void
		{
			if(this.cancelFunction != null) this.cancelFunction();
			super.__closeClick(e);
		}
		
		private function __onClose():void
		{
			InventoryItemInfo.startTimer();
			close();
		}
		
		public function setList(arr:Array):void
		{
			arr.sort(function(a:InventoryItemInfo, b:InventoryItemInfo):Number{
				var sort_arr:Array=[7,5,1,17,8,9,14,6,13,15,3,4,2];
				var a_index:uint=sort_arr.indexOf(a.CategoryID);
				var b_index:uint=sort_arr.indexOf(b.CategoryID);
				if(a_index<b_index)
				{
					return -1;
				}else if(a_index==b_index)
				{
					return 0;
				}else
				{
					return 1;
				};
			});
			for each(var i:InventoryItemInfo in arr)
			{
				if(ShopManager.Instance.canAddPrice(i.TemplateID))
				{
					var item:ContinuationItem = new ContinuationItem();
					item.shopItemInfo = i;
					item.setColor(i.Color);
					_list.appendItem(item);
					item.addEventListener(ContinuationItem.DELETE_ITEM,__onItemDelete);
					item.addEventListener(ContinuationItem.CONDITION_CHANGE,__onItemChange);
				}
			}
			updateTxt();
		}
		private function __onFillBtnClick(e:Event):void
		{
			LeavePage.leaveToFill();
		}
		private function __onItemChange(e:Event):void
		{
			updateTxt();
		}
		private function __onItemDelete(e:Event):void
		{
//			var item:ContinuationItem=ContinuationItem(e.currentTarget);
//			item.removeEventListener(ContinuationItem.DELETE_ITEM,__onItemDelete);
//			item.dispose();
//			_list.removeItem(item);
		}
		private function get shopInfoListWithOutDelete():Array
		{
			var arr:Array=new Array;
			for each(var i:ContinuationItem in _list.items)
			{
				if(!i.isDelete)
				{
					arr.push(i.currentShopItem);
				}
			}
			return arr;
		}
		private function get shopInfoList():Array
		{
			var arr:Array=new Array;
			for each(var i:ContinuationItem in _list.items)
			{
				arr.push(i.currentShopItem);
			}
			return arr;
		}
		private function __onOkClick():void
		{
			if(PlayerManager.Instance.Self.bagLocked)
			{
				new BagLockedGetFrame().show();
			}else
			{
				payAll();
			}
		}
		private function payAll():void
		{
			var shopInfoList_arr:Array=shopInfoList;
			var buy_arr:Array=ShopManager.Instance.buyIt(shopInfoListWithOutDelete,PlayerManager.Instance.Self);
			if(buy_arr.length>0){
				var pay_arr:Array=new Array;
				var info_arr:Array=new Array;
				var remove_arr:Array=new Array;
				for each(var j:ShopIICarItemInfo in buy_arr)
				{
					var index:uint=shopInfoList_arr.indexOf(j);
					info_arr.push(ContinuationItem(_list.items[index]).info);
					remove_arr.push(_list.items[index]);
				}
				for each(var k:DisplayObject in remove_arr)
				{
					_list.removeItem(k);
				}
				var i:int;
				for(i=0;i<buy_arr.length;i++)
				{
					var isDress:Boolean=info_arr[i].Place<=30;
					pay_arr.push([info_arr[i].BagType,info_arr[i].Place,buy_arr[i].GoodsID,buy_arr[i].currentBuyType,isDress]);
				}
				
				SocketManager.Instance.out.sendGoodsContinue(pay_arr);
				if(_list.itemCount<=0)//全部完成续费
				{
					super.close();
					
				}else if(shopInfoListWithOutDelete.length>0)//如果续费的装备有失败的
				{
					showTipPanel();
				}
				updateTxt();
			}else if(shopInfoListWithOutDelete.length==0)
			{
				
			}else
			{
				showTipPanel();
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.continuation.contiuationFailed"));
			}
		}
		private function showTipPanel():void
		{
			if(price.moneyValue>PlayerManager.Instance.Self.Money)
			{
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.point"),true,LeavePage.leaveToFill,null,true,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
			}
			else if(price.giftValue>PlayerManager.Instance.Self.Gift)
			{
				HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.lijinbuzu"),true,null,true,LanguageMgr.GetTranslation("ok"));
			}
		}
		private function updateTxt():void
		{
			var pay_num:uint=shopInfoListWithOutDelete.length
			_shortcutpay.count_txt.text=String(pay_num);
			if(pay_num<=0)
			{
				okBtnEnable=false;
			}
			else
			{
				okBtnEnable=true;
			}
			
			price=new ItemPrice(null,null,null);
			for each(var i:ShopIICarItemInfo in shopInfoListWithOutDelete)
			{
				price.addItemPrice(i.getCurrentPrice());
			}
			_shortcutpay.needMoney_txt.text=String(price.moneyValue);
			_shortcutpay.needGift_txt.text=String(price.giftValue);
			updataTextColor();
			
			PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__onPlayerPropertyChange,false,0,true);
		}
		private function __onPlayerPropertyChange(e:Event):void
		{
			_shortcutpay.money_txt.text = String(PlayerManager.Instance.Self.Money);
			_shortcutpay.gift_txt.text = String(PlayerManager.Instance.Self.Gift);
			updataTextColor();
		}
		private function updataTextColor():void
		{
			if(price)
			{
				if(price.moneyValue>PlayerManager.Instance.Self.Money)
				{
					_shortcutpay.needMoney_txt.textColor=0xff0000;
				}else
				{
					_shortcutpay.needMoney_txt.textColor=0x000000;
				}
				if(price.giftValue>PlayerManager.Instance.Self.Gift)
				{
					_shortcutpay.needGift_txt.textColor=0xff0000;
				}else
				{
					_shortcutpay.needGift_txt.textColor=0x000000;
				}
			}
		}
		public override function dispose():void
		{
			fill_btn.addEventListener(MouseEvent.CLICK,__onFillBtnClick);
			fill_btn.dispose();
			if(fill_btn && fill_btn.parent)fill_btn.parent.removeChild(fill_btn);
			fill_btn = null;
			for(var i:int = 0;i<_list.items.length;i++)
			{
				_list.items[i].dispose();
				_list.items[i].removeEventListener(ContinuationItem.DELETE_ITEM,__onItemDelete);
				_list.items[i].removeEventListener(ContinuationItem.CONDITION_CHANGE,__onItemChange);
			}
			_list.clearItems();
			_list = null;
			super.dispose();
			PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__onPlayerPropertyChange);
		}
	}
}