package ddt.request.feedback
{
	import ddt.data.feedback.FeedbackInfo;
	import ddt.data.feedback.FeedbackReplyInfo;
	import ddt.loader.RequestLoader;
	import ddt.manager.FeedbackManager;
	
	public class LoadFeedbackAppraisal extends RequestLoader
	{
		private var _callBack:Function;
		
		/**
		 *问题提交请求页面 
		 */		
		public static const PATH:String = "AdvanceQuestionAppraisal.ashx";
		
		/**
		 * 提交问题评价 
		 * @param questionId 问题ID
		 * @param appraisalGrade 评价级别
		 * @param AppraisalContent 评价详情
		 * @param callBack 返回方法
		 */		
		public function LoadFeedbackAppraisal(questionId:String, replyId:int, appraisalGrade:int, AppraisalContent:String, callBack:Function)
		{
			_callBack=callBack;
			var object:Object=new Object();
			object.question_id=questionId;
			object.reply_id=replyId;
			object.appraisal_grade=appraisalGrade;
			object.appraisal_content=AppraisalContent;
			super(PATH,object);
		}
		
		override protected function onRequestReturn(xml:XML):void
		{
			if(_callBack!=null) _callBack(xml ? int(xml) : 0);
		}
	}
}