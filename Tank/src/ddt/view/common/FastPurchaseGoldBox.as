package ddt.view.common
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.manager.TipManager;
	
	import ddt.events.ShortcutBuyEvent;
	import ddt.manager.LanguageMgr;
	import ddt.view.bagII.bagStore.BagStore;
	
	public class FastPurchaseGoldBox extends HConfirmDialog
	{
		private var _msg:String;
		private var _itemId:int;
		private var _title :String;
		private var _quick:QuickBuyFrame;
		public function FastPurchaseGoldBox(title:String, msg:String , itemId:int)
		{
			_title = title
			_msg = msg;
			super(_title,_msg);
			_itemId = itemId;
			init();
		}
		
		private function init():void
		{
			this.cancelFunction = _cancelback;
			this.okFunction     = _callback;
		}
		
		private function _callback():void
		{
			_quick = new QuickBuyFrame(LanguageMgr.GetTranslation("ddt.view.store.matte.goldQuickBuy"),"");
		    _quick.itemID = _itemId;
			_quick.x = 350;
			_quick.y = 200;
//			_quick.storeTab = _storeTab;
			_quick.addEventListener(ShortcutBuyEvent.SHORTCUT_BUY,__shortCutBuyHandler);
			_quick.addEventListener(Event.REMOVED_FROM_STAGE,removeFromStageHandler);
			TipManager.AddTippanel(_quick,false);
			this.dispose();
		}
		
		override protected function __closeClick(e:MouseEvent):void
		{
			if(cancelFunction != null) cancelFunction();
			super.__closeClick(e);
		}
		
		override public function show():void
		{
			alphaGound = false;
			TipManager.AddTippanel(this,true);
			alphaGound = true;
		}
		
		private function removeFromStageHandler(event:Event):void{
			BagStore.Instance.reduceTipPanelNumber();
		}
		
		private function __shortCutBuyHandler(evt:ShortcutBuyEvent):void
		{
			evt.stopImmediatePropagation();
			dispatchEvent(new ShortcutBuyEvent(evt.ItemID,evt.ItemNum));
		}
		
		private function _cancelback():void
		{
			this.dispose();
		}
		
	    override public function dispose():void
		{
			super.dispose();
		}

	}
}