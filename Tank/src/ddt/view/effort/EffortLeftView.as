package ddt.view.effort
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import road.manager.SoundManager;
	
	import ddt.events.EffortEvent;
	import ddt.manager.EffortManager;
	
	public class EffortLeftView extends Sprite
	{
		private var _effortCategoryTitleItem:EffortCategoryTitleItem;
		private var _effortCategoryTitleItemArray:Array;
		private var _controller:EffortController;
		public function EffortLeftView(controller:EffortController)
		{
			_controller = controller;
			init();
			initEvent();
		}
		
		private function init():void
		{
			_effortCategoryTitleItemArray = [];
			for(var i:int = 0 ; i<= 5 ; i++)
			{
				var	effortCategoryTitleItem:EffortCategoryTitleItem = new EffortCategoryTitleItem(i);
				effortCategoryTitleItem.y = i*effortCategoryTitleItem.contentHeight;
				effortCategoryTitleItem.addEventListener(MouseEvent.CLICK	,__CategoryTitleClick);
				_effortCategoryTitleItemArray.push(effortCategoryTitleItem);
				addChild(effortCategoryTitleItem);
			}
			_controller.currentRightViewType = _controller.currentRightViewType;
		}
		
		private function initEvent():void
		{
			EffortManager.Instance.addEventListener(EffortEvent.TYPE_CHANGED , __typeChanged);
			_controller.addEventListener(Event.CHANGE , __rightChange);
		}
		
		private function __CategoryTitleClick(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			if(!_effortCategoryTitleItem)_effortCategoryTitleItem =  evt.currentTarget as EffortCategoryTitleItem;
			if(_effortCategoryTitleItem != evt.currentTarget as EffortCategoryTitleItem)
			{
				_effortCategoryTitleItem.ChildCategory = false;
				_effortCategoryTitleItem.selectState   = false;
			}
			_effortCategoryTitleItem = evt.currentTarget as EffortCategoryTitleItem;
			_effortCategoryTitleItem.selectState = _effortCategoryTitleItem.isExpand ? false : true;
			for(var j:int = 1 ; j<= 5 ; j++)
			{
				(_effortCategoryTitleItemArray[j] as EffortCategoryTitleItem).y = (_effortCategoryTitleItemArray[j-1] as EffortCategoryTitleItem).contentHeight+(_effortCategoryTitleItemArray[j-1] as EffortCategoryTitleItem).y;
			}
			if(_controller.currentRightViewType != (evt.currentTarget as EffortCategoryTitleItem).currentType)
			{
				_controller.currentRightViewType = (evt.currentTarget as EffortCategoryTitleItem).currentType;
			}
			__rightChange();
		}
		
		private function __rightChange(evt:Event = null):void
		{
			if(_effortCategoryTitleItem)
			{
				_effortCategoryTitleItem.ChildCategory = false;
				_effortCategoryTitleItem.selectState   = false;
			}
			_effortCategoryTitleItem = _effortCategoryTitleItemArray[_controller.currentRightViewType] as EffortCategoryTitleItem;
			_effortCategoryTitleItem.ChildCategory = _effortCategoryTitleItem.isExpand ? false : true;
			_effortCategoryTitleItem.selectState   = _effortCategoryTitleItem.isExpand ? false : true;
		}
		
		private function __typeChanged(evt:Event):void
		{
			_controller.currentRightViewType = _controller.currentRightViewType;
		}
		
		private function disposeItem():void
		{
			if(!_effortCategoryTitleItemArray)return;
			for(var i:int = 0 ; i <_effortCategoryTitleItemArray.length ; i++)
			{
				(_effortCategoryTitleItemArray[i] as EffortCategoryTitleItem).parent.removeChild((_effortCategoryTitleItemArray[i] as EffortCategoryTitleItem));
				(_effortCategoryTitleItemArray[i] as EffortCategoryTitleItem).removeEventListener(MouseEvent.CLICK , __CategoryTitleClick);
				(_effortCategoryTitleItemArray[i] as EffortCategoryTitleItem).dispose();
				_effortCategoryTitleItemArray[i] = null;
			}
		}
		
		public function dispose():void
		{
			disposeItem();
			EffortManager.Instance.removeEventListener(EffortEvent.TYPE_CHANGED , __typeChanged);
			_controller.removeEventListener(Event.CHANGE , __rightChange);
			if(_effortCategoryTitleItem)
			{
				_effortCategoryTitleItem.dispose();
				_effortCategoryTitleItem = null;
			}
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
		}

	}
}