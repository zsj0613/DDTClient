package ddt.game
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import road.ui.manager.TipManager;
	
	import ddt.data.game.LocalPlayer;
	import ddt.data.goods.PropInfo;
	import ddt.events.LivingEvent;
	import ddt.view.common.RoomIIPropTip;
	import ddt.view.items.ItemContainer;
	import ddt.view.items.ItemEvent;
	import ddt.view.items.PropItemView;

	public class BaseGamePropBarView extends Sprite
	{
				
		protected var _cite:RoomIIPropTip;
		
		protected var _notExistTip:Sprite;
		
		protected var _itemContainer:ItemContainer;
		
		private var _self:LocalPlayer;
		
		public function get self():LocalPlayer
		{
			return _self;
		}
		
		public function BaseGamePropBarView(self:LocalPlayer,count:Number,column:Number,bgvisible:Boolean,ordinal:Boolean,clickable:Boolean)
		{
			_self = self;
			
			_itemContainer = new ItemContainer(count,column,bgvisible,ordinal,clickable);
			_itemContainer.addEventListener(ItemEvent.ITEM_CLICK,__click);
			_itemContainer.addEventListener(ItemEvent.ITEM_MOVE,__move);
			_itemContainer.addEventListener(ItemEvent.ITEM_OUT,__out);
			_itemContainer.addEventListener(ItemEvent.ITEM_OVER,__over);
			addChild(_itemContainer);
			_cite = new RoomIIPropTip(false,true,true);
			createTip();
				
			_self.addEventListener(LivingEvent.ENERGY_CHANGED,__energyChange);
			_self.addEventListener(LivingEvent.DIE,__die);
			_self.addEventListener(LivingEvent.ATTACKING_CHANGED,__changeAttack);
		}		
		
		public function setClickEnabled(clickAble:Boolean,isGray:Boolean):void
		{
			_itemContainer.setState(clickAble,isGray);
		}
		
		public function dispose():void
		{
			_self.removeEventListener(LivingEvent.DIE,__die);
			_self.removeEventListener(LivingEvent.ENERGY_CHANGED,__energyChange);
			_self.removeEventListener(LivingEvent.ATTACKING_CHANGED,__changeAttack);
			removeChild(_itemContainer);
			_itemContainer.removeEventListener(ItemEvent.ITEM_CLICK,__click);
			_itemContainer.removeEventListener(ItemEvent.ITEM_MOVE,__move);
			_itemContainer.removeEventListener(ItemEvent.ITEM_OUT,__out);
			_itemContainer.removeEventListener(ItemEvent.ITEM_OVER,__over);
			_itemContainer.dispose();
			_itemContainer = null;
			if(_cite.parent)
			{
				parent.removeChild(_cite);
			}
			_cite = null;
			if(parent)
			{
				parent.removeChild(this);
				_itemContainer = null;
			}
		}
		
		private function createTip():void
		{
			_notExistTip = new Sprite();
			_notExistTip.graphics.beginFill(0x000000,.7);
			_notExistTip.graphics.drawRoundRect(0,0,100,60,10,10);
			_notExistTip.graphics.endFill();
			var text:TextField = new TextField();
//			text.text = "点击此处可以快捷购买无限道具卡";
			text.width = 90;
			text.multiline = true;
			text.wordWrap = true;
			text.textColor = 0xffffff;
			text.x = 5;
			text.y = 3;
			_notExistTip.addChild(text);
		}
		
		private function __changeAttack(event:LivingEvent):void
		{
			if(_self.isAttacking && _self.isLiving && !_self.LockState)
			{
				setClickEnabled(false,false);
			}
		}
		
		private function __die(event:LivingEvent):void
		{
			setClickEnabled(false,false);
		}
		
		protected function __energyChange(event:LivingEvent):void
		{
			if(_self.isLiving&&!_self.LockState)
			{
				_itemContainer.setClickByEnergy(_self.energy);
			}else if(_self.isLiving && _self.LockState)
			{
				setClickEnabled(false,true);
			}
		}
		
		protected function __move(event:ItemEvent):void
		{

		}
		
		protected function __over(event:ItemEvent):void
		{
			var item:PropInfo = PropItemView(event.item).info;
			_cite.update(item.Template,item.Count);
			if(PropItemView(event.item).isExist)
			{
				TipManager.setCurrentTarget(event.item as DisplayObject,_cite);
			}else
			{
//				TipManager.setCurrentTarget(event.item as DisplayObject,_notExistTip);
			}
		}
		
		protected function __out(event:ItemEvent):void
		{
			TipManager.setCurrentTarget(null,null);
		}
		
		protected function __click(event:ItemEvent):void
		{
			
		}	
		
	}
}