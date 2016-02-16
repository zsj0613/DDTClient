package ddt.view.dailyconduct
{
	import com.dailyconduct.view.DailyConductBgAsset;
	import com.dailyconduct.view.DayGetItemAsset;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import road.manager.SoundManager;
	import road.ui.controls.SimpleGrid;
	import road.ui.controls.HButton.HFrameButton;
	import road.utils.ComponentHelper;
	import road.utils.StringHelper;
	
	import ddt.data.DaylyGiveInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.manager.ItemManager;
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.request.LoadDaylyGiveTemplete;
	import ddt.utils.LeavePage;
	import ddt.view.DownloadingView;
	
	public class DayGetList
	{
		private var _parent : DailyConductBgAsset;
		private var _list   : SimpleGrid;
//		private var _clientList:SimpleGrid;
//		private var _dayGet : HBaseButton;
		private var _getAllBtn : HFrameButton;
		
		private var _enableClientGetBtn:Boolean = false;
		
		public function DayGetList($parent : DailyConductBgAsset)
		{
			_parent = $parent;
			init();
		}
		private function init() : void
		{
			_list = new SimpleGrid(_parent.pos1.width,17);
			_list.setSize(_parent.pos1.width,_parent.pos1.height);
			_list.horizontalScrollPolicy = "off";
			_list.verticalScrollPolicy   = "auto";
			ComponentHelper.replaceChild(_parent,_parent.pos1,_list);
			
//			_clientList = new SimpleGrid(_parent.pos5.width, 17);
//			_clientList.setSize(_parent.pos5.width, _parent.pos5.height);
//			_clientList.horizontalScrollPolicy = "off";
//			_clientList.verticalScrollPolicy = "auto";
//			ComponentHelper.replaceChild(_parent,_parent.pos5,_clientList);
//			
//			updateAllGetBtnClient();
			updateAllGetBtn();
			
			_parent.btnEffect.visible = DailyConductFrame.isDayGet;
			_parent.btnEffect.mouseChildren = _parent.btnEffect.mouseEnabled = false;
			_parent.allGetBtn.buttonMode = DailyConductFrame.isDayGet;
			_parent.allGetBtn.addEventListener(MouseEvent.CLICK,  __onClickHandler);
			_parent.allGetBtn.addEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);
			
//			_parent.btnEffectClient.visible = (DailyConductFrame.isClientGet && _enableClientGetBtn);
//			_parent.btnEffectClient.mouseChildren = _parent.btnEffectClient.mouseEnabled = false;
//			_parent.allGetBtnClient.buttonMode = (DailyConductFrame.isClientGet && _enableClientGetBtn);
//			_parent.allGetBtnClient.addEventListener(MouseEvent.CLICK,  __onClickClientHandler);
//			_parent.allGetBtnClient.addEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);
			
			DailyConductFrame.dispatcher.addEventListener(Event.CHANGE, __dailyBtnChange);
			DailyConductFrame.dispatcher.addEventListener(Event.COMPLETE, __dailyBtnChange);
			setup();
		}
		
		private function __dailyBtnChange(evt : Event) : void
		{
			__addToStageHandler(null);
		}
		
		/* 客户端领取 */
		private function __onClickClientHandler(e:MouseEvent):void
		{
			var isClientLogin:Boolean = LeavePage.IsDesktopApp; 
			SoundManager.Instance.play("008");
			
			if(isClientLogin)
			{
				SocketManager.Instance.out.sendDailyAward(1);
//				_parent.btnEffectClient.visible = false;
				_parent.allGetBtnClient.mouseChildren = false;
				_parent.allGetBtnClient.mouseEnabled  = false;
				DailyConductFrame.isClientGet = false;
//				updateAllGetBtnClient();
			}
			else
			{
				if(PathManager.hasClientDownland())
				{
					var view:DownloadingView = new DownloadingView();
					_parent.stage.addChild(view);
				}
			}
		}
		
		private function __onClickHandler(evt : MouseEvent) : void
		{
			SoundManager.Instance.play("008");
			SocketManager.Instance.out.sendDailyAward(0);
			_parent.btnEffect.visible = false;
			_parent.allGetBtn.mouseChildren = false;
			_parent.allGetBtn.mouseEnabled  = false;
			_parent.allGetBtn.gotoAndStop(2);
			DailyConductFrame.isDayGet = false;
		}
		private function __addToStageHandler(evt : Event) : void
		{
			if(_parent && _parent.btnEffect)
			{
//				updateAllGetBtnClient();
				
				updateAllGetBtn();
			}
			if(!_data)
			{
				new LoadDaylyGiveTemplete().loadSync(__resultHandler,3);
			}
		}
		
		private function updateAllGetBtn():void
		{
			_parent.btnEffect.visible = DailyConductFrame.isDayGet;
			_parent.allGetBtn.buttonMode = DailyConductFrame.isDayGet;
			_parent.allGetBtn.mouseChildren = DailyConductFrame.isDayGet;
			_parent.allGetBtn.mouseEnabled  = DailyConductFrame.isDayGet;
			if(DailyConductFrame.isDayGet)
			{
				_parent.allGetBtn.gotoAndStop(1);
			}
			else
			{
				_parent.allGetBtn.gotoAndStop(2);
			}
		}
		
		private function updateAllGetBtnClient():void
		{
//			_parent.btnEffectClient.visible = (DailyConductFrame.isClientGet && _enableClientGetBtn);
//			_parent.allGetBtnClient.buttonMode = (DailyConductFrame.isClientGet && _enableClientGetBtn);
//			_parent.allGetBtnClient.mouseChildren = (DailyConductFrame.isClientGet && _enableClientGetBtn);
//			_parent.allGetBtnClient.mouseEnabled = (DailyConductFrame.isClientGet && _enableClientGetBtn);
			
			if(_enableClientGetBtn)
			{
				if(DailyConductFrame.isClientGet)
				{
					_parent.allGetBtnClient.gotoAndStop(1);
				}
				else
				{
					_parent.allGetBtnClient.gotoAndStop(2);
				}
			}
			else
			{
				_parent.allGetBtnClient.gotoAndStop(3);
			}
		}
		
		public function setup():void
		{
			//if(!_data)
			//{
			//	new LoadDaylyGiveTemplete().loadSync(__resultHandler,3);
			//}
			//else
			//{
				show();
			//}
		}
		
		private function __resultHandler(action : LoadDaylyGiveTemplete) : void
		{
			_data = action.list;
			action.list = null;
			show();
		}
		
		private var _data : Array;
		public function get data() : Array
		{
			return _data;
		}
		
		private function show ():void
		{
			if(_data == null || !_list) return;
		//	var sex:int =  PlayerManager.Instance.Self.Sex ? 1 : 2;
			_list.clearItems();
//			_clientList.clearItems();


					var a:int=100+PlayerManager.Instance.Self.VIPLevel;
					
                    var cell : ItemTemplateInfo = ItemManager.Instance.getTemplateById(a);
					var item: DayGetItemAsset = new DayGetItemAsset();
					var title : String = StringHelper.rePlaceHtmlTextField(cell.Name);
					item.titleTxt.htmlText = "<b><FONT SIZE='13' FACE='Arial' KERNING='2' COLOR='#764B37' >"+ title+"</FONT></b>";
					_list.appendItem(item);

		}
		
		public function dispose() :void
		{
			if(_getAllBtn)
			{
				_getAllBtn.removeEventListener(MouseEvent.CLICK,  __onClickHandler);
				_getAllBtn.removeEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);
				_getAllBtn.dispose();
			}
			_getAllBtn = null;
			
			DailyConductFrame.dispatcher.removeEventListener(Event.CHANGE, __dailyBtnChange);
			DailyConductFrame.dispatcher.removeEventListener(Event.COMPLETE, __dailyBtnChange);
			
			if(_list)
			{
				_list.clearItems();
				
				if(_list.parent)
					_list.parent.removeChild(_list);
			}
			_list = null;
			
//			if(_clientList)
//			{
//				_clientList.clearItems();
//				if(_clientList.parent)
//					_clientList.parent.removeChild(_clientList);
//			}
//			_clientList = null;
			
			_parent = null;
			_data = null;
		}

	}
}