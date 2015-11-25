package ddt.view.feedback
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import game.crazyTank.view.feedback.feedbackContactAsset;
	
	import road.ui.controls.hframe.HConfirmFrame;
	
	import ddt.data.PathInfo;
	import ddt.manager.PathManager;

	public class FeedbackContactView extends HConfirmFrame
	{
		private var _feedbackContactAsset:feedbackContactAsset;
		private var ueUrl:URLRequest;
		private var tel:String;
		private var url:String;
		
		public function FeedbackContactView()
		{
			initialize();
		}
		
		/**
		 * 初始化运行
		 */		
		protected function initialize():void
		{
			this.closeCallBack=cancelSubmit;
			
			this.titleText="弹弹堂意见反馈";
			this.centerTitle = true;
			this.blackGound = false;
			this.alphaGound = false;
			this.moveEnable = false;
			this.fireEvent = false;
			this.showBottom = false;
			this.showClose = true;
			this.showCancel=false;
			this.okBtn.visible=false;
			this.buttonGape = 100;
			this.setContentSize(340,130);
			
			_feedbackContactAsset=new feedbackContactAsset();
			addChild(_feedbackContactAsset);
			
			_feedbackContactAsset.boxService.buttonMode=true;
			_feedbackContactAsset.boxService.mouseChildren=false;
			tel=PathManager.solveFeedbackServiceTel();
			url=PathManager.solveFeedbackServiceUrl();
			_feedbackContactAsset.boxTel.lblTel.text=tel ? tel : "";
			_feedbackContactAsset.boxService.lblSite.text=url ? url : "";
			
			setEvent();
		}
		
		private function setEvent():void
		{
			_feedbackContactAsset.boxTel.addEventListener(MouseEvent.CLICK, onTelClick);
			_feedbackContactAsset.boxService.addEventListener(MouseEvent.CLICK, onUrlClick);
		}
		
		private function onTelClick(evt:MouseEvent):void
		{
			_feedbackContactAsset.boxTel.gotoAndStop(2);
			_feedbackContactAsset.boxService.gotoAndStop(1);
		}
		
		private function onUrlClick(evt:MouseEvent):void
		{
			_feedbackContactAsset.boxService.gotoAndStop(2);
			_feedbackContactAsset.boxTel.gotoAndStop(1);
			
			ueUrl=new URLRequest(url);
			navigateToURL(ueUrl, "_blank");
		}
		
		private function cancelSubmit():void
		{
			dispose();
			this.close();
		}	
		
		override public function show():void
		{
			super.show();
			blackGound = true;
		}
		
		override protected function __closeClick(e:MouseEvent):void
		{
			if(this.cancelFunction != null) this.cancelFunction();
			dispose();
			super.__closeClick(e);
		}
		
		override protected function __addToStage(e:Event):void
		{
			super.__addToStage(e);
		}
		
		override public function dispose():void
		{
			ueUrl=null;
			
			if(_feedbackContactAsset && _feedbackContactAsset.parent) _feedbackContactAsset.parent.removeChild(_feedbackContactAsset);
			_feedbackContactAsset=null;
		}
	}
}