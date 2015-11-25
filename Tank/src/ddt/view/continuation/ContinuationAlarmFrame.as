package ddt.view.continuation
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import game.crazy.Tank.view.bagII.ContinuationAlarmAsset;
	
	import org.aswing.KeyboardManager;
	
	import road.ui.controls.hframe.HConfirmFrame;
	import road.ui.manager.UIManager;
	
	import ddt.data.goods.InventoryItemInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	
	public class ContinuationAlarmFrame extends HConfirmFrame
	{
		private var _bg:ContinuationAlarmAsset;
		public function ContinuationAlarmFrame()
		{
			this.showBottom = false;
			this.autoDispose = true;
			this.okBtn.x = 30;
			this.okLabel = LanguageMgr.GetTranslation("ddt.view.common.AddPricePanel.xu");
			this.setContentSize(365,167);
			this.buttonGape=80;
			this.moveEnable=false;
			
			this.okFunction =__onContinuationBtnClick ;
			this.cancelFunction=__confirm;
			this.closeCallBack=__confirm;
			
			init();
			
			initEvent();
		}

		override protected function __closeClick(e:MouseEvent):void
		{
			if(this.cancelFunction != null) this.cancelFunction();
			super.__closeClick(e);
		}
		
		private function init():void
		{
			_bg = new ContinuationAlarmAsset();
			addContent(_bg,true);
		}
		private function __onContinuationBtnClick():void
		{
			var frame:ContinuationFrame = new ContinuationFrame();
			var arr:Array=new Array;
			frame.setList(arr=PlayerManager.Instance.Self.OvertimeListByBody);
			frame.show();
			super.close();
		}
		private function initEvent():void
		{
			KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN, __keydownHandler);
		}
		
		private function __keydownHandler(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.ESCAPE)
				__confirm();
		}
		
		private function __confirm():void
		{
			InventoryItemInfo.startTimer();
			super.close();
		}
		override public function dispose():void
		{
			KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN, __keydownHandler);
			super.dispose();
		}
	}
}