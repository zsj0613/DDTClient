package ddt.view.roulette
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import road.comm.PackageIn;
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	
	import ddt.data.bossBoxInfo.BoxGoodsTempInfo;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.events.CrazyTankSocketEvent;
	import tank.game.movement.RouletteAsset;
	import tank.game.movement.RouletteGoodsAsset;
	import tank.game.movement.RouletteSelectGoodsAsset;
	import tank.game.movement.RouletteStopAsset;
	import ddt.manager.ItemManager;
	import ddt.manager.RouletteManager;
	import ddt.manager.SocketManager;
	
	public class RouletteView extends RouletteAsset
	{
		private var _keyCount:int = 0;
		private var _turnControl:TurnControl;
		private var _startButton:RouletteButton;
		private var _buyKeyButton:HBaseButton
		/**
		 *选择的次数 0 -> 7
		 */		
		private var _selectNumber:int = 0;
		/**
		 *每次转动需要的钥匙数量 
		 */		
		private var _needKeyCount:Array = [0,2,3,4,5,6,7,8,0];
		/**
		 *保存18样物品 
		 */		
		private var _goodsList:Array;
		/**
		 *18样物品的TemplateID 
		 */		
		private var _templateIDList:Array;
		/**
		 *被选中的8样物品 
		 */		
		private var _selectGoodsList:Array;
		/**
		 *被选中的物品编号 
		 */		
		private var _selectGoogsNumber:int = 0;
		/**
		 *被选中的物品在轮盘中的编号
		 */		
		private var _turnSlectedNumber:int = 0;
		/**
		 *被选中物品的背包物品信息 
		 */		
		private var _selectedGoodsInfo:InventoryItemInfo;
		/**
		 *被选中的物品在_templateIDList中的编号,用于特殊物品的闪动定位 
		 */		
		private var _selectedGoodsNumberInTemplateIDList:int = 0;
		/**
		 *轮盘是否在转动 
		 */		
		private var _isTurn:Boolean = false;
		/**
		 *是否可以关闭宝箱 
		 */		
		private var _isCanClose:Boolean = true;
		/**
		 *物品信息是否加载成功 
		 */		
		private var _isLoadSucceed:Boolean = false;
		/**
		 *setTimeOut()超时进程的唯一数字标识符 
		 */		
		private var _winTimeOut:uint = 1;
		/**
		 *选中高级物品时的特殊闪动效果 
		 */		
		private var _glintView:RouletteGlintView;
		/**
		 *被选中物品的等级高低,搞等级物品将有特殊闪动效果 
		 */		
		private var _selectedItemType:int;
		
		private var _selectedCount:int;
		
		public function RouletteView(templateIDList:Array)
		{
			_templateIDList = templateIDList;
			init();
			initEvent();
		}
		
		private function init():void
		{
			_turnControl = new TurnControl();
			_goodsList = new Array();
			_selectGoodsList = new Array();
			
			for(var i:int = 1 ; i <= 18 ; i++)
			{
				var cell:RouletteGoodsCell = new RouletteGoodsCell(new RouletteGoodsAsset());
				cell.x = this["cell_"+i].x;
				cell.y = this["cell_"+i].y;
				removeChild(this["cell_"+i]);
				cell.selected = false;
				addChild(cell);
				
				var goodsInfo:BoxGoodsTempInfo = _templateIDList[i - 1] as BoxGoodsTempInfo;
				var info:InventoryItemInfo =  getTemplateInfo(goodsInfo.TemplateId) as InventoryItemInfo;
				info.IsBinds = goodsInfo.IsBind;
				info.ValidDate = goodsInfo.ItemValid;
				info.IsJudge = true;
				cell.info = info;
				cell.count = goodsInfo.ItemCount;
				_goodsList.push(cell);
			}
			
			for(var j:int = 1 ; j <= 8 ; j++)
			{
				var selectCell:RouletteGoodsCell = new RouletteGoodsCell(new RouletteSelectGoodsAsset());
				selectCell.x = this["select_cell_"+j].x;
				selectCell.y = this["select_cell_"+j].y;
				removeChild(this["select_cell_"+j]);
				selectCell.selected = false;
				selectCell.cellBG = false;
				addChild(selectCell);
				
				_selectGoodsList.push(selectCell);
			}
			
			selectNumber = 0;
			
			_startButton = new RouletteButton(_start);
			addChild(_startButton);
			_buyKeyButton = new HBaseButton(_buyKey);
			addChild(_buyKeyButton);
			
			_glintView = new RouletteGlintView();
			addChild(_glintView);
		}
		
		private function initEvent():void
		{
		//	SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOTTERY_GET_ITEM , _getItem);
			RouletteManager.Instance.addEventListener(RouletteEvent.ROULETTE_KEYCOUNT_UPDATE , _keyUpdate);
			_turnControl.addEventListener(TurnControl.TURNCOMPLETE , _turnComplete);
			_startButton.addEventListener(MouseEvent.CLICK , _turnClick);
			_buyKeyButton.addEventListener(MouseEvent.CLICK , _buyKeyClick);
		}
		
		/**
		 *接收被选中的物品的信息 
		 * @param e
		 * 
		 */		
		private function _getItem(e:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = e.pkg;
			var templateID:int = pkg.readInt();
			var itemType:int = pkg.readInt();
			
			_selectedGoodsInfo =  getTemplateInfo(templateID) as InventoryItemInfo;
			_selectedGoodsInfo.StrengthenLevel =  pkg.readInt();
			_selectedGoodsInfo.AttackCompose =  pkg.readInt();
			_selectedGoodsInfo.DefendCompose =  pkg.readInt();
			_selectedGoodsInfo.LuckCompose = pkg.readInt();
			_selectedGoodsInfo.AgilityCompose =  pkg.readInt();
			_selectedGoodsInfo.IsBinds = pkg.readBoolean();
			_selectedGoodsInfo.ValidDate =  pkg.readInt();
			_selectedCount = pkg.readByte();
			_selectedGoodsInfo.IsJudge = true;
			
			_selectedItemType = itemType;
			turnSlectedNumber = _findCellByItemID(templateID , _selectedCount);
			_selectedGoodsNumberInTemplateIDList = _findSelectedGoodsNumberInTemplateIDList(templateID , _selectedCount);
			if(turnSlectedNumber == -1){
				isTurn = false;
			}else{
			 	_startTurn();
				_isCanClose = false;
			}
		}
		
		private function _turnClick(e:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			if(!isTurn)
			{
				if(needKeyCount <= keyCount)
				{	
					isTurn = true;
		//			SocketManager.Instance.out.sendStartTurn();
				}
				else
					RouletteManager.Instance.showBuyRouletteKey(_needKeyCount[_selectNumber]);
			}
		}
		
		private function _startTurn():void
		{
			_turnControl.turnPlate(_goodsList , turnSlectedNumber);
		}
		
		private function _buyKeyClick(e:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			var i:int = (_needKeyCount[_selectNumber] == 0)?1:_needKeyCount[_selectNumber];
			RouletteManager.Instance.showBuyRouletteKey(i);
		}
		
		/**
		 *更新用户的钥匙数量 
		 * @param e 轮盘事件
		 * 
		 */		
		private function _keyUpdate(e:RouletteEvent):void
		{
			keyCount = e.keyCount;
		}
		
		private function _turnComplete(e:Event):void
		{
			_goodsList[turnSlectedNumber].selected = false;
			_winTimeOut = setTimeout(_updateTurnList , 3100);
			_glintView.showOneCell(_selectedGoodsNumberInTemplateIDList , 3000);
			SoundManager.Instance.play("126");
		}
		
		/**
		 *每次转动后,功能物品表的显示,下次转动需要的物品数组 
		 * 
		 */		
		private function _updateTurnList():void
		{
			_moveToSelctView();
			SoundManager.Instance.play("125");
			_isCanClose = true;
			if(_selectedItemType >= 5)
			{
				_glintView.showTwoStep(7500);
				//SoundManager.instance.pauseMusic();
				SoundManager.Instance.play("063");
				_glintView.addEventListener(RouletteGlintView.BIGGLINTCOMPLETE , _bigGlintComplete);
			}
			else
			{
				selectNumber++;
				isTurn = (_selectNumber >= 8)?true:false;
			}
		}
		
		private function _bigGlintComplete(e:Event):void
		{
			_glintView.removeEventListener(RouletteGlintView.BIGGLINTCOMPLETE , _bigGlintComplete);
			selectNumber++;
			isTurn = (_selectNumber >= 8)?true:false;
			//SoundManager.instance.resumeMusic();
			SoundManager.Instance.stop("063");
		}
		
		/**
		 *将选中的物品隐藏,并在被选中区域显示该物品 
		 * 
		 */		
		private function _moveToSelctView():void
		{
			var stop:RouletteStopAsset = new RouletteStopAsset();
			stop.x = _goodsList[turnSlectedNumber].x - 2;
			stop.y = _goodsList[turnSlectedNumber].y - 2;
			addChild(stop);
			_goodsList[turnSlectedNumber].visible = false;
			var cell:RouletteGoodsCell = _goodsList.splice(turnSlectedNumber , 1)[0] as RouletteGoodsCell;
			if(selectNumber <= 8)
			{
				_selectGoodsList[selectNumber].info = _selectedGoodsInfo;
				_selectGoodsList[selectNumber].count = _selectedCount;
				_selectGoodsList[selectNumber].cellBG = true;
				cell.dispose();
			}	
		}
		
		/**
		 *通过 TemplateID 在_GoodsList 中找到对应物品的编号
		 * @param itemId TemplateID
		 * @return cell在_GoodsList中的编号
		 * 
		 */		
		private function _findCellByItemID(itemId:int , _count:int):int
		{
			for(var i:int = 0 ; i < _goodsList.length ; i++)
			{
				if(_goodsList[i].info.TemplateID == itemId && _goodsList[i].count == _count)
					return i;
			}
			return -1;
		}
		/**
		 * 通过 TemplateID 在_templateIDList 中找到对应物品的编号
		 * @param itemId
		 * 
		 */		
		private function _findSelectedGoodsNumberInTemplateIDList(itemId:int , _count:int):int
		{
			for(var i:int = 0 ; i < _templateIDList.length ; i++)
			{
				if(_templateIDList[i].TemplateId == itemId && _templateIDList[i].ItemCount == _count)
					return i;
			}
			return -1;
		}
		
		private function _finish():void
		{
	//		SocketManager.Instance.out.sendFinishRoulette();
		}
		
		public function set keyCount(value:int):void
		{
			_keyCount = value;
			_keyConutText.text = String(value);
		}
		
		public function get keyCount():int
		{
			return _keyCount;
		}
		
		public function set selectNumber(value:int):void
		{
			_selectNumber = value;
			_selectNumberText.text = String(8 - _selectNumber);
			_needKeyText.text = String(_needKeyCount[_selectNumber]);
		}
		
		private function get needKeyCount():int
		{
			return _needKeyCount[_selectNumber];
		}
		
		public function get selectNumber():int
		{
			return _selectNumber;
		}
		
		public function set turnSlectedNumber(value:int):void
		{
			_turnSlectedNumber = value;
		}
		
		public function get turnSlectedNumber():int
		{
			return _turnSlectedNumber;
		}
		
		public function set isTurn(value:Boolean):void
		{
			_isTurn = value;
			if(_isTurn)
			{
				_startButton.enable = false;
				_buyKeyButton.enable = false;
			}
			else
			{
				_startButton.enable = true;
				_buyKeyButton.enable = true;
			}
		}
		
		public function get isTurn():Boolean
		{
			return _isTurn;
		}
		
		public function get isCanClose():Boolean
		{
			return _isCanClose;
		}
		
		private function getTemplateInfo(id : int) : InventoryItemInfo
		{
			var itemInfo : InventoryItemInfo = new InventoryItemInfo();
			itemInfo.TemplateID = id;
			ItemManager.fill(itemInfo);
			return itemInfo;
		}
		
		public function dispose():void
		{
			RouletteManager.Instance.removeEventListener(RouletteEvent.ROULETTE_KEYCOUNT_UPDATE , _keyUpdate);
		//	SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LOTTERY_GET_ITEM , _getItem);
			_turnControl.removeEventListener(TurnControl.TURNCOMPLETE , _turnComplete);
			_startButton.removeEventListener(MouseEvent.CLICK , _turnClick);
			_buyKeyButton.removeEventListener(MouseEvent.CLICK , _buyKeyClick);
			
			if(_turnControl)
			{
				_turnControl.dispose();
				_turnControl = null;
			}
			
			if(_glintView)
			{
				_glintView.dispose();
				_glintView = null;
			}
			
			_finish();
			
			_templateIDList.splice(0,_templateIDList.length);
			
			clearTimeout(_winTimeOut);
			
			_startButton.dispose();
			
			for(var i:int = 0 ; i < _goodsList.length ; i++)
			{
				_goodsList[i].dispose();
			}
			
			for(var j:int = 0 ; j < _selectGoodsList.length ; j++)
			{
				_selectGoodsList[j].dispose();
			}
			
			if(this.parent)
				this.parent.removeChild(this);
		}
	}
}




























