package ddt.view.effort
{
	import flash.events.MouseEvent;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.hframe.HAlertDialog;
	
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.data.quest.QuestInfo;
	import ddt.data.quest.QuestItemReward;
	import ddt.events.EffortEvent;
	import ddt.events.TaskEvent;
	import ddt.manager.EffortManager;
	import ddt.manager.ItemManager;
	import ddt.manager.TaskManager;
	import ddt.view.taskII.TaskAwardCell;
	import tank.view.effort.EffortTaskAsset;
	
	public class EffortTaskView extends EffortTaskAsset
	{
		private var _getHortationBtn:HBaseButton;
		private var _cell:TaskAwardCell;
		private var _questInfo:QuestInfo;
		private var _itemTemplateinfo:ItemTemplateInfo;
		public function EffortTaskView()
		{
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			light_mc.visible = false;
			_questInfo = TaskManager.achievementQuest;
			if(!_questInfo)
			{
				HAlertDialog.show("提示","成就任务为空");
				return;
			}
			_cell = new TaskAwardCell();
			_cell.x = cell_pos.x;
			_cell.y = cell_pos.y;
			var tempItem:QuestItemReward = _questInfo.itemRewards[0];
			var info:InventoryItemInfo = new InventoryItemInfo();
			info.ValidDate = tempItem.ValidateTime;
			info.TemplateID = tempItem.itemID;
			info.IsJudge = true;
			info.IsBinds = tempItem.isBind;
			info.AttackCompose = tempItem.AttackCompose;
			info.DefendCompose = tempItem.DefendCompose;
			info.AgilityCompose = tempItem.AgilityCompose;
			info.LuckCompose = tempItem.LuckCompose;
			info.StrengthenLevel = tempItem.StrengthenLevel;
			ItemManager.fill(info);
			if(info && info.TemplateID != 0)
			{
				_cell.visible = true;
				_cell.info = info;
				_cell.count = tempItem.count;
				if(tempItem.IsCount && _questInfo.data && _questInfo.data.quality){
					_cell.count = tempItem.count * _questInfo.data.quality;
				}
			}
			addChild(_cell);
			_getHortationBtn = new HBaseButton(GetHortationBtn_mc);
			_getHortationBtn.useBackgoundPos = true;
			_getHortationBtn.enable = false;
			addChild(_getHortationBtn);
			updateText();
		}
		
		private function updateText():void
		{
			if(!_questInfo)return;
			detail_txt.text = _questInfo.Detail;
			var currentValue:int = _questInfo._conditions[0].param2 - _questInfo.data.progress[0];
			currentValue = currentValue > _questInfo._conditions[0].param2 ? currentValue : _questInfo._conditions[0].param2;
			progress_txt.text = "("+ String( _questInfo._conditions[0].param2 - _questInfo.data.progress[0] ) +"/"+  String(_questInfo._conditions[0].param2)  +")"
			btnEnable()
		}
		
		private function btnEnable():void
		{
			if(!_questInfo || !_getHortationBtn)return;
			if(_questInfo.data.progress[0] <= 0)
			{
				_getHortationBtn.enable = true;
				light_mc.visible = true;
				light_mc.play();
			}else
			{
				_getHortationBtn.enable = false;
				light_mc.visible = false;
				light_mc.stop();
			}
		}
		
		private function initEvent():void
		{
			_getHortationBtn.addEventListener(MouseEvent.CLICK , __btnClick);
			TaskManager.addEventListener(TaskEvent.CHANGED , __update);
		}
		
		private function __update(evt:TaskEvent):void
		{
			updateText();
			btnEnable()
		}
		
		private function __btnClick(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			if(_questInfo)
			{
				TaskManager.requestAchievementReward();
				updateText();
			}
		}
		
		public function dispose():void
		{
			TaskManager.removeEventListener(TaskEvent.CHANGED , __update);
			if(_getHortationBtn && _getHortationBtn.parent)
			{
				_getHortationBtn.removeEventListener(MouseEvent.CLICK , __btnClick);
				_getHortationBtn.parent.removeChild(_getHortationBtn)
				_getHortationBtn.dispose();
				_getHortationBtn = null;
			}
			if(_cell && _cell.parent)
			{
				_cell.parent.removeChild(_cell);
				_cell.dispose();
				_cell = null;
			}
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
		}
	}
}