package ddt.consortia.consortiabank
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.bagII.ConsortiaBagBgAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.manager.TipManager;
	
	import ddt.data.EquipType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.data.player.BagInfo;
	import ddt.data.player.PlayerInfo;
	import ddt.data.player.PlayerPropertyEvent;
	import ddt.data.player.SelfInfo;
	import ddt.manager.DragManager;
	import ddt.manager.ItemManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.view.bagII.*;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;
	import ddt.view.cells.BagCell;
	import ddt.view.changeColor.ChangeColorCardPanel;
	import ddt.view.common.AddPricePanel;
	import ddt.view.common.CellMenu;
	import ddt.view.infoandbag.CellEvent;
	
	public class ConsortiaBankBagView extends ConsortiaBagBgAsset
	{
		
		public static var DEFAULT_SHOW_TYPE:int = 0;
		private const STATE_SELL:uint=1;
		private var state:int=0;
		private var _controller:IBagIIController;
		private var _model : IBagIIModel;
		private var _equiplist:BagIIEquipListView;
		private var _proplist : BagIIEquipListView;/**double click**/
		private var _consortiaBank: ConsortiaBankListView;
		private var _sellBtn:SellGoodsBtn;
		private var _sellBtnContainer:Sprite;
		private var _lists:Array;
		private var _currentList:BagIIListView;
		private var _breakBtn:BreakGoodsBtn;
		//		private var _keySetBtn:HBaseButton;
		//		private var _keySetFrame:KeySetFrame;
		
		public function ConsortiaBankBagView(controller:IBagIIController,model:IBagIIModel)
		{
			_controller = controller;
			_model = model;
			super();
			init()
			initEvent();
		}
		
		private function init():void
		{			
			_equiplist = new BagIIEquipListView(0,_controller);
			_proplist  = new BagIIEquipListView(1,_controller,0,49);
			_consortiaBank = new ConsortiaBankListView(11,_controller,PlayerManager.Instance.Self.StoreLevel);
			_equiplist.x = _proplist.x  = list_pos.x;
			_equiplist.y = _proplist.y = list_pos.y;
			_consortiaBank.y = list_pos.y - 28;
			_consortiaBank.x = -484;
			_consortiaBank.width = _consortiaBank.height = 460;
			_equiplist.width = _proplist.width  = list_pos.width;
			_equiplist.height = _proplist.height = list_pos.height;
			addChild(_equiplist);
			addChild(_proplist);
			addChild(_consortiaBank);
			removeChild(list_pos);
			
			
			
			_proplist.visible = false;
			_lists = [_equiplist,_proplist];
			_currentList = _equiplist;
			_equiplist.addEventListener(CellEvent.ITEM_CLICK,__cellClick);
			_equiplist.addEventListener(CellEvent.DOUBLE_CLICK,__cellDoubleClick);
			_equiplist.addEventListener(Event.CHANGE,__listChange);
			_proplist.addEventListener(CellEvent.ITEM_CLICK,__cellClick);
			_proplist.addEventListener(CellEvent.DOUBLE_CLICK,__cellDoubleClick);
			_proplist.addEventListener(Event.CHANGE,__listChange);
			_consortiaBank.addEventListener(CellEvent.ITEM_CLICK,__cellClick);
			_consortiaBank.addEventListener(Event.CHANGE,__listChange);
			_consortiaBank.addEventListener(CellEvent.DOUBLE_CLICK,__bankCellDoubleClick);
			addEventListener(Event.ADDED_TO_STAGE,   __addToStageHandler);
			PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__upConsortiaStroeLevel);
			_sellBtn = new SellGoodsBtn();
			
			removeChild(del_pos);
			_sellBtn.x = del_pos.x;
			_sellBtn.y = del_pos.y;
			addChild(_sellBtnContainer=new HBaseButton(_sellBtn));
			
			_breakBtn = new BreakGoodsBtn();
			removeChild(break_pos);
			_breakBtn.x = break_pos.x;
			_breakBtn.y = break_pos.y;
			addChild(_breakBtn);
			_breakBtn.enable = true;
			
			
			//			_keySetBtn = new HBaseButton(keySetBtnAccect);
			//			_keySetBtn.useBackgoundPos = true;
			//			addChild(_keySetBtn);
			
			updateMoney();
			tabs.gotoAndStop(DEFAULT_SHOW_TYPE);
			showBag(DEFAULT_SHOW_TYPE);
			DEFAULT_SHOW_TYPE = 0;
			
			//			_keySetFrame = new KeySetFrame();
			
		}
		private function __cellUse(evt:Event):void
		{
			evt.stopImmediatePropagation();
			var cell:BagCell = CellMenu.instance.cell as BagCell;
			if(cell.info.TemplateID == EquipType.COLORCARD)
			{
				TipManager.AddTippanel(new ChangeColorCardPanel(cell.place),true);
			}else
			{
				useCard(cell.itemInfo);
			}
		}
		private function useCard(info:InventoryItemInfo):void
		{
			if(EquipType.canBeUsed(info))
			{
				SocketManager.Instance.out.sendUseCard(info.BagType,info.Place,info.TemplateID,info.PayType);
			}
		}
		
		private function __upConsortiaStroeLevel(evt : PlayerPropertyEvent) : void
		{
			if(evt.changedProperties["StoreLevel"])__addToStageHandler(null);
		}
		private function __addToStageHandler(evt : Event) : void
		{
			_consortiaBank.upLevel(PlayerManager.Instance.Self.StoreLevel);
		}
		
		private function initEvent():void
		{
			_sellBtn.addEventListener(MouseEvent.CLICK,__sellClick);
			_breakBtn.addEventListener(MouseEvent.CLICK,__breakClick);
			for(var i:int = 0; i < 2; i++)
			{
				this["btn_" + i].addEventListener(MouseEvent.CLICK,__tabClick);
				this["btn_" + i].buttonMode = true;
			}
			_model.getPlayerInfo().addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__propertyChange);
			CellMenu.instance.addEventListener(CellMenu.ADDPRICE,__cellAddPrice);
			CellMenu.instance.addEventListener(CellMenu.MOVE,__cellMove);
			CellMenu.instance.addEventListener(CellMenu.OPEN,__cellOpen);
			
			CellMenu.instance.addEventListener(CellMenu.USE,__cellUse);
			//			_keySetBtn.addEventListener(MouseEvent.CLICK,__keySetFrameClick);
		}
		
		//		private function __keySetFrameClick(e:MouseEvent):void
		//		{
		//			SoundManager.instance.play("047");
		//			if(_keySetFrame.parent)
		//			{
		//				var fun : Function = _keySetFrame.cancelFunction;
		//				if(fun != null)fun();
		//				fun = null;
		//			}
		//			else
		//			{
		//				_keySetFrame.show();
		//			}
		//		}
		
		private function __propertyChange(evt:PlayerPropertyEvent):void
		{
			if(evt.changedProperties["Money"] || evt.changedProperties["Gold"] || evt.changedProperties[PlayerInfo.GIFT])
			{
				updateMoney();
			}
		}
		
		private function updateMoney():void
		{
			gold_txt.text = String(_model.getPlayerInfo().Gold);
			coupons_txt.text = String(_model.getPlayerInfo().Money);
			gift_txt.text = String(_model.getPlayerInfo().Gift);
		}
		
		private function __tabClick(evt:MouseEvent):void
		{
			var index:int = int(evt.currentTarget.name.slice(-1));
			if(_currentList == _lists[index])return;
			index == 0 ? _breakBtn.enable = false : _breakBtn.enable = true;
			SoundManager.instance.play("008");
			tabs.gotoAndStop(index + 1);
			_currentList.visible = false;
			_currentList = _lists[index];
			_currentList.visible = true;
		}
		
		public function addStageInit() : void
		{
			var index:int = 0;
			if(_currentList == _lists[index])return;
			index == 0 ? _breakBtn.enable = false : _breakBtn.enable = true;
			SoundManager.instance.play("008");
			tabs.gotoAndStop(index + 1);
			_currentList.visible = false;
			_currentList = _lists[index];
			_currentList.visible = true;
		}
		
		public function showBag(index:int):void
		{
			if(index >= 0 && index < _lists.length)
			{
				
				index == 0 ? _breakBtn.enable = false : _breakBtn.enable = true;
				if(_currentList == _lists[index])return;
				tabs.gotoAndStop(index + 1);
				_currentList.visible = false;
				_currentList = _lists[index];
				_currentList.visible = true;
			}
		}
		
		private function __listChange(evt:Event):void
		{
			if(evt.currentTarget is ConsortiaBankListView)return;
			if(_currentList == evt.currentTarget)return;
			var index:int = _lists.indexOf(evt.currentTarget);
			tabs.gotoAndStop(index + 1);
			
			index == 0 ? _breakBtn.enable = false : _breakBtn.enable = true;
			if(_currentList)
				_currentList.visible = false;
			_currentList = evt.currentTarget as BagIIListView;
			if(_currentList)
				_currentList.visible = true;
		}
		
		private function __sellClick(evt:MouseEvent):void
		{
//			if(!(state&STATE_SELL)||(!DragManager.isDraging))
//			{
//				state|=STATE_SELL;
//				SoundManager.instance.play("008");
//				_sellBtn.dragStart(evt.stageX,evt.stageY);
//				evt.stopImmediatePropagation();
//			}else
//			{
//				state=(~STATE_SELL)&state;
//				_sellBtn.stopDrag();
//			}
			
			if(!(state&STATE_SELL)){
				state|=STATE_SELL;
				SoundManager.instance.play("008");
				_sellBtn.dragStart(evt.stageX,evt.stageY);
				dispatchEvent(new Event("sellstart"));
				stage.addEventListener(MouseEvent.CLICK,__onStageClick_SellBtn);
				evt.stopImmediatePropagation();
			}else
			{
				state=(~STATE_SELL)&state;
				_sellBtn.stopDrag();
			}
		}
		
		private function __onStageClick_SellBtn(e:Event):void
		{
			state=(~STATE_SELL)&state;
			dispatchEvent(new Event("sellstop"));
			if(stage)
				stage.removeEventListener(MouseEvent.CLICK,__onStageClick_SellBtn);
		}
		
		private function __breakClick(evt:MouseEvent):void
		{
			if(_breakBtn.enable)
			{
				SoundManager.instance.play("008");
				if(PlayerManager.Instance.Self.bagLocked)
				{
					new BagLockedGetFrame().show();
				}
				else
				{
					_breakBtn.dragStart(evt.stageX,evt.stageY);
				}
				
			}
		}
		
		private function __cellClick(evt:CellEvent):void
		{
			if(_controller.getEnabled() && !_sellBtn.isActive)
			{
				evt.stopImmediatePropagation();
				SoundManager.instance.play("008");
				var cell:BagCell = evt.data as BagCell;
				var info:InventoryItemInfo;
				if(cell)
				{
					info = cell.info as InventoryItemInfo;
				}
				if(info == null) { return; }
				if(!cell.locked)
				{
					//					if(KeyboardManager.isDown(Keyboard.SHIFT) && info.Count > 1 && info.MaxCount > 1)
					//					{
					//						createBreakWin(cell);
					//					}
					//					else 
					
					if(info.BagType != 11 && ((info.getRemainDate() <= 0 && !(EquipType.isProp(info))) || EquipType.isPackage(info) || (info.getRemainDate() <= 0&&info.TemplateID == 10200))|| (EquipType.canBeUsed(info) && info.BagType != 11))
						CellMenu.instance.show(cell,stage.mouseX,stage.mouseY);
					else
						cell.dragStart();
				}
			}
		}
		
		public function set cellDoubleClickEnable (b:Boolean):void
		{
			if(b)
			{
				_equiplist.addEventListener(CellEvent.DOUBLE_CLICK,__cellDoubleClick);
				_proplist.addEventListener(CellEvent.DOUBLE_CLICK,__cellDoubleClick);
			}
			else
			{
				_equiplist.removeEventListener(CellEvent.DOUBLE_CLICK,__cellDoubleClick);
				_proplist.removeEventListener(CellEvent.DOUBLE_CLICK,__cellDoubleClick);
			}
		}
		
		private function __cellDoubleClick(evt:CellEvent):void
		{
			SoundManager.instance.play("008");
			var checkNum : int = _consortiaBank.checkConsortiaStoreCell();
			if(checkNum  > 0)
			{
				if(checkNum == 1 )
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.club.ConsortiaClubView.cellDoubleClick"));
					//MessageTipManager.getInstance().show("请升级公会保管箱");
				}
				else if(checkNum == 2 || checkNum == 3)
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.club.ConsortiaClubView.cellDoubleClick.msg"));
					//MessageTipManager.getInstance().show("公会保管箱已满");
				}
				return;
			} 
			if(PlayerManager.Instance.Self.bagLocked)
			{
				//				HConfirmDialog.show("提示","二级密码尚未解锁，不可进行操作。");
				new BagLockedGetFrame().show();
				return;
			}
			if(_controller.getEnabled())
			{
				evt.stopImmediatePropagation();
				var cell:BagCell = evt.data as BagCell;
				var info:InventoryItemInfo = cell.info as InventoryItemInfo;
				var templeteInfo:ItemTemplateInfo = ItemManager.Instance.getTemplateById(info.TemplateID);
				var playerSex:int = PlayerManager.Instance.Self.Sex ? 1 : 2;
				//				if((templeteInfo.NeedSex != playerSex) && (templeteInfo.NeedSex != 0))
				//				{
				//					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.data.player.SelfInfo.object"));
				////					物品所需性别不同，不能装备
				//					return
				//				}
				if(!cell.locked)
				{
					SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.CONSORTIA,-1);
					//					SocketManager.Instance.out.sendMoveStoreItem(info.BagType,info.Place,-1,info.Count);
					//					SocketManager.Instance.out.sendEquipItem(info,-1);
				}
			}
		}
		
		private function __bankCellDoubleClick(evt:CellEvent):void
		{
			SoundManager.instance.play("008");
			evt.stopImmediatePropagation();
			if(PlayerManager.Instance.Self.bagLocked)
			{
				new BagLockedGetFrame().show();
				return;
			}
			var cell:BagCell = evt.data as BagCell;
			var info:InventoryItemInfo = cell.itemInfo;
			SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,getItemBagType(info),-1,info.Count);
		}
		
		
		private function getItemBagType(info:InventoryItemInfo):int
		{
			if(info && (info.CategoryID == 10 || info.CategoryID == 11 || info.CategoryID == 12)) return BagInfo.PROPBAG;
			else return BagInfo.EQUIPBAG;
		}
		
		private function __cellAddPrice(evt:Event):void
		{
			var cell:BagCell = CellMenu.instance.cell;
			if(cell)
			{
				AddPricePanel.Instance.setInfo(cell.itemInfo,false);
				TipManager.AddTippanel(AddPricePanel.Instance,true);
			}
		}
		
		private function __cellMove(evt:Event):void
		{
			var cell:BagCell = CellMenu.instance.cell;
			if(cell)
				cell.dragStart();
		}
		
		private function __cellOpen(evt:Event):void
		{
			var cell:BagCell = CellMenu.instance.cell as BagCell;
			if(cell != null)
			{
				if(PlayerManager.Instance.Self.Grade >= cell.info.NeedLevel)
				{
					SocketManager.Instance.out.sendItemOpenUp(cell.bagType,cell["place"]);
				}else
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.club.ConsortiaClubView.cellOpen"));
					//MessageTipManager.getInstance().show("等级不足.");
				}
			}
		}
		
		private function createBreakWin(cell:BagCell):void
		{
			SoundManager.instance.play("008");
			var win:BreakGoodsView = new BreakGoodsView(cell);
			win.show();
		}
		
		public function setCellInfo(index:int,info:InventoryItemInfo):void
		{
			_currentList.setCellInfo(index,info);
		}
		
		//		public function setData(bagdata:BagInfo):void
		//		{
		//			_equiplist.setData(bagdata.getBagThingByIndex(BagInfo.EQUIPBAG));
		//			_proplist.setData(bagdata.getBagThingByIndex(BagInfo.PROPBAG));
		//			_consortiaBank.setData(bagdata.getBagThingByIndex(BagInfo.STORE));
		//		}
		
		public function setData($info : SelfInfo):void
		{
			_equiplist.setData($info.Bag);
			_proplist.setData($info.PropBag);
			_consortiaBank.setData($info.ConsortiaBag);
		}
		public function dispose():void
		{
			//			_keySetBtn.removeEventListener(MouseEvent.CLICK,__keySetFrameClick);
			_equiplist.removeEventListener(CellEvent.DOUBLE_CLICK,__cellDoubleClick);
			_proplist.removeEventListener(CellEvent.DOUBLE_CLICK,__cellDoubleClick);
			CellMenu.instance.removeEventListener(CellMenu.ADDPRICE,__cellAddPrice);
			CellMenu.instance.removeEventListener(CellMenu.MOVE,__cellMove);
			CellMenu.instance.removeEventListener(CellMenu.OPEN,__cellOpen);
			
			CellMenu.instance.removeEventListener(CellMenu.USE,__cellUse);
			_model.getPlayerInfo().removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__propertyChange);
			PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__upConsortiaStroeLevel);
			removeEventListener(Event.ADDED_TO_STAGE,   __addToStageHandler);
			
			
			_equiplist.removeEventListener(CellEvent.ITEM_CLICK,__cellClick);
			_equiplist.removeEventListener(CellEvent.DOUBLE_CLICK,__cellDoubleClick);
			_equiplist.removeEventListener(Event.CHANGE,__listChange);
			_proplist.removeEventListener(CellEvent.ITEM_CLICK,__cellClick);
			_proplist.removeEventListener(CellEvent.DOUBLE_CLICK,__cellDoubleClick);
			_proplist.removeEventListener(Event.CHANGE,__listChange);
			_consortiaBank.removeEventListener(CellEvent.ITEM_CLICK,__cellClick);
			_consortiaBank.removeEventListener(Event.CHANGE,__listChange);
			_consortiaBank.removeEventListener(CellEvent.DOUBLE_CLICK,__bankCellDoubleClick);
			
			_equiplist.dispose();
			_equiplist = null;
			_proplist.dispose();
			_proplist = null;
			_consortiaBank.dispose();
			_consortiaBank = null;
			_currentList = null;
			_sellBtn.removeEventListener(MouseEvent.CLICK,__sellClick);
			_sellBtn.dispose();
			_sellBtn = null;
			_sellBtnContainer=null;
			_breakBtn.removeEventListener(MouseEvent.CLICK,__breakClick);
			if(stage) stage.removeEventListener(MouseEvent.CLICK,__onStageClick_SellBtn);
			//			_keySetFrame.dispose();
			//			_keySetFrame = null;
			_controller = null;
			_model = null;
			if(parent)parent.removeChild(this);
		}
	}
}