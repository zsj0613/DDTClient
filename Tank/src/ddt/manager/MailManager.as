package ddt.manager
{
	import road.comm.PackageIn;
	
	import ddt.data.EmailInfo;
	import ddt.data.RoomInfo;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.request.email.GetEmailAction;
	import ddt.view.common.BellowStripViewII;
	import ddt.view.emailII.EmailIIEvent;
	import ddt.view.emailII.EmailIIState;
	import ddt.view.emailII.EmailModel;
	import ddt.view.emailII.EmailViewII;
	
	public class MailManager
	{
		public const NUM_OF_WRITING_DIAMONDS:uint = 4;
		
		private var _model:EmailModel;
	
		private var _view:EmailViewII;
		
		private var _isShow:Boolean;
		
		public function get Model():EmailModel
		{
			return _model;
		}
		
		public function MailManager()
		{
			_model = new EmailModel();
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SEND_EMAIL,__sendEmail);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DELETE_MAIL,__deleteMail);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GET_MAIL_ATTACHMENT,__getMailToBag);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MAIL_CANCEL,__mailCancel);
		}
		
		public function loadMail(type:uint):void
		{
			switch(type)
			{
				case 1:
				new GetEmailAction(PlayerManager.Instance.Self.ID,GetEmailAction.PATH_ALL).loadSync(__getEmails);
				break;
				case 2:
				new GetEmailAction(PlayerManager.Instance.Self.ID,GetEmailAction.PATH_SENDED).loadSync(__getSendedEmails);
				break;
				case 3:
				new GetEmailAction(PlayerManager.Instance.Self.ID,GetEmailAction.PATH_ALL).loadSync(__getEmails);
				new GetEmailAction(PlayerManager.Instance.Self.ID,GetEmailAction.PATH_SENDED).loadSync(__getSendedEmails);
				break;
			}
		}
		
		public function get isShow():Boolean
		{
			return _isShow;
		}
		
		private function __getEmails(loader:GetEmailAction):void
		{
			if(loader.isSuccess)
			{
				_model.emails = loader.list;
				changeSelected(null);
				if(_model.hasUnReadEmail() && (RoomManager.Instance.current != null && RoomManager.Instance.current.roomState != RoomInfo.STATE_PICKING))
				{
					BellowStripViewII.Instance.unReadEmail = true;
				}
			}
			else
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.MailManager.email"));
				//MessageTipManager.getInstance().show("邮件打开失败，请稍后重试!");
			}
		}	
		
		private function __getSendedEmails(loader:GetEmailAction):void
		{
			if(loader.isSuccess)
			{
				_model.sendedMails = loader.list;
			}
			else
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.MailManager.email"));
				//MessageTipManager.getInstance().show("邮件打开失败，请稍后重试!");
			}
		}	
		
		public function show():void
		{
			if(_view == null)
			{
				_view = new EmailViewII(this,_model);
			}
			_view.addEventListener(EmailIIEvent.ESCAPE_KEY, __escapeKeyDown);
			_isShow = true;
			_view.show();
		}
		
		public function hide():void
		{
			BellowStripViewII.Instance.unReadEmail = false;
			if(_view)
			{
				_model.selectEmail = null;
				_model.mailType = EmailIIState.ALL;
			    _view.removeEventListener(EmailIIEvent.ESCAPE_KEY, __escapeKeyDown);
				_view.dispose();
				_view = null;
			}
			_isShow = false;
		}
		private function __escapeKeyDown(evt : EmailIIEvent) : void
		{
			if(_view)
			{
				if(_view.writeView.parent)_view.writeView.closeWin();
				else hide();
				
			}
		}
		
		public function switchVisible():void
		{
			if(_view)
			{
				hide();
			}
			else
			{
				show();
			}
		}
		/**
		 * 更改状态 
		 * @param state
		 * 
		 */		
		public function changeState(state:String):void
		{
			_model.state = state;
		}
		
		/**
		 * 更改邮件类别 
		 * @param info
		 * 
		 */		
		public function changeType(type:String):void
		{
			if(_model.mailType == type)return;
			updateNoReadMails();
			_model.mailType = type;
		}
		/**
		 * 更改选中的邮件 
		 * @param info
		 * 
		 */		
		public function changeSelected(info:EmailInfo):void
		{
			_model.selectEmail = info;
		}
		/**
		 *  更新未读邮件
		 */	
		public function updateNoReadMails():void
		{
			_model.getNoReadMails();
		}
		
		public function getAnnexToBag(info:EmailInfo,type:int):void
		{
			if(!HasAtLeastOneDiamond(info)) return;
			SocketManager.Instance.out.sendGetMail(info.ID,type);
		}
		
		private function HasAtLeastOneDiamond(info:EmailInfo):Boolean
		{
			if(info.Gold >0)return true;
			if(info.Money >0)return true;
			if(info.GiftToken > 0) return true;
			
			for(var i:uint = 1;i<=5;i++)
			{
				if(info["Annex"+i]) return true;
			}
			
			return false;
		}	
			
		public function deleteEmail(info:EmailInfo):void
		{
			if(info){
				SocketManager.Instance.out.sendDeleteMail(info.ID);
			}
		}
		/**
		 * 标记邮件为已读 
		 * @param info
		 * 
		 */		
		public function readEmail(info:EmailInfo):void
		{
			if(_model.mailType != EmailIIState.NOREAD)
			{
				_model.removeFromNoRead(info);
			}
			
			SocketManager.Instance.out.sendUpdateMail(info.ID);
		}
		
		public function setPage(pre:Boolean,canChangePane:Boolean=true):void
		{
			if(!pre && !canChangePane)
			{
				_model.currentPage = _model.currentPage
				return;
			}
			if(pre)
			{
				if(_model.currentPage - 1 > 0)
				{
					_model.currentPage = _model.currentPage - 1;
				}
			}
			else
			{
				if(_model.currentPage + 1 <= _model.totalPage)
				{
					_model.currentPage = _model.currentPage + 1;
				}else if(_model.mailType == EmailIIState.NOREAD&&_model.totalPage==1)
				{
					_model.currentPage = 1;
				}
			}
		}
		
		public function sendEmail(value:Object):void
		{
			SocketManager.Instance.out.sendEmail(value);
		}
		public function onSendAnnex(annexArr:Array):void{
			TaskManager.onSendAnnex(annexArr);
		}
		
		public function untreadEmail(id:int):void
		{
			SocketManager.Instance.out.untreadEmail(id);
		}
		/**
		 * 提取邮件附件响应
		 * @param event
		 * 
		 */		
		private function __getMailToBag(event:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = event.pkg;
			var id:int = pkg.readInt();
			var count:int = pkg.readInt();
			//TODO
			var currentMail:EmailInfo = _model.getMailByID(id);
			
			if(!currentMail)
			{
				return;
			}
			
			if(currentMail.Type > 100&&currentMail.Money>0)
			{
				currentMail.ValidDate = 72;
				
				currentMail.Money = 0;
			}
			
			for(var i:uint = 0;i<count;i++)
			{
				var type:int = pkg.readInt();
				
				deleteMailDiamond(currentMail,type);
			}
			_model.changeEmail(currentMail);
		}
		
		private function deleteMailDiamond(mail:EmailInfo,type:int):void
		{
			switch(type)
			{
				case 6:
				mail.Gold = 0;
				break;
				case 7:
				mail.Money = 0;
				break;
				case 8:
				mail.GiftToken = 0;
				break;
				default:
				for(var i:uint = 1;i<=5;i++)
				{
					if(type == i)
					{
						mail["Annex"+i] = null;
						break;
					}
				}
			}
		}
		
		private function __deleteMail(event:CrazyTankSocketEvent):void
		{
			var id:int = event.pkg.readInt();
			var isSuccess:Boolean = event.pkg.readBoolean();
			
			if(isSuccess)
			{
				removeMail(_model.getMailByID(id));

				changeSelected(null);
				
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.MailManager.delete"),true);
				//MessageTipManager.getInstance().show("邮件删除成功",true);
			}
			else
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.MailManager.false"),true);
				//MessageTipManager.getInstance().show("邮件删除失败",true);
			}
			
		}
		
		public function removeMail(info:EmailInfo):void
		{
			_model.removeEmail(info);
		}
		
		private function __sendEmail(event:CrazyTankSocketEvent):void
		{
			if(event.pkg.readBoolean())
			{
				_view.resetWrite();
			}
		}
		
		private function __mailCancel(event:CrazyTankSocketEvent):void
		{
			var cancelID:int = event.pkg.readInt();
			if(event.pkg.readBoolean())
			{
				_model.removeEmail(_model.selectEmail);
				changeSelected(null);
				
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.MailManager.back"),true);
				//MessageTipManager.getInstance().show("退回邮件成功！",true);
			}else
			{
				
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.MailManager.return"),true);
				//MessageTipManager.getInstance().show("退回邮件失败！",true);
			}
		}
		
		 
		private static var _instance:MailManager;
		public static function get Instance():MailManager
		{
		 	if(_instance == null)
		 	{
		 		_instance = new MailManager();
		 	}
		 	return _instance;
		}
	}
}