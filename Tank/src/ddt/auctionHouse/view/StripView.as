package ddt.auctionHouse.view
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import game.crazyTank.view.AuctionHouse.StripIocnAsset;
	
	import road.ui.manager.TipManager;
	
	import ddt.auctionHouse.AuctionState;
	import ddt.auctionHouse.event.AuctionHouseEvent;
	import ddt.manager.LanguageMgr;

	[Event(name = "selectStrip",type = "ddt.auctionHouse.event.AuctionHouseEvent")]
	internal class StripView extends BaseStripView
	{
		private var _seller:TextField;
		
		private var _curPrice:StripCurPriceView;
		
		private var _vie:Sprite;
		
		private var _lef:Sprite;//挡时间
		
		public function StripView()
		{
			super();
		}
		
		override protected function initView():void
		{
			super.initView();
			_name.x = 63;
			_name.width = 160;
			
			_count.x = 230;
			_count.width = 65;
			
			_leftTime.x = 309;
			_leftTime.width = 85;
			
			_lef = drawRect(_leftTime.width,_leftTime.height);
			_lef.x = _leftTime.x-2;
			_lef.y = _leftTime.y-2;
			_lef.alpha = 0;
			addChild(_lef);	
			
			_seller = createText(393);
			_seller.width = 112;
			addChild(_seller);	
			
			_vie = new StripIocnAsset();
			_vie.x = 290 - 1.5*_vie.width;
			_vie.y = _vie.height-4;
			_vie.visible = false;
			addChildAt(_vie,this.getChildIndex(_leftTime)+1);	
			
			_curPrice = new StripCurPriceView();
			_curPrice.x = 495;
//			_curPrice.x = 485;
			_curPrice.y = 9;
			addChild(_curPrice);	
			this.buttonMode = true;
			addEvent();
		}
		private function addEvent():void
		{
			//_leftTime.mouseEnabled = true;
			//_leftTime.selectable  = false;
			_lef.addEventListener(MouseEvent.MOUSE_OVER,__overHandler);
			_lef.addEventListener(MouseEvent.MOUSE_OUT,__outHandler);
			_vie.addEventListener(MouseEvent.MOUSE_OVER,__overHandler);
			_vie.addEventListener(MouseEvent.MOUSE_OUT,__outHandler);
		}
		private function drawRect(w:Number,h:Number):Sprite
		{
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(0xFFFFFF);
			sprite.graphics.drawRect(0,0,w,h);
			sprite.graphics.endFill();
			return sprite;
		}
		private function __overHandler(evt:MouseEvent):void
		{
			var msg:String = "";
			if(evt.target == _lef)
			{
				msg = _info.getSithTimeDescription();
				
			}else if(evt.target == _vie)
			{
				if(_info.BuyerName!="")
				{
					msg = LanguageMgr.GetTranslation("ddt.auctionHouse.view.auctioned");
				}
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
		override protected function updateInfo():void
		{
			super.updateInfo();
			////增加竞标字段
			if(AuctionState.CURRENTSTATE == AuctionState.SELL)
			{
				if(_info.BuyerName=="")
				{
					_seller.text = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
				}else
				{
					_seller.text = _info.BuyerName;
				}
			}
			else
			{
				_seller.text = _info.AuctioneerName;
				_vie.visible = (_info.BuyerName!="");
			}
			
			_lef.width  = _leftTime.width;
			_lef.height = _leftTime.height;
			
			_curPrice.info = _info;
			this.addChild(_curPrice);
			this.mouseEnabled = true;
		}
		
		override internal function clearSelectStrip():void
		{
			super.clearSelectStrip();
			_seller.text = "";
			if(_curPrice && _curPrice.parent)_curPrice.parent.removeChild(_curPrice);
			if(_vie && _vie.parent)_vie.parent.removeChild(_vie);
			this.mouseEnabled = false;
		}
	
		
		override internal function dispose():void
		{
			if(_lef!=null)
			{
				_lef.removeEventListener(MouseEvent.MOUSE_OVER,__overHandler);
				_lef.removeEventListener(MouseEvent.MOUSE_OUT,__outHandler);
				if(_lef.parent)_lef.parent.removeChild(_lef);
			}
			if(_vie!=null)
			{
				_vie.removeEventListener(MouseEvent.MOUSE_OVER,__overHandler);
				_vie.removeEventListener(MouseEvent.MOUSE_OUT,__outHandler);
				if(_vie.parent)_vie.parent.removeChild(_vie);
			}
			super.dispose();
			
			if(_curPrice)_curPrice.dispose();
			_curPrice = null;
		}
		
	}
}