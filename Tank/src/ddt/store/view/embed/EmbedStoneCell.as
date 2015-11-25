package ddt.store.view.embed
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import game.crazyTank.view.GoodsTipBgAsset;
	import game.crazyTank.view.storeII.EmbedStoneCellAsset;
	import game.crazyTank.view.storeII.EmbedStoneCellShine;
	import game.crazyTank.view.storeII.StoreEmbedCellAsset;
	import game.crazyTank.view.storeII.tipOne;
	import game.crazyTank.view.storeII.tipThree;
	import game.crazyTank.view.storeII.tipTwo;
	
	import road.ui.manager.TipManager;
	import road.utils.ComponentHelper;
	
	import ddt.store.events.EmbedBackoutEvent;
	import ddt.store.events.EmbedEvent;
	
	import ddt.data.EquipType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.manager.DragManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.utils.Helpers;
	import ddt.view.cells.BagCell;
	import ddt.view.cells.DragEffect;
	import ddt.view.cells.LinkedBagCell;
	import ddt.view.common.FastPurchaseGoldBox;
	import ddt.view.common.ShineObject;

	/**
	 * @author wicki LA
	 * @time 11/24/2009
	 * @discription 镶嵌的宝珠格子。此格子有三种类型：1圆形、2方形、3三角形.有开启与关闭两种状态
	 * */

	public class EmbedStoneCell extends LinkedBagCell
	{
		private var _id:int;
		private var _state:Boolean;
		private var _stoneType:int;
//		private var _shiner:ShineObject;
		private var _stoneBg:EmbedStoneCellAsset;
		private var _tipPanel:Sprite;
		private var _textField:TextField;
		private var _tipDerial:Boolean;
		private var tipSprite:Sprite;
		private var _tipOne:Sprite;
		private var _tipTwo:Sprite;
		private var _tipThree:Sprite;
		private var _shiner:ShineObject;
		
		public function EmbedStoneCell(id:int,stoneType:int)
		{
			super(new StoreEmbedCellAsset());
			_id = id;
			_stoneType = stoneType;
			_state = false;
//			_shiner = new ShineObject(new cellShine());
//			_shiner.mouseChildren = _shiner.mouseEnabled = false;
//			addChild(_shiner);
			_stoneBg = new EmbedStoneCellAsset();
			addChildAt(_stoneBg,0);
			allowDrag = false;
			DoubleClickEnabled = false;
			close();
			_tipOne = new tipOne();
			_tipTwo = new tipTwo();
			_tipThree = new tipThree();
			
			initTips(_tipOne);
			initTips(_tipTwo);
			initTips(_tipThree);
			
			_shiner = new ShineObject(new EmbedStoneCellShine());
			addChild(_shiner);
			_shiner.mouseChildren = _shiner.mouseEnabled =_shiner.visible = false;
			
			initEvents();
		}
		private function initTips(object:Sprite):void
		{
			Helpers.hidePosMc(object);
			ComponentHelper.replaceChild(object,object["bg_pos"],new GoodsTipBgAsset);
		}
		private function initEvents():void
		{
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		/**
		 * 单镶嵌格子开启并且尚未镶嵌宝珠时触发mouseOver时触发tips
		 */
		override protected function onMouseOver(evt:MouseEvent):void{
			switch((evt.currentTarget as EmbedStoneCell).StoneType){
				case 1:
					tipSprite = _tipOne;
					break;
				case 2:
					tipSprite = _tipTwo;		
					break;
				case 3:
					tipSprite = _tipThree;	
					break;
				default:
					break;
			}
			
			//显示拆除下拉菜单
			if(_state && !_tipDerial)
			{
				dispatchEvent(new EmbedBackoutEvent(EmbedBackoutEvent.EMBED_BACKOUT_DOWNITEM_OVER,this._id, info.TemplateID));
			}
			
			if(_state && _tipDerial){
				TipManager.setCurrentTarget(DisplayObject(evt.currentTarget),tipSprite,20,20);
				return;
			}else{
				super.showMouseOver(evt, 10, 10);
				//super.onMouseOver(evt);
			}
		}
		
		override protected function onMouseClick(evt:MouseEvent):void
		{
			super.onMouseClick(evt);
		}
		
		private function onMouseDown(evt:MouseEvent):void
		{
			if(info)
			{
				dispatchEvent(new EmbedBackoutEvent(EmbedBackoutEvent.EMBED_BACKOUT_DOWNITEM_DOWN,this._id, info.TemplateID));
			}
		}
		
		public function showTip(evt:MouseEvent):void
		{
			super.showMouseOver(evt, 20, 20);
		}
		
		public function closeTip(evt:MouseEvent):void
		{
			super.onMouseOut(evt);
		}
		
		override protected function onMouseOut(evt:MouseEvent):void{
			//显示拆除下拉菜单移除
			if(_state && !_tipDerial)
			{
				dispatchEvent(new EmbedBackoutEvent(EmbedBackoutEvent.EMBED_BACKOUT_DOWNITEM_OUT,this._id, info.TemplateID));
			}
			
			if(_state && _tipDerial){
				TipManager.setCurrentTarget(null,null);
				return;
			}else{
				super.onMouseOut(evt);
			}
		}
		
		public function open():void
		{
			if(_stoneType == -1) return;
			_state = true;
			_stoneBg.close.visible = false;
			bagLocked = false;
		}
		
		public function set StoneType(value:int):void
		{
			_stoneType = value;
			_stoneBg.bg.gotoAndStop(_stoneType);
		}
		
		public function get StoneType():int{
			return _stoneType;		
		}
		
		override public function set info(value:ItemTemplateInfo):void
		{
			super.info = value;
			bagLocked = true;
		}
		
		public function close():void
		{
			_state = false;
			_stoneBg.close.visible = true;
			if(bagCell)
			{
				bagCell.locked = false;
				bagCell = null;
			}
			info = null;
			bagLocked = true;
		}
		override public function dragDrop(effect:DragEffect):void
		{
			if(PlayerManager.Instance.Self.bagLocked) return;
			
			if(!(effect.source is EmbedBackoutButton))
			{
				var sourceInfo:InventoryItemInfo = effect.data as InventoryItemInfo;
				if(sourceInfo.CategoryID != 11 || sourceInfo.Property1 != "31") return;
			}

			
			if(!_state)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.store.matte.notOpen"));
				return;
			}
			
			if(effect.source is EmbedBackoutButton)
			{//拆除
				if(effect.action != DragEffect.SPLIT)
				{
					effect.action = DragEffect.NONE;
					
					DragManager.acceptDrag(this,DragEffect.LINK);
					dispatchEvent(new EmbedBackoutEvent(EmbedBackoutEvent.EMBED_BACKOUT,this._id, info.TemplateID));
					_tipDerial = false;
				}
			}
			else
			{
				if(sourceInfo && effect.action != DragEffect.SPLIT)
				{
					effect.action = DragEffect.NONE;
					if(sourceInfo.CategoryID == 11 && sourceInfo.Property1 == "31")
					{
						if(sourceInfo.Property2 == _stoneType.toString())
						{
							bagCell = effect.source as BagCell;
							DragManager.acceptDrag(this,DragEffect.LINK);
							dispatchEvent(new EmbedEvent(EmbedEvent.EMBED,this._id));
							_tipDerial = false;
						}else
						{
							MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.store.matte.notType"));
						}
					}
				}
			}
		}
		
		public function get tipDerial():Boolean{
			return _tipDerial;
		}
		
		public function set tipDerial(value:Boolean):void{
			_tipDerial = value;
		}
		
		public function startShine():void
		{
			_shiner.visible=true;
			_shiner.shine();
		}
		
		public function stopShine():void
		{
			_shiner.stopShine();
			_shiner.visible=false;
		}
		
		override public function dispose():void
		{
			_shiner.dispose();
			super.dispose();
		}
		
	}
}