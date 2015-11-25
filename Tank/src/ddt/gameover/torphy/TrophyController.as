package ddt.gameover.torphy
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import ddt.manager.PlayerManager;
	import ddt.manager.StateManager;
	import ddt.states.StateType;
	import ddt.view.bagII.BagEvent;
	import ddt.view.common.CheckCodePanel;
	
	public class TrophyController extends EventDispatcher implements ITropyController
	{
		private var _view:TrophyPannelView;
		
		private var _model:TrophyModel;
	
		public function TrophyController()
		{
			init();
			createEvent();
			_view.update();
		}
		
		private function init():void
		{			
			_model = new TrophyModel(this);
			_view = new TrophyPannelView(this,_model);	
		}
		
		public function getView():Sprite
		{
			return _view;
		}
		
		private function createEvent():void
		{
			PlayerManager.Instance.Self.TempBag.addEventListener(BagEvent.UPDATE,__update);
		}
		
		private function removeEvent():void
		{
			PlayerManager.Instance.Self.TempBag.removeEventListener(BagEvent.UPDATE,__update);
		}

		public function dispose():void
		{
			removeEvent();
			PlayerManager.Instance.Self.TempBag.clearnAll();
			if(_view)
			{
				_view.dispose();
			}
			_view = null;
			_model = null;
			
			if(!CheckCodePanel.Instance.isShowed)
			{
				CheckCodePanel.Instance.show();
				StateManager.setState(PlayerManager.gotoState);
				CheckCodePanel.Instance.addEventListener(Event.CLOSE,__checkCodeComplete);
			}else
			{
//				if(StateManager.currentStateType != StateType.MISSION_RESULT){
//					StateManager.setState(PlayerManager.gotoState);
//				} 
				dispatchEvent(new Event(Event.CLOSE));
			}
			
			function __checkCodeComplete(e:Event):void
			{
				CheckCodePanel.Instance.removeEventListener(Event.CLOSE,__checkCodeComplete);
			    StateManager.setState(PlayerManager.gotoState);
				dispatchEvent(new Event(Event.CLOSE));
			}
		}

		
		private function __update(event:BagEvent):void
		{
			_view.update();
		}
	}
}