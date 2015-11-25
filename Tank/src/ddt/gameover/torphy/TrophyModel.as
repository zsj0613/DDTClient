package ddt.gameover.torphy
{
	import flash.events.EventDispatcher;
	
	import ddt.data.goods.ItemTemplateInfo;
	
	public class TrophyModel
	{
		private var _controller:ITropyController;
		
		public function TrophyModel(controller:ITropyController)
		{
			_controller = controller;
		}
	}
}