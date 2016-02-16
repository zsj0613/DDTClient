package ddt.view.cells
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;
	
	import game.crazyTank.view.bagII.BagIICellAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HConfirmDialog;
	
	import ddt.data.EquipType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.data.player.BagInfo;
	import ddt.manager.DragManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.view.bagII.BreakGoodsBtn;
	import ddt.view.bagII.DeleteGoodsBtn;
	import ddt.view.bagII.SellGoodsBtn;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;
	import ddt.view.infoandbag.CellEvent;

	public class BagCell extends BaseCell 
	{
		private var _place:int;
		protected var _tbxCount:TextField;
		private var _bgOverDate:Sprite;
		private var _bgCell:Sprite;
		
		public var bagType:int;
		
		public function BagCell(index:int, info:ItemTemplateInfo=null, showLoading:Boolean=true,bg:Sprite = null)
		{
			super(bg ? bg : new BagIICellAsset(), info, showLoading);
			_place = index;
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			locked = false;
			_bgCell = getBg()["cellbg"];
			_tbxCount = getBg()["count_txt"];
			if(_tbxCount)
			{
				_tbxCount.mouseEnabled = false;
			}
			_bgOverDate = getBg()["overdate_bg"];
			updateCount();
			checkOverDate();
			updateBgVisible(false);
		}
		
		override public function set info(value:ItemTemplateInfo):void
		{
			super.info = value;
			updateCount();
			checkOverDate();
			if(info is InventoryItemInfo)
			{
				this.locked = this.info["lock"];
			}
			
		}
		
		private function __onLockChange(e:CellEvent):void
		{
			
		}
		
		override protected function onMouseOver(evt:MouseEvent):void
		{
			super.onMouseOver(evt);
			updateBgVisible(true);
		}
		
		override protected function onMouseOut(evt:MouseEvent):void
		{
			super.onMouseOut(evt);
			updateBgVisible(false);
		}
		
		protected function updateBgVisible(visible:Boolean):void
		{
			if(_bgCell)
				_bgCell.visible = visible;
		}
		
		override public function dragDrop(effect:DragEffect):void
		{
			if(bagLocked && PlayerManager.Instance.Self.bagLocked)
			{
				if(effect.data is InventoryItemInfo)
					effect.action = DragEffect.NONE;
				DragManager.acceptDrag(this);
				return ;
			}
			if(effect.data is InventoryItemInfo)
			{
				var info:InventoryItemInfo = effect.data as InventoryItemInfo;
				if(locked)
				{
					if(info == this.info)
					{
						this.locked = false;
						DragManager.acceptDrag(this);
					}
					else
					{
						DragManager.acceptDrag(this,DragEffect.NONE);
					}
				}
				else
				{
					if(bagType == 11 || info.BagType == 11)
					{
						if(effect.action == DragEffect.SPLIT)
						{
							effect.action = DragEffect.NONE;
						}
						else if(bagType != 11)
						{
							//移向背包
							SocketManager.Instance.out.sendMoveGoods(BagInfo.CONSORTIA,info.Place,bagType,place,info.Count);
							effect.action = DragEffect.NONE;
						}
						else if(bagType == info.BagType)
						{
							//银行内拖动
							if(place >= PlayerManager.Instance.Self.StoreLevel *10)
							{
								effect.action = DragEffect.NONE;//银行内拖向等级不够的格子
							}
							else
							{
								SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,info.BagType,place,info.Count);
							}
							
						}
						else
						{
							//背包拖入到银行
							if(PlayerManager.Instance.Self.StoreLevel < 1)
							{
								MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.club.ConsortiaClubView.cellDoubleClick"));
								//MessageTipManager.getInstance().show("请升级公会保管箱");
								effect.action = DragEffect.NONE;								
							}
							else
							{
								SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,bagType,place,info.Count);
								effect.action = DragEffect.NONE;
							}
						}
					}
					else if(info.BagType == bagType)
					{
						if(!itemInfo)
						{
							//背包拖动
							SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,info.BagType,place,info.Count);
							effect.action = DragEffect.NONE;//chocolate 11.18 修改在铁匠铺 打开邮箱背包移动物品时物品会变灰的BUG时改的
							return;
						}
						if(info.CategoryID == itemInfo.CategoryID && info.Place <= 30 && (info.BindType ==1 || info.BindType == 2 || info.BindType == 3) && itemInfo.IsBinds == false
						   && EquipType.canEquip(info))
						{
							HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.bagII.BagIIView.BindsInfo"),true,sendDefy,null,true,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
							temInfo = info;
						}else
						{
							//背包拖动
							SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,info.BagType,place,info.Count);
							effect.action = DragEffect.NONE;//chocolate 11.18 修改在铁匠铺 打开邮箱背包移动物品时物品会变灰的BUG时改的
						}
					}
					else
					{
						effect.action = DragEffect.NONE;
					}
					DragManager.acceptDrag(this);
				}
				
			}
				//			else if(effect.data is DeleteGoodsBtn)
				//			{//直接删除物品
				//				/**公会保管箱里的不可删**/
				//				if(!locked && _info  && this.bagType != 11)
				//				{
				//					locked = true;
				//					DragManager.acceptDrag(this);
				//				}
				//			}
			else if(effect.data is SellGoodsBtn)
			{//物品回收
				/**公会保管箱里的不可回收**/
				if(!locked && _info  && this.bagType != 11)
				{
					locked = true;
					DragManager.acceptDrag(this);
				}
			}
			else if(effect.data is BreakGoodsBtn)
			{
				if(!locked && _info)
				{
					//					locked = true;
					DragManager.acceptDrag(this);
				}
			}
		}
		
		private var temInfo:InventoryItemInfo;
		private function sendDefy():void
		{
			SoundManager.Instance.play("008");
			if(PlayerManager.Instance.Self.canEquip(temInfo))
			{
				SocketManager.Instance.out.sendMoveGoods(temInfo.BagType,temInfo.Place,temInfo.BagType,place,temInfo.Count);
			}
		}
		
		override public function dragStart():void
		{
			super.dragStart();
			if(_info)
			{
				dispatchEvent(new CellEvent(CellEvent.DRAGSTART,this.info,true));
			}
		}
		
		override public function dragStop(effect:DragEffect):void
		{
			var $info : InventoryItemInfo  = effect.data as InventoryItemInfo;
			if(bagLocked && PlayerManager.Instance.Self.bagLocked)
			{
				new BagLockedGetFrame().show();
				effect.action = DragEffect.NONE;
				super.dragStop(effect);
			}
			else if(effect.action == DragEffect.MOVE && effect.target == null )
			{
				if($info && $info.BagType == 11)
				{
					effect.action = DragEffect.NONE;
					super.dragStop(effect);
				}
				else if($info && $info.BagType == 12)
				{
					locked = false;
				}
				else{
					locked = false;
					sellItem();
				}
			}
			else if(effect.action == DragEffect.SPLIT && effect.target == null)
			{
				locked = false;
			}
			else
			{
				super.dragStop(effect);
			}
			dispatchEvent(new CellEvent(CellEvent.DRAGSTOP,null,true));
		}
		
		public function dragCountStart(count:int):void
		{
			if(_info && !locked && stage && count != 0)
			{
				var info:InventoryItemInfo = itemInfo;
				var action:String = DragEffect.MOVE;
				if(count != itemInfo.Count)
				{
					info = new InventoryItemInfo();
					info.ItemID = itemInfo.ItemID;
					info.BagType = itemInfo.BagType;
					info.Place = itemInfo.Place;
					info.IsBinds = itemInfo.IsBinds;
					info.BeginDate = itemInfo.BeginDate;
					info.ValidDate = itemInfo.ValidDate;
					info.Count = count;
					action = DragEffect.SPLIT;
				}
				if(DragManager.startDrag(this,info,createDragImg(),stage.mouseX,stage.mouseY,action))
				{
					locked = true;
				}
			}
		}
		private var _confirm:HConfirmDialog;
		
		/**
		 *出售(回收物品) 
		 * 
		 */		
		public function sellItem():void
		{
			SoundManager.Instance.play("008");	
			_confirm = HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.bagII.SellGoodsBtn.sure").replace("{0}", itemInfo.Count * itemInfo.ReclaimValue+(itemInfo.ReclaimType==1 ? LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.gold") : itemInfo.ReclaimType==2 ? LanguageMgr.GetTranslation("ddt.gameover.takecard.gifttoken") : "")),true,confirmSell,confirmCancel);
		}
		
		/**
		 *确定出售(回收)物品 
		 * 
		 */		
		private function confirmSell():void
		{
			_confirm.dispose();
			_confirm.close();
			_confirm=null;
			
			if(info)
			{
				SocketManager.Instance.out.reclaimGoods(itemInfo.BagType,itemInfo.Place, itemInfo.Count);
			}
		}
		
		private function confirmCancel():void
		{
			_confirm.dispose();
			_confirm.close();
			_confirm=null;
			locked = false;
		}
		
		public function get place():int
		{
			return _place;
		}
		
		public function get itemInfo():InventoryItemInfo
		{
			return _info as InventoryItemInfo;
		}
		
		public function replaceBg(bg:Sprite):void
		{
			_bg = bg;
		}
		
		public function updateCount():void
		{
			if(_tbxCount)
			{
				if(_info && itemInfo && itemInfo.MaxCount > 1)
				{
					_tbxCount.text = String(itemInfo.Count);
					_tbxCount.visible = true;
					addChild(_tbxCount);
				}
				else
				{
					_tbxCount.visible = false;
				}
			}
		}
		
		public function checkOverDate():void
		{
			if(_bgOverDate)
			{
				if(itemInfo && itemInfo.getRemainDate() <= 0)
				{
					_bgOverDate.visible = true;
					addChild(_bgOverDate);
					_pic.filters = [new ColorMatrixFilter([0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0])];
				}
				else
				{
					_bgOverDate.visible = false;
					if(_pic) _pic.filters = [];
				}
			}
		}
		
		public function set BGVisible(value:Boolean):void
		{
			_bg.visible = value;
		}
		
		override public function dispose():void
		{
			if(_tbxCount && _tbxCount.parent)
				_tbxCount.parent.removeChild(_tbxCount);
			_tbxCount = null;
			
			if(_bgOverDate && _bgOverDate.parent)
				_bgOverDate.parent.removeChild(_bgOverDate);
			
			if(_bgCell && _bgCell.parent)
				_bgCell.parent.removeChild(_bgCell);
			
			if(_confirm)
			{
				_confirm.close();
				_confirm.dispose();
			}
			_confirm = null;
			
			super.dispose();
		}
	}
}