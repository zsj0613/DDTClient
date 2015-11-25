package ddt.church.churchScene.fire
{
	import ddt.church.churchScene.SceneControler;
	
	import fl.controls.ScrollPolicy;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Rectangle;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.SimpleGrid;
	import road.utils.ComponentHelper;
	
	import tank.church.UseFireAsset;
	import ddt.data.EquipType;
	import ddt.data.goods.ShopItemInfo;
	import ddt.data.player.PlayerPropertyEvent;
	import ddt.events.ChurchRoomEvent;
	import ddt.manager.ChatManager;
	import ddt.manager.ChurchRoomManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.manager.ShopManager;
	import ddt.manager.SocketManager;
	import ddt.view.chatsystem.ChatData;
	import ddt.view.chatsystem.ChatInputView;
	import ddt.view.common.FastPurchaseGoldBox;
	

	public class FireView extends UseFireAsset
	{
		private var _list:SimpleGrid;
		public static const All_Fires:Array = [21002,21006];
		private var closeBtn:HBaseButton;
		private var _controler:SceneControler;
		public function FireView(control:SceneControler)
		{
			_controler = control;
			init();
		}
		
		private function init():void
		{
			_list = new SimpleGrid(54,54,2);
			_list.verticalScrollPolicy = ScrollPolicy.ON;
			_list.horizontalScrollPolicy = ScrollPolicy.OFF;
			ComponentHelper.replaceChild(this,list_pos,_list);
			initItems();
			
			closeBtn = new HBaseButton(closeAsset);
			closeBtn.useBackgoundPos = true;
			closeBtn.addEventListener(MouseEvent.CLICK,closeHandler);
//			addEventListener(KeyboardEvent.KEY_DOWN,__keyDown);
			addChild(closeBtn);
			
			money_txt.text = PlayerManager.Instance.Self.Gold.toString();
			PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__updateGold);
			ChurchRoomManager.instance.addEventListener(ChurchRoomEvent.ROOM_FIRE_ENABLE_CHANGE,__fireEnableChange);
//			darger.addEventListener(MouseEvent.MOUSE_DOWN,dargerHander);
//			darger.addEventListener(MouseEvent.MOUSE_UP,dargerUp);
		}
		private function removeEvent() : void
		{
			if(closeBtn)closeBtn.removeEventListener(MouseEvent.CLICK,closeHandler);
//			removeEventListener(KeyboardEvent.KEY_DOWN,__keyDown);
			PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__updateGold);
			ChurchRoomManager.instance.removeEventListener(ChurchRoomEvent.ROOM_FIRE_ENABLE_CHANGE,__fireEnableChange);
		}
		
		private function dargerHander(e:MouseEvent):void
		{
			this.startDrag(false,new Rectangle(0,0,1800,900));
		}
		
		private function __updateGold(evt:PlayerPropertyEvent):void
		{
			money_txt.text = PlayerManager.Instance.Self.Gold.toString();
		}
		
		private function dargerUp(e:MouseEvent):void
		{
			this.stopDrag();
		}
		
//		private function __keyDown(event:KeyboardEvent):void
//		{
//			event.stopImmediatePropagation();
//			if(event.keyCode == Keyboard.ESCAPE)
//			{
//				closeHandler(null);
//			}
//		}
		
		private function closeHandler(e:MouseEvent):void
		{
			SoundManager.instance.play("008");
			if(parent)
			{
				parent.removeChild(this);
			}
		}
		
		private function initItems():void
		{
			for(var i:int = 0;i<All_Fires.length;i++)
			{
//				var info:ItemTemplateInfo = ItemManager.Instance.getTemplateById(All_Fires[i]);
				var shopItemInfo:ShopItemInfo = ShopManager.Instance.getGoldShopItemByTemplateID(All_Fires[i]);
				var fireItem:FireItem = new FireItem();
				fireItem.setInfo(shopItemInfo);
				fireItem.addEventListener(MouseEvent.CLICK,itemClickHandler);
				_list.appendItem(fireItem);
			}
			if(All_Fires.length<=6)
			{
				_list.verticalScrollPolicy = ScrollPolicy.OFF;
			}
		}
		
		private function removeItems():void
		{
			for(var i: int=(_list.items.length-1);i>=0;i--)
			{
				var fireItem:FireItem = _list.getItemAt(i) as FireItem;
				fireItem.addEventListener(MouseEvent.CLICK,itemClickHandler);
				_list.removeItem(fireItem);
				fireItem = null;
			}
			_list.clearItems();
		}
		
		private function addEvent():void
		{
			//
		}
		
		private function itemClickHandler(e:MouseEvent):void
		{
			if(PlayerManager.Instance.Self.Gold<200)
			{
				SoundManager.instance.play("008");
				new FastPurchaseGoldBox(LanguageMgr.GetTranslation("ddt.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("ddt.view.GoldInadequate"),EquipType.GOLD_BOX).show();
//				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIBtnPanel.gold"));
				//MessageTipManager.getInstance().show("金币不足");
				
//				var msg:ChatData = new ChatData();
//				msg.channel = ChatInputView.SYS_TIP;
//				msg.msg = LanguageMgr.GetTranslation("shop.ShopIIBtnPanel.gold");
//				//msg.msg = "金币不足";
//				ChatManager.Instance.chat(msg);
				return;
			}
			var target:FireItem = e.currentTarget as FireItem;
			_controler.useFire(PlayerManager.Instance.Self.ID,target.info.TemplateID);
			SocketManager.Instance.out.sendUseFire(PlayerManager.Instance.Self.ID,target.info.TemplateID);
		}
		
		private function __fireEnableChange(e:ChurchRoomEvent):void
		{
			var value:Boolean = ChurchRoomManager.instance.fireEnable;
			setButtnEnable(_list,value);
			if(value)
			{
				for(var i:int;i<_list.itemCount;i++)
				{
					_list.items[i].addEventListener(MouseEvent.CLICK,itemClickHandler);
				}
			}else
			{
				for(var j:int;j<_list.itemCount;j++)
				{
					_list.items[j].removeEventListener(MouseEvent.CLICK,itemClickHandler);
				}
			}
			
		}
		
		private function setButtnEnable(obj:Sprite,value:Boolean):void
		{
			obj.mouseEnabled = value;
			obj.filters = value?[]:[new ColorMatrixFilter([0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0])];
		}
		
		public function dispose():void
		{
			removeEvent();
			removeItems();
			if(this.parent)this.parent.removeChild(this);
		}
	}
}