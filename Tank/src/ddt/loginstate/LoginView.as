package ddt.loginstate
{
	import road.manager.SoundManager;
	
	import ddt.manager.JSHelper;
	import ddt.manager.SocketManager;
	import ddt.states.BaseStateView;
	import ddt.states.StateType;

	public class LoginView extends BaseStateView
	{
		private var _login:LoginPosView;
		
		override public function prepare():void
		{
			super.prepare();
		}
		
		override public function enter(prev:BaseStateView,data:Object = null):void
		{
			super.enter(prev,data);
			
			SocketManager.Instance.isLogin = false;
			_login = new LoginPosView();
			addChild(_login);
			SoundManager.Instance.playMusic("062");
		}
		
		override public function getType():String
		{
			return StateType.LOGIN;
		}
		
		override public function leaving(next:BaseStateView):void
		{
			_login.dispose();
			_login = null;
			super.leaving(next);
		}
		
		override public function removedFromStage():void
		{
			super.removedFromStage();
		}		
	}
}