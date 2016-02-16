package ddt.request.feedback
{
	import road.utils.StringHelper;
	
	import ddt.data.feedback.FeedbackInfo;
	import ddt.data.feedback.FeedbackReplyInfo;
	import ddt.loader.RequestLoader;
	import ddt.manager.FeedbackManager;
	import ddt.manager.PlayerManager;
	
	/**
	 * 投诉反馈问题回复取得 
	 */	
	public class LoadFeedbackReply extends RequestLoader
	{
		/**
		 *问题回复取得请求页面 
		 */		
		public static const PATH:String = "AdvanceQuestionRead.ashx";
		
		public function LoadFeedbackReply()
		{
			var object:Object=new Object();
			object.userid=PlayerManager.Instance.Self.ID.toString();
			super(PATH,object);
		}
		
		override protected function onRequestReturn(xml:XML):void
		{
			if(xml=="0" || xml=="" || xml.length()<=0) return;
			var xmllist:XMLList = xml..Question;
			if(!xmllist) return;
			
			for(var i:int = 0;i < xmllist.length(); i ++)
			{
				var feedbackReplyInfo:FeedbackReplyInfo=new FeedbackReplyInfo();
				feedbackReplyInfo.questionId=xmllist[i].@QuestionID;
				feedbackReplyInfo.replyId=xmllist[i].@ReplyID;
				feedbackReplyInfo.occurrenceDate=xmllist[i].@OccurrenceDate;
				feedbackReplyInfo.questionTitle=xmllist[i].@Title;				
				feedbackReplyInfo.questionContent=xmllist[i].@QuestionContent;
				feedbackReplyInfo.replyContent=xmllist[i].@ReplyContent;
				FeedbackManager.Instance.feedbackReplyData.add(feedbackReplyInfo.questionId + "_" + feedbackReplyInfo.replyId, feedbackReplyInfo);
			}
		}
	}
}