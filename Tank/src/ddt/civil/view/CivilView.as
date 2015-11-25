package ddt.civil.view
{
	import ddt.civil.CivilControler;
	import ddt.civil.CivilModel;
	
	import flash.display.Sprite;
	
	import tank.civil.CivilBgAsset;
	import ddt.manager.ChatManager;
	
	public class CivilView extends CivilBgAsset
	{
		private var _civilLeftView   : CivilLeftView;
		private var _civilRightView  : CivilRightView;
		private var _controler	     : CivilControler;
		private var _model     		 : CivilModel;
		private var _chatFrame       : Sprite;
		public function CivilView(controler:CivilControler,model:CivilModel)
		{
			_controler = controler;
			_model     = model;
			init();
		}
		
		private function init():void
		{
			_civilLeftView    = new CivilLeftView(_controler, _model);
			_civilRightView   = new CivilRightView(_controler,_model);
			_civilLeftView.x  = this.leftViewPos.x;
			_civilLeftView.y  = this.leftViewPos.y;
			_civilRightView.x = this.rightViewPos.x;
			_civilRightView.y = this.rightViewPos.y;
			ChatManager.Instance.state = ChatManager.CHAT_CIVIL_VIEW;
			_chatFrame        = ChatManager.Instance.view;
			addChild(_civilLeftView);
			addChild(_civilRightView);
			addChild(_chatFrame);
			removeChild(leftViewPos);
			removeChild(rightViewPos);
		}
		
		public function dispose():void
		{
			if(_civilLeftView)
			{
				removeChild(_civilLeftView);
				_civilLeftView.dispose();
			}
			_civilLeftView = null;
			if(_civilRightView)
			{
				removeChild(_civilRightView);
				_civilRightView.dispose();
			}
			_civilRightView = null;
		}

	}
}