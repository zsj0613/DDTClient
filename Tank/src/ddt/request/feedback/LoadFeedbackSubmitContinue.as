package ddt.request.feedback
{
	import road.utils.MD5;
	import road.utils.StringHelper;
	
	import ddt.data.feedback.FeedbackInfo;
	import ddt.loader.RequestLoader;
	import ddt.manager.FeedbackManager;
	import ddt.manager.PlayerManager;
	
	public class LoadFeedbackSubmitContinue extends RequestLoader
	{
		private var _callBack:Function;
		
		/**
		 *问题继续提交请求页面 
		 */		
		public static const PATH:String = "AdvanceReply.ashx";
		
		public function LoadFeedbackSubmitContinue(questionID:String, replyId:int, questionContent:String, callBack:Function)
		{
			_callBack=callBack;
			var object:Object=new Object();
			object.question_id=questionID;
			object.userid=PlayerManager.Instance.Self.ID;
			object.nick_name=PlayerManager.Instance.Self.NickName;
			object.reply_id=replyId;
			object.reply_content=questionContent;
			object.key=MD5.hash(PlayerManager.Instance.Self.ID + "3kjf2jfwj93pj22jfsl11jjoe12oij");
			super(PATH,object);
		}
		
		override protected function onRequestReturn(xml:XML):void
		{
			if(_callBack!=null) _callBack(xml ? int(xml) : 0);
		}
	}
}