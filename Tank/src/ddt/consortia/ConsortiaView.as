package ddt.consortia
{
	import flash.display.Sprite;
	
	import ddt.consortia.club.ConsortiaClubView;
	import ddt.consortia.consortiadiplomatism.ConsortiaDiplomatismView;
	import ddt.consortia.myconsortia.MyConsortiaView;
	import ddt.manager.ChatManager;
	
	public class ConsortiaView extends Sprite
	{
		private var _model             : ConsortiaModel;
		private var _consortiaClubView : ConsortiaClubView;
		private var _myConsortiaView   : MyConsortiaView;
		private var _constro           : ConsortiaControl;
		private var _consortiaDisplomatism : ConsortiaDiplomatismView;
		private var chat:Sprite;
		public function ConsortiaView(model : ConsortiaModel,contro : ConsortiaControl)
		{
			super();
			_model = model;
			_constro = contro;
			ChatManager.Instance.state = ChatManager.CHAT_CLUB_STATE;
		
			chat = ChatManager.Instance.view;
			init();
			
		}
		private function init() : void
		{
			_myConsortiaView = new MyConsortiaView(_model,_constro);
			_consortiaClubView = new ConsortiaClubView(_model,_constro);
			_consortiaDisplomatism = new ConsortiaDiplomatismView(this._model,_constro);
			_myConsortiaView.x = 8;
			_myConsortiaView.y = 31;
			_consortiaClubView.x = 3;
			_consortiaClubView.y = 25;
			_consortiaDisplomatism.x = 5;
			_consortiaDisplomatism.y = 25;
			addChild(_consortiaDisplomatism).visible = false;
			addChild(_consortiaClubView).visible = false;
			addChild(_myConsortiaView).visible = false;
			addChild(chat);
		}
	
		public function getViewBySate(state:String):IConsortiaViewPage
		{
		    if(state == ConsortiaControl.MYCONSORTIA_STATE)
			{
				return _myConsortiaView;
			}else if(state == ConsortiaControl.CLUBE_STATE)
			{
				return _consortiaClubView;
			}else if(state == ConsortiaControl.DIPLOMATISM_STATE)
			{
				return _consortiaDisplomatism;
			}
			return null
		}
		
		public function set viewState(state:String):void
		{
//			if(state == ConsortiaControl.MYCONSORTIA_STATE)
//			{
//				chat.y = 405;
//			}else if(state == ConsortiaControl.CLUBE_STATE)
//			{
//				chat.y = 412;//422
//			}else if(state == ConsortiaControl.DIPLOMATISM_STATE)
//			{
//				chat.y = 420;
//			}
		}
		
		public function dispose():void
		{
			_consortiaClubView.dispose();
			_consortiaClubView = null;
			_myConsortiaView.dispose();
			_myConsortiaView = null;
			_consortiaDisplomatism.dispose();
			_consortiaDisplomatism = null;
			_model = null;
			if(chat.parent)
			{
				removeChild(chat);
			}
			if(parent)
			{
				parent.removeChild(this);
			}
		}
		
		public function leaving() : void
		{
			
		}
		private function addEvent() : void
		{
			
		}

	}
}