package ddt.view.common
{
	import game.crazyTank.view.common.SimpleLoadingAsset;
	
	import road.ui.manager.TipManager;
	import road.ui.manager.UIManager;
	public class SimpleLoading extends SimpleLoadingAsset
	{
		
		private static var _instance:SimpleLoading;
		public function SimpleLoading()
		{
		}
		public static function get instance():SimpleLoading
		{
			if(_instance == null)
			{
				_instance = new SimpleLoading();
				UIManager.setChildCenter(instance);
			}
			return _instance;
		}
		
		public function show(showOnTipLayer:Boolean = false):void
		{
			if(showOnTipLayer)
			{
				TipManager.AddTippanel(instance,true);
			}else
			{
				UIManager.AddDialog(instance);
			}
		}
		
		public function hide():void
		{
			if(instance.parent)instance.parent.removeChild(instance);
		}
		
		public function dispose():void
		{
			if(instance.parent)instance.parent.removeChild(instance);
		}

	}
}