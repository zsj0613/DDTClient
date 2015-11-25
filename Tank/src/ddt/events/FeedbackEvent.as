package ddt.events
{
	import flash.events.Event;
	public class FeedbackEvent extends Event
	{
		/**
		 *增加一条问题回复 
		 */		
		public static const FEEDBACK_REPLY_ADD:String = "feedbackReplyAdd";
		
		/**
		 * 移除一条问题回复 
		 */		
		public static const FEEDBACK_REPLY_REMOVE:String = "feedbackReplyRemove";
		
		public var data:Object; 
		public function FeedbackEvent(type:String, data:Object)
		{
			this.data=data;
			super(type);
		}
	}
}