package ddt.view.feedback
{
	import fl.controls.TextArea;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import game.crazyTank.view.feedback.feedbackAppraisalAsset;
	import game.crazyTank.view.feedback.feedbackSubmitContinueViewAsset;
	
	import road.ui.controls.hframe.HConfirmFrame;
	import road.utils.StringHelper;
	
	import ddt.data.feedback.FeedbackReplyInfo;
	import ddt.manager.FeedbackManager;
	import ddt.manager.MessageTipManager;
	import ddt.request.feedback.LoadFeedbackSubmitContinue;
	
	public class FeedbackSubmitContinueView extends HConfirmFrame
	{
		private var _feedbackSubmitContinueViewAsset:feedbackSubmitContinueViewAsset;
		private var _feedbackReplyInfo:FeedbackReplyInfo;
		private var _feedbackContactView:FeedbackContactView;
		private var _loadFeedbackSubmitContinue:LoadFeedbackSubmitContinue;
		private var _txtQuestionContent:TextArea;
		
		public function FeedbackSubmitContinueView(feedbackReplyInfo:FeedbackReplyInfo)
		{
			_feedbackReplyInfo=feedbackReplyInfo;
			initialize();
		}
		
		/**
		 * 初始化运行
		 */		
		protected function initialize():void
		{
			this.okFunction = confirmSubmit;
			this.cancelFunction=cancelSubmit;
			this.closeCallBack=cancelSubmit;
			
			this.titleText="弹弹堂意见反馈";
			this.okLabel="提交";
			this.cancelLabel="关闭";
			this.centerTitle = true;
			this.blackGound = false;
			this.alphaGound = false;
			this.moveEnable = false;
			this.fireEvent = false;
			this.showClose = true;
			this.buttonGape = 100;
			this.stopKeyEvent=true;
			this.setContentSize(307,390);
			
			_feedbackSubmitContinueViewAsset=new feedbackSubmitContinueViewAsset();
			addChild(_feedbackSubmitContinueViewAsset);
			
			_feedbackSubmitContinueViewAsset.btnContact.buttonMode=true;
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.size=14;
			_txtQuestionContent=new TextArea();
			if(_feedbackSubmitContinueViewAsset.txtQuestionContent.parent) _feedbackSubmitContinueViewAsset.txtQuestionContent.parent.removeChild(_feedbackSubmitContinueViewAsset.txtQuestionContent);
			_txtQuestionContent.x=_feedbackSubmitContinueViewAsset.txtQuestionContent.x;
			_txtQuestionContent.y=_feedbackSubmitContinueViewAsset.txtQuestionContent.y;
			_txtQuestionContent.width=_feedbackSubmitContinueViewAsset.txtQuestionContent.width;
			_txtQuestionContent.height=_feedbackSubmitContinueViewAsset.txtQuestionContent.height;
			_feedbackSubmitContinueViewAsset.addChild(_txtQuestionContent);
			_txtQuestionContent.setStyle("textFormat",textFormat);
			
			var bg:Shape = new Shape();
			bg.graphics.beginFill(0x000000,0);
			bg.graphics.drawRect(0,0,10,10);
			bg.graphics.endFill();
			_txtQuestionContent.setStyle("upSkin",bg);
			
			setEvent();
			
			//取得问题标题
			_feedbackSubmitContinueViewAsset.lblQuestionTitle.text=_feedbackReplyInfo.questionTitle;
		}
		
		private function setEvent():void
		{
			_feedbackSubmitContinueViewAsset.btnContact.addEventListener(MouseEvent.CLICK, openContactView);
		}
		
		/**
		 *提交
		 */		
		private function confirmSubmit():void
		{
			if(StringHelper.IsNullOrEmpty(_txtQuestionContent.text))
			{
				MessageTipManager.getInstance().show("请填写完整必填项。");
				return;
			}
			
			_loadFeedbackSubmitContinue = new LoadFeedbackSubmitContinue(_feedbackReplyInfo.questionId, _feedbackReplyInfo.replyId, _txtQuestionContent.text, confirmSubmitCallBack);
			_loadFeedbackSubmitContinue.loadSync();
		}
		
		/**
		 *提交结果返回 
		 * @param result 返回结果：1=成功,0=失败
		 */	
		private function confirmSubmitCallBack(result:int):void
		{
			if(result==1)
			{
				MessageTipManager.getInstance().show("您的问题已提交，感谢您的支持！");
				
				//提交成功以后，从回复列表中去除当前 的回复
				FeedbackManager.Instance.feedbackReplyData.remove(_feedbackReplyInfo.questionId + "_" + _feedbackReplyInfo.replyId);
				
				dispose();
				this.close();
			}
			else if(result==-1)
			{//每天提交超上限
				MessageTipManager.getInstance().show("今日提交次数已达上限。");
			}
			else
			{
				MessageTipManager.getInstance().show("系统繁忙，请稍后再试。");
			}
		}
		
		/**
		 *关闭
		 */
		private function cancelSubmit():void
		{
			dispose();
			this.close();
		}
		
		/**
		 *打开联系方式 
		 */		
		private function openContactView(event:MouseEvent):void
		{
			if(_feedbackContactView)
			{
				if(_feedbackContactView.parent) _feedbackContactView.parent.removeChild(_feedbackContactView);
				_feedbackContactView=null;
			}
			else
			{
				_feedbackContactView=new FeedbackContactView();
				_feedbackContactView.show();
			}
		}
		
		override protected function __onKeyDownd(e:KeyboardEvent):void
		{
			if(stopKeyEvent)
			{
				e.stopImmediatePropagation();
			}
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
			_feedbackReplyInfo=null;
			
			if(_feedbackSubmitContinueViewAsset) _feedbackSubmitContinueViewAsset.btnContact.removeEventListener(MouseEvent.CLICK, openContactView);
			
			if(_txtQuestionContent && _txtQuestionContent.parent) _txtQuestionContent.parent.removeChild(_txtQuestionContent);
			_txtQuestionContent=null;
			
			if(_feedbackSubmitContinueViewAsset && _feedbackSubmitContinueViewAsset.parent) _feedbackSubmitContinueViewAsset.parent.removeChild(_feedbackSubmitContinueViewAsset);
			_feedbackSubmitContinueViewAsset=null;
			
			if(_feedbackContactView)
			{
				if(_feedbackContactView.parent) _feedbackContactView.parent.removeChild(_feedbackContactView);
				_feedbackContactView.dispose();
			}
			_feedbackContactView=null;
		}
	}
}