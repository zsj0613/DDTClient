package ddt.manager
{
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import ddt.view.MouseClickTipView;
	
	public class StageFocusManager
	{
		private var _count          : int;
		private var _stage          : Stage;
		private var _setFocusLayer  : MouseClickTipView;
		private static var instance : StageFocusManager; 
		
		public static function Instance():StageFocusManager{
			if(instance == null){
				instance = new StageFocusManager();
			}
			return instance;
		}
		
		public function steup($state : Stage) : void
		{
			_stage = $state;
			_setFocusLayer = new MouseClickTipView();
			addEvent();
		}
		
		public function removeEvent() : void
		{
			_stage.removeEventListener(Event.DEACTIVATE,          __deactivateHandler);
			_stage.removeEventListener(Event.ACTIVATE,            __activateHandler);
//			_setFocusLayer.removeEventListener(MouseEvent.CLICK,  __onClickHandler);
			
		}
		public function addEvent() : void
		{
			_stage.addEventListener(Event.DEACTIVATE,          __deactivateHandler);
			_stage.addEventListener(Event.ACTIVATE,            __activateHandler);
//			_setFocusLayer.addEventListener(MouseEvent.CLICK,  __onClickHandler);
		}
		private function __deactivateHandler(evt : Event) : void
		{
//			TipManager.addToStageLayer(_setFocusLayer);
			_stage.addChild(_setFocusLayer);
		}
		private function __activateHandler(evt : Event) : void
		{
			if(_setFocusLayer.stage && _currentActiveObject)
			{
				_setFocusLayer.stage.focus = _currentActiveObject;
			}
			if(_setFocusLayer.parent)_setFocusLayer.parent.removeChild(_setFocusLayer);
//			_setFocusLayer.addEventListener(Event.ENTER_FRAME, __enterFrameHandler);
		}
		
		private function __enterFrameHandler(evt : Event) : void
		{
			_count ++;
			if(_count >= 2)
			{
				_setFocusLayer.removeEventListener(Event.ENTER_FRAME, __enterFrameHandler);
				if(_setFocusLayer.parent)_setFocusLayer.parent.removeChild(_setFocusLayer);
				_count = 0;
			}
		}
		private function __onClickHandler(evt : MouseEvent) : void
		{
			evt.stopImmediatePropagation();
			evt.stopPropagation();
		}
		
		private var _currentActiveObject:InteractiveObject
		public function setActiveFocus(activeObject:InteractiveObject):void
		{
			_currentActiveObject = activeObject;
		}
	}
}