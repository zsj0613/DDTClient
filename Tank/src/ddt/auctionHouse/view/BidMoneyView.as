package ddt.auctionHouse.view
{
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import game.crazyTank.view.AuctionHouse.BidMoneyAsset;
	
	import road.utils.ComponentHelper;
	
	import ddt.manager.PlayerManager;
	import road.manager.SoundManager;
	/**
	 * 竞标的文本框控制 
	 * @author SYC
	 * 
	 */
	internal class BidMoneyView extends BidMoneyAsset
	{
		private var _money:TextField;
		private var _gold:TextField;
		
		private var _canMoney:Boolean;
		internal function get canMoney():Boolean
		{
			return _canMoney;
		}
		
		private var _canGold:Boolean;
		internal function get canGold():Boolean
		{
			return _canGold;
		}
	
		public function BidMoneyView()
		{
			initView();
			addEvent();
		}
		
		private function initView():void
		{
			var format:TextFormat = new TextFormat();
			format.bold = true;
			_money = new TextField();
			_money.type = TextFieldType.INPUT;
			_money.autoSize = TextFieldAutoSize.RIGHT;
			_money.restrict = "0-9";
			ComponentHelper.replaceChild(this,moneyPos_mc,_money);
			_money.defaultTextFormat = format;
		}
		
		private function addEvent():void
		{
			_money.addEventListener(Event.CHANGE,__change);
			_money.addEventListener(TextEvent.TEXT_INPUT,__inputTextM);
		}
		
		private function removeEvent():void
		{
			_money.removeEventListener(Event.CHANGE,__change);
			_money.removeEventListener(TextEvent.TEXT_INPUT,__inputTextM);
		}
		
		internal function canMoneyBid(price:int):void
		{
			_money.mouseEnabled = true;
			_canMoney = true;
			_canGold = false;
			_money.text = price.toString();
		}
		
		internal function canGoldBid(price:int):void
		{
			_money.text = "";
			if(_money.stage)_money.stage.focus = null;
			_money.mouseEnabled = false;
			_canGold = true;
			_canMoney = false;
		}
		
		internal function cannotBid():void
		{
			_money.mouseEnabled = false;
			_money.text = "";
			if(_money.stage)_money.stage.focus = null;
			_canGold = false;
			_canMoney = false;
		}
		
		internal function dispose():void
		{
			removeEvent();
			if(parent)parent.removeChild(this);
			if(_money.parent)removeChild(_money);
			_money = null;
		}
		
		internal function getData():Number
		{
			var result:Number;
			if(_canGold)
			{
			}
			else if(_canMoney)
			{
				result = Number(_money.text);
			}
			return result;
		}
		
		private function __change(event:Event):void
		{
//			SoundManager.instance.play("043");
		}
		
		private function __inputTextM(event:TextEvent):void
		{
			if(Number(_money.text) + Number(event.text) > PlayerManager.Instance.Self.Money || Number(_money.text) + Number(event.text) == 0)
			{
				event.preventDefault();
			}
		}
	}
}