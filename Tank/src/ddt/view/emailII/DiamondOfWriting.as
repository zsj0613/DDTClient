package ddt.view.emailII
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.GoodsTipBgAsset;
	import game.crazyTank.view.emailII.EmailInfoAsset;
	
	import road.manager.SoundManager;
	import road.utils.ComponentHelper;
	
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.utils.Helpers;
	
	/**
	 * 可写附件
	 * @author SYC
	 * 
	 */	
	[Event(name = "showBagframe",type = "ddt.view.emailII.EmailIIEvent")]
	[Event(name = "hideBagframe",type = "ddt.view.emailII.EmailIIEvent")]
	[Event(name = "draginAnniex",type = "ddt.view.emailII.EmailIIEvent")]
	[Event(name = "dragoutAnniex",type = "ddt.view.emailII.EmailIIEvent")]
	public class DiamondOfWriting extends DiamondBase
	{
		private var _cellGoodsID:int;
		private var _annex:ItemTemplateInfo;
		
		private var _annexTip:EmailInfoAsset;
		
		internal function get annex():ItemTemplateInfo
		{
			return _annex;
		}
		
		internal function set annex(value:ItemTemplateInfo):void
		{
			_annex = value;
//			update();	
		}
		
		public function DiamondOfWriting(index:int)
		{
			super(index);
		}
		
		override protected function initView():void
		{
			super.initView();
			mouseEnabled = true;
			mouseChildren = true;
			
			_cell.visible = true;
			_cell.allowDrag = true;
			
			_annexTip = new EmailInfoAsset();
			Helpers.hidePosMc(_annexTip);
			ComponentHelper.replaceChild(_annexTip,_annexTip.bg_pos,new GoodsTipBgAsset());
			_annexTip.visible = false;
			_annexTip.x = 28;
			_annexTip.y = -15;
			addChild(_annexTip);
		}
		
		override protected function update():void
		{
			if(_annex == null)
			{
				click_mc.gotoAndStop(1);
				click_mc.visible = true;
			}
			_cell.info = _annex;
		}
		
		override protected function addEvent():void
		{
			_cell.addEventListener(Event.CHANGE,__dragInBag);
			
			addEventListener(MouseEvent.CLICK,__click);
			addEventListener(MouseEvent.MOUSE_MOVE,overHandle);
			addEventListener(MouseEvent.MOUSE_OUT,outHandle);
		}
		
		override protected function removeEvent():void
		{
			_cell.removeEventListener(Event.CHANGE,__dragInBag);
			
			removeEventListener(MouseEvent.CLICK,__click);
			removeEventListener(MouseEvent.MOUSE_MOVE,overHandle);
			removeEventListener(MouseEvent.MOUSE_OUT,outHandle);
		}
		
		private function overHandle(e:MouseEvent):void
		{
			_annexTip.visible = true; 
		}
		private function outHandle(e:MouseEvent):void
		{
			_annexTip.visible = false; 
		}
		
		public function setBagUnlock():void
		{
			_cell.clearLinkCell();
		}
		
		private function __click(event:MouseEvent):void
		{
			SoundManager.instance.play("008");
			dispatchEvent(new EmailIIEvent(EmailIIEvent.SHOW_BAGFRAME));
			if(_annex)
			{
				_cell.dragStart();
			}
		}	
		
		private function __dragInBag(event:Event):void
		{
//			if(_cell && _cell.info && annex && (_cell.info.TemplateID!=_cellGoodsID && _cellGoodsID>0))
//			{//当前物品被更新时，如果更新过来的物品不是当前原物品，则把当前物品取下放回背包（用与背包整理时，其物品位置发生变化时，对当前物品的更新操作）
//				_cell.clearLinkCell();
//				annex=null;
//				dispatchEvent(new EmailIIEvent(EmailIIEvent.DRAGOUT_ANNIEX));
//				return;
//			}
			
			annex = _cell.info;
			if(annex)
			{
//				_cellGoodsID=annex.TemplateID;
				dispatchEvent(new EmailIIEvent(EmailIIEvent.DRAGIN_ANNIEX));
			}
			else
			{
				dispatchEvent(new EmailIIEvent(EmailIIEvent.DRAGOUT_ANNIEX));
			}
		}

		override public function dispose():void
		{
			super.dispose();
			_annex = null;
		}
	}
}