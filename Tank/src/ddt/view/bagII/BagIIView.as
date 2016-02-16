﻿package ddt.view.bagII
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import game.crazyTank.view.bagII.BagBGAsset;
	import game.crazyTank.view.bagII.KeySetBtnAccect;
	
	import org.aswing.KeyboardManager;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.HButton.HTipButton;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.manager.TipManager;
	
	import tank.assets.ScaleBMP_9;
	import ddt.data.EquipType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.data.player.BagInfo;
	import ddt.data.player.PlayerInfo;
	import ddt.data.player.PlayerPropertyEvent;
	import ddt.data.player.SelfInfo;
	import ddt.manager.ItemManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.RouletteManager;
	import ddt.manager.SharedManager;
	import ddt.manager.ShopManager;
	import ddt.manager.SocketManager;
	import ddt.view.ConsortiaReworkNameView;
	import ddt.view.ReworkNameView;
	import ddt.view.bagII.baglocked.BagLockedExplainFrame;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;
	import ddt.view.cells.BagCell;
	import ddt.view.changeColor.ChangeColorCardPanel;
	import ddt.view.common.AddPricePanel;
	import ddt.view.common.CellMenu;
	import ddt.view.infoandbag.CellEvent;
	import ddt.view.transferProp.TransferPanel;

	/**
	* 	这两个事件是为了让左边人物物品栏在删除状态下不显示各种tips，也就是不响应鼠标事件
	*/	
	[Event(name="sellstart")]
	[Event(name="sellstop")]
	public class BagIIView extends BagBGAsset
	{
		
		public static var DEFAULT_SHOW_TYPE:int = 0;
		
		private const STATE_SELL:uint=1;
		private var state:uint=0;
		private var _controller:IBagIIController;
		private var _model:IBagIIModel;
		private var _equiplist:BagIIEquipListView;
		private var _proplist:BagIIListView;
		private var _sellBtn:SellGoodsBtn;
		private var _sellBtnContainer:Sprite;
		private var _lists:Array;
		private var _currentList:BagIIListView;
		private var _breakBtn:BreakGoodsBtn;
		private var _keySetBtn:HBaseButton;
		private var _keySetFrame:KeySetFrame;
		
		private var _bagType:int;
		
		private var _bagLockedBtn    : HTipButton;
		private var _bagLocked       : Boolean;
		private var _bagFinishingBtn    : HTipButton;
		private var _bitMapBg:ScaleBMP_9;   /**包包位图背景**/
		private var _self:SelfInfo=PlayerManager.Instance.Self;
		public var cells:Array;//物品列表(物品格)
		
		public function BagIIView(controller:IBagIIController,model:IBagIIModel)
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
			_proplist = new BagIIListView(1,_controller);
			_equiplist.x = _proplist.x =  list_pos.x;
			_equiplist.y = _proplist.y = list_pos.y;
			_equiplist.width = _proplist.width = list_pos.width;
			_equiplist.height = _proplist.height = list_pos.height;
			addChild(_equiplist);
			addChild(_proplist);
			removeChild(list_pos);
			
			_proplist.visible = false;
			_lists = [_equiplist,_proplist];
			_currentList = _equiplist;
			_sellBtn = new SellGoodsBtn();
			_equiplist.addEventListener(CellEvent.ITEM_CLICK,__cellClick);
			_equiplist.addEventListener(CellEvent.DOUBLE_CLICK,__cellDoubleClick);
			_equiplist.addEventListener(Event.CHANGE,__listChange);
			_proplist.addEventListener(CellEvent.ITEM_CLICK,__cellClick);
			_proplist.addEventListener(Event.CHANGE,__listChange);

			cells=[];
			if(_equiplist._cells)
			{//增加装备背包物品至列表
				for each(var bagCell1:BagCell in _equiplist._cells)
				{
					cells.push(bagCell1);
				}
			}
			if(_equiplist._cells)
			{//增加道具背包物品至列表
				for each(var bagCell2:BagCell in _proplist._cells)
				{
					cells.push(bagCell2);
				}
			}
			
			removeChild(del_pos);
			_sellBtn.x = del_pos.x;
			_sellBtn.y = del_pos.y;
			addChild(_sellBtnContainer=new HBaseButton(_sellBtn));
			
			_breakBtn = new BreakGoodsBtn();
			removeChild(break_pos);
			_breakBtn.x = break_pos.x;
			_breakBtn.y = break_pos.y;
			addChild(_breakBtn);
			
			removeChild(keySetPos);
			_keySetBtn = new HBaseButton(new KeySetBtnAccect());
			_keySetBtn.x = keySetPos.x;
			_keySetBtn.y = keySetPos.y;
			addChild(_keySetBtn);
		
			updateMoney();
			tabs.gotoAndStop(DEFAULT_SHOW_TYPE);
			showBag(DEFAULT_SHOW_TYPE);
			DEFAULT_SHOW_TYPE = 0;
			
			_keySetFrame = new KeySetFrame();
			
			_bagLockedBtn = new HTipButton(BagLockedAsset,"",LanguageMgr.GetTranslation("ddt.view.bagII.BagIIView.bagLockedBtn"));
			//_bagLockedBtn = new HTipButton(BagLockedAsset,"","二级密码设置");
			_bagLockedBtn.useBackgoundPos = true;
			addChild(_bagLockedBtn);
			_bagLocked = PlayerManager.Instance.Self.bagLocked;
			BagLockedAsset.locked.visible = _bagLocked;
			BagLockedAsset.openLocked.visible = !_bagLocked;
			/**背包按钮提示只显示在没点击前,状态数据保存在本地**/
/* 			if(SharedManager.Instance.setBagLocked || PlayerManager.Instance.Self.bagPwdState)
			{
				BagLockedEffectAsset.visible = false;
			} */
			
			BagLockedAsset.locked.gotoAndStop(1);
			BagLockedAsset.openLocked.gotoAndStop(1);
			
			_bagFinishingBtn=new HTipButton(btnBagFinishing, "", LanguageMgr.GetTranslation("ddt.view.bagII.BagIIView.bagFinishingBtn"));
			_bagFinishingBtn.useBackgoundPos = true;
			addChild(_bagFinishingBtn);
			btnBagFinishing.Normal.visible=true;
			btnBagFinishing.Click.visible=false;
			btnBagFinishing.Over.visible=false;
			
			setBagCountShow(_bagType);
		}
		
		public function set bagFinishingBtnEnable(value:Boolean):void {
			_bagFinishingBtn.enable = value;
		}
		
		private function initEvent():void
		{
			//_sellBtn.addEventListener(MouseEvent.CLICK,__delClick);
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
			_keySetBtn.addEventListener(MouseEvent.CLICK,__keySetFrameClick);
			_bagLockedBtn.addEventListener(MouseEvent.CLICK, __openBagLockedFrame);
			_bagLockedBtn.addEventListener(MouseEvent.MOUSE_OVER,__bagLockedMouseOver);
			_bagLockedBtn.addEventListener(MouseEvent.MOUSE_OUT,__bagLockedMouseOut);
			
			_bagFinishingBtn.addEventListener(MouseEvent.CLICK, __bagFinishingClick);
			_bagFinishingBtn.addEventListener(MouseEvent.MOUSE_OVER, __bagFinishingMouseOver);
			_bagFinishingBtn.addEventListener(MouseEvent.MOUSE_OUT, __bagFinishingMouseOut);
			
			
			_self.getBag(BagInfo.EQUIPBAG).addEventListener(BagEvent.UPDATE,__onBagUpdateEQUIPBAG);
			_self.getBag(BagInfo.PROPBAG).addEventListener(BagEvent.UPDATE,__onBagUpdatePROPBAG);
		}
		
		private function __onBagUpdateEQUIPBAG(ev:BagEvent):void
		{
			setBagCountShow(BagInfo.EQUIPBAG);
		}
		
		private function __onBagUpdatePROPBAG(ev:BagEvent):void
		{
			setBagCountShow(BagInfo.PROPBAG);
		}
		
		private function __openBagLockedFrame(evt : MouseEvent) : void
		{
			SoundManager.Instance.play("008");
			var bagLocked :BagLockedExplainFrame = new BagLockedExplainFrame();
			//BagLockedExplainFrame
			//BagLockedHelpFrame
			//BagLockedExplainFrame
			//BagLockedSetPasswordFrame
			//passwordAffrimFrame
			bagLocked.show();
			//BagLockedEffectAsset.visible = false;
			SharedManager.Instance.setBagLocked = true;
			SharedManager.Instance.save();
		}

		
		private function __bagLockedMouseOver(evt : MouseEvent) : void
		{
			BagLockedAsset.locked.gotoAndStop(2);
			BagLockedAsset.openLocked.gotoAndStop(2);
		}
		
		private function __bagLockedMouseOut(evt : MouseEvent) : void
		{
			BagLockedAsset.locked.gotoAndStop(1);
			BagLockedAsset.openLocked.gotoAndStop(1);
		}
		
		private function __bagFinishingClick(evt : MouseEvent) : void
		{
			SoundManager.Instance.play("008");
 			btnBagFinishing.Click.visible=true;
			btnBagFinishing.Normal.visible=false;
			btnBagFinishing.Over.visible=false;
			
			switch(_bagType)
			{
				case BagInfo.EQUIPBAG:
					PlayerManager.Instance.Self.PropBag.Finishing(PlayerManager.Instance.Self.getBag(BagInfo.EQUIPBAG), _equiplist._startIndex, _equiplist._stopIndex);
				break;
				case BagInfo.PROPBAG:
					PlayerManager.Instance.Self.PropBag.Finishing(PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG), 0, 48);
				break;
			}
			return;
		}
		
		private function __bagFinishingMouseOver(evt : MouseEvent) : void
		{
			btnBagFinishing.Normal.visible=false;
			btnBagFinishing.Over.visible=true;
			btnBagFinishing.Click.visible=false;
		}
		
		private function __bagFinishingMouseOut(evt : MouseEvent) : void
		{
			btnBagFinishing.Normal.visible=true;
			btnBagFinishing.Over.visible=false;
			btnBagFinishing.Click.visible=false;
		}
		
		private function __keySetFrameClick(e:MouseEvent):void
		{
			SoundManager.Instance.play("047");
			if(_keySetFrame.parent)
			{
				var fun : Function = _keySetFrame.cancelFunction;
				if(fun != null)fun();
				fun = null;
			}
			else
			{
				_keySetFrame.show();
			}
		}
		
		public function closeKeySetFrame():void
		{
			_keySetFrame.close();
		}
		
		private function __propertyChange(evt:PlayerPropertyEvent):void
		{
			if(evt.changedProperties["Money"] || evt.changedProperties["Gold"] || evt.changedProperties[PlayerInfo.GIFT])
			{
				updateMoney();
			}
			else if(evt.changedProperties["bagLocked"])
			{
				_bagLocked = PlayerManager.Instance.Self.bagLocked;
				BagLockedAsset.locked.visible = _bagLocked;
				BagLockedAsset.openLocked.visible = !_bagLocked;
				//BagLockedEffectAsset.visible = !PlayerManager.Instance.Self.bagPwdState;
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
			
			switch(index)
			{
				case 0:
					_bagType=BagInfo.EQUIPBAG;
				break;
				case 1:
					_bagType=BagInfo.PROPBAG;
				break;
			}
			
			if(_currentList == _lists[index])return;
			index == 0 ? _breakBtn.enable = false : _breakBtn.enable = true;
			SoundManager.Instance.play("008");
			tabs.gotoAndStop(index + 1);
			_currentList.visible = false;
			_currentList = _lists[index];
			_currentList.visible = true;
			
			setBagCountShow(_bagType);
		}
		
		public function addStageInit() : void
		{
			var index:int = 0;
			switch(index)
			{
				case 0:
					_bagType=BagInfo.EQUIPBAG;
				break;
				case 1:
					_bagType=BagInfo.PROPBAG;
				break;
			}
			
			if(_currentList == _lists[index])return;
			index == 0 ? _breakBtn.enable = false : _breakBtn.enable = true;
			SoundManager.Instance.play("008");
			tabs.gotoAndStop(index + 1);
			_currentList.visible = false;
			_currentList = _lists[index];
			_currentList.visible = true;
		}
		
		public function showBag(index:int):void
		{
			if(index >= 0 && index < _lists.length)
			{
				switch(index)
				{
					case 0:
						_bagType=BagInfo.EQUIPBAG;
					break;
					case 1:
						_bagType=BagInfo.PROPBAG;
					break;
				}
				setBagCountShow(_bagType);
				
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
			if(_currentList == evt.currentTarget)return;
			var index:int = _lists.indexOf(evt.currentTarget);
			
			switch(index)
			{
				case 0:
					_bagType=BagInfo.EQUIPBAG;
				break;
				case 1:
					_bagType=BagInfo.PROPBAG;
				break;
			}
			
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
			if(!(state&STATE_SELL)){
				state|=STATE_SELL;
				SoundManager.Instance.play("008");
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
				SoundManager.Instance.play("008");
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
		
		public function resetMouse():void
		{
			_sellBtn.stopDrag();
			_breakBtn.stopDrag();
		}
		
		private function __cellClick(evt:CellEvent):void
		{
			if(_controller.getEnabled() && !_sellBtn.isActive)
			{
				evt.stopImmediatePropagation();
				var cell:BagCell = evt.data as BagCell;
				var info:InventoryItemInfo;
				if(cell)
				{
					info = cell.info as InventoryItemInfo;
				}
				if(info == null) { return; }
				if(!cell.locked)
				{
					
					SoundManager.Instance.play("008");
					if(KeyboardManager.isDown(Keyboard.SHIFT) && info.Count > 1 && info.MaxCount > 1)
					{
						if(PlayerManager.Instance.Self.bagLocked)
						{
							new BagLockedGetFrame().show();
							return;
						}
						else
						{
							createBreakWin(cell);
						}
						
					}else if((info.getRemainDate() <= 0 && !(EquipType.isProp(info))) || EquipType.isPackage(info) || (info.getRemainDate() <= 0&&info.TemplateID == 10200)||EquipType.canBeUsed(info))
					{
						CellMenu.instance.show(cell,stage.mouseX,stage.mouseY);
					}
					else
					{
						cell.dragStart();
					}
				}
			}
		}
		
		public function set cellDoubleClickEnable (b:Boolean):void
		{
			if(b)
			{
				_equiplist.addEventListener(CellEvent.DOUBLE_CLICK,__cellDoubleClick);
			}
			else
			{
				_equiplist.removeEventListener(CellEvent.DOUBLE_CLICK,__cellDoubleClick);
			}
		}
		
		private function __cellDoubleClick(evt:CellEvent):void
		{
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
				if(info.getRemainDate() <= 0) return;
				if((templeteInfo.NeedSex != playerSex) && (templeteInfo.NeedSex != 0))
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.data.player.SelfInfo.object"));
//					物品所需性别不同，不能装备
					return
				}
				if(!cell.locked)
				{
					if((cell.info.BindType == 1 || cell.info.BindType == 2 || cell.info.BindType == 3) && cell.itemInfo.IsBinds == false)
					{
						HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.bagII.BagIIView.BindsInfo"),true,sendDefy,null,true,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
						temInfo = info;
					}else
					{
						SoundManager.Instance.play("008");
						if(PlayerManager.Instance.Self.canEquip(info))
						{
							var toPlace:int = PlayerManager.Instance.getDressEquipPlace(info);
							SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,info.Place,BagInfo.EQUIPBAG,toPlace);
						}
					}
				}
			}
		}
		private var temInfo:InventoryItemInfo;
		private function sendDefy():void
		{
			SoundManager.Instance.play("008");
			if(PlayerManager.Instance.Self.canEquip(temInfo))
			{
				var toPlace:int = PlayerManager.Instance.getDressEquipPlace(temInfo);
				SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,temInfo.Place,BagInfo.EQUIPBAG,toPlace);
			}
		}
		
		private function __cellAddPrice(evt:Event):void
		{
			var cell:BagCell = CellMenu.instance.cell;
			if(cell)
			{
				if(ShopManager.Instance.canAddPrice(cell.itemInfo.TemplateID))
				{
					AddPricePanel.Instance.setInfo(cell.itemInfo,false);
					TipManager.AddTippanel(AddPricePanel.Instance,true);
				}else
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.bagII.cantAddPrice"));
				}
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
			if(cell != null && cell.itemInfo != null)
			{
				var sexN:Number = PlayerManager.Instance.Self.Sex ? 1 : 2;
				if(sexN != cell.info.NeedSex && cell.info.NeedSex != 0)
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.bagII.sexErr"));
					return;
				}
				if(PlayerManager.Instance.Self.Grade >= cell.info.NeedLevel)
				{
					if(cell.info.TemplateID == EquipType.ROULETTE_BOX)
					{
						evt.stopImmediatePropagation();
						RouletteManager.Instance.useRouletteBox(cell);
					}else
					{
						SocketManager.Instance.out.sendItemOpenUp(cell.itemInfo.BagType,cell["place"]);
					}
				}else
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.bagII.BagIIView.level"));
					//MessageTipManager.getInstance().show("等级不足.");
				}
			}
		}
		/**
		 *  使用道具时触发事件
		 * @param evt
		 * 
		 */		
		private function __cellUse(evt:Event):void
		{
			if(PlayerManager.Instance.Self.bagLocked)
			{
				new BagLockedGetFrame().show();
				return;
			}
			evt.stopImmediatePropagation();
			var cell:BagCell = CellMenu.instance.cell as BagCell;
			if(!cell || cell.info == null)return;
			if(cell.info.TemplateID == EquipType.REWORK_NAME)
			{
				new ReworkNameView(cell.bagType,cell.place).show();
				return;
			}
			if(cell.info.TemplateID == EquipType.CONSORTIA_REWORK_NAME)
			{
				new ConsortiaReworkNameView(cell.bagType,cell.place).show();
				return;
			}
			if(cell.info.TemplateID == EquipType.COLORCARD)
			{
				TipManager.AddTippanel(new ChangeColorCardPanel(cell.place),true);
			}else if(cell.info.TemplateID == EquipType.TRANSFER_PROP)
			{
				TipManager.AddTippanel(new TransferPanel(cell.place),true);
			}else
			{
				if(PlayerManager.Instance.Self.bagLocked)
				{
					new BagLockedGetFrame().show();
					return;
				}
				else
				{
					useCard(cell.itemInfo);
				}
			}
		}
		
		private function useCard(info:InventoryItemInfo):void
		{
			if((info.TemplateID == EquipType.FREE_PROP_CARD)||(info.TemplateID == EquipType.DOUBLE_EXP_CARD)||(info.TemplateID == EquipType.DOUBLE_GESTE_CARD)||(info.TemplateID == EquipType.PREVENT_KICK)||(info.TemplateID.toString().substring(0,3) == "119"))
			{
				SocketManager.Instance.out.sendUseCard(info.BagType,info.Place,info.TemplateID,info.PayType);
			}
		}
		
		private function createBreakWin(cell:BagCell):void
		{
			SoundManager.Instance.play("008");
			var win:BreakGoodsView = new BreakGoodsView(cell);
			win.show();
		}
		
		public function setCellInfo(index:int,info:InventoryItemInfo):void
		{
			_currentList.setCellInfo(index,info);
		}
		
		public function setData(info:SelfInfo):void
		{
			_equiplist.setData(info.Bag);
			_proplist.setData(info.PropBag);
		}
		
		public function dispose():void
		{
			_equiplist.removeEventListener(CellEvent.ITEM_CLICK,__cellClick);
			_proplist.removeEventListener(CellEvent.ITEM_CLICK,__cellClick);
			_proplist.removeEventListener(Event.CHANGE,__listChange);
			_equiplist.removeEventListener(Event.CHANGE,__listChange);
			_bagLockedBtn.removeEventListener(MouseEvent.CLICK, __openBagLockedFrame);
			_bagLockedBtn.removeEventListener(MouseEvent.MOUSE_OVER,__bagLockedMouseOver);
			_bagLockedBtn.removeEventListener(MouseEvent.MOUSE_OUT,__bagLockedMouseOut);
			_keySetBtn.removeEventListener(MouseEvent.CLICK,__keySetFrameClick);
			_equiplist.removeEventListener(CellEvent.DOUBLE_CLICK,__cellDoubleClick);
			CellMenu.instance.removeEventListener(CellMenu.ADDPRICE,__cellAddPrice);
			CellMenu.instance.removeEventListener(CellMenu.MOVE,__cellMove);
			CellMenu.instance.removeEventListener(CellMenu.OPEN,__cellOpen);
			CellMenu.instance.removeEventListener(CellMenu.USE,__cellUse);
			_model.getPlayerInfo().removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__propertyChange);
			if(_bagLockedBtn && _bagLockedBtn.parent)_bagLockedBtn.parent.removeChild(_bagLockedBtn);
			if(_bagLockedBtn)_bagLockedBtn.dispose();
			
			_bagFinishingBtn.removeEventListener(MouseEvent.CLICK, __bagFinishingClick);
			_bagFinishingBtn.removeEventListener(MouseEvent.MOUSE_OVER, __bagFinishingMouseOver);
			_bagFinishingBtn.removeEventListener(MouseEvent.MOUSE_OUT, __bagFinishingMouseOut);
			if(_bagFinishingBtn && _bagFinishingBtn.parent)_bagFinishingBtn.parent.removeChild(_bagFinishingBtn);
			if(_bagFinishingBtn)_bagFinishingBtn.dispose();
			_bagFinishingBtn=null;
			
			_self.getBag(BagInfo.EQUIPBAG).removeEventListener(BagEvent.UPDATE,__onBagUpdateEQUIPBAG);
			_self.getBag(BagInfo.PROPBAG).removeEventListener(BagEvent.UPDATE,__onBagUpdatePROPBAG);
			_self=null;
			
			if(_keySetBtn) _keySetBtn.dispose();
			_keySetBtn = null;
			_bagLockedBtn = null;
			_equiplist.dispose();
			_equiplist = null;
			_proplist.dispose();
			_proplist = null;
			_currentList = null;
			_sellBtn.removeEventListener(MouseEvent.CLICK,__sellClick);
			_sellBtn.dispose();
			_sellBtn = null;
			_sellBtnContainer=null;
			_breakBtn.removeEventListener(MouseEvent.CLICK,__breakClick);
			_breakBtn.dispose();
			_breakBtn = null;
			_keySetFrame.dispose();
			_keySetFrame = null;
			_controller = null;
			_model = null;
			if(parent)parent.removeChild(this);
		}
		
		//取得背包物品数量（显示）
		public function setBagCountShow(bagType:int):void
		{
			var itemBgNumber:int=0;
			bagCount.text="49";//总数量
			var filter:Array = [];
			var glowFilter:GlowFilter=null;
			var textColor:uint;
			switch(bagType)
			{
				case BagInfo.EQUIPBAG:
					itemBgNumber=PlayerManager.Instance.Self.getBag(bagType).itemBgNumber(_equiplist._startIndex, _equiplist._stopIndex);//使用数量
					if(itemBgNumber>=49)
					{
						textColor=0xff0000;
						glowFilter = new GlowFilter(0xffffff,0.5,3,3,10);
						filter.push(glowFilter);
					}
					else
					{
						textColor=0x13FF04;
						glowFilter = new GlowFilter(0x0D5E00,0.5,3,3,10);
						filter.push(glowFilter);
					}
				break;
				case BagInfo.PROPBAG:
					itemBgNumber= PlayerManager.Instance.Self.getBag(bagType).itemBgNumber(0, 48);//使用数量
					if(itemBgNumber>=49)
					{
						textColor=0xff0000;
						glowFilter = new GlowFilter(0xffffff,0.5,3,3,10);
						filter.push(glowFilter);
					}
					else
					{
						textColor=0x13FF04;
						glowFilter = new GlowFilter(0x0D5E00,0.5,3,3,10);
						filter.push(glowFilter);
					}
				break;
			}
			
			bagUseCount.textColor=textColor;
			bagUseCount.filters = filter;
			bagUseCount.text= itemBgNumber.toString();//使用数量
		}
	}
}