package ddt.view.common
{
	import com.trainer.asset.QuestionAsset;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import road.manager.SoundManager;
	import road.ui.controls.SimpleGrid;
	import road.ui.controls.hframe.HFrame;
	import road.utils.ComponentHelper;
	
	import ddt.data.RegisterDropInfo;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.manager.ItemManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.SocketManager;
	import ddt.manager.StatisticManager;
	import ddt.request.GetRegisterDropList;
	import ddt.view.taskII.TaskAwardCell;

	public class UserGuideQuestionView extends HFrame
	{
		private var _NO : int ;
		private var _list : SimpleGrid;
		private var _currentItem : UserGuideQuestionAnswerView;
		private var _asset : QuestionAsset;
		private var _answer : int;
		private var _cell   : TaskAwardCell;
		private var dropList:Dictionary;
		
		public function UserGuideQuestionView($no:int)
		{
			super();
			_NO = $no;
			_asset = new QuestionAsset();
			this.addContent(_asset);
			this.showClose = false;
			this.moveEnable = false;
			this.titleText = LanguageMgr.GetTranslation("ddt.view.common.newAnwserTitle");
			this.setContentSize(398,336);
			this.showBottom = false;
			
			_asset.y = -5;
			
			_list = new SimpleGrid(380,38,1);
			_list.setSize(386,104);
			_list.horizontalScrollPolicy = "off";
			_list.verticalScrollPolicy   = "off";
			_asset.addChild(_list);
			_list.x = 12;
			_list.y = 122;
			
			new GetRegisterDropList().loadSync(__resultRegisterDropList);
		}
		private function __resultRegisterDropList(action : GetRegisterDropList) : void
		{
			dropList = new Dictionary(true);
			var tempArr:Array = action.list
			for each(var item:RegisterDropInfo in tempArr)
			{
				var info : InventoryItemInfo =  getTemplateInfo(item.ItemId) as InventoryItemInfo;
				info.Count = item.BeginData;
				info.IsBinds = item.IsBind;
				info.BindType = (item.IsBind ? 1 : 0);
				info.ValidDate = item.ValueDate;
				info.IsJudge = true;
				dropList[item.DropId] = info;
			}
			upView();
			show();
			this.x += 140;
		}
		public function set answer(a : int) : void
		{
			_answer = a;
		}
		public function get answer() : int
		{
			return _answer;
		}
		private function getTemplateInfo(id : int) : ItemTemplateInfo
		{
			var itemInfo : InventoryItemInfo = new InventoryItemInfo();
			itemInfo.TemplateID = id;
			ItemManager.fill(itemInfo);
			return itemInfo;
		}
		private function upView() : void
		{
			clearList();
			var arr : Array;
			_cell = new TaskAwardCell();
			if(_NO == 3)
			{
				arr = [LanguageMgr.GetTranslation("ddt.view.common.newQuestion1"),
				LanguageMgr.GetTranslation("ddt.view.common.newAnwser1"),
				LanguageMgr.GetTranslation("ddt.view.common.newAnwser2")
				];
//				arr = ['强化的作用是什么？','提高装备属性。','提高自身的血量。']
				_cell.info = dropList[3];
				_cell.count = (dropList[3] as InventoryItemInfo).Count; 
			}
			else if(_NO == 4)
			{
				arr = [LanguageMgr.GetTranslation("ddt.view.common.newQuestion2"),
				LanguageMgr.GetTranslation("ddt.view.common.newAnwser3"),
				LanguageMgr.GetTranslation("ddt.view.common.newAnwser4")
				];
//				arr = ['神恩符的作用是什么？','防止装备强化等级下降属性降低。','可以让你获得好运气。'];
				_cell.info = dropList[4];
				_cell.count = (dropList[4] as InventoryItemInfo).Count;
			}
			ComponentHelper.replaceChild(_asset,_asset.cellPos,_cell);
			_cell.width = 160;
			_cell.x = 110;
			_cell.y = 264
			for(var i:int=1;i<arr.length;i++)
			{
				var item : UserGuideQuestionAnswerView = new UserGuideQuestionAnswerView(i);
				_list.appendItem(item);
				item.IconAsset.gotoAndStop(i);
				item.title = arr[i].toString();
				item.addEventListener(MouseEvent.CLICK, __itemClickHandler);
			}
			_asset.title_txt.text = String(arr[0]);
		}
		private function __itemClickHandler(evt : MouseEvent) : void
		{
			SoundManager.instance.play("008");
			if(_currentItem)_currentItem.isSelect = false;
			_currentItem = evt.currentTarget as UserGuideQuestionAnswerView;
			_currentItem.isSelect = true;
			if(answer == _currentItem.id)
			{
				SoundManager.instance.play("1001");
				this.dispatchEvent(new Event(Event.CLOSE));
				if(_NO == 3){
					SocketManager.Instance.out.sendUserGuideProgress(48);
					StatisticManager.Instance().startAction("answer3","yes");
				}
				if(_NO == 4){
					SocketManager.Instance.out.sendUserGuideProgress(49);
					StatisticManager.Instance().startAction("answer4","yes");
				}
			}
			else
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.userGuide.AnswerView.answerFail"));
			}
		}
		private function clearList() : void
		{
			for(var i:int=0;i<_list.itemCount;i++)
			{
				var item : UserGuideQuestionAnswerView = _list.items[i] as UserGuideQuestionAnswerView;
				item.removeEventListener(MouseEvent.CLICK, __itemClickHandler);
				item.dispose();
				item = null;
			}
			_list.clearItems();
			_currentItem = null;
		}
		private function __okFunction() : void
		{
			this.dispatchEvent(new Event(Event.CLOSE));
		}
		override public function dispose() : void
		{
			clearList();
			if(_list && _list.parent)
				_list.parent.removeChild(_list);
			_list = null;
			
			if(_cell)_cell.dispose();
			_cell = null;
			
			if(_asset.parent)_asset.parent.removeChild(_asset);
			
			_currentItem = null;
			
			
			super.dispose();
		}
	}
}