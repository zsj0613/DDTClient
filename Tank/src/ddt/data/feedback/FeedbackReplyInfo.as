package ddt.data.feedback
{
	public class FeedbackReplyInfo
	{
		/**
		 *工单编号 
		 */		
		private var _questionId:String;
		
		/**
		 *问题标题 
		 */		
		private var _questionTitle:String;		

		/**
		 *发生时间 
		 */		
		private var _occurrenceDate:String;
		
		/**
		 * 详细描述
		 */		
		private var _questionContent:String;	
		
		/**
		 *回复编号 
		 */		
		private var _replyId:int;
		
		/**
		 *玩家昵称 
		 */		
		private var _nickName:String;		
		
		/**
		 *回复时间 
		 */		
		private var _replyDate:Date;
		
		/**
		 *回复内容 
		 */		
		private var _replyContent:String;		
		
		
		
		/**
		 *工单编号
		 */
		public function get questionId():String
		{
			return _questionId;
		}

		/**
		 * 工单编号
		 */
		public function set questionId(value:String):void
		{
			_questionId = value;
		}

		/**
		 *回复编号 
		 */
		public function get replyId():int
		{
			return _replyId;
		}

		/**
		 * 回复编号
		 */
		public function set replyId(value:int):void
		{
			_replyId = value;
		}

		/**
		 *玩家昵称 
		 */
		public function get nickName():String
		{
			return _nickName;
		}

		/**
		 * 玩家昵称
		 */
		public function set nickName(value:String):void
		{
			_nickName = value;
		}

		/**
		 *回复时间
		 */
		public function get replyDate():Date
		{
			return _replyDate;
		}

		/**
		 * 回复时间
		 */
		public function set replyDate(value:Date):void
		{
			_replyDate = value;
		}

		/**
		 *回复内容
		 */
		public function get replyContent():String
		{
			return _replyContent;
		}

		/**
		 * 回复内容
		 */
		public function set replyContent(value:String):void
		{
			_replyContent = value;
		}

		/**
		 *问题标题 
		 */
		public function get questionTitle():String
		{
			return _questionTitle;
		}

		/**
		 * 问题标题
		 */
		public function set questionTitle(value:String):void
		{
			_questionTitle = value;
		}
		
		/**
		 * 发生时间
		 */
		public function get occurrenceDate():String
		{
			return _occurrenceDate;
		}
		
		/**
		 * 发生时间
		 */
		public function set occurrenceDate(value:String):void
		{
			_occurrenceDate = value;
		}
		
		/**
		 *详细描述
		 */
		public function get questionContent():String
		{
			return _questionContent;
		}
		
		/**
		 * 详细描述
		 */
		public function set questionContent(value:String):void
		{
			_questionContent = value;
		}
	}
}