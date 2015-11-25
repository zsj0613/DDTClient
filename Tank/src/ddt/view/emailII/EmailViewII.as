package ddt.view.emailII
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import road.manager.SoundManager;
	import road.ui.manager.UIManager;
	
	import ddt.manager.MailManager;

	public class EmailViewII extends Sprite  
	{
		private var _controller:MailManager;
		private var _model:EmailModel;
		
		private var _read:ReadingView;
		
		private var _write:WritingView;
		
		public function EmailViewII(controller:MailManager,model:EmailModel)
		{
			super();
			_controller = controller;
			_model = model;
			
			addEvent();
			initView();
		}
		
		private function initView():void
		{
			_read = new ReadingView();
			_write = new WritingView();
			//__changePage(null);
		}
		
		private function addEvent():void
		{
			addEventListener(Event.ADDED_TO_STAGE,__addToStage);
			_model.addEventListener(EmailIIEvent.CHANE_STATE,__changeState);
			_model.addEventListener(EmailIIEvent.CHANGE_TYPE,__changeType);
			_model.addEventListener(EmailIIEvent.CHANE_PAGE,__changePage);
			_model.addEventListener(EmailIIEvent.SELECT_EMAIL,__selectEmail);
			_model.addEventListener(EmailIIEvent.REMOVE_EMAIL,__removeEmail);
			_model.addEventListener(EmailIIEvent.INIT_EMAIL,__initEmail);
			addEventListener(KeyboardEvent.KEY_DOWN, __keyDownHandler);
		}
		
		private function removeEvent():void
		{
			_model.removeEventListener(EmailIIEvent.CHANE_STATE,__changeState);
			_model.removeEventListener(EmailIIEvent.CHANGE_TYPE,__changeType);
			_model.removeEventListener(EmailIIEvent.CHANE_PAGE,__changePage);
			_model.removeEventListener(EmailIIEvent.SELECT_EMAIL,__selectEmail);
			_model.removeEventListener(EmailIIEvent.REMOVE_EMAIL,__removeEmail);
			_model.removeEventListener(EmailIIEvent.INIT_EMAIL,__initEmail);
			removeEventListener(KeyboardEvent.KEY_DOWN, __keyDownHandler);
		}
		private function __keyDownHandler(evt : KeyboardEvent) : void
		{
			if(evt.keyCode == Keyboard.ESCAPE)
			{
				evt.stopImmediatePropagation();
				SoundManager.instance.play("008");
				this.dispatchEvent(new EmailIIEvent(EmailIIEvent.ESCAPE_KEY));
			}
		}
		public function dispose():void
		{
			removeEvent();
			if(_read.parent)
			{
				removeChild(_read);
			}
			_read.dispose();
			_read = null;
			if(_write.parent)
			{
				removeChild(_write);
			}
			_write.dispose();
			_write = null;
			if(parent)
			{
				parent.removeChild(this);
			}
		}
		
		public function show():void
		{
			UIManager.AddDialog(this);
//			TipManager.AddTippanel(this,true);
		}
		
		public function resetWrite():void
		{
			_write.reset();
		}
		
		public function cancelMail():void
		{
//			_read.setListView(_model.getViewData(),_model.totalPage,_model.currentPage);
		}
		
		private function __addToStage(event:Event):void
		{
			MailManager.Instance.changeState(EmailIIState.READ);
			MailManager.Instance.changeType(EmailIIState.ALL);
			MailManager.Instance.updateNoReadMails();
			if(_model.isLoaded)
			{
				_model.currentPage = 1;
			}
		}
		/**
		 * 邮件类型转换侦听器
		 * @param event
		 */		
		private function __changeType(event:EmailIIEvent):void
		{
			_read.switchBtnsVisible(!(_model.mailType == EmailIIState.SENDED));
			
			updateListView();
		}
		
		private function __changeState(event:EmailIIEvent):void
		{
			if(_model.state == EmailIIState.READ)
			{
				addChild(_read);
				if(stage && stage.focus)
				{
					stage.focus == _read;
				}
				
				x = 91;
				y = 38;
				if(_write.parent)
				{
					removeChild(_write);
				}
			}
			else
			{
				x = 292;
				_write.x = -225;
				_write.selectInfo = _model.selectEmail;
				addChild(_write);
				if(stage && stage.focus)
				{
					stage.focus == _write;
				}
				if(_read.parent)
				{
					removeChild(_read);
				}
				
				if(_model.state == EmailIIState.WRITE)
				{
					_write.reset();
				}
			}	
		}
		
		private function __changePage(event:EmailIIEvent):void
		{
			updateListView();
		}
		
		private function __selectEmail(event:EmailIIEvent):void
		{
			_read.info = event.info;
			if(event.info == null) {
				_read.personalHide();
			}
			_read.readOnly = false;
			
			if(_model.mailType == EmailIIState.SENDED)
			{
				_read.isCanReply = (null) ? true : false;
				_read.readOnly = true;
				return;
			}
			
			_read.isCanReply = (_model.selectEmail) ? true : false;
		}
		
		private function __removeEmail(event:EmailIIEvent):void
		{
			updateListView();
		}
		
		private function __initEmail(event:EmailIIEvent):void
		{
			updateListView();
		}
		
		private function updateListView():void
		{
			_read.setListView(_model.getViewData(),_model.totalPage,_model.currentPage,_model.mailType == EmailIIState.SENDED);
		}
		
		/* bret 09.9.17 */
		public function get writeView():WritingView
		{
			return _write;
		}
	}
}