package ddt.game
{
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	
	import org.aswing.KeyStroke;
	import org.aswing.KeyboardManager;
	
	import road.manager.SoundManager;
	
	import ddt.data.BuffInfo;
	import ddt.data.EquipType;
	import ddt.data.game.LocalPlayer;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.PropInfo;
	import ddt.manager.GameManager;
	import ddt.manager.ItemManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SharedManager;
	import ddt.manager.ShopManager;
	import ddt.manager.SocketManager;
	import ddt.socket.GameInSocketOut;
	import ddt.view.common.BuyBuffCardFrame;
	import ddt.view.items.ItemEvent;
	import ddt.view.items.PropItemView;
	
	import webgame.crazytank.game.view.RightShotChutBack;

	public class RightPropView extends BaseGamePropBarView
	{
		private var _shotCut:RightShotChutBack;
		
		private static const PROP_ID:int = 10;
		
		public function RightPropView(self:LocalPlayer)
		{
			super(self,8,1,false,false,false)			
			initView();
			setItem();
		}
		
		private function initView():void
		{
			_itemContainer.cellPaddingHeight = 4;
			_itemContainer.setSize(50,350);
			_shotCut = new RightShotChutBack();
			_shotCut.x = 27;
			addChild(_shotCut);
			_shotCut.mouseEnabled = false;
			KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN,__keyDown);
		}
		
		private function __keyDown(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case KeyStroke.VK_1.getCode():
				case KeyStroke.VK_NUMPAD_1.getCode():
					_itemContainer.mouseClickAt(0);
					break;
				case KeyStroke.VK_2.getCode():
				case KeyStroke.VK_NUMPAD_2.getCode():
					_itemContainer.mouseClickAt(1);
					break;
				case KeyStroke.VK_3.getCode():
				case KeyStroke.VK_NUMPAD_3.getCode():
					_itemContainer.mouseClickAt(2);
					break;
				case KeyStroke.VK_4.getCode():
				case KeyStroke.VK_NUMPAD_4.getCode():
					_itemContainer.mouseClickAt(3);
					break;
				case KeyStroke.VK_5.getCode():
				case KeyStroke.VK_NUMPAD_5.getCode():
					_itemContainer.mouseClickAt(4);
					break;
				case KeyStroke.VK_6.getCode():
				case KeyStroke.VK_NUMPAD_6.getCode():
					_itemContainer.mouseClickAt(5);
					break;
				case KeyStroke.VK_7.getCode():
				case KeyStroke.VK_NUMPAD_7.getCode():
					_itemContainer.mouseClickAt(6);
					break;
				case KeyStroke.VK_8.getCode():
				case KeyStroke.VK_NUMPAD_8.getCode():
					_itemContainer.mouseClickAt(7);
					break;
			}
		}
		
		public function setItem():void
		{
			_itemContainer.clear();
			
			var hasItem:Boolean = false;
			var propAllProp:InventoryItemInfo = PlayerManager.Instance.Self.PropBag.findFistItemByTemplateId(EquipType.T_ALL_PROP,true,true);
			
			var _sets:Dictionary = SharedManager.Instance.GameKeySets;
			for (var propId:String in _sets)
			{
				if(int(propId) == 9) break;
				var info:PropInfo = new PropInfo(ItemManager.Instance.getTemplateById(_sets[propId]));
				if(propAllProp||PlayerManager.Instance.Self.hasBuff(BuffInfo.FREE))
				{
					if(propAllProp)
					{
						info.Place = propAllProp.Place;
					}else
					{
						info.Place = -1;
					}
					info.Count = -1;
					_itemContainer.appendItemAt(new PropItemView(info),int(propId)-1);
					hasItem = true;
				}
				else
				{
					var items:Array = PlayerManager.Instance.Self.PropBag.findItemsByTempleteID(_sets[propId]);
					if(items.length > 0)
					{
						info.Place = items[0].Place;
						for each(var i:InventoryItemInfo in items)
						{
							info.Count += i.Count;
						}
						
//						if(SharedManager.Instance.KeyAutoSnap)
//						{
//							_itemContainer.appendItem(new PropItemView(info));
//						}else
//						{
							_itemContainer.appendItemAt(new PropItemView(info),int(propId)-1);
//						}
						hasItem = true;
					}else
					{
						_itemContainer.appendItemAt(new PropItemView(info,false),int(propId)-1);
					}
				}
				
			}
			
			
			if(hasItem)
			{
//				_itemContainer.visible = true;
//				_shotCut.visible = true;
				_itemContainer.setClickByEnergy(self.energy)
			}
		}	
		
		override public function dispose():void
		{
			super.dispose();
			KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,__keyDown);
		}
		
		override protected function __click(event:ItemEvent):void
		{
			var itemView:PropItemView = event.item as PropItemView;
			var item:PropInfo = itemView.info;
			if(itemView.isExist)
			{
				if(self.isLiving == false)
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.game.RightPropView.prop"));
					return;
				}else if(!self.isAttacking)
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.game.ArrowViewIII.fall"));
					return;
					//MessageTipManager.getInstance().show("轮到你行动时才可以使用");
				}else if(self.LockState)
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.game.cantUseItem"));
					return;
				}
				else if(self.energy < item.needEnergy)
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.game.actions.SelfPlayerWalkAction"));
					return;
				}
				else
				{
					self.useItem(item.Template);
					GameInSocketOut.sendUseProp(1,item.Place,item.Template.TemplateID);
				}
			}else
			{
				SoundManager.instance.play("008");
		    	BuyBuffCardFrame.Instance.setInfo(ItemManager.Instance.getTemplateById(EquipType.FREE_PROP_CARD));
		    	BuyBuffCardFrame.Instance.show();
			}
		}
		
		private function confirm():void
		{
			if(PlayerManager.Instance.Self.Money>=ShopManager.Instance.getMoneyShopItemByTemplateID(EquipType.FREE_PROP_CARD).getItemPrice(1).moneyValue)
		    {
		    	SocketManager.Instance.out.sendUseCard(-1,-1,EquipType.FREE_PROP_CARD,1,true);
		    }else
		    {
		    	MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIBtnPanel.stipple"));
//		    	HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.comon.lack"),true,__fillClick,null);
		    }
		}

	}
}