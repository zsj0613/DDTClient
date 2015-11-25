package ddt.civil
{
	import ddt.civil.view.CivilRegisterFrame;
	import ddt.civil.view.CivilView;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import road.ui.manager.TipManager;
	
	import ddt.data.player.CivilPlayerInfo;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.request.LoadCivilMemberList;
	import ddt.states.BaseStateView;
	import ddt.states.StateType;
	import ddt.view.common.BellowStripViewII;
	import ddt.view.common.SimpleLoading;

	public class CivilControler extends BaseStateView
	{
		private var _model     :CivilModel;
		private var _view	   :CivilView;
		private var _register  :CivilRegisterFrame;
		private var _container :Sprite;
		public function CivilControler()
		{
			super();
		}
		
		override public function prepare():void
		{
			super.prepare();
		}
		
		override public function enter(prev:BaseStateView, data:Object=null):void
		{
			super.enter(prev,data);
			
			SocketManager.Instance.out.sendCurrentState(1);
			
			init();
			BellowStripViewII.Instance.show();
		}
		
		private function init():void
		{
			_container = new Sprite();
			_model = new CivilModel();
			this.loadCivilMemberList(1,!PlayerManager.Instance.Self.Sex);
			_model.sex = !PlayerManager.Instance.Self.Sex;
			_view = new CivilView(this,_model);
			_container.addChild(_view);
		}
		
		public function Register():void
		{
			if(!_register)
			{
				_register = new CivilRegisterFrame(_model);
			}
		 	if(_register.parent)
		 	{
		 		_register.removeEvent();
		 		_register.dispose();
		 		_register.parent.removeChild(_register);
		 	}
		 	else 
		 	{
		 		TipManager.AddTippanel(_register,true);
		 		_register.addEvent();
		 	    
		 	}
		 	
		}
		
		override public function getView():DisplayObject
		{
			return _container;
		}
		
		public function get currentcivilInfo():CivilPlayerInfo
		{
			if(_model)
			{
				return _model.currentcivilItemInfo;
			}else
			{
				return null;
			} 
		}
		
		public function set currentcivilInfo(value:CivilPlayerInfo):void
		{
			if(_model)
			{
				_model.currentcivilItemInfo = value;
			}
		}
		
		/* 更新左边视图 */
		public function upLeftView(info:CivilPlayerInfo):void
		{
			if(_model)_model.currentcivilItemInfo = info;
//			_view.upLeftView();

		}
		
		/* 在视图那里调用这个方法，给 model 赋值 */
		public function loadCivilMemberList(page:int=0, sex:Boolean=true, name:String="") : void
		{
			new LoadCivilMemberList(page,sex,name).loadSync(__loadCivilMemberList);
		}
		private function __loadCivilMemberList(action : LoadCivilMemberList) : void
		{
//			if(action.civilMemberList)
			if(_model)
			{
				if(_model.TotalPage != action._totalPage)_model.TotalPage = action._totalPage;
				_model.civilPlayers = action.civilMemberList;
			}
		}
		
		override public function leaving(next:BaseStateView):void
		{
			super.leaving(next);
			if(SimpleLoading && SimpleLoading.instance)
			{
				SimpleLoading.instance.hide();
			}
			dispose();
		}
		
		override public function getType():String
		{
			return StateType.CIVIL;
		}
		
		override public function getBackType():String
		{
			return StateType.MAIN;
		}
		
		override public function dispose():void
		{
			_model.dispose();
			_model = null;
//			_view.dispose();
//			_view = null;
			if(_register)
			{
				_register.dispose();
				_register = null;
			}
		}
	}
}