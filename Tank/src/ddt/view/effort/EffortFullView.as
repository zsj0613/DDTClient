package ddt.view.effort
{
	import crazytank.view.effort.EffortFullBGAsset;
	
	import fl.controls.ScrollPolicy;
	
	import flash.events.MouseEvent;
	
	import road.data.DictionaryData;
	import road.manager.SoundManager;
	import road.ui.controls.SimpleGrid;
	
	import ddt.data.effort.EffortInfo;
	import ddt.manager.EffortManager;
	import ddt.manager.PlayerManager;

	public class EffortFullView extends EffortFullBGAsset
	{
		private var _recentlyList         :SimpleGrid;
		private var _recentlyInfoArray    :Array;
		private var _scheduleArray        :Array;
		private var _fullScaleStrip       :EffortScaleStrip;
		private var _integrationScaleStrip:EffortScaleStrip;
		private var _taskScaleStrip       :EffortScaleStrip;
		private var _roleScaleStrip       :EffortScaleStrip;
		private var _duplicateScaleStrip  :EffortScaleStrip;
		private var _combatScaleStrip     :EffortScaleStrip;
		private var fullArray             :Array;
		private var integrationArray      :Array;
		private var roleArray             :Array;
		private var taskArray             :Array;
		private var duplicateArray        :Array;
		private var combatArray           :Array;
		private var _controller:EffortController;
		public function EffortFullView(controller:EffortController)
		{
			_controller = controller;
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			updateItem();
			updateScheduleArray();
			_fullScaleStrip 	   = new EffortScaleStrip(fullArray.length,EffortCategoryTitleItem.FULL , 500 ,28 );
			_fullScaleStrip.setButtonMode(false);
			_fullScaleStrip.x = scaleStrip_pos.x;
			_fullScaleStrip.y = scaleStrip_pos.y;
			addChild(_fullScaleStrip);
			
			_roleScaleStrip = new EffortScaleStrip(roleArray.length,EffortCategoryTitleItem.PART ,240,28);
			_roleScaleStrip.x = _fullScaleStrip.x;
			_roleScaleStrip.y = _fullScaleStrip.y + 30;
			_roleScaleStrip.setButtonMode(true);
			addChild(_roleScaleStrip);
			
			_taskScaleStrip 	   = new EffortScaleStrip(taskArray.length,EffortCategoryTitleItem.TASK ,240,28);
			_taskScaleStrip.x = _roleScaleStrip.x + _roleScaleStrip.width + 20;
			_taskScaleStrip.y = _roleScaleStrip.y;
			_taskScaleStrip.setButtonMode(true);
			addChild(_taskScaleStrip);
			
			_duplicateScaleStrip 	   = new EffortScaleStrip(duplicateArray.length,EffortCategoryTitleItem.DUNGEON ,240,28);
			_duplicateScaleStrip.x = _roleScaleStrip.x;
			_duplicateScaleStrip.y = _roleScaleStrip.y + 30;
			_duplicateScaleStrip.setButtonMode(true);
			addChild(_duplicateScaleStrip);
			
			_combatScaleStrip   = new EffortScaleStrip(combatArray.length,EffortCategoryTitleItem.FIGHT ,240,28);
			_combatScaleStrip.x = _duplicateScaleStrip.x + _duplicateScaleStrip.width + 20;
			_combatScaleStrip.y = _duplicateScaleStrip.y;
			_combatScaleStrip.setButtonMode(true);
			addChild(_combatScaleStrip);
			
			_integrationScaleStrip      = new EffortScaleStrip(integrationArray.length,EffortCategoryTitleItem.INTEGRATION ,240,28);
			_integrationScaleStrip.x = _duplicateScaleStrip.x;
			_integrationScaleStrip.y = _duplicateScaleStrip.y + 30;
			_integrationScaleStrip.setButtonMode(true);
			addChild(_integrationScaleStrip);
			updateScaleStrip();
			
		}
		
		private function initEvent():void
		{
			_integrationScaleStrip.addEventListener(MouseEvent.CLICK , __scaleStripClick);
			_roleScaleStrip.addEventListener(MouseEvent.CLICK        , __scaleStripClick);
			_taskScaleStrip.addEventListener(MouseEvent.CLICK        , __scaleStripClick);
			_duplicateScaleStrip.addEventListener(MouseEvent.CLICK   , __scaleStripClick);
			_combatScaleStrip.addEventListener(MouseEvent.CLICK      , __scaleStripClick);
			
		}
		
		private function updateScheduleArray():void
		{
			var dic:DictionaryData = EffortManager.Instance.fullList;
			fullArray                = [];
			integrationArray         = [];
			roleArray       		 = [];
			taskArray       		 = [];
			duplicateArray     	     = [];
			combatArray        	     = [];
			for each(var i:EffortInfo in dic)
			{
				fullArray.push(i);
				switch(i.PlaceID)
				{
					case 0:
						integrationArray.push(i);
						break;
					case 1:
						roleArray.push(i);
						break;
					case 2:
						taskArray.push(i);
						break;
					case 3:
						duplicateArray.push(i);
						break;
					case 4:
						combatArray.push(i);
						break;
				}
			}
		}
		
		private function __scaleStripClick(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			switch(evt.currentTarget)
			{
				case _roleScaleStrip:
					_controller.currentRightViewType = 1;
					break;
				case _taskScaleStrip:
					_controller.currentRightViewType = 2;
					break;
				case _duplicateScaleStrip:
					_controller.currentRightViewType = 3;
					break;
				case _combatScaleStrip:
					_controller.currentRightViewType = 4;
					break;
				case _integrationScaleStrip:
					_controller.currentRightViewType = 5;
					break;
			}
		}
		
		private function getCurrentSchedule(arr:Array):int
		{
			var value:int = 0;
			if(EffortManager.Instance.isSelf)
			{
				for(var i:int = 0 ; i < arr.length ; i++)
				{
					if((arr[i] as EffortInfo).CompleteStateInfo)
					{
						value ++;
					}
				}
			}else
			{
				for(var j:int = 0 ; j < arr.length ; j++)
				{
					if(EffortManager.Instance.tempEffortIsComplete( (arr[j] as EffortInfo).ID) )
					{
						value ++;
					}
				}
			}
			return value;
		}
		
		private function updateScaleStrip():void
		{
			_fullScaleStrip.currentVlaue        = getCurrentSchedule(fullArray);
			_integrationScaleStrip.currentVlaue = getCurrentSchedule(integrationArray);
			_roleScaleStrip.currentVlaue        = getCurrentSchedule(roleArray);
			_taskScaleStrip.currentVlaue        = getCurrentSchedule(taskArray);
			_duplicateScaleStrip.currentVlaue   = getCurrentSchedule(duplicateArray);
			_combatScaleStrip.currentVlaue      = getCurrentSchedule(combatArray);
		}
		
		private function updateItem():void
		{
			cleanList();
			_recentlyList = new SimpleGrid(493,55,1);
			_recentlyList.verticalScrollPolicy = ScrollPolicy.OFF;
			_recentlyList.horizontalScrollPolicy = ScrollPolicy.OFF;
			_recentlyList.x = fullItem_pos.x;
			_recentlyList.y = fullItem_pos.y;
			if(EffortManager.Instance.isSelf)
			{
				_recentlyInfoArray = EffortManager.Instance.getNewlyCompleteEffort();
			}else
			{
				_recentlyInfoArray = EffortManager.Instance.getTempNewlyCompleteEffort();
			}
			for each(var info:EffortInfo in _recentlyInfoArray)
			{
				if(_recentlyList && _recentlyList.itemCount >= 4)break;
				var i:EffortFullItemView = new EffortFullItemView(info);
				_recentlyList.appendItem(i);
			}
			_recentlyList.drawNow();
			_recentlyList.setSize(fullItem_pos.width , fullItem_pos.height);
			addChild(_recentlyList);
		}
		
		private function cleanList():void
		{
			if(_recentlyList)
			{
				for(var i:int = 0;i<_recentlyList.itemCount;i++)
				{
					_recentlyList.items[i].dispose();
				}
				_recentlyList.clearItems();
			}
			if(_recentlyList && _recentlyList.parent)
				_recentlyList.parent.removeChild(_recentlyList);
			_recentlyList = null;
		}
		
		public function dispose():void
		{
			cleanList();
			if(_fullScaleStrip)
			{
				_fullScaleStrip.parent.removeChild(_fullScaleStrip);
				_fullScaleStrip.dispose()
				_fullScaleStrip = null;
			}
			
			if(_integrationScaleStrip)
			{
				_integrationScaleStrip.parent.removeChild(_integrationScaleStrip);
				_integrationScaleStrip.dispose()
				_integrationScaleStrip = null;
			}
			if(_roleScaleStrip)
			{
				_roleScaleStrip.parent.removeChild(_roleScaleStrip);
				_roleScaleStrip.dispose()
				_roleScaleStrip = null;
			}
			if(_taskScaleStrip)
			{
				_taskScaleStrip.parent.removeChild(_taskScaleStrip);
				_taskScaleStrip.dispose()
				_taskScaleStrip = null;
			}
			if(_duplicateScaleStrip)
			{
				_duplicateScaleStrip.parent.removeChild(_duplicateScaleStrip);
				_duplicateScaleStrip.dispose()
				_duplicateScaleStrip = null;
			}
			if(_combatScaleStrip)
			{
				_combatScaleStrip.parent.removeChild(_combatScaleStrip);
				_combatScaleStrip.dispose()
				_combatScaleStrip = null;
			}
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
		}
	}
}