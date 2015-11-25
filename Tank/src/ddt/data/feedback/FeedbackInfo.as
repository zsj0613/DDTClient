package ddt.data.feedback
{
	import ddt.data.player.PlayerInfo;

	public class FeedbackInfo
	{
		/**
		 *玩家ID 
		 */		
		private var _userID:int;
		
		/**
		 *玩家账号 
		 */		
		private var _userName:String;
		
		/**
		 *玩家昵称 
		 */		
		private var _userNickName:String;		
		
		/**
		 *问题标题  
		 */		
		private var _questionTitle:String;
		
		/**
		 * 详细描述
		 */		
		private var _questionContent:String;		
		
		/**
		 *发生时间 
		 */		
		private var _occurrenceDate:String;		
		
		/**
		 *工单类型 
		 */		
		private var _questionType:int;			
		
		/**
		 *物品获得途径 
		 */		
		private var _goodsGetMethod:String;			
		
		/**
		 *物品获得时间 
		 */		
		private var _goodsGetDate:String;			
		
		/**
		 *充值订单号 
		 */		
		private var _chargeOrderId:String;			
		
		/**
		 *充值方式 
		 */		
		private var _chargeMethod:String;		
		
		/**
		 *充值金额 
		 */		
		private var _chargeMoneys:Number;			
		
		/**
		 *活动是否异常 
		 */		
		private var _activityIsError:Boolean;			
		
		/**
		 *活动名称 
		 */		
		private var _activityName:String;		
		
		/**
		 *举报用户名称 
		 */		
		private var _reportUserName:String;
		
		/**
		 *举报名称或网址 
		 */		
		private var _reportUrl:String;		
		
		/**
		 *玩家姓名 
		 */		
		private var _userFullName:String;
		
		/**
		 *玩家手机 
		 */		
		private var _userPhone:String;		
		
		/**
		 *投诉标题 
		 */		
		private var _complaintsTitle:String;			
		
		/**
		 *投诉来源 
		 */		
		private var _complaintsSource:String;		
		
		/**
		 *投诉来源 
		 */		
		private var _appraisalGrade:String;			
		
		/**
		 *评价
		 */		
		private var _appraisalContent:String;		
		
		
		/**
		 *问题标题 
		 */
		public function get question_title():String
		{
			return _questionTitle;
		}

		/**
		 * 问题标题 
		 */
		public function set question_title(value:String):void
		{
			_questionTitle = value;
		}

		/**
		 *详细描述
		 */
		public function get question_content():String
		{
			return _questionContent;
		}
		
		/**
		 * 详细描述
		 */
		public function set question_content(value:String):void
		{
			_questionContent = value;
		}

		/**
		 * 发生时间
		 */
		public function get occurrence_date():String
		{
			return _occurrenceDate;
		}

		/**
		 * 发生时间
		 */
		public function set occurrence_date(value:String):void
		{
			_occurrenceDate = value;
		}

		/**
		 *工单类型 
		 */
		public function get question_type():int
		{
			return _questionType;
		}

		/**
		 * 工单类型
		 */
		public function set question_type(value:int):void
		{
			_questionType = value;
		}

		/**
		 *物品获得途径
		 */
		public function get goods_get_method():String
		{
			return _goodsGetMethod;
		}

		/**
		 * 物品获得途径
		 */
		public function set goods_get_method(value:String):void
		{
			_goodsGetMethod = value;
		}

		/**
		 *物品获得时间 
		 */
		public function get goods_get_date():String
		{
			return _goodsGetDate;
		}

		/**
		 * 物品获得时间
		 */
		public function set goods_get_date(value:String):void
		{
			_goodsGetDate = value;
		}

		/**
		 *充值订单号
		 */
		public function get charge_order_id():String
		{
			return _chargeOrderId;
		}

		/**
		 * 充值订单号
		 */
		public function set charge_order_id(value:String):void
		{
			_chargeOrderId = value;
		}

		/**
		 *充值方式
		 */
		public function get charge_method():String
		{
			return _chargeMethod;
		}

		/**
		 * 充值方式
		 */
		public function set charge_method(value:String):void
		{
			_chargeMethod = value;
		}

		/**
		 *充值金额 
		 */
		public function get charge_moneys():Number
		{
			return _chargeMoneys;
		}

		/**
		 * 充值金额
		 */
		public function set charge_moneys(value:Number):void
		{
			_chargeMoneys = value;
		}

		/**
		 *活动是否异常
		 */
		public function get activity_is_error():Boolean
		{
			return _activityIsError;
		}

		/**
		 * 活动是否异常
		 */
		public function set activity_is_error(value:Boolean):void
		{
			_activityIsError = value;
		}

		/**
		 *活动名称
		 */
		public function get activity_name():String
		{
			return _activityName;
		}

		/**
		 * 活动名称
		 */
		public function set activity_name(value:String):void
		{
			_activityName = value;
		}

		/**
		 *举报用户名称 
		 */
		public function get report_user_name():String
		{
			return _reportUserName;
		}

		/**
		 * 举报用户名称
		 */
		public function set report_user_name(value:String):void
		{
			_reportUserName = value;
		}

		/**
		 *举报名称或网址
		 */
		public function get report_url():String
		{
			return _reportUrl;
		}

		/**
		 * 举报名称或网址
		 */
		public function set report_url(value:String):void
		{
			_reportUrl = value;
		}

		/**
		 *玩家姓名
		 */
		public function get user_full_name():String
		{
			return _userFullName;
		}

		/**
		 * 玩家姓名
		 */
		public function set user_full_name(value:String):void
		{
			_userFullName = value;
		}

		/**
		 *玩家手机
		 */
		public function get user_phone():String
		{
			return _userPhone;
		}

		/**
		 * 玩家手机
		 */
		public function set user_phone(value:String):void
		{
			_userPhone = value;
		}

		/**
		 *投诉标题
		 */
		public function get complaints_title():String
		{
			return _complaintsTitle;
		}

		/**
		 * 投诉标题
		 */
		public function set complaints_title(value:String):void
		{
			_complaintsTitle = value;
		}

		/**
		 *投诉来源
		 */
		public function get complaints_source():String
		{
			return _complaintsSource;
		}

		/**
		 * 投诉来源
		 */
		public function set complaints_source(value:String):void
		{
			_complaintsSource = value;
		}

		/**
		 * 评价级别
		 */
		public function get appraisal_grade():String
		{
			return _appraisalGrade;
		}

		/**
		 * 评价级别
		 */
		public function set appraisal_grade(value:String):void
		{
			_appraisalGrade = value;
		}

		/**
		 *评价
		 */
		public function get appraisal_content():String
		{
			return _appraisalContent;
		}

		/**
		 * 评价
		 */
		public function set appraisal_content(value:String):void
		{
			_appraisalContent = value;
		}

		/**
		 *玩家ID
		 */
		public function get user_id():int
		{
			return _userID;
		}

		/**
		 * 玩家ID
		 */
		public function set user_id(value:int):void
		{
			_userID = value;
		}

		/**
		 *玩家账号
		 */
		public function get user_name():String
		{
			return _userName;
		}

		/**
		 * 玩家账号
		 */
		public function set user_name(value:String):void
		{
			_userName = value;
		}

		/**
		 *玩家昵称 
		 */
		public function get user_nick_name():String
		{
			return _userNickName;
		}

		/**
		 * 玩家昵称
		 */
		public function set user_nick_name(value:String):void
		{
			_userNickName = value;
		}


	}
}