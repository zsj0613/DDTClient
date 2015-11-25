package ddt.tofflist.view
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.crazytank.view.tofflist.*;

	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	
	import ddt.tofflist.TofflistController;
	import ddt.tofflist.TofflistEvent;
	import ddt.tofflist.TofflistModel;

	public class TofflistRightView extends Sprite
	{
		private var _stairMenu      : TofflistStairMenu;/*一级菜单*/
		private var _twoGradeMenu   : TofflistTwoGradeMenu;/*二级菜单*/
		private var _thirdClassMenu : TofflistThirdClassMenu;/*三级菜单*/
		private var _titleBar       : TofflistTitleBarAsset;/*标题栏*/
		private var _gridBg         : TofflistGridBgAsset;/*网格背景*/
		private var _upPage         : TofflistPageAsset;/*上下页*/
		private var _pgup           : HBaseButton;//翻上页
		private var _pgdn           : HBaseButton;//翻下页
		private var _totalPage      : int;//总页数
		private var _currentPage    : int;//当前页
		private var _currentData    : Array;//当前的数据
		private var _orderList      : TofflistOrderList;
		private var _contro         : TofflistController;
		public function TofflistRightView($contro : TofflistController)
		{
			_contro = $contro; 
			super();
			init();
			addEvent();
		}
		private function init() : void
		{
			_stairMenu = new TofflistStairMenu();
			addChild(_stairMenu);
			_twoGradeMenu = new TofflistTwoGradeMenu();
			addChild(_twoGradeMenu);
			_thirdClassMenu = new TofflistThirdClassMenu();
			addChild(_thirdClassMenu);
			
			_titleBar  = new TofflistTitleBarAsset();
			_titleBar.gotoAndStop(1);
			addChild(_titleBar);
			
			_gridBg    = new TofflistGridBgAsset();
			addChild(_gridBg);
			_gridBg.gotoAndStop(1);
			_upPage    = new TofflistPageAsset();
			addChild(_upPage);
			_pgup      = new HBaseButton(_upPage.prePageBtnAsset);
			_pgdn      = new HBaseButton(_upPage.nextPageBtnAsset);
			_pgup.useBackgoundPos = _pgdn.useBackgoundPos = true;
			addChild(_pgup);
			addChild(_pgdn);
			_pgup.enable = _pgdn.enable = false;
			_orderList = new TofflistOrderList();
			addChild(_orderList);
			_orderList.x = 510;
			_orderList.y = 138;
		}
		private function addEvent() : void
		{
			_stairMenu.addEventListener(TofflistEvent.TOFFLIST_TOOL_BAR_SELECT,       __selectStairMenuHandler);
			_twoGradeMenu.addEventListener(TofflistEvent.TOFFLIST_TOOL_BAR_SELECT,    __selectChildBarHandler);
			_thirdClassMenu.addEventListener(TofflistEvent.TOFFLIST_TOOL_BAR_SELECT,  __searchOrderHandler);
			TofflistModel.addEventListener(TofflistEvent.TOFFLIST_TYPE_CHANGE,        __menuTypeHandler);
			_pgup.addEventListener(MouseEvent.CLICK,                                  __pgupHandler);
			_pgdn.addEventListener(MouseEvent.CLICK,                                  __pgdnHandler);
			this.addEventListener(Event.ADDED_TO_STAGE,                               __addToStageHandler);
		}
		private function removeEvent() : void
		{
			_stairMenu.removeEventListener(TofflistEvent.TOFFLIST_TOOL_BAR_SELECT,       __selectStairMenuHandler);
			_twoGradeMenu.removeEventListener(TofflistEvent.TOFFLIST_TOOL_BAR_SELECT,    __selectChildBarHandler);
			_thirdClassMenu.removeEventListener(TofflistEvent.TOFFLIST_TOOL_BAR_SELECT,  __searchOrderHandler);
			TofflistModel.removeEventListener(TofflistEvent.TOFFLIST_TYPE_CHANGE,        __menuTypeHandler);
			_pgup.removeEventListener(MouseEvent.CLICK,                                  __pgupHandler);
			_pgdn.removeEventListener(MouseEvent.CLICK,                                  __pgdnHandler);
			this.removeEventListener(Event.ADDED_TO_STAGE,                               __addToStageHandler);
		}
		private function __addToStageHandler(evt : Event) : void
		{
			_stairMenu.type = TofflistStairMenu.PERSONAL;
			_twoGradeMenu.setParentType(_stairMenu.type);
		}
		public function dispose() : void
		{
			removeEvent();
			_orderList.dispose();
			_stairMenu.dispose();
			_twoGradeMenu.dispose();
			_thirdClassMenu.dispose();
			if(this.parent)this.parent.removeChild(this);
		}
		/**上一页**/
		private function __pgupHandler(evt : MouseEvent) : void
		{
			SoundManager.instance.play("008");
			_currentPage --;
			_orderList.items(_currentData,_currentPage); 
			checkPageBtn();
		}
		/**下一页**/
		private function __pgdnHandler(evt : MouseEvent) : void
		{
			if(!_currentData)return;
			SoundManager.instance.play("008");
			_currentPage ++;
			_orderList.items(_currentData,_currentPage); 
			checkPageBtn();
		}
		
		/**选择一级菜单*/
		private function __selectStairMenuHandler(evt : TofflistEvent) : void
		{
			TofflistModel.firstMenuType = _stairMenu.type;
			_twoGradeMenu.setParentType(_stairMenu.type);
		}
		/**选择二级菜单*/
		private function __selectChildBarHandler(evt : TofflistEvent) : void
		{
			TofflistModel.secondMenuType = _twoGradeMenu.type;
			_thirdClassMenu.selectType(_stairMenu.type,_twoGradeMenu.type);
		}
		/**选择三级菜单*/
		private function __searchOrderHandler(evt : TofflistEvent) : void
		{
			if(TofflistModel.firstMenuType == TofflistStairMenu.PERSONAL)
			{
				if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.BATTLE)
				{
					if(_thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)_contro.loadPersonalBattleAcuumulate();
					
				}else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.LEVEL)
				{
					/**个人排行，等级**/
					if(_thirdClassMenu.type == TofflistThirdClassMenu.DAY)_contro.loadIndividualGradeDay();
					else if(_thirdClassMenu.type == TofflistThirdClassMenu.WEEK)_contro.loadIndividualGradeWeek();
					else if(_thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)_contro.loadIndividualGradeAccumulate();
				}
				else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.GESTE)
				{
					/**个人排行，功勋**/
					if(_thirdClassMenu.type == TofflistThirdClassMenu.DAY)_contro.loadIndividualExploitDay();
					else if(_thirdClassMenu.type == TofflistThirdClassMenu.WEEK)_contro.loadIndividualExploitWeek();
					else if(_thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)_contro.loadIndividualExploitAccumulate();
				}else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.ACHIEVEMENTPOINT)
				{
					/**个人排行, 成就点**/
					if(_thirdClassMenu.type == TofflistThirdClassMenu.DAY)_contro.loadPersonalAchievementPointDay();
					else if(_thirdClassMenu.type == TofflistThirdClassMenu.WEEK)_contro.loadPersonalAchievementPointWeek();
					else if(_thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)_contro.loadPersonalAchievementPoint();
				}
			}else if(TofflistModel.firstMenuType == TofflistStairMenu.CONSORTIA)
			{
				if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.LEVEL)
				{
					/**公会，等级，累积*/
					if(_thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)_contro.loadConsortiaAccumulate();
				}
				else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.ASSETS)
				{
					if(_thirdClassMenu.type == TofflistThirdClassMenu.DAY)_contro.loadConsortiaAssetDay();
					else if(_thirdClassMenu.type == TofflistThirdClassMenu.WEEK)_contro.loadConsoritaAssetWeek();
					else if(_thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)_contro.loadConsortiaAssetAccumulate();
				}
				else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.GESTE)
				{
					if(_thirdClassMenu.type == TofflistThirdClassMenu.DAY) _contro.loadConsortiaExploitDay();
					else if(_thirdClassMenu.type == TofflistThirdClassMenu.WEEK)_contro.loadConsortiaExploitWeek();
					else if(_thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)_contro.loadConsortiaExploitAccumulate();
				}else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.BATTLE)
				{
					/**公会，战斗力，累积*/
					if(_thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)_contro.loadConsortiaBattleAccumulate();
				}
			}else if(TofflistModel.firstMenuType == TofflistStairMenu.CROSS_SERVER_PERSONAL)
			{
				if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.BATTLE)
				{
					if(_thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)_contro.loadCrossServerPersonalBattleAcuumulate();
					
				}else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.LEVEL)
				{
					/**个人排行，等级**/
					if(_thirdClassMenu.type == TofflistThirdClassMenu.DAY)_contro.loadCrossServerIndividualGradeDay();
					else if(_thirdClassMenu.type == TofflistThirdClassMenu.WEEK)_contro.loadCrossServerIndividualGradeWeek();
					else if(_thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)_contro.loadCrossServerIndividualGradeAccumulate();
				}
				else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.GESTE)
				{
					/**个人排行，功勋**/
					if(_thirdClassMenu.type == TofflistThirdClassMenu.DAY)_contro.loadCrossServerIndividualExploitDay();
					else if(_thirdClassMenu.type == TofflistThirdClassMenu.WEEK)_contro.loadCrossServerIndividualExploitWeek();
					else if(_thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)_contro.loadCrossServerIndividualExploitAccumulate();
				}else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.ACHIEVEMENTPOINT)
				{
					/**个人排行, 成就点**/
					if(_thirdClassMenu.type == TofflistThirdClassMenu.DAY)_contro.loadCrossServerPersonalAchievementPointDay();
					else if(_thirdClassMenu.type == TofflistThirdClassMenu.WEEK)_contro.loadCrossServerPersonalAchievementPointWeek();
					else if(_thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)_contro.loadCrossServerPersonalAchievementPoint();
				}
			}else if(TofflistModel.firstMenuType == TofflistStairMenu.CROSS_SERVER_CONSORTIA)
			{
				if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.LEVEL)
				{
					/**公会，等级，累积*/
					if(_thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)_contro.loadCrossServerConsortiaAccumulate();
				}
				else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.ASSETS)
				{
					if(_thirdClassMenu.type == TofflistThirdClassMenu.DAY)_contro.loadCrossServerConsortiaAssetDay();
					else if(_thirdClassMenu.type == TofflistThirdClassMenu.WEEK)_contro.loadCrossServerConsoritaAssetWeek();
					else if(_thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)_contro.loadCrossServerConsortiaAssetAccumulate();
				}
				else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.GESTE)
				{
					if(_thirdClassMenu.type == TofflistThirdClassMenu.DAY) _contro.loadCrossServerConsortiaExploitDay();
					else if(_thirdClassMenu.type == TofflistThirdClassMenu.WEEK)_contro.loadCrossServerConsortiaExploitWeek();
					else if(_thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)_contro.loadCrossServerConsortiaExploitAccumulate();
				}else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.BATTLE)
				{
					/**公会，战斗力，累积*/
					if(_thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)_contro.loadCrossServerConsortiaBattleAccumulate();
				}
			}
		}
		/**二级菜单的响应*/
		private function __menuTypeHandler(evt : TofflistEvent) : void
		{
			if(TofflistModel.firstMenuType == TofflistStairMenu.PERSONAL)
			{
				switch(TofflistModel.secondMenuType)
				{
					case TofflistTwoGradeMenu.BATTLE:
					_titleBar.gotoAndStop("individualBattle");
					_gridBg.gotoAndStop(1);
					break;
					case TofflistTwoGradeMenu.LEVEL:
					_titleBar.gotoAndStop("individualLevel");
					_gridBg.gotoAndStop(2);
					break;
					case TofflistTwoGradeMenu.GESTE:
					_titleBar.gotoAndStop("individualGeste");
					_gridBg.gotoAndStop(1);
					break;
					case TofflistTwoGradeMenu.ACHIEVEMENTPOINT:
					_titleBar.gotoAndStop("individuaAchievementPoint");
					_gridBg.gotoAndStop(1);
					break;
				}
			}else if(TofflistModel.firstMenuType == TofflistStairMenu.CONSORTIA)
			{
				switch(TofflistModel.secondMenuType)
				{
					case TofflistTwoGradeMenu.LEVEL:
					_titleBar.gotoAndStop("consortiaLevel");
					_gridBg.gotoAndStop(2);
					break;
					case TofflistTwoGradeMenu.ASSETS:
					_titleBar.gotoAndStop("consortiaAsset");
					_gridBg.gotoAndStop(1);
					break;
					case TofflistTwoGradeMenu.GESTE:
					_titleBar.gotoAndStop("consortiaGeste");
					_gridBg.gotoAndStop(1);
					break;
					case TofflistTwoGradeMenu.BATTLE:
					_titleBar.gotoAndStop("individualBattle");
					_gridBg.gotoAndStop(1);
				}
			}else
			{
				crossServerMenuTypeHandler();
			}
		}
		
		private function crossServerMenuTypeHandler():void
		{
			if(TofflistModel.firstMenuType == TofflistStairMenu.CROSS_SERVER_PERSONAL)
			{
				switch(TofflistModel.secondMenuType)
				{
					case TofflistTwoGradeMenu.BATTLE:
					_titleBar.gotoAndStop("crossServerIndividualBattle");
					_gridBg.gotoAndStop(4);
					break;
					case TofflistTwoGradeMenu.LEVEL:
					_titleBar.gotoAndStop("crossServerIndividualLevel");
					_gridBg.gotoAndStop(3);
					break;
					case TofflistTwoGradeMenu.GESTE:
					_titleBar.gotoAndStop("crossServerIndividualGeste");
					_gridBg.gotoAndStop(4);
					break;
					case TofflistTwoGradeMenu.ACHIEVEMENTPOINT:
					_titleBar.gotoAndStop("crossServerIndividuaAchievementPoint");
					_gridBg.gotoAndStop(4);
					break;
				}
			}else if(TofflistModel.firstMenuType == TofflistStairMenu.CROSS_SERVER_CONSORTIA)
			{
				switch(TofflistModel.secondMenuType)
				{
					case TofflistTwoGradeMenu.LEVEL:
					_titleBar.gotoAndStop("crossServerConsortiaLevel");
					_gridBg.gotoAndStop(3);
					break;
					case TofflistTwoGradeMenu.ASSETS:
					_titleBar.gotoAndStop("crossServerConsortiaAsset");
					_gridBg.gotoAndStop(4);
					break;
					case TofflistTwoGradeMenu.GESTE:
					_titleBar.gotoAndStop("crossServerConsortiaGeste");
					_gridBg.gotoAndStop(4);
					break;
					case TofflistTwoGradeMenu.BATTLE:
					_titleBar.gotoAndStop("crossServerIndividualBattle");
					_gridBg.gotoAndStop(4);
				}
			}
		}
		
		/**数据更新**/
		public function orderList($list : Array) : void
		{
//			if(!$list)return;
			_currentData = $list;
			_orderList.items($list); 
			_totalPage = Math.ceil(($list == null ? 0 : $list.length) / 8);
			if(_currentData && _currentData.length>0)_currentPage = 1;
			else _currentPage = 1;
			checkPageBtn();
		}
		/**检查翻页按钮**/
		private function checkPageBtn() : void
		{
			if(_currentPage <= 1)this._pgup.enable = false;
			else this._pgup.enable = true;
			if(_currentPage < _totalPage) this._pgdn.enable = true;
			else this._pgdn.enable = false;
			this._upPage.pageTxt.text = String(_currentPage);
		}
		public function get firstType() : String
		{
			return this._stairMenu.type;
		}
		public function get twoGradeType() : String
		{
			return this._twoGradeMenu.type;
		}
	}
}