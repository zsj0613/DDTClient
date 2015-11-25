package ddt.data
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import ddt.manager.StateManager;
	import ddt.manager.UserGuideManager;
	import ddt.states.StateType;

	public class UserGuideStep extends EventDispatcher
	{
		public static const STEP_COMPLETE:String = "stepComplete"
		public function UserGuideStep(step:int,target:IEventDispatcher=null)
		{
			super(target);
		}
		private var _step:int
		public function load():void{
			UserGuideManager.Instance.stage.addEventListener(Event.ENTER_FRAME,__onEnterFrame);
		}
		private function __onEnterFrame(e:Event):void{
			if(validate()){
				dispatchEvent(new Event(UserGuideStep.STEP_COMPLETE));
			}
		}
		private function validate():Boolean{
			switch(_step){
				case 1:
					if(StateManager.currentStateType == StateType.ROOM_LIST){
						return true;
					}else{
						return false;
					}
				default:
					return false;
			}
		}
	}
}