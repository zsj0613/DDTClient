package  ddt.game
{
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	
	import org.aswing.KeyStroke;
	import org.aswing.KeyboardManager;
	
	import ddt.data.game.LocalPlayer;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.PropInfo;
	import ddt.data.player.BagInfo;
	import ddt.data.player.SelfInfo;
	import ddt.manager.GameManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.socket.GameInSocketOut;
	import ddt.view.bagII.BagEvent;
	import ddt.view.items.ItemEvent;
	import ddt.view.items.PropItemView;

	public class SelfPropContainBar extends BaseGamePropBarView
	{
		private var _back:PropBackAsset;
		private var _info:SelfInfo;
		
		private var _shortCut:PropShortCutView;

		public function SelfPropContainBar(self:LocalPlayer)
		{
			super(self,3,3,false,false,false);
			
			_back = new PropBackAsset();
			_back.x = 2;
			addChild(_back);

			_itemContainer.x = 3;
			_itemContainer.y = 50;
			_itemContainer.setSize(140,50);
			_itemContainer.cellPaddingWidth = 4;
			addChild(_itemContainer);
			
			_shortCut = new PropShortCutView();
			_shortCut.setPropCloseEnabled(0,false);
			_shortCut.setPropCloseEnabled(1,false);
			_shortCut.setPropCloseEnabled(2,false);
			addChild(_shortCut);
			
			setLocalPlayer(self.playerInfo as SelfInfo);
			
			KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN,__keyDown);
			
			initData();
		}
		private var _myitems:Array;
		private function initData():void
		{
			var bag:BagInfo = _info.FightBag;
			for each(var info:InventoryItemInfo in bag.items)
			{
				var propInfo:PropInfo = new PropInfo(info);
				propInfo.Place = info.Place;
				addProp(propInfo);
			}
		}
		
		private function __keyDown(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case KeyStroke.VK_Z.getCode():
					_itemContainer.mouseClickAt(0);
					break;
				case KeyStroke.VK_X.getCode():
					_itemContainer.mouseClickAt(1);
					break;
				case KeyStroke.VK_C.getCode():
					_itemContainer.mouseClickAt(2);
					break;
			}
		}

		override public function dispose():void
		{
			super.dispose();
			if(_shortCut)
			{
				removeChild(_shortCut);
				_shortCut.dispose();
			}
			_shortCut = null;
			KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,__keyDown);
		}
		
		public function setLocalPlayer(value:SelfInfo):void
		{
			if(_info != value)
			{
				if(_info)
				{
					_info.FightBag.removeEventListener(BagEvent.UPDATE,__updateProp);
					_itemContainer.clear();
				}
				_info = value;
				if(_info)
				{
					_info.FightBag.addEventListener(BagEvent.UPDATE,__updateProp);
				}
			}
		}
		
		private function __removeProp(event:BagEvent):void
		{
			var propInfo:PropInfo = new PropInfo(event.changedSlots as InventoryItemInfo);
			propInfo.Place = event.changedSlots.Place;
			removeProp(propInfo as PropInfo);
		}
		
		private function __updateProp(event:BagEvent):void
		{
			var changes:Dictionary = event.changedSlots;
			for each(var i:InventoryItemInfo in changes)
			{
				var c:InventoryItemInfo = _info.FightBag.getItemAt(i.Place);
				if(c)
				{
					var propInfo:PropInfo = new PropInfo(c);
					propInfo.Place = c.Place;
					addProp(propInfo);
				}else
				{
					var propInfo1:PropInfo = new PropInfo(i);
					propInfo1.Place = i.Place;
					removeProp(propInfo1);
				}
			}
		}
		
		override public function setClickEnabled(clickAble:Boolean,isGray:Boolean):void
		{
			super.setClickEnabled(clickAble,isGray);
		}
		
		override protected function __click(event:ItemEvent):void
		{
			if(event.item == null) return;
			if(self.LockState)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.game.prop.effect.seal"));
//				MessageTipManager.getInstance().show("被封印状态下不可使用道具");
			}
			else if(self.isLiving && !self.isAttacking)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.game.ArrowViewIII.fall"));
				return;
				//MessageTipManager.getInstance().show("轮到你行动时才可以使用");
			}
			else if(self.energy >= (Number(PropItemView(event.item).info.Template.Property4)))
			{
				var info:PropInfo = PropItemView(event.item).info;
				self.useItem(info.Template);
				GameInSocketOut.sendUseProp(2,info.Place,info.Template.TemplateID);
				_itemContainer.setItemClickAt(info.Place,false,true);
				_shortCut.setPropCloseVisible(info.Place,false);
			}
			else 
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.game.actions.SelfPlayerWalkAction"));
				//MessageTipManager.getInstance().show("体力不足");
			}
		}
		
		override protected function __over(event:ItemEvent):void
		{
			super.__over(event);
			_shortCut.setPropCloseVisible(event.index,true);
			
		}
		
		override protected function __out(event:ItemEvent):void
		{
			super.__out(event);
			_shortCut.setPropCloseVisible(event.index,false);
		}
		
		public function addProp(info:PropInfo):void
		{
			_shortCut.setPropCloseEnabled(info.Place,true);
			_itemContainer.appendItemAt(new PropItemView(info),info.Place);
		}
		
		public function removeProp(info:PropInfo):void
		{
			_shortCut.setPropCloseEnabled(info.Place,false);
			_shortCut.setPropCloseVisible(info.Place,false);
			_itemContainer.removeItemAt(info.Place);
			if(_cite.parent)
			{
				_cite.parent.removeChild(_cite);
			}
		}		
	}
}