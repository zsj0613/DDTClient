package ddt.view.effort
{
	import fl.containers.ScrollPane;
	import fl.controls.ScrollPolicy;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import road.manager.SoundManager;
	import road.ui.controls.SimpleGrid;
	
	import ddt.data.effort.EffortInfo;
	import ddt.events.EffortEvent;
	import ddt.manager.EffortManager;

	public class EffortRightView extends Sprite
	{
		private var effortRigthItemArray:Array;
		private var _currentListArray:Array;
		private var _contentList:ScrollPane;
		private var _content:Sprite;
		private var _currentSelectItem:EffortRigthItemView;
		private var _controller:EffortController;
		public function EffortRightView(controller:EffortController)
		{
			_controller = controller;
			init();
			initEvent();
		}
		
		private function init():void
		{
			initScrollPane();
			setCurrentList(EffortManager.Instance.currentEffortList);
		}
		
		private function initScrollPane():void
		{
			_contentList = new ScrollPane();
			_contentList.setSize(510,446);
			_contentList.verticalScrollPolicy = ScrollPolicy.ON;
			_contentList.horizontalScrollPolicy = ScrollPolicy.OFF;
			var myBg:Shape = new Shape();
			myBg.graphics.beginFill(0x000000,0);
			myBg.graphics.drawRect(0,0,10,10);
			myBg.graphics.endFill();
			_contentList.setStyle("upSkin",myBg);
			_content = new Sprite();
			_contentList.source = _content;
			addChild(_contentList);
		}
		
		private function initEvent():void
		{
			EffortManager.Instance.addEventListener(EffortEvent.LIST_CHANGED ,__listChanged);
		}
		
		private function __listChanged(evt:EffortEvent):void
		{
			setCurrentList(EffortManager.Instance.currentEffortList);
		}
		
		private function updateCurrentList():void
		{
			if(!_contentList)
			{
				disposeItems();
				initScrollPane();
			}
			for(var i:int = 0 ; i<=_currentListArray.length ;i++)
			{
				if(_currentListArray[i])
				{
					var effortRigthItem:EffortRigthItemView = new EffortRigthItemView(_currentListArray[i]);
					effortRigthItem.addEventListener(MouseEvent.CLICK   , __itemClick);
					effortRigthItemArray.push(effortRigthItem);
					_content.addChild(effortRigthItem);
				}
			}
			updateItem();
			updateScrollPolicy();
		}
		
		public function updateItem():void
		{
			for(var i:int = 0 ; i < effortRigthItemArray.length ; i++ )
			{
				if(!effortRigthItemArray[i+1])
				{
					updateScrollPolicy();
					return;
				}
				(effortRigthItemArray[i+1] as EffortRigthItemView).y = (effortRigthItemArray[i] as EffortRigthItemView).y + (effortRigthItemArray[i] as EffortRigthItemView).height;
			}
		}
		
		public function setCurrentList(list:Array):void
		{
			_currentListArray = [];
			disposeItems();
			effortRigthItemArray = [];
//			_currentListArray = list;
			var temList:Array = list;
			var temInCompleteList:Array = [];
			temList.sortOn("ID",Array.DESCENDING);
			if(EffortManager.Instance.isSelf)
			{
				for( var i:int = 0 ; i < temList.length ; i++)
				{
					if((temList[i] as EffortInfo).CompleteStateInfo)
					{
						_currentListArray.unshift(temList[i]);
					}else
					{
						temInCompleteList.unshift(temList[i]);
					}
				}
				_currentListArray = _currentListArray.concat(temInCompleteList);
			}else
			{
				for( var j:int = 0 ; j < temList.length ; j++)
				{
					if(EffortManager.Instance.tempEffortIsComplete(temList[j].ID))
					{
						_currentListArray.unshift(temList[j]);
					}else
					{
						temInCompleteList.unshift(temList[j]);
					}
				}
				_currentListArray = _currentListArray.concat(temInCompleteList);
			}
			updateCurrentList();
		}
		
		private function updateScrollPolicy():void
		{
			if(effortRigthItemArray && effortRigthItemArray.length >=  6)
			{
				if(_contentList)_contentList.verticalScrollPolicy = ScrollPolicy.ON;
			}else
			{
				if(_contentList)_contentList.verticalScrollPolicy = ScrollPolicy.OFF;
			}
			if(_content && _content.height > 448)
			{
				if(_contentList)_contentList.verticalScrollPolicy = ScrollPolicy.ON;
			}
			if(_contentList)_contentList.update();
		}
		
		public function __itemClick(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			if(!_currentSelectItem)_currentSelectItem = evt.currentTarget as EffortRigthItemView;
			if(_currentSelectItem != evt.currentTarget as EffortRigthItemView)
			{
				_currentSelectItem.select = false;
			}
			_currentSelectItem = evt.currentTarget as EffortRigthItemView;
			_currentSelectItem.select = true;
			updateItem();
			_contentList.update();
		}
		
		private function disposeItems():void
		{
			if(_contentList && effortRigthItemArray)
			{
				for(var i:int = 0 ; i<effortRigthItemArray.length ; i++)
				{
					_content.removeChild(effortRigthItemArray[i]);
					effortRigthItemArray[i].removeEventListener(MouseEvent.CLICK   , __itemClick);
					effortRigthItemArray[i].dispose();
					effortRigthItemArray[i] = null;
				}
				if(_content && _content.parent)
				{
					_content.parent.removeChild(_content);
					_content = null;
				}
				if(_contentList && _contentList.parent)
				{
					_contentList.source = null;
					_contentList.parent.removeChild(_contentList);
					_contentList = null
				}
			}
		}
		
		public function dispose():void
		{
			EffortManager.Instance.removeEventListener(EffortEvent.LIST_CHANGED ,__listChanged);
			disposeItems();
			_currentListArray = null;
			effortRigthItemArray = null;
			if(_contentList)
			{
				_contentList.source = null;
				_contentList.parent.removeChild(_contentList);
				_contentList = null
			}
			if(_content && _content.parent)
			{
				_content.parent.removeChild(_content);
				_content = null;
			}
			if(_currentSelectItem)
			{
				_currentSelectItem.dispose();
				_currentSelectItem = null;
			}
		}  
	}
}