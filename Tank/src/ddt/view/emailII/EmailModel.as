package ddt.view.emailII
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	import ddt.data.EmailInfo;
	import ddt.data.EmailInfoOfSended;
	
	[Event(name = "initEmail",type = "ddt.view.emailII.EmailIIEvent")]
	[Event(name = "changeEmail",type = "ddt.view.emailII.EmailIIEvent")]
	[Event(name = "addEmail",type = "ddt.view.emailII.EmailIIEvent")]
	[Event(name = "removeEmail",type = "ddt.view.emailII.EmailIIEvent")]
	[Event(name = "clearEmail",type = "ddt.view.emailII.EmailIIEvent")]
	[Event(name = "selectEnail",type = "ddt.view.emailII.EmailIIEvent")]
	[Event(name = "changeState",type = "ddt.view.emailII.EmailIIEvent")]
	[Event(name = "changePage",type = "ddt.view.emailII.EmailIIEvent")]
	[Event(name = "changeMode",type = "ddt.view.emailII.EmailIIEvent")]
	public class EmailModel extends EventDispatcher
	{
		//记录第一次加载是否完成
		public var isLoaded:Boolean = false;
		
		/* 已发邮件 */
		private var _sendedMails:Array = [];
		public function set sendedMails(value:Array):void
		{
			_sendedMails = value;
			
			if(_mailType == EmailIIState.SENDED)
			dispatchEvent(new EmailIIEvent(EmailIIEvent.INIT_EMAIL));
		}
		public function get sendedMails():Array
		{
			return _sendedMails;
		}
		/* 未读邮件 */
		private var _noReadMails:Array;
		public function get noReadMails():Array
		{
			return _noReadMails;
		}
		
		/* 所有邮件 */
		private var _emails:Array = [];
		public function get emails():Array
		{
			return _emails.slice(0);
		}
		public function set emails(value:Array):void
		{
			_emails = value;
			getNoReadMails();
			isLoaded = true;
			dispatchEvent(new EmailIIEvent(EmailIIEvent.INIT_EMAIL));
		}
		
		/* 邮件类别*/
		private var _mailType:String = EmailIIState.ALL;
		public function set mailType(value:String):void
		{
			_mailType = value;
			
			resetModel();

			dispatchEvent(new EmailIIEvent(EmailIIEvent.CHANGE_TYPE));
		}
		public function get mailType():String
		{
			return _mailType;
		}
		
		/* 引用当前用到的邮件数据 */
		private var _currentDate:Array;
		public function get currentDate():Array
		{
			switch(_mailType)
			{
				case EmailIIState.ALL:
				_currentDate = _emails;
				break;
				case EmailIIState.NOREAD:
				_currentDate = _noReadMails;
				break;
				case EmailIIState.SENDED:
				_currentDate = _sendedMails;
				break;
				default:
				_currentDate = _emails;
			}
			return _currentDate;
		}
		/* 邮件状态 */
		private var _state:String = EmailIIState.READ;
		public function set state(value:String):void
		{
			_state = value;
			dispatchEvent(new EmailIIEvent(EmailIIEvent.CHANE_STATE));
		}
		public function get state():String
		{
			return _state;
		}
		
		private function resetModel():void
		{
			_currentPage = 1;
			selectEmail = null;
		}
		
		public function get totalPage():int
		{
			if(currentDate)
			{
				if(currentDate.length == 0)
				{
					return 1;
				}
				return Math.ceil(currentDate.length / 7);
			}
			return 1;
		}
		
		private var _currentPage:int = 1;
		public function get currentPage():int
		{
			if(_currentPage > totalPage) _currentPage = totalPage;
			
			return _currentPage;
		}
		public function set currentPage(value:int):void
		{
			_currentPage = value;
			dispatchEvent(new EmailIIEvent(EmailIIEvent.CHANE_PAGE));
		}
		
		public function getNoReadMails():void
		{
			_noReadMails = [];
			
			for each(var info:EmailInfo in _emails)
	 		{
	 			if(!info.IsRead)
	 			{
	 				_noReadMails.push(info);
	 			}
	 		}
		}
		
		public function getMailByID(id:int):EmailInfo
		{
			var le:int = _emails.length;;
			for(var i:uint = 0;i<le;i++)
			{
				if((_emails[i] as EmailInfo).ID == id)
				{
					return _emails[i] as EmailInfo;
				}
			}
			return null;
		}
		
		
		/**
		 * 获取显示数据 
		 * @return 
		 */		
		public function getViewData():Array
		{
			if(_mailType == EmailIIState.NOREAD) getNoReadMails();
			var result:Array = new Array();
			if(currentDate)
			{
				var begin:int = (currentPage * 7 - 7);
				var end:int = (begin + 7) > currentDate.length ? (currentDate.length) : (begin + 7);
				result = currentDate.slice(begin,end);
			}
			return result;
		}
		
		private var _selectEmail:EmailInfo;
		public function get selectEmail():EmailInfo
		{
			return _selectEmail;
		}
		public function set selectEmail(value:EmailInfo):void
		{
			if(value)
			{
				if(_emails.indexOf(value)<=-1&&_sendedMails.indexOf(value)<=-1)
				{
					_selectEmail = null;
				}else
				{
					_selectEmail = value;
				}
			}else
			{
				_selectEmail = null;
			}
			
			dispatchEvent(new EmailIIEvent(EmailIIEvent.SELECT_EMAIL,_selectEmail));
		}
		
		public function EmailModel(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function addEmail(info:EmailInfo):void
		{
			_emails.push(info);
			dispatchEvent(new EmailIIEvent(EmailIIEvent.ADD_EMAIL,info));
		}
		
		public function addEmailToSended(info:EmailInfoOfSended):void
		{
			_sendedMails.unshift(info);
			if(_sendedMails.length>21)
			{
				_sendedMails.pop();
			}
			
		}
		
		/**
		 * 从未读邮件中删除已读邮件
		 * @param info
		 * 
		 */		
		public function removeFromNoRead(info:EmailInfo):void
		{
			var index:int = _noReadMails.indexOf(info);
			if(index > -1)
			{
				_noReadMails.splice(index,1);
			}
		}
		/**
		 * 删除邮件、所有邮件与未读邮件的同步
		 * @param info
		 * 
		 */		
		public function removeEmail(info:EmailInfo):void
		{
			var index:int = _emails.indexOf(info);
			if(index > -1)
			{
				_emails.splice(index,1);
				
				getNoReadMails();
				
				dispatchEvent(new EmailIIEvent(EmailIIEvent.REMOVE_EMAIL,info));
			}
		}
		
		public function changeEmail(info:EmailInfo):void
		{
			var index:int = _emails.indexOf(info);
			info.IsRead = true;
			if(index > -1)
			{
				dispatchEvent(new EmailIIEvent(EmailIIEvent.SELECT_EMAIL,info));
			}
		}
		
		public function clearEmail():void
		{
			_emails = new Array();
			dispatchEvent(new EmailIIEvent(EmailIIEvent.CLEAR_EMAIL));
		}
		
		public function dispose():void
		{
			_emails = new Array();
		}
		
		public function hasUnReadEmail():Boolean
		{
	 		for each(var info:EmailInfo in _emails)
	 		{
	 			if(!info.IsRead)
	 			{
	 				return true;
	 			}
	 		}
		 	return false;
		}
	}
}