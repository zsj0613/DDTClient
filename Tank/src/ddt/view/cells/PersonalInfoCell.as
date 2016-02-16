package ddt.view.cells
{
	import game.crazyTank.view.common.bagCellShine;
	import game.crazyTank.view.personalinfoII.PersonalInfoIIArmCellAsset;
	import game.crazyTank.view.personalinfoII.PersonalInfoIICellAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HConfirmDialog;
	
	import ddt.data.EquipType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.data.player.BagInfo;
	import ddt.manager.DragManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;
	import ddt.view.common.ShineObject;
	import ddt.view.infoandbag.CellEvent;

	public class PersonalInfoCell extends BagCell
	{
		private var _shineObject:ShineObject;
		public function PersonalInfoCell(index:int, info:ItemTemplateInfo=null, showLoading:Boolean=true)
		{
			super(index, info, showLoading,(index + 1 == EquipType.ARM) ? new PersonalInfoIIArmCellAsset() : new PersonalInfoIICellAsset());
			_shineObject = new ShineObject(new bagCellShine());
		}
		
		override public function dragStart():void
		{
			if(_info && !locked && stage && allowDrag)
			{
				if(DragManager.startDrag(this,_info,createDragImg(),stage.mouseX,stage.mouseY,DragEffect.MOVE))
				{
					locked = true;
				}
			}
		}
		
		override public function dragDrop(effect:DragEffect):void
		{
			if(PlayerManager.Instance.Self.bagLocked)return;
			var info:InventoryItemInfo = effect.data as InventoryItemInfo;//source
			if(info)
			{ 
				if(PlayerManager.Instance.Self.bagLocked)return;
				
				//if(info.Place <= 30 && info.BagType != BagInfo.PROPBAG ) return;
				
				if((info.BindType ==1 || info.BindType == 2 || info.BindType == 3) && info.IsBinds == false)
				{
					HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.bagII.BagIIView.BindsInfo"),true,sendDefy,null,true,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
					temInfo = info;
					DragManager.acceptDrag(this,DragEffect.NONE);
					return;
				}
				if(PlayerManager.Instance.Self.canEquip(info))
				{
					var toPlace:int;
					if(getCellIndex(info).indexOf(place) != -1)
					{
						toPlace = place;
					}else
					{
						toPlace = PlayerManager.Instance.getDressEquipPlace(info);
					}
					SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,info.Place,BagInfo.EQUIPBAG,toPlace);
					DragManager.acceptDrag(this,DragEffect.MOVE);
				}else
				{
					DragManager.acceptDrag(this,DragEffect.NONE);
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
		
		private function getCellIndex(info:ItemTemplateInfo):Array
		{
			if(EquipType.isWeddingRing(info))
			{
				return [16];
			}
			switch(info.CategoryID)
			{
				case EquipType.HEAD:
				    return [0];
			    case EquipType.GLASS:
				    return [1];
			    case EquipType.HAIR:
				    return [2];
			    case EquipType.EFF:
				    return [3];
			    case EquipType.CLOTH:
				    return [4];
			    case EquipType.FACE:
				    return [5];
			    case EquipType.ARM:
				    return [6];
			    case EquipType.ARMLET:
				    return [7,8];
			    case EquipType.RING:
				    return [9,10];
				case EquipType.SUITS:
				    return [11];
			    case EquipType.NECKLACE:
				    return [12];
				case EquipType.WING:
				    return [13];
			    case EquipType.CHATBALL:
				    return [14];
				case EquipType.OFFHAND:
					return [15];
				case EquipType.PET:
					return [17];
				case EquipType.ShenQi1:
				case EquipType.ShenQi2:
					return [18,19,20,21,22,23,24,25,26,27];
				default:
				    return [-1];
			}
			return [];
		}
		
		override public function dragStop(effect:DragEffect):void
		{
			
			if(PlayerManager.Instance.Self.bagLocked)
			{
				new BagLockedGetFrame().show();
				effect.action = DragEffect.NONE;
				super.dragStop(effect);
			}
			//global.traceStr("OnDragStop");
			locked = false;
			dispatchEvent(new CellEvent(CellEvent.DRAGSTOP,null,true));
		}
		
		public function shine():void
		{
			addChild(_shineObject);
			_shineObject.shine();
		}
		
		public function stopShine():void
		{
			if(this.contains(_shineObject))
			{
				removeChild(_shineObject);
			}
			_shineObject.stopShine();
		}
		
		override public function set locked(value:Boolean):void
		{
			super.locked = value;
		}
		
		override public function dispose():void
		{
			_shineObject.dispose();
			_shineObject = null;
			super.dispose();
		}
	}
}