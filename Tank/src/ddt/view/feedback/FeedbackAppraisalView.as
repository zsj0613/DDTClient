package ddt.view.feedback
{
	import fl.controls.TextArea;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import game.crazyTank.view.feedback.feedbackAppraisalAsset;
	
	import road.ui.controls.HButton.ToggleButtonGroup;
	import road.ui.controls.HButton.TogleButton;
	import road.ui.controls.HButton.togleButtonAsset;
	import road.ui.controls.hframe.HConfirmFrame;
	
	import ddt.data.feedback.FeedbackReplyInfo;
	import ddt.manager.FeedbackManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.request.feedback.LoadFeedbackAppraisal;
	
	public class FeedbackAppraisalView extends HConfirmFrame
	{
		private var _feedbackReplyInfo:FeedbackReplyInfo;
		private var _feedbackAppraisalAsset:feedbackAppraisalAsset;
		private var _feedbackContactView:FeedbackContactView;
		private var _txtAppraisalContent:TextArea;//评价内容
		private var _loadFeedbackAppraisal:LoadFeedbackAppraisal;
		private var _tbgAppraisalGrade:ToggleButtonGroup;//咨询活动相关，活动是否异常单选组
		private var _rbtnAppraisalGrade1:TogleButton;//差
		private var _rbtnAppraisalGrade2:TogleButton;//一般
		private var _rbtnAppraisalGrade3:TogleButton;//满意
		private var _rbtnAppraisalGrade4:TogleButton;//非常满意
		
		public function FeedbackAppraisalView(feedbackReplyInfo:FeedbackReplyInfo)
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
			
			this.titleText="弹弹堂意见反馈";
			this.okLabel="提交评价";
			this.centerTitle = true;
			this.blackGound = false;
			this.alphaGound = false;
			this.moveEnable = false;
			this.fireEvent = false;
			this.showClose = false;
			this.showCancel=false;
			this.buttonGape = 100;
			this.setContentSize(307,390);
			this.stopKeyEvent=true;
			
			_feedbackAppraisalAsset=new feedbackAppraisalAsset();
			addChild(_feedbackAppraisalAsset);
			
			_feedbackAppraisalAsset.btnContact.buttonMode=true;

			var textFormat:TextFormat = new TextFormat();
			textFormat.size=14;
			_txtAppraisalContent=new TextArea();
			if(_feedbackAppraisalAsset.txtAppraisalContent.parent) _feedbackAppraisalAsset.txtAppraisalContent.parent.removeChild(_feedbackAppraisalAsset.txtAppraisalContent);
			_txtAppraisalContent.x=_feedbackAppraisalAsset.txtAppraisalContent.x;
			_txtAppraisalContent.y=_feedbackAppraisalAsset.txtAppraisalContent.y;
			_txtAppraisalContent.width=_feedbackAppraisalAsset.txtAppraisalContent.width;
			_txtAppraisalContent.height=_feedbackAppraisalAsset.txtAppraisalContent.height;
			_feedbackAppraisalAsset.addChild(_txtAppraisalContent);
			_txtAppraisalContent.setStyle("textFormat",textFormat);
			
			var bg:Shape = new Shape();
			bg.graphics.beginFill(0x000000,0);
			bg.graphics.drawRect(0,0,10,10);
			bg.graphics.endFill();
			_txtAppraisalContent.setStyle("upSkin",bg);
			
			setAppraisalGradeTogle();
			
			setEvent();
		}
		
		private function setEvent():void
		{
			_feedbackAppraisalAsset.btnContact.addEventListener(MouseEvent.CLICK, openContactView);
		}
		
		/**
		 *设置单选按钮 
		 */		
		private function setAppraisalGradeTogle():void
		{
			_tbgAppraisalGrade=new ToggleButtonGroup();
			
			if(_feedbackAppraisalAsset.posAppraisalGrade1.parent) _feedbackAppraisalAsset.posAppraisalGrade1.parent.removeChild(_feedbackAppraisalAsset.posAppraisalGrade1);
			if(_feedbackAppraisalAsset.posAppraisalGrade2.parent) _feedbackAppraisalAsset.posAppraisalGrade2.parent.removeChild(_feedbackAppraisalAsset.posAppraisalGrade2);
			if(_feedbackAppraisalAsset.posAppraisalGrade3.parent) _feedbackAppraisalAsset.posAppraisalGrade3.parent.removeChild(_feedbackAppraisalAsset.posAppraisalGrade3);
			if(_feedbackAppraisalAsset.posAppraisalGrade4.parent) _feedbackAppraisalAsset.posAppraisalGrade4.parent.removeChild(_feedbackAppraisalAsset.posAppraisalGrade4);
			
			var textFormat:TextFormat = new TextFormat(LanguageMgr.GetTranslation("heiti"),16,0x000000,true);
			
			_rbtnAppraisalGrade1 = new TogleButton(new togleButtonAsset(),"差");
			_rbtnAppraisalGrade1.textGape = 4;
			_rbtnAppraisalGrade1.textFilters=null;
			_rbtnAppraisalGrade1.textFormat=_rbtnAppraisalGrade1.unableTextFormat=_rbtnAppraisalGrade1.enableTextFormat = textFormat;
			_rbtnAppraisalGrade1.x=_feedbackAppraisalAsset.posAppraisalGrade1.x;
			_rbtnAppraisalGrade1.y=_feedbackAppraisalAsset.posAppraisalGrade1.y;
			_feedbackAppraisalAsset.addChild(_rbtnAppraisalGrade1);
			_tbgAppraisalGrade.addItem(_rbtnAppraisalGrade1);
			
			_rbtnAppraisalGrade2 = new TogleButton(new togleButtonAsset(),"一般");
			_rbtnAppraisalGrade2.textGape = 4;
			_rbtnAppraisalGrade2.textFilters=null;
			_rbtnAppraisalGrade2.textFormat=_rbtnAppraisalGrade2.unableTextFormat=_rbtnAppraisalGrade2.enableTextFormat = textFormat;
			_rbtnAppraisalGrade2.x=_feedbackAppraisalAsset.posAppraisalGrade2.x;
			_rbtnAppraisalGrade2.y=_feedbackAppraisalAsset.posAppraisalGrade2.y;
			_feedbackAppraisalAsset.addChild(_rbtnAppraisalGrade2);
			_tbgAppraisalGrade.addItem(_rbtnAppraisalGrade2);
			
			_rbtnAppraisalGrade3 = new TogleButton(new togleButtonAsset(),"满意");
			_rbtnAppraisalGrade3.textGape = 4;
			_rbtnAppraisalGrade3.textFilters=null;
			_rbtnAppraisalGrade3.textFormat=_rbtnAppraisalGrade3.unableTextFormat=_rbtnAppraisalGrade3.enableTextFormat = textFormat;
			_rbtnAppraisalGrade3.x=_feedbackAppraisalAsset.posAppraisalGrade3.x;
			_rbtnAppraisalGrade3.y=_feedbackAppraisalAsset.posAppraisalGrade3.y;
			_feedbackAppraisalAsset.addChild(_rbtnAppraisalGrade3);
			_tbgAppraisalGrade.addItem(_rbtnAppraisalGrade3);
			
			_rbtnAppraisalGrade4 = new TogleButton(new togleButtonAsset(),"非常满意");
			_rbtnAppraisalGrade4.textGape = 4;
			_rbtnAppraisalGrade4.textFilters=null;
			_rbtnAppraisalGrade4.textFormat=_rbtnAppraisalGrade4.unableTextFormat=_rbtnAppraisalGrade4.enableTextFormat = textFormat;
			_rbtnAppraisalGrade4.x=_feedbackAppraisalAsset.posAppraisalGrade4.x;
			_rbtnAppraisalGrade4.y=_feedbackAppraisalAsset.posAppraisalGrade4.y;
			_feedbackAppraisalAsset.addChild(_rbtnAppraisalGrade4);
			_tbgAppraisalGrade.addItem(_rbtnAppraisalGrade4);
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
		
		/**
		 *确定提交 
		 */		
		private function confirmSubmit():void
		{
			//取得评价级别
			var appraisalGrade:int=_rbtnAppraisalGrade1.selected ? 1 : _rbtnAppraisalGrade2.selected ? 2 : _rbtnAppraisalGrade3.selected ? 3 : _rbtnAppraisalGrade4.selected ? 4 : 0;
			_loadFeedbackAppraisal = new LoadFeedbackAppraisal(_feedbackReplyInfo.questionId, _feedbackReplyInfo.replyId, appraisalGrade, _txtAppraisalContent.text, confirmSubmitCallBack);
			_loadFeedbackAppraisal.loadSync();
		}
		
		/**
		 *提交结果返回 
		 * @param result 返回结果：1=成功,0=失败
		 */	
		private function confirmSubmitCallBack(result:int):void
		{
			if(result==1)
			{
				MessageTipManager.getInstance().show("感谢您的评价！");
				
				//提交成功以后，从回复列表中去除当前 的回复
				FeedbackManager.Instance.feedbackReplyData.remove(_feedbackReplyInfo.questionId + "_" + _feedbackReplyInfo.replyId);
				
				dispose();
				this.close();
			}
			else
			{
				MessageTipManager.getInstance().show("系统繁忙，请稍后再试。");
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
			if(_feedbackAppraisalAsset) _feedbackAppraisalAsset.btnContact.removeEventListener(MouseEvent.CLICK, openContactView);
			
			if(_feedbackContactView)
			{
				if(_feedbackContactView.parent) _feedbackContactView.parent.removeChild(_feedbackContactView);
				_feedbackContactView.dispose();
			}
			_feedbackContactView=null;
			
			if(_feedbackAppraisalAsset && _feedbackAppraisalAsset.parent) _feedbackAppraisalAsset.parent.removeChild(_feedbackAppraisalAsset);
			_feedbackAppraisalAsset=null;
		}
	}
}