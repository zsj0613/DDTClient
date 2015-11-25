package ddt.store.events
{
	import fl.controls.progressBarClasses.IndeterminateBar;
	
	import flash.events.Event;

	public class ChoosePanelEvnet extends Event
	{
		public static const CHOOSEPANELEVENT:String = "ChoosePanelEvent";
		private var _currentPanel:int;
		public function ChoosePanelEvnet(currentPanel:int)
		{
			this._currentPanel = currentPanel;
			super(CHOOSEPANELEVENT,true);
		}
		
		public function get currentPanle():int
		{
			return _currentPanel;
		}
	}
}