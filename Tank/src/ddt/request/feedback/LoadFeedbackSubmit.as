package ddt.request.feedback
{
	import ddt.data.feedback.FeedbackInfo;
	import ddt.loader.RequestLoader;
	import ddt.manager.FeedbackManager;

	/**
	 * 投诉反馈问题提交 
	 */	
	public class LoadFeedbackSubmit extends RequestLoader
	{
		private var _callBack:Function;
		
		/**
		 *问题提交请求页面 
		 */		
		public static const PATH:String = "AdvanceQuestion.ashx";
		
		public function LoadFeedbackSubmit(feedbackInfo:FeedbackInfo, callBack:Function)
		{
			_callBack=callBack;
			var object:Object=new Object();
			object.question_title=feedbackInfo.question_title;
			object.question_content=feedbackInfo.question_content;
			object.occurrence_date=feedbackInfo.occurrence_date;
			object.question_type=feedbackInfo.question_type.toString();
			object.goods_get_method=feedbackInfo.goods_get_method;
			object.goods_get_date=feedbackInfo.goods_get_date;
			object.charge_order_id=feedbackInfo.charge_order_id;
			object.charge_method=feedbackInfo.charge_method;
			object.charge_moneys=feedbackInfo.charge_moneys.toString();
			object.activity_is_error=feedbackInfo.activity_is_error.toString();
			object.activity_name=feedbackInfo.activity_name;
			object.report_user_name=feedbackInfo.report_user_name;
			object.report_url=feedbackInfo.report_url;
			object.user_full_name=feedbackInfo.user_full_name;
			object.user_phone=feedbackInfo.user_phone;
			object.complaints_title=feedbackInfo.complaints_title;
			object.complaints_source=feedbackInfo.complaints_source;
			object.user_id=feedbackInfo.user_id.toString();
			object.user_name=feedbackInfo.user_name;
			object.user_nick_name=feedbackInfo.user_nick_name;
			
			super(PATH,object);
		}
		
		override protected function onRequestReturn(xml:XML):void
		{
			if(_callBack!=null) _callBack(xml ? int(xml) : 0);
		}
	}
}