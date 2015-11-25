package ddt.view.dailyconduct
{
	import com.dailyconduct.view.DailyConductBgAsset;
	
	import flash.events.Event;
	
	import road.ui.controls.SimpleGrid;
	import road.utils.ComponentHelper;
	
	import ddt.data.MovementInfo;
	import ddt.view.common.SimpleLoading;
	import ddt.view.movement.MovementModel;

	public class DailyMovementList
	{
		private var _list    : SimpleGrid;
		private var _context : DailyMovementContext;
		private var _parent  : DailyConductBgAsset;
		private var _currentItem : DailyMovementItem;
		public function DailyMovementList($parent : DailyConductBgAsset)
		{
			_parent = $parent;
			super();
			init();
			addEvent();
		}
		
		private function init() : void
		{
			_list = new SimpleGrid(_parent.pos2.width,25);
			_list.horizontalScrollPolicy = "off";
			_list.verticalScrollPolicy   = "auto";
			ComponentHelper.replaceChild(_parent,_parent.pos2,_list);
			
			_context = new DailyMovementContext(_parent);
			SimpleLoading.instance.show(false);
			if(MovementModel.Instance.actives)
			{
				SimpleLoading.instance.hide();
			}
//			__displayerListHandler(null);
//			ComponentHelper.replaceChild(_parent,_parent.pos4,_context);
			
		}
		private function addEvent() : void
		{
			MovementModel.Instance.addEventListener(Event.COMPLETE,  __displayerListHandler);
			_parent.addEventListener(Event.ADDED_TO_STAGE,__onAddToStage);
		}
		private function removeEvent() : void
		{
			MovementModel.Instance.removeEventListener(Event.COMPLETE,  __displayerListHandler);
			_parent.removeEventListener(Event.ADDED_TO_STAGE,__onAddToStage);
		}
		private function __displayerListHandler(evt : Event) : void
		{
			if(!MovementModel.Instance.actives)return;
			clearList();
			var data : Array = MovementModel.Instance.actives;
			for each(var i:MovementInfo in data)
			{
				var item : DailyMovementItem = new DailyMovementItem();
				item.info = i;
				item.addEventListener(DailyConductEvent.LINK,  __onClickItemHandler);			
				_list.appendItem(item);
			}
			if(_list.getItemAt(0) is DailyMovementItem)
			displayerMovementContext((_list.getItemAt(0) as DailyMovementItem));
			SimpleLoading.instance.hide();
		}
		
		private function __onAddToStage(e:Event):void
		{
			__displayerListHandler(null);
		}
		
		
		private function clearList() : void
		{
			if(_list)
			{
				_currentItem = null;
				for each(var item : DailyMovementItem in _list.items)
				{
					item.removeEventListener(DailyConductEvent.LINK,  __onClickItemHandler);
					item.dispose();
					item = null;
				}
				_list.clearItems();
			}
		}
		public function dispose() : void
		{
			removeEvent();
			
			clearList();
			
			if(_list && _list.parent)_list.parent.removeChild(_list);
			_list = null;
			
			if(_context)
				_context.dispose();
			_context = null;
			
			_parent = null;
		}
		
		private function __onClickItemHandler(evt : DailyConductEvent) : void
		{
			var item : DailyMovementItem = evt.currentTarget as DailyMovementItem;
			displayerMovementContext(item);
		}
		
		private function displayerMovementContext($item : DailyMovementItem): void
		{
			if(!$item)return;
			
			if(_currentItem)
				_currentItem.selectState = false;
				
			_currentItem = $item;
			
			if(_currentItem)
				_currentItem.selectState = true;
			
			if(!$item.info)return;
			
			_context.info = $item.info;
		}
	}
}