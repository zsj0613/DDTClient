package ddt.view.movement
{
	import flash.events.MouseEvent;
	
	import road.manager.SoundManager;
	import road.ui.controls.SimpleGrid;
	
	import ddt.data.MovementInfo;

	public class LeftListView extends SimpleGrid
	{
		private var _actives:Array;
		
		private var _strips:Array = [];
		
		internal function set actives(value:Array):void
		{
			_actives = value;
			update();
		}
		
		public function LeftListView(cellWidth:uint=100, cellHeight:uint=20, column:uint=1)
		{
			super(cellWidth, cellHeight, column);
			cellPaddingHeight = 1;
		}
		
		internal function update():void
		{
			clearList();
			for each(var i:MovementInfo in _actives)
			{
				var strip:MovementStripView = new MovementStripView();
				strip.addEventListener(MouseEvent.CLICK,__select,false,0,true);
				strip.info = i;
				appendItem(strip);
				_strips.push(strip);
			}
//			if(_actives[0])
//			{	
//				_strips[0].select = true;
//				MovementLeftView.Instance.model.currentInfo = _actives[0];
//			}
		}
		private function clearList() : void
		{
			for(var i:int=0;i<_strips.length;i++)
			{
				var strip:MovementStripView = _strips[i] as MovementStripView;
				strip.removeEventListener(MouseEvent.CLICK,__select);
				removeItem(strip);
				strip.dispose();
				strip = null;
			}
			_strips = new Array();
		}
		
		private function __select(event:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			var target:MovementStripView = event.target as MovementStripView;
			MovementLeftView.Instance.model.currentInfo = target.info;
			for each(var strip:MovementStripView in _strips)
			{
				strip.select = (target == strip);
			}
		}
		
		internal function dispose():void
		{
			clearList();
		}
		
		
	}
}