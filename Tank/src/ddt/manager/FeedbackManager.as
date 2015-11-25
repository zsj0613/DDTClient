package ddt.manager
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.feedback.feedbackAppraisalAsset;
	import game.crazyTank.view.feedback.feedbackNavigationAsset;
	
	import road.comm.PackageIn;
	import road.data.DictionaryData;
	import road.data.DictionaryEvent;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.manager.TipManager;
	
	import ddt.data.feedback.FeedbackReplyInfo;
	import ddt.data.socket.CrazyTankPackageType;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.events.FeedbackEvent;
	import ddt.request.feedback.LoadFeedbackReply;
	import ddt.view.feedback.FeedbackAppraisalView;
	import ddt.view.feedback.FeedbackReplyView;
	import ddt.view.feedback.FeedbackSubmitContinueView;
	import ddt.view.feedback.FeedbackSubmitView;
	
	public class FeedbackManager extends Sprite
	{
		/**
		 *回复数据列表 
		 */		
		private var _feedbackReplyData:DictionaryData=new DictionaryData();
		
		private var _feedbackNavigationAsset:feedbackNavigationAsset;
		private var _feedbackSubmitView:FeedbackSubmitView;
		private var _feedbackReplyView:FeedbackReplyView;
		private var _loadFeedbackReply:LoadFeedbackReply;
		private var _feedbackAppraisalView:FeedbackAppraisalView;
		private var _feedbackSubmitContinueView:FeedbackSubmitContinueView;
		private var _btnFeedbackNavigation:HBaseButton;
		
		private static var _instance:FeedbackManager;
		public static function get instance():FeedbackManager
		{
			if(_instance == null)
			{
				_instance = new FeedbackManager();
			}
			
			return _instance;
		}
		
		public function setup():void
		{
			if(!_feedbackNavigationAsset) _feedbackNavigationAsset=new feedbackNavigationAsset();
			
			setEvent();
		}
		
		private function setEvent():void
		{
			_feedbackReplyData.addEventListener(DictionaryEvent.ADD, feedbackReplyDataAdd);
			_feedbackReplyData.addEventListener(DictionaryEvent.REMOVE, feedbackReplyDataRemove);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FEEDBACK_REPLY, feedbackReplyBySocket);//取得问题回复
		}
		
		/**
		 *从Request中取得问题回复
		 */
		public function feedbackReplyByRequest():void
		{
			_loadFeedbackReply = new LoadFeedbackReply();
			_loadFeedbackReply.loadSync();
		}
		
		/**
		 *从Socket中取得问题回复 
		 */
		private function feedbackReplyBySocket(event:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = event.pkg;
			var feedbackReplyInfo:FeedbackReplyInfo=new FeedbackReplyInfo();
			feedbackReplyInfo.questionId=pkg.readUTF();
			feedbackReplyInfo.replyId=pkg.readInt();
			feedbackReplyInfo.occurrenceDate=pkg.readUTF();
			feedbackReplyInfo.questionTitle=pkg.readUTF();
			feedbackReplyInfo.questionContent=pkg.readUTF();
			feedbackReplyInfo.replyContent=pkg.readUTF();
			
			_feedbackReplyData.add(feedbackReplyInfo.questionId + "_" + feedbackReplyInfo.replyId, feedbackReplyInfo);
		}
		
		/**
		 *增加一条问题回复
		 */		
		private function feedbackReplyDataAdd(event:DictionaryEvent):void
		{
			checkFeedbackReplyData();
			dispatchEvent(new FeedbackEvent(FeedbackEvent.FEEDBACK_REPLY_ADD, event.data));
		}
		
		/** 
		 *移除一条问题回复
		 */
		private function feedbackReplyDataRemove(event:DictionaryEvent):void
		{
			checkFeedbackReplyData();
			dispatchEvent(new FeedbackEvent(FeedbackEvent.FEEDBACK_REPLY_REMOVE, event.data));
		}
		
		/**
		 *检查是否有回复数据 
		 */		
		private function checkFeedbackReplyData():void
		{
			if(_feedbackReplyData.length<=0)
			{//如果列表中已经没有回复内容
				_feedbackNavigationAsset.gotoAndStop(1);
				if(_btnFeedbackNavigation) _btnFeedbackNavigation.removeEventListener(MouseEvent.CLICK, openFeedbackSubmitView);
				if(_btnFeedbackNavigation) _btnFeedbackNavigation.removeEventListener(MouseEvent.CLICK, openFeedbackReplyView);
				
				if(_btnFeedbackNavigation) _btnFeedbackNavigation.addEventListener(MouseEvent.CLICK, openFeedbackSubmitView);
			}
			else
			{
				_feedbackNavigationAsset.gotoAndStop(2);
				if(_btnFeedbackNavigation) _btnFeedbackNavigation.removeEventListener(MouseEvent.CLICK, openFeedbackSubmitView);
				if(_btnFeedbackNavigation) _btnFeedbackNavigation.removeEventListener(MouseEvent.CLICK, openFeedbackReplyView);
				
				if(_btnFeedbackNavigation) _btnFeedbackNavigation.addEventListener(MouseEvent.CLICK, openFeedbackReplyView);
			}
		}
		
		/**
		 *打开提交问题视图
		 */		
		private function openFeedbackSubmitView(event:MouseEvent):void
		{
			if(_feedbackSubmitView)
			{
				if(_feedbackSubmitView.parent) _feedbackSubmitView.parent.removeChild(_feedbackSubmitView);
				_feedbackSubmitView.dispose();
			}
			_feedbackSubmitView=null;
			
			_feedbackSubmitView=new FeedbackSubmitView();
			_feedbackSubmitView.show();
		}
		
		/**
		 *打开问题回复视图
		 */		
		private function openFeedbackReplyView(event:MouseEvent):void
		{
			if(_feedbackReplyView)
			{
				if(_feedbackReplyView.parent) _feedbackReplyView.parent.removeChild(_feedbackReplyView);
				_feedbackReplyView.dispose();
			}
			_feedbackReplyView=null;
			
			var feedbackReplyInfo:FeedbackReplyInfo=_feedbackReplyData.list[0] as FeedbackReplyInfo;
			_feedbackReplyView=new FeedbackReplyView(feedbackReplyInfo);
			_feedbackReplyView.show();
		}
		
		/**
		 * 显示投诉反馈导航按钮 
		 * @param displayObjectContainer 在显示到的父级
		 * @param posX 在视图中的X坐标
		 * @param posY 在视图中的Y坐标
		 * @param state 显示状态
		 */
		public function showNavigation(displayObjectContainer:DisplayObjectContainer, posX:Number=0, posY:Number=0, state:Boolean=true):void
		{
			if(state)
			{
				if(!_feedbackNavigationAsset) _feedbackNavigationAsset=new feedbackNavigationAsset();
				_btnFeedbackNavigation = new HBaseButton(_feedbackNavigationAsset);
				_btnFeedbackNavigation.addEventListener(MouseEvent.CLICK, openFeedbackSubmitView);
				_btnFeedbackNavigation.x=posX;
				_btnFeedbackNavigation.y=posY;
				displayObjectContainer.addChild(_btnFeedbackNavigation);
				
				FeedbackManager.instance.feedbackReplyByRequest();//取得投诉反馈回复列表数据
				checkFeedbackReplyData();
			}
			else
			{
				if(_btnFeedbackNavigation && _btnFeedbackNavigation.parent) _btnFeedbackNavigation.parent.removeChild(_btnFeedbackNavigation);
			}
		}
		
		/**
		 *移除投诉反馈导航按钮 
		 */		
		public function hideNavigation():void
		{
			if(_btnFeedbackNavigation && _btnFeedbackNavigation.parent) _btnFeedbackNavigation.parent.removeChild(_btnFeedbackNavigation);
		}
		
		/**
		 *打开回复评价视图 
		 */		
		public function openFeedbackAppraisalView(feedbackReplyInfo:FeedbackReplyInfo):void
		{
			if(_feedbackAppraisalView)
			{
				if(_feedbackAppraisalView.parent) _feedbackAppraisalView.parent.removeChild(_feedbackAppraisalView);
				_feedbackAppraisalView.dispose();
			}
			_feedbackAppraisalView=null;
			
			_feedbackAppraisalView=new FeedbackAppraisalView(feedbackReplyInfo);
			_feedbackAppraisalView.show();
		}
		
		/**
		 *打开继续提交视图 
		 */		
		public function openFeedbackSubmitContinueView(feedbackReplyInfo:FeedbackReplyInfo):void
		{
			if(_feedbackSubmitContinueView)
			{
				if(_feedbackSubmitContinueView.parent) _feedbackSubmitContinueView.parent.removeChild(_feedbackSubmitContinueView);
				_feedbackSubmitContinueView.dispose();
			}
			_feedbackSubmitContinueView=null;
			
			_feedbackSubmitContinueView=new FeedbackSubmitContinueView(feedbackReplyInfo);
			_feedbackSubmitContinueView.show();
		}		
		
		/**
		 *回复数据列表 
		 */
		public function get feedbackReplyData():DictionaryData
		{
			return _feedbackReplyData;
		}
		
		/**
		 * 回复数据列表
		 */
		public function set feedbackReplyData(value:DictionaryData):void
		{
			_feedbackReplyData = value;
		}
		
		public function dispose():void
		{
			_feedbackReplyData.removeEventListener(DictionaryEvent.ADD, feedbackReplyDataAdd);
			_feedbackReplyData.removeEventListener(DictionaryEvent.REMOVE, feedbackReplyDataRemove);
			if(_btnFeedbackNavigation) _btnFeedbackNavigation.removeEventListener(MouseEvent.CLICK, openFeedbackSubmitView);
			if(_btnFeedbackNavigation) _btnFeedbackNavigation.removeEventListener(MouseEvent.CLICK, openFeedbackReplyView);
			
			_loadFeedbackReply=null;
			
			if(_feedbackSubmitView)
			{
				if(_feedbackSubmitView.parent) _feedbackSubmitView.parent.removeChild(_feedbackSubmitView);
				_feedbackSubmitView.dispose();
			}
			_feedbackSubmitView=null;
			
			if(_feedbackReplyView)
			{
				if(_feedbackReplyView.parent) _feedbackReplyView.parent.removeChild(_feedbackReplyView);
				_feedbackReplyView.dispose();
			}
			_feedbackReplyView=null;
			
			if(_feedbackNavigationAsset && _feedbackNavigationAsset.parent) _feedbackNavigationAsset.parent.removeChild(_feedbackNavigationAsset);
			_feedbackNavigationAsset=null;
			
			if(_btnFeedbackNavigation && _btnFeedbackNavigation.parent) _btnFeedbackNavigation.parent.removeChild(_btnFeedbackNavigation);
			_btnFeedbackNavigation=null;			
		}
		
	}
}