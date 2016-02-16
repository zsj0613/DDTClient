package ddt.view.feedback
{
	import fl.controls.TextArea;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import game.crazyTank.view.feedback.feedbackReplyAsset;
	
	import road.ui.controls.hframe.HConfirmFrame;
	
	import ddt.data.feedback.FeedbackReplyInfo;
	import ddt.manager.FeedbackManager;
	
	public class FeedbackReplyView extends HConfirmFrame
	{
		private var _feedbackReplyAsset:feedbackReplyAsset;
		private var _feedbackContactView:FeedbackContactView;
		private var _feedbackReplyInfo:FeedbackReplyInfo;
		private var _questionContent:TextArea;//详细描述
		private var _replyContent:TextArea;//回复内容
		
		public function FeedbackReplyView(feedbackReplyInfo:FeedbackReplyInfo)
		{
			_feedbackReplyInfo=feedbackReplyInfo;
			initialize();
		}
		
		/**
		 * 初始化运行
		 */		
		protected function initialize():void
		{
			this.okFunction = endSubmit;
			this.cancelFunction=continueSubmit;
			this.closeCallBack=continueSubmit;
			
			this.titleText="弹弹堂意见反馈";
			this.okLabel="结贴";
			this.cancelLabel="继续提交"
			this.centerTitle = true;
			this.blackGound = false;
			this.alphaGound = false;
			this.moveEnable = false;
			this.fireEvent = false;
			this.showClose = false;
			this.buttonGape = 100;
			this.setContentSize(307,390);
			
			_feedbackReplyAsset=new feedbackReplyAsset();
			addChild(_feedbackReplyAsset);
			
			_feedbackReplyAsset.btnContact.buttonMode=true;
			
			setEvent();
			loadFeedbackReplyInfo();
		}
		
		/**
		 *取得回复内容 
		 */		
		private function loadFeedbackReplyInfo():void
		{
			if(_feedbackReplyInfo)
			{
				var textFormat:TextFormat = new TextFormat();
				textFormat.size=14;
				
				_feedbackReplyAsset.txtQuestionTitle.text=_feedbackReplyInfo.questionTitle;
				var arrDate:Array=_feedbackReplyInfo.occurrenceDate.split('-');
				_feedbackReplyAsset.lblOccurrenceDateYear.text=arrDate[0] ? arrDate[0].toString() : "";
				_feedbackReplyAsset.lblOccurrenceDateMonth.text=arrDate[1] ? arrDate[1].toString() : "";
				_feedbackReplyAsset.lblOccurrenceDateDay.text=arrDate[2] ? arrDate[2].toString() : "";
				
				_questionContent=new TextArea();
				if(_feedbackReplyAsset.txtQuestionContent.parent) _feedbackReplyAsset.txtQuestionContent.parent.removeChild(_feedbackReplyAsset.txtQuestionContent);
				_questionContent.x=_feedbackReplyAsset.txtQuestionContent.x;
				_questionContent.y=_feedbackReplyAsset.txtQuestionContent.y;
				_questionContent.width=_feedbackReplyAsset.txtQuestionContent.width;
				_questionContent.height=_feedbackReplyAsset.txtQuestionContent.height;
				_questionContent.setStyle("textFormat",textFormat);
				_questionContent.text=_feedbackReplyInfo.questionContent;
				_questionContent.editable=false;
				
				_feedbackReplyAsset.addChild(_questionContent);
				
				_replyContent=new TextArea();
				if(_feedbackReplyAsset.txtReplyContent.parent) _feedbackReplyAsset.txtReplyContent.parent.removeChild(_feedbackReplyAsset.txtReplyContent);
				_replyContent.x=_feedbackReplyAsset.txtReplyContent.x;
				_replyContent.y=_feedbackReplyAsset.txtReplyContent.y;
				_replyContent.width=_feedbackReplyAsset.txtReplyContent.width;
				_replyContent.height=_feedbackReplyAsset.txtReplyContent.height;
				_feedbackReplyAsset.addChild(_replyContent);
				_replyContent.setStyle("textFormat",textFormat);
				_replyContent.text=_feedbackReplyInfo.replyContent;
				_replyContent.editable=false;
				
				var bg:Shape = new Shape();
				bg.graphics.beginFill(0x000000,0);
				bg.graphics.drawRect(0,0,10,10);
				bg.graphics.endFill();
				_questionContent.setStyle("upSkin",bg);
				_replyContent.setStyle("upSkin",bg);
			}
		}
		
		private function setEvent():void
		{
			_feedbackReplyAsset.btnContact.addEventListener(MouseEvent.CLICK, openContactView);
		}
		
		/**
		 *结贴
		 */		
		private function endSubmit():void
		{
			FeedbackManager.Instance.openFeedbackAppraisalView(_feedbackReplyInfo);
			
			dispose();
			this.close();
		}
		
		/**
		 *继续提交
		 */
		private function continueSubmit():void
		{
			FeedbackManager.Instance.openFeedbackSubmitContinueView(_feedbackReplyInfo);
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
			
			if(_questionContent && _questionContent.parent) _questionContent.parent.removeChild(_questionContent);
			_questionContent=null;
			
			if(_replyContent && _replyContent.parent) _replyContent.parent.removeChild(_replyContent);
			_replyContent=null;
			
			if(_feedbackReplyAsset) _feedbackReplyAsset.btnContact.removeEventListener(MouseEvent.CLICK, openContactView);
			
			if(_feedbackContactView)
			{
				if(_feedbackContactView.parent) _feedbackContactView.parent.removeChild(_feedbackContactView);
				_feedbackContactView.dispose();
			}
			_feedbackContactView=null;
			
			if(_feedbackReplyAsset && _feedbackReplyAsset.parent) _feedbackReplyAsset.parent.removeChild(_feedbackReplyAsset);
			_feedbackReplyAsset=null;
		}
	}
}