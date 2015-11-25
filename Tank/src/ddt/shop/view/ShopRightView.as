package ddt.shop.view
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.shopII.ShopBgAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.ISelectable;
	import road.ui.controls.SimpleGrid;
	import road.utils.ClassFactory;
	import road.utils.ComponentHelper;
	
	import ddt.shop.ShopController;
	
	import ddt.data.EquipType;
	import ddt.data.goods.ShopIICarItemInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.ShopManager;
	import ddt.manager.UserGuideManager;

	public class ShopRightView extends ShopBgAsset
	{		
		private var _btns:Array;
		private var _second_btns:Array;
		private var _three_btns:Array;
		private var _list:SimpleGrid;
		private var _items:Array;
		private var _currentType:int = -1;
		//记录子菜单的种类
		private var _currentSecType:int = -1;
		/**
		 *记录三级菜单的种类 
		 */		
		private var _currentThreeType:int = -1;
		private var _currentSex:int;
		private var _controller:ShopController;
		private var _types:Array;
		//记录点击按钮后加载的类型(按类型ID排序按钮)
		private var _currentPage:int;
		
		private var preBtn:HBaseButton;
		private var nextBtn:HBaseButton;
		
		public function ShopRightView(controller:ShopController)
		{
			super();
			_controller = controller;
			init();
			initEvent();
		}
	
		private function init():void
		{
			_items = [];
			_btns = [hotBtn,weaponBtn,clothBtn,beautyBtn,equipBtn,freeBtn];
			_types = [[0,1],
					  [ShopManager.WEAPON],
					  [ShopManager.CLOTH,ShopManager.HAT,ShopManager.GLASS,[ShopManager.ARMLET,ShopManager.RING],ShopManager.SUITS],
					  [ShopManager.HAIR,ShopManager.WING,ShopManager.EYES,ShopManager.FACE_ORNAMENTS],
					//  [ShopManager.UNFIGHT_PROP,ShopManager.PAOPAO,ShopManager.FIGHT_PROP],
					  [ShopManager.UNFIGHT_PROP,ShopManager.PAOPAO],
					  [1,2]
					 ];
			_second_btns = [[_recommebbtn,_rebateBtn],
							[],
							[_clothBtn,_hatBtn,_glassBtn,_jewelryBtn,_suitsBtn],
							[_hairBtn,_wingBtn,_faceBtn,_effBtn],
						//	[_unfrightpropBtn,_specialpropBtn,_frightpropBtn],
							[_unfrightpropBtn,_specialpropBtn],
							[_giftBtn,_gesteBtn],
						   ];
			_three_btns = [_threeAll,_threeCloth,_threeWeapon,_threeBeauty,_threeEquip];
		
			var i:int = 0;
			for(i = 0; i < _btns.length; i++)
			{
				_btns[i].gotoAndStop(2);
				_btns[i].addEventListener(MouseEvent.CLICK,__btnClick);
				_btns[i].buttonMode = true;
			}
			for(i = 0; i < _second_btns.length; i++)
			{
				for(var j:int = 0; j < _second_btns[i].length; j++)
				{
					_second_btns[i][j].visible = false;
					_second_btns[i][j].gotoAndStop(1);
					_second_btns[i][j].addEventListener(MouseEvent.CLICK,__secBtnClick,false,0,true);
					_second_btns[i][j].buttonMode = true;
				}
			}
			
			for(i = 0 ; i < _three_btns.length ; i++)
			{
				_three_btns[i].visible = false;
				_three_btns[i].gotoAndStop(1);
				_three_btns[i].addEventListener(MouseEvent.CLICK,__threeBtnClick,false,0,true);
				_three_btns[i].buttonMode = true;
			}
			
			_list = new SimpleGrid(230,91,2);
			_list.marginHeight = _list.marginWidth = 2;
			_list.cellPaddingHeight = 1;
			_list.cellPaddingWidth = 8;
			ComponentHelper.replaceChild(this,list_pos,_list);
			for(i = 0; i < 8; i++)
			{
				var item:ShopGoodsItem = new ShopGoodsItem();
				item.addEventListener(MouseEvent.CLICK,__itemClick);
				item.addEventListener(ShopGoodsItem.ADDTOCAR,__addToCar);
				_list.appendItem(item);
				_items.push(item);
				item.selected = false;
			}
			man_btn.buttonMode = true;
			woman_btn.buttonMode = true;
			setCurrentSex(PlayerManager.Instance.Self.Sex ? 1 : 2);
			_currentType = 0;
			_currentPage = 1;
			_btns[0].gotoAndStop(1);
			
			
			preBtn = new HBaseButton(preBtnAccect);
			preBtn.useBackgoundPos = true;
			addChild(preBtn);
			
			nextBtn = new HBaseButton(nextBtnAccect);
			nextBtn.useBackgoundPos = true;
			addChild(nextBtn);
		}
		
		private function initEvent():void
		{
			man_btn.addEventListener(MouseEvent.CLICK,__sexClick);
			woman_btn.addEventListener(MouseEvent.CLICK,__sexClick);
			preBtn.addEventListener(MouseEvent.CLICK,__preBtnClick);
			nextBtn.addEventListener(MouseEvent.CLICK,__nextBtnClick);
			addEventListener(Event.ADDED_TO_STAGE,userGuide);
		}
		private function userGuide(e:Event):void{
			if(!UserGuideManager.Instance.getIsFinishTutorial(35)){//选择免费区
				UserGuideManager.Instance.setupStep(35,UserGuideManager.CONTROL_GUIDE,null,checkUserGuideTask35);
			}
		}
		
		private function checkUserGuideTask35():Boolean{
			if(_currentType == 5){
				setType(5);
				return true;
			}
			return false;
		}
		
		private function __btnClick(evt:MouseEvent):void
		{
			var index:int = _btns.indexOf(evt.currentTarget as MovieClip);
			if(index != -1 && index != _currentType)
			{
				setType(index);
				SoundManager.instance.play("008");
			}
		}
		
		public function setType(type:int):void
		{
			if(_currentType != -1)
			{
				_btns[_currentType].gotoAndStop(2);
				addChildAt(_btns[_currentType],1);
			}
			_currentType = type;
			_btns[_currentType].gotoAndStop(1);
			addChild(_btns[_currentType]);
			_currentSecType = -1;
			_currentPage = 1;
			showSecBtns(_currentType);
			showThreeBtns(_currentType);
			loadList();
		}
		
		private function showSecBtns(type:int):void
		{
			for(var i:int = 0; i < _second_btns.length; i++)
			{
				var j:int = 0;
				if(i == type)
				{
					for(j = 0; j < _second_btns[i].length; j++)
					{
						_second_btns[i][j].visible = true;
						_second_btns[i][j].gotoAndStop(1);
						_second_btns[i][0].gotoAndStop(2);
						_currentSecType = 0;
					}
				}
				else
				{
					for(j = 0; j < _second_btns[i].length; j++)
					{
						_second_btns[i][j].visible = false;
						_second_btns[i][j].gotoAndStop(1);
					}
				}
			}
		}
		
		private function showThreeBtns(type:int):void
		{
			if(type == 5)
			{
				for(var i:int = 0 ; i < _three_btns.length ; i++)
				{
					_three_btns[i].visible = true;
					_three_btns[i].gotoAndStop(1);
					_three_btns[0].gotoAndStop(2);
					_currentThreeType = 0;
				}
			}
			else
			{
				for(i = 0 ; i < _three_btns.length ; i++)
				{
					_three_btns[i].visible = false;
					_three_btns[i].gotoAndStop(1);
					_currentThreeType = -1;
				}
			}
		}
		
		private function __secBtnClick(evt:MouseEvent):void
		{
			if((evt.currentTarget as MovieClip).currentFrame == 2)return;
			_currentSecType = _second_btns[_currentType].indexOf(evt.currentTarget as MovieClip);
			if(_currentSecType == -1)return;
			for(var i:int = 0; i < _second_btns[_currentType].length; i++)
			{
				_second_btns[_currentType][i].gotoAndStop(1);
			}
			_second_btns[_currentType][_currentSecType].gotoAndStop(2);
			_currentPage = 1;
			showThreeBtns(_currentType);
			loadList();			
			SoundManager.instance.play("008");
		}
		
		private function __threeBtnClick(evt:MouseEvent):void
		{
			if((evt.currentTarget as MovieClip).currentFrame == 2)return;
			_currentThreeType = _three_btns.indexOf(evt.currentTarget as MovieClip);
			if(_currentSecType == -1)return;
			
			for(var i:int = 0 ; i < _three_btns.length ; i++)
			{
				_three_btns[i].gotoAndStop(1);
			}
			
			_three_btns[_currentThreeType].gotoAndStop(2);
			_currentPage = 1;
			loadList();			
			SoundManager.instance.play("008");
		}
		
		private function __itemClick(evt:MouseEvent):void
		{
			var item:ShopGoodsItem = evt.currentTarget as ShopGoodsItem;
			if(!item.shopItemInfo)return;
			if(item.shopItemInfo.count == 0)
			{
				SoundManager.instance.play("008");
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.countOver"));
				return;
			}
			
			// 限量购买处理 add by Freeman <start>

			//商品栏目小于16为玩家可装备的商品, 10, 11, 12 为非可装备到身上的道具
			if(item.shopItemInfo.ShopID<=16 &&item.shopItemInfo.ShopID!=10 && item.shopItemInfo.ShopID!=11 && item.shopItemInfo.ShopID!=12){
				for each (var obj:Object in ShopManager.countLimitArray){
					if(obj["templateID"]==item.shopItemInfo.TemplateID){
						if(obj["currentCount"]<=item.shopItemInfo.count){
							obj["currentCount"]++;
						}
						if(obj["currentCount"]>item.shopItemInfo.count && item.shopItemInfo.count!=-1)
						{
							item.selected = true;
							obj["currentCount"]--;
							MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.GoodsNumberLimit"));
							return;
						}
					}
				}
			}
			

			
			// 限量购买处理 add by Freeman <end>
			
			itemClick(item);
			if(item.info != null)
			{
				if(!EquipType.isProp(item.info))
					_controller.addTempEquip(item.shopItemInfo);
			}
		}

		private function itemClick(item:ShopGoodsItem):void
		{
			if(item.info != null)
			{
				if(_currentSex != item.info.NeedSex && item.info.NeedSex != 0)
				{
					setCurrentSex(item.info.NeedSex);
					_controller.setFittingModel(_currentSex == 1);
				}
				for each(var i:ISelectable in _items)
				{
					i.selected = i == item;
				}
				SoundManager.instance.play("047");
			}
		}
		
		private function __addToCar(evt:Event):void
		{
			var item:ShopGoodsItem = evt.currentTarget as ShopGoodsItem;
			if(item.shopItemInfo && item.shopItemInfo.count == 0)
			{
				SoundManager.instance.play("008");
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.countOver"));
				return;
			}
			itemClick(item);
			if(item.shopItemInfo != null)
			{
				var shopItem:ShopIICarItemInfo = new ShopIICarItemInfo(item.shopItemInfo.GoodsID,item.shopItemInfo.TemplateID);
				ClassFactory.copyProperties(item.shopItemInfo,shopItem);
				_controller.addToCar(shopItem);
			}
			_controller.showPanel(ShopController.SHOPCAR);
		}
		
		private function __sexClick(evt:MouseEvent):void
		{
			var target:int = (evt.currentTarget == man_btn ? 1 : 2);
			if(_currentSex == target) return;
			setCurrentSex(target);
			_currentPage = 1;
			_controller.setFittingModel(_currentSex == 1);
			SoundManager.instance.play("008");
		}
		
		public function setCurrentSex(sex:int):void
		{
			_currentSex = sex;
			man_btn.gotoAndStop(1);
			woman_btn.gotoAndStop(1);
			if(_currentSex == 1)man_btn.gotoAndStop(2);
			else woman_btn.gotoAndStop(2);
		}
		
		private function __preBtnClick(evt:MouseEvent):void
		{
			if(_currentPage == 1)
				_currentPage = ShopManager.Instance.getResultPages(8) + 1;
			_currentPage --;
			loadList();
			SoundManager.instance.play("008");
		}
		
		private function __nextBtnClick(evt:MouseEvent):void
		{
			if(_currentPage == ShopManager.Instance.getResultPages(8))
				_currentPage = 0;
			_currentPage ++;
			loadList();
			SoundManager.instance.play("008");
		}
		
		public function loadList():void
		{
			if(_currentType == 5)
			{
				if(_currentSecType == -1 || _currentSecType == 0)
				{
					setList(ShopManager.Instance.getGiftShopTemplatesByEquipType(_currentPage,-1,_currentSex,_currentThreeType));
				}else
				{
					setList(ShopManager.Instance.getGesteShopTemplatesByEquipType(_currentPage,_currentSex,-1,_currentThreeType));
				}
			}else if(_currentType == 0)
			{
				if(_currentSecType == -1 || _currentSecType == 0)
				{
					_controller.loadList(_currentPage,[],_currentSex,true);
				}else
				{
					setList(ShopManager.Instance.getDiscountShopTemplates(_currentPage,_currentSex));
				}
			}else if(_currentType == 1)
			{ 
				_controller.loadList(_currentPage,_types[_currentType],_currentSex,false);
			}else
			{
				_controller.loadList(_currentPage,_types[_currentType][_currentSecType],_currentSex,false);
			}
		}
		
		public function setList(list:Array):void
		{
			clearitems();
			for(var i:int = 0; i < _items.length; i++)
			{
				_items[i].selected = false;
				if(list[i])
				{	
					_items[i].shopItemInfo = list[i];
				}
			}
			page_txt.text = _currentPage + "/" + ShopManager.Instance.getResultPages(8);
		}
		
		private function clearitems():void
		{
			for(var i:int = 0 ; i < 8; i++)
			{
				_items[i].shopItemInfo = null;
			}
		}
		
		public function dispose():void
		{
			man_btn.removeEventListener(MouseEvent.CLICK,__sexClick);
			woman_btn.removeEventListener(MouseEvent.CLICK,__sexClick);
			preBtn.removeEventListener(MouseEvent.CLICK,__preBtnClick);
			nextBtn.removeEventListener(MouseEvent.CLICK,__nextBtnClick);
			_controller = null;
			for(var i:int = 0; i < _items.length; i++)
			{
				_items[i].removeEventListener(MouseEvent.CLICK,__itemClick);
				_items[i].removeEventListener(ShopGoodsItem.ADDTOCAR,__addToCar);
				_items[i].dispose();
			}
			if(_list.parent)_list.parent.removeChild(_list);
			for(i = 0; i < _btns.length; i++)
			{
				_btns[i].removeEventListener(MouseEvent.CLICK,__btnClick);
			}
			_btns = null;
			if(parent)parent.removeChild(this);
		}
	}
}