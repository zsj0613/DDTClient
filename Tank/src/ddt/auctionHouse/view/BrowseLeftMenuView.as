package ddt.auctionHouse.view
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import game.crazyTank.view.AuctionHouse.BrowserLeftStripAsset;
	import game.crazyTank.view.AuctionHouse.BrowserLeftSubStripAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.SimpleGrid;
	import road.utils.ComponentHelper;
	import road.utils.StringHelper;
	
	import ddt.auctionHouse.event.AuctionHouseEvent;
	import ddt.auctionHouse.model.AuctionHouseModel;
	import ddt.auctionHouse.view.vmenu.VerticalMenu;
	import ddt.data.goods.CateCoryInfo;
	import ddt.manager.LanguageMgr;
	import ddt.utils.DisposeUtils;
	
	import game.crazyTank.view.AuctionHouse.BrowseLeftListAsset;
	public class BrowseLeftMenuView extends BrowseLeftListAsset
	{
		
		private var menu:VerticalMenu;
		private var list:SimpleGrid;
		private var _name:TextField;
		private var item_all:BrowseLeftMenuItem;
		private var searchStatus : Boolean;//查看和搜索
		
		private var _searchIIBtn : HBaseButton;
		private var _searchBtn   : HBaseButton;
		private var _searchValue : String;
		
		private var _glowState:Boolean;
		
		/**
		 * 全部
		 * 武器
		 * 	   武器
		 * 	   副武器
		 * 服装
		 * 	   帽子
		 * 	   眼镜
		 * 	   衣服
		 * 	   首饰
		 * 美容
		 * 	   头发
		 * 	   脸饰
		 * 	   眼睛
		 * 	   套装
		 * 	   翅膀
		 * 道具
		 * 	   战斗道具
		 * 	   辅助道具
		 * 	   泡泡
		 * 强化石
		 * 	   强化石1级
		 * 	   强化石2级
		 * 	   强化石3级
		 * 	   强化石4级
		 * 	   强化石5级
		 * 合成石
		 * 	   朱雀石
		 * 	   玄武石
		 * 	   青龙石
		 * 	   白虎石
		 * 宝珠
		 * 	   三角宝珠
		 * 	   圆形宝珠
		 * 	   方形宝珠	
		 * */
		
		private static const ALL:int = -1;
			
		private static const WEAPON:int = 25;
			private static const SUB_WEAPON:int = 7;
			private static const OFFHAND:int = 17;
		private static const CLOTH:int = 21;
			private static const HAT:int = 1;
			private static const GLASS:int = 2;
			private static const SUB_CLOTH:int = 5;
			private static const JEWELRY:int = 24;
		private static const BEAUTY:int = 22;
			private static const HAIR:int = 3;
			private static const ORNAMENT:int = 4;
			private static const EYES:int = 6;
			private static const SUITS:int = 13;
			private static const WINGS:int = 15;
		private static const PROP:int = 23;
			private static const FIGHT_PROP:int = 10;
			private static const UNFIGHT_PROP:int = 11;
			private static const PAOPAO:int = 16;
		private static const STRENTH:int = 1100;
			private static const STRENTH_1:int = 1101;
			private static const STRENTH_2:int = 1102;
			private static const STRENTH_3:int = 1103;
			private static const STRENTH_4:int = 1104;
			private static const STRENTH_5:int = 1110;
		private static const COMPOSE:int = 1105;
			private static const ZHUQUE:int = 1106;
			private static const XUANWU:int = 1107;
			private static const QINGLONG:int = 1108;
			private static const BAIHU:int = 1109;
		private static const SPHERE:int = 26;
			private static const TRIANGLE:int = 27;
			private static const ROUND:int = 28;
			private static const SQUERE:int = 29;
		
		public function BrowseLeftMenuView()
		{
			initView();
		}
		
		private function initView():void
		{
			searchIIBtn.search_mc.visible = true;
			_searchIIBtn   = new HBaseButton(searchIIBtn);
			_searchIIBtn.useBackgoundPos = true;
			addChild(_searchIIBtn);
			_searchBtn    = new HBaseButton(searchBtn);
			_searchBtn.useBackgoundPos = true;
			
			addChild(_searchBtn);
			
			var format:TextFormat = new TextFormat();
			format.color = 0x000000;
			format.size = 14;
			format.bold = true;
			format.font = "Arial";
			_name = new TextField();
			_name.type = TextFieldType.INPUT;
			_name.defaultTextFormat = format;
			_name.text = "";
			_searchValue = "";
			_name.maxChars = 20;
			
			ComponentHelper.replaceChild(this,searchNamePos_mc,_name);
			_name.addEventListener(KeyboardEvent.KEY_DOWN,__keyDown);
			_name.addEventListener(Event.ADDED_TO_STAGE, setFocus);
			_searchBtn.addEventListener(MouseEvent.CLICK,__searchCondition);
			_searchIIBtn.addEventListener(MouseEvent.CLICK,__searchCondition);
			
			list = new SimpleGrid(188,250,1);
			list.x = listPos_mc.x - 2;
			list.y = listPos_mc.y;
			list.setSize(205,340);
			list.horizontalScrollPolicy = "off";
			list.verticalScrollPolicy   = "on";
			addChild(list);
			
			menu = new VerticalMenu(17,30,33);
			listPos_mc.visible = false;
//			menu.x = listPos_mc.x;
//			menu.y = listPos_mc.y;
//			addChild(menu);
			
			list.appendItem(menu);
			menu.addEventListener(VerticalMenu.MENU_CLICKED,menuItemClick);
		}
		
		private function setFocus(evt : Event) : void
		{
			_name.text         = "";
			_searchValue       = "";
			_name.stage.focus  = TextField(_name);
		}
		
		internal function dispose():void
		{
			_name.removeEventListener(KeyboardEvent.KEY_DOWN,__keyDown);
			if(_searchBtn)_searchBtn.removeEventListener(MouseEvent.CLICK,__searchCondition);
			if(_searchIIBtn)_searchIIBtn.removeEventListener(MouseEvent.CLICK,__searchCondition);
			_name.removeEventListener(Event.ADDED_TO_STAGE, setFocus);
			if(item_all)
			{
				item_all.dispose();
				item_all = null;
			}
			if(menu)
			{
				menu.removeEventListener(VerticalMenu.MENU_CLICKED,menuItemClick);
				menu.dispose();
				menu = null;
			}
			if(list)
			{
				list.clearItems();
				list = null;
			}
			DisposeUtils.disposeHBaseButton(_searchIIBtn);
			DisposeUtils.disposeHBaseButton(_searchBtn);
			while(this.numChildren)
			{
				var mc : DisplayObject = this.getChildAt(0) as DisplayObject;
				this.removeChild(mc);
				mc = null;
			}
		}
		
		internal function getInfo():CateCoryInfo
		{
			if(menu.currentItem){
				return menu.currentItem.info as CateCoryInfo;
			}else{
				return item_all.info as CateCoryInfo;
			}
		}
		
		internal function setSelectType(type:CateCoryInfo):void
		{
			
		}	
		
		internal function getType():int
		{
			if(menu.currentItem){
				return menu.currentItem.info.ID;
			}else{
				return -1;
			}
		}
		
		internal function setCategory(value:Array):void
		{
			LanguageMgr.GetTranslation("ddt.auctionHouse.view.BrowseLeftMenuView.Weapon")
			item_all = new BrowseLeftMenuItem(new BrowserLeftStripAsset(),getMainCateInfo(ALL,"全部"),true);
			var item0:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(),getMainCateInfo(CLOTH,LanguageMgr.GetTranslation("ddt.auctionHouse.view.cloth")));
			var item1:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(),getMainCateInfo(BEAUTY,LanguageMgr.GetTranslation("ddt.auctionHouse.view.beauty")));
			var item2:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(),getMainCateInfo(PROP,LanguageMgr.GetTranslation("ddt.auctionHouse.view.prop")));
			var item4:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(),getMainCateInfo(WEAPON,LanguageMgr.GetTranslation("ddt.auctionHouse.view.BrowseLeftMenuView.Weapon")));
		    
		    var item5:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(),getMainCateInfo(STRENTH,LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.qianghuashi")));
		    var item6:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(),getMainCateInfo(COMPOSE,LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.hechengshi")));
		    var item7:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(),getMainCateInfo(SPHERE,LanguageMgr.GetTranslation("ddt.auctionHouse.view.sphere")));
			menu.addItemAt(item_all,-1);
			menu.addItemAt(item4,-1);
			menu.addItemAt(item0,-1);
			menu.addItemAt(item1,-1);
			menu.addItemAt(item2,-1);
			
			menu.addItemAt(item5,-1);
			menu.addItemAt(item6,-1);
			menu.addItemAt(item7,-1);
			
			
			for each(var info:CateCoryInfo in value)
			{
				var item:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),info);
				
				if(info.ID == HAT ||info.ID == GLASS ||info.ID == SUB_CLOTH)
				{
//					服装
					menu.addItemAt(item,2);
				}
				else if(info.ID == SUITS ||info.ID == WINGS ||info.ID == EYES || info.ID == ORNAMENT || info.ID == HAIR)
				{
//					美容
					menu.addItemAt(item,3);
				}
				else if(info.ID == FIGHT_PROP ||info.ID == UNFIGHT_PROP || info.ID == PAOPAO)
				{
//					道具
					menu.addItemAt(item,4);
				}
			}
			/**这里增加了一些数据库没有的类别,所以用文本进行全局搜索,在控制器那里的类型ID有处理成-1***/
			var jewelry:CateCoryInfo = new CateCoryInfo();
			jewelry.ID = JEWELRY;
			jewelry.Name = LanguageMgr.GetTranslation("ddt.auctionHouse.view.jewelry");
			var jewelryItem:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),jewelry);
			menu.addItemAt(jewelryItem,2);
			
			var subWeapon:CateCoryInfo = new CateCoryInfo();
			subWeapon.ID = SUB_WEAPON;
			subWeapon.Name = LanguageMgr.GetTranslation("ddt.auctionHouse.view.BrowseLeftMenuView.Weapon");
			var subWeaponItem:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),subWeapon);
			menu.addItemAt(subWeaponItem,1);
			var offHand:CateCoryInfo = new CateCoryInfo();
			offHand.ID = OFFHAND;
			offHand.Name = LanguageMgr.GetTranslation("ddt.auctionHouse.view.offhand");
			var offHandItem:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),offHand);
			menu.addItemAt(offHandItem,1);
			
			var subItem1:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset,getMainCateInfo(STRENTH_1,LanguageMgr.GetTranslation("ddt.auctionHouse.view.BrowseLeftMenuView.qianghua1")));
			var subItem2:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset,getMainCateInfo(STRENTH_2,LanguageMgr.GetTranslation("ddt.auctionHouse.view.BrowseLeftMenuView.qianghua2")));
			var subItem3:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset,getMainCateInfo(STRENTH_3,LanguageMgr.GetTranslation("ddt.auctionHouse.view.BrowseLeftMenuView.qianghua3")));
			var subItem4:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset,getMainCateInfo(STRENTH_4,LanguageMgr.GetTranslation("ddt.auctionHouse.view.BrowseLeftMenuView.qianghua4")));
			var subItem5:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset,getMainCateInfo(STRENTH_5,LanguageMgr.GetTranslation("ddt.auctionHouse.view.BrowseLeftMenuView.qianghua5")));
			menu.addItemAt(subItem1,5);menu.addItemAt(subItem2,5);menu.addItemAt(subItem3,5);menu.addItemAt(subItem4,5);menu.addItemAt(subItem5,5);
			
			var subItem6 : BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset,getMainCateInfo(ZHUQUE,LanguageMgr.GetTranslation("BrowseLeftMenuView.zhuque")));
			var subItem7 : BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset,getMainCateInfo(XUANWU,LanguageMgr.GetTranslation("BrowseLeftMenuView.xuanwu")));
			var subItem8 : BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset,getMainCateInfo(QINGLONG,LanguageMgr.GetTranslation("BrowseLeftMenuView.qinglong")));
			var subItem9 : BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset,getMainCateInfo(BAIHU,LanguageMgr.GetTranslation("BrowseLeftMenuView.baihu")));
			menu.addItemAt(subItem6,6);
			menu.addItemAt(subItem7,6);
			menu.addItemAt(subItem8,6);
			menu.addItemAt(subItem9,6);
			
			var triangle:CateCoryInfo = new CateCoryInfo();
			triangle.ID = TRIANGLE;
			triangle.Name = LanguageMgr.GetTranslation("ddt.auctionHouse.view.triangle");
			var triangleItem:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),triangle);
			menu.addItemAt(triangleItem,7);
			
			var round:CateCoryInfo = new CateCoryInfo();
			round.ID = ROUND;
			round.Name = LanguageMgr.GetTranslation("ddt.auctionHouse.view.round");
			var roundItem:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),round);
			menu.addItemAt(roundItem,7);
			
			var square:CateCoryInfo = new CateCoryInfo();
			square.ID = SQUERE;
			square.Name = LanguageMgr.GetTranslation("ddt.auctionHouse.view.square");
			var squareItem:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),square);
			menu.addItemAt(squareItem,7);
			
		}
		
		private function getMainCateInfo(id:int,name:String):CateCoryInfo
		{
			var info:CateCoryInfo = new CateCoryInfo();
			info.ID = id;
			info.Name = name;
			return info;
		}
		
		public function get searchText():String
		{
			//点查看,搜索返回不同的值
			if(searchStatus || AuctionHouseModel.searchType == 3)
			{
				return _name.text;
			}
			else
			{
				return "";
			}
			
		}
		public function set setSearchStatus(b : Boolean) : void
		{
			searchStatus = b;
		}
		
		public function set searchText(s:String):void
		{
			_name.text = s;
			_searchValue = s;
			
		}
		
		private function __keyDown(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.ENTER)
			{
				__searchCondition(null);
			}
		}
		
		private function __searchCondition(event:MouseEvent):void
		{
			SoundManager.instance.play("008");
			_searchValue = "";
			searchIIBtn.search_mc.visible = false; //bret 09.8.6
				
			//点查看还是搜索
			if(event == null || event.target.name == "searchBtn")
			{
				searchStatus = true;
				AuctionHouseModel.searchType = 2;
			}
			else 
			{
				searchStatus = false;
				AuctionHouseModel.searchType = 1;
			}
			
			_name.text = StringHelper.trim(_name.text);
			_searchValue = _name.text;

			dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.SELECT_STRIP));
			
			_name.stage.focus  = TextField(_name);
			
			
		}
		
		private function menuItemClick(e:Event):void
		{
			list.cellHeight = menu.$height;
			searchIIBtn.search_mc.visible = true; //bret 09.8.6
//			dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.SELECT_STRIP));
		}
		

	}
}