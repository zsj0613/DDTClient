package ddt.auctionHouse.view
{
	
	/**
	 * 拍卖右部分strip条 
	 * @author SYC
	 * 
	 */	
	 
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import road.ui.manager.TipManager;
	 
	internal class AuctionBuyStripView extends BaseStripView
	{
		private var _curPrice:StripCurBuyPriceView;
		
		public function AuctionBuyStripView()
		{
			super();
		}
		
		override protected function initView():void
		{
			super.initView();
			back_mc.width = 832;
			stripSelect_mc.width = 888;
			_name.x = 61;
			_count.x = 302;
			_leftTime.x = 380;
			
			
			_curPrice = new StripCurBuyPriceView(1);
			_curPrice.x = 415;
			_curPrice.y = 12;
			addChild(_curPrice);	
			
			addEvent();	
			
		}
		private function addEvent():void
		{
			_leftTime.mouseEnabled = true;
			_leftTime.selectable  = false;
			_leftTime.addEventListener(MouseEvent.MOUSE_OVER,__overHandler);
			_leftTime.addEventListener(MouseEvent.MOUSE_OUT,__outHandler);
		}
		private function __overHandler(evt:MouseEvent):void
		{
			var msg:String = "";
			if(evt.target == _leftTime)
			{
				msg = _info.getSithTimeDescription();
				
			}
			if(msg!="")TipManager.setCurrentTarget(DisplayObject(evt.target),createTipRender(msg),0,0);
		}
		private function __outHandler(evt:MouseEvent):void
		{

			TipManager.setCurrentTarget(null,null);
		}
		private function createTipRender(msg:String):Sprite
		{
			var noBuffTip:StripTip = new StripTip(msg);
			return noBuffTip;
		}
		override internal function clearSelectStrip():void
		{
			super.clearSelectStrip();
			this.removeChild(_curPrice);
		}
		
		override protected function updateInfo():void
		{
			super.updateInfo();
			_curPrice.info = _info;
		}
		
		override internal function dispose():void
		{
			if(_leftTime!=null)
			{
				_leftTime.removeEventListener(MouseEvent.MOUSE_OVER,__overHandler);
				_leftTime.removeEventListener(MouseEvent.MOUSE_OUT,__outHandler);
			}
			super.dispose();
			if(_curPrice)_curPrice.dispose();
			_curPrice = null;
		}
		
	}
}