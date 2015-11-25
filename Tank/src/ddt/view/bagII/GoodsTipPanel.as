package ddt.view.bagII
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import fl.core.UIComponent;
	
	import game.crazyTank.view.GoodsTipBgAsset;
	import game.crazyTank.view.GoodsTipHeaderAsset;
	import game.crazyTank.view.GoodsTipItemDefenceAsset;
	import game.crazyTank.view.GoodsTipItemHertAsset;
	import game.crazyTank.view.GoodsTipItemNameAsset;
	import game.crazyTank.view.GoodsTipItemRecoverAsset;
	import game.crazyTank.view.GoodsTipItemTypeAsset;
	import game.crazyTank.view.GoodsTipQualityAsset;
	import game.crazyTank.view.HRuleAsset;
	
	import road.utils.StringHelper;
	
	import ddt.data.EquipType;
	import ddt.data.QualityType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.data.goods.StaticFormula;
	import ddt.manager.ItemManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	

	public class GoodsTipPanel extends UIComponent
	{
		private var _bg:GoodsTipBgAsset = new GoodsTipBgAsset();
		private var _head:GoodsTipHeaderAsset = new GoodsTipHeaderAsset();
		private var _list:TipGrid;
		private var _propertys:Array;
		private var _info:ItemTemplateInfo;
		private var _hert:GoodsTipItemHertAsset;
		private var _defense:GoodsTipItemDefenceAsset;
		private var _isBalance:Boolean;/* 是否需要装备对比 */
		private var _isBalanceTip:Boolean;/* 是否为对比装备的Tip */
		private var _isFurnished:Boolean;/* 是否为已装备 */
		private var _furnishedList:Array;/* 当前物品类型对应的已装备物品列表 */
		private var _curretnContains:Sprite; /* 当前物品Tips容器 */
		private var _furnishedContains:Sprite; /* 已装备物品Tips容器 */
		private var descript:TextField; /* 说明文字 */
		
		private var enableBalance:Boolean; /* 是否启用装备对比 */
		
		private var tiptype:GoodsTipItemTypeAsset;
		
		private var tipname:GoodsTipItemNameAsset;
		
		private var tiprecover:GoodsTipItemRecoverAsset;
		
		private var tipquality:GoodsTipQualityAsset;
		
		private var disableShowDelTime:Boolean;/* 禁止显示删除时间,true表示禁止，false表示显示 */
		
		private var itemMaxWidth:int = 0;
		
		//类别是否显示二级类别
		private var _typeIsSecond:Boolean;
		
		//private var _levelcolors:Array = [0x00FF00,0x00FFFF,0x9900FF,0xFFCC00,0xffffff];
//		public static var _quality:Array = [0x000000,0xe1e1e1,0x1eff00,0x0070dd,0xa335ee,0xff8000,0xff0099,0xe5cc80];
		
		public function GoodsTipPanel(info:ItemTemplateInfo, typeIsSecond:Boolean = false, isBalanceTip:Boolean = false)
		{
			super();
			
			_isBalanceTip = isBalanceTip;
			
			initialize(info);
		}
		
		private function initialize(info:ItemTemplateInfo):void
		{
			mouseChildren = false;
			mouseEnabled = false;
			enableBalance = false;
			disableShowDelTime = true;
			_isBalance = true;
			_isFurnished = false;
			
			/* 固定true让所有物品全部显示二级类别 */
			//_typeIsSecond = typeIsSecond;
			_typeIsSecond = true;
			clearList();
			_info = info;
			setInfo(info);
			initializeList();
			
			drawBackground();
			//初始化隐藏
			initWeaponStrenghtLevelIcon();
			//显示强化等级图标，最高等级显示到15级
			showStrenghtLevelIcon();
			updateText();
			
			//创建装备对比
			createBlance();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			_propertys = [];
			
			_curretnContains = new Sprite();
			
			addChild(_curretnContains);
			
			_curretnContains.addChild(_bg);
			
			_curretnContains.addChild(_head);
			
//			_list = new SimpleGrid(170,21);
			_list = new TipGrid();
			_list.width=170;
			_list.height=21;
			_list.paddingV=0;
//			_list.move(3,29);
			_list.x=5;
			_list.y=29;
			_list.columnCount=1;
			addChild(_list);
		}
		
		public function set showBound(value:Boolean):void
		{
			tiptype.bound.visible = value;
		}
		
		/////////////////////////////显示插孔所用方法/////////////////////////////
		private function getHole(inventoryInfo:InventoryItemInfo,index:int):int
		{
			if (index >= 7)
				return -1;
			else
				return int(inventoryInfo["Hole"+index.toString()]);
		}
		
		private function getHoleType(type:int):String //插孔 类型1为圆形插孔，类型2为方形插孔，类型3为三角插孔
		{
			switch(type)
			{
				case 1:
					return LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.trianglehole");
//					return "攻击宝珠";
				case 2:
					return LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.recthole");
//					return "防御宝珠";
				case 3:
					return LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.ciclehole");
//					return "属性宝珠";
				default:
					break;
			}
			return LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.unknowhole");
//			return "未知宝珠类型";
		}
		
		private function getTipItem(inventoryInfo:InventoryItemInfo,index:int,strengthLevel:int,holeType:int):GoodsTipItem
		{
			var item:GoodsTipItem;
			var goodsTemplateInfos:ItemTemplateInfo
			
			var holeState:int = getHole(inventoryInfo,index + 1);
			
			if(inventoryInfo.StrengthenLevel >= strengthLevel)
			{
				if(holeState <= 0)
				{
					item = new GoodsTipItem("",getHoleType(holeType) + LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.holeenable"),0xFFFFFF);
//					item = new GoodsTipItem("",getHoleType(holeType) + "(已开启)",0xFFFFFF);
				}
				else if (holeState > 0)
				{
					goodsTemplateInfos = ItemManager.Instance.getTemplateById(holeState);
				
					if(goodsTemplateInfos)
					{
						item = new GoodsTipItem("",goodsTemplateInfos.Data,0xFFFF00);
					}
				}
			}
			else
			{
				
				if(holeState < 0)
				{
//					item = new GoodsTipItem("",getHoleType(holeType) +(StringHelper.format(LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.holerequire")),strengthLevel.toString()),0x666666);
					item = new GoodsTipItem("",getHoleType(holeType) + StringHelper.format(LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.holerequire"),strengthLevel.toString()),0x666666);
				}
				else if(holeState == 0)
				{
					item = new GoodsTipItem("",getHoleType(holeType) + StringHelper.format(LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.holerequire"),strengthLevel.toString()),0x666666);
				}
				else if (holeState > 0)
				{
					goodsTemplateInfos = ItemManager.Instance.getTemplateById(holeState);
				
					if(goodsTemplateInfos)
					{
						item = new GoodsTipItem("",goodsTemplateInfos.Data + StringHelper.format(LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.holerequire"),strengthLevel.toString()),0x666666);
						return item;
					}
				}
			}
			
			return item;
		}
		
		/**插孔的状态，等于-1表示未开启，等于0表示已开启，但未镶嵌，大于0表示已镶嵌
		 * 
		 * 返回True表示已开启，大于等于0
		 * 返回False表示未开启，等于-1
		 * @param inventoryInfo
		 * @param index
		 * @return 
		 * 
		 */		
		private function getHoleState(inventoryInfo:InventoryItemInfo,strengthLevel:int):Boolean
		{
			return (inventoryInfo.StrengthenLevel >= strengthLevel)
		}
		
		/** 检测装备是否改造过
		 * true 为改造过，不可删除
		 * false 为未改造，可以删除
		 */
		protected function checkReworked():Boolean
		{
			var tmp:InventoryItemInfo = _info as InventoryItemInfo;
			if(tmp.CanDrop == 0 
			|| tmp.StrengthenLevel > 0 
			|| tmp.AttackCompose > 0 
			|| tmp.DefendCompose > 0 
			|| tmp.AgilityCompose > 0
			|| tmp.LuckCompose > 0
			|| tmp.Hole1 > 0
			|| tmp.Hole2 > 0
			|| tmp.Hole3 > 0
			|| tmp.Hole4 > 0
			|| tmp.Hole5 > 0
			|| tmp.Hole6 > 0)
			{
				return true;
			}
			
			return false;
		}
		
		private function createHoleItem():void
		{
			//===============================================装备插孔显示开始===============================================//
			
			if(!StringHelper.isNullOrEmpty(_info.Hole))
			{
				var holeList:Array = [];
				var strHoleList:Array = _info.Hole.split("|");
				var inventoryInfo:InventoryItemInfo = _info as InventoryItemInfo;
				if(strHoleList.length > 0 && String(strHoleList[0]) != "" && inventoryInfo != null)
				{
					var i:int=0;
					do{
						var str:String = String(strHoleList[i]);
						var tmpArr:Array = str.split(",");
						
						if(int(tmpArr[1]) == -1)// -1表示无法开启
						{
							i++;
							continue;
						}
						else
						{
							var requireStrengthenLevel:int = int(tmpArr[0]);
							_propertys.push(getTipItem(inventoryInfo,i,requireStrengthenLevel,tmpArr[1]));
						}
						i++;
					}while(getHole(inventoryInfo,i)>=0)
				}
			}
			
			//===============================================装备插孔显示结束===============================================//
		}
		/////////////////////////////显示插孔所用方法/////////////////////////////
		
		/**判断并创建装备对比功能
		 * 
		 */		
		protected function createBlance():void
		{
			if(_isBalance)
			{
				_furnishedContains = new Sprite();
				
				addChild(_furnishedContains);
				
				_furnishedContains.x = _curretnContains.width+1;
				var furnishedY:uint = 0;
				
				for(var i:uint = 0; i < _furnishedList.length; i++)
				{
					var furnishedTipPanel:GoodsTipPanel = new GoodsTipPanel(_furnishedList[i] as ItemTemplateInfo,false,true);
					furnishedTipPanel.name = "furnishedTip"+i.toString();
					
					furnishedTipPanel.y = furnishedY;
					
					_furnishedContains.addChild(furnishedTipPanel);
					
					furnishedY = furnishedTipPanel.y + furnishedTipPanel.height;
				}
				
				furnishedY = furnishedY - _curretnContains.height;
				
				if(_furnishedList.length > 1)
				{
					_furnishedContains.y = furnishedY / 2 * -1;
				}
			}
			else
			{
				if(!_isBalanceTip)
				{
					if(_head && _head.parent)
					{
						_head.parent.removeChild(_head);
					}
					
					_head = null;
					
//					_list.move(3,4);
					_list.x=5;
					_list.y=4;
					
					//descript.y -= 30;
					
					_bg.width = _list.contentWidth + 4;
					_bg.height = _list.contentHeight + 10 /*+ descript.height+10;*/
					setSize(_bg.width,_bg.height + 5);
				}
			}
		}
		
		/**添加到舞台后调用更新对比装备Tips的显示坐标
		 * @param dis 目标装备位置对象
		 * 
		 */		
		public function updatePosition(dis:DisplayObject):void
		{
			if(_furnishedContains)
			{
				var point:Point = dis.localToGlobal(new Point(dis.x,dis.y));
				if(x < point.x)
				{
					_furnishedContains.x *= -1;
				}
				else
				{
					var _w:int = x + _curretnContains.width + _furnishedContains.width;
					
					if(_w > dis.stage.stageWidth)
					{
						x = x - _curretnContains.width - dis.width;
						_furnishedContains.x *= -1;
					}
				}
				var pos:Point = _furnishedContains.parent.localToGlobal(new Point(_furnishedContains.x,_furnishedContains.y));
				if((_furnishedContains.height < dis.stage.stageHeight) && (pos.y + _furnishedContains.height) > dis.stage.stageHeight)
				{
					_furnishedContains.y = _furnishedContains.y - (pos.y + _furnishedContains.height - dis.stage.stageHeight);
				}
				
				if(pos.y < 0)
				{
					_furnishedContains.y = _furnishedContains.y - pos.y;
				}
			}
		}
		
		private function __addToStageHandler(e:Event):void
		{
			if((_furnishedContains.x + _furnishedContains.width) > stage.stageWidth)
			{
				_curretnContains.x = _curretnContains.x - _curretnContains.width - 45;
				_furnishedContains.x = _curretnContains.x - _furnishedContains.width - 1;
			}
				
			if(_furnishedContains.y < 0)
			{
				y = 0;
			}
			
			if((_furnishedContains.height < stage.stageHeight) && (_furnishedContains.y + _furnishedContains.height) > stage.stageHeight)
			{
				_furnishedContains.y = stage.stageHeight - _furnishedContains.height;
			}
		}
		
		protected function setInfo(info:ItemTemplateInfo):void
		{
			if(info == null)
				return;
			
			//设置是否需要生成对比装备
			setIsNeedBalance();
			//检查是否为已装备物品的Tips，是则设置已装备字样
			setHeaderText();
			//名称
			createGoodsNameItem();
			//品质
			createQualityItem();
			//类别
			createCategoryItem();
			/* 副武器恢复量 */
			createDeputyWeaponRecover();
			
			//护甲
			createDefenseItem();
			
			setRule(10,5)//---------------------------------------------
			//项链,加血tips
			createAdditionLimitPHItem();
			//某些物品特有的攻击，防御，敏捷，幸运等属性
			setDatas();
			setRule(0,3)//---------------------------------------------
			createDescript();
			//设置是否为绑定和绑定类型
			setBindType();
			
			createRemainTime();
			
			
		}
		private function isShowLevelIcon():Boolean
		{
			return (_info is InventoryItemInfo)&&(InventoryItemInfo(_info).StrengthenLevel>0)
		}
		private function createDescript():void
		{
			initializeDescription();
			var layout:Object=getDefaultLayout();
			delete layout.height;
			layout.paddingV=-5;
			_propertys.push(descript);
			_layoutMap[descript]=layout;
		}
		private function setRule(paddingTop:Number=10,paddingBottom:Number=10):void
		{
//			var rule:HRuleAsset=new HRuleAsset();
//			var item:DisplayObjectContainer=_propertys[_propertys.length-1];
//			if(item)
//			{
//				rule.y=item.height+1;
//				item.addChild(rule);
//			}
			if(!(_propertys[_propertys.length-1] is HRuleAsset))
			{
				var pre_layout:Object=_layoutMap[_propertys[_propertys.length-1]]||getDefaultLayout();
				pre_layout.paddingV=paddingTop;
				_layoutMap[_propertys[_propertys.length-1]]=pre_layout;
				var prop:Object=new HRuleAsset;
				_propertys.push(prop);
				var layout:Object=getDefaultLayout();
				layout.paddingV=paddingBottom;
				layout.height=0
				_layoutMap[prop]=layout;
			}
		}
		private function setDatas():void
		{
			if(_info is InventoryItemInfo)
			{
				if((_info as InventoryItemInfo).IsJudge == false)
					return;
			}
			
			var tat:int = 0;
			var tde:int = 0;
			var tag:int = 0;
			var tlu:int = 0;
			var tpr:Number = 0;
			var tst:int = 0;
			if(_info is InventoryItemInfo)
			{
				var t:InventoryItemInfo = _info as InventoryItemInfo;
				if(t.StrengthenLevel > 0)tst = t.StrengthenLevel;
				if(t.AttackCompose > 0)tat = t.AttackCompose;
				if(t.DefendCompose > 0)tde = t.DefendCompose;
				if(t.AgilityCompose > 0)tag = t.AgilityCompose;
				if(t.LuckCompose > 0)tlu = t.LuckCompose;
			}
			if(_info.Attack != 0)
			{
				_propertys.push(new GoodsTipItem(LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.fire"),String(_info.Attack) + ((tat > 0) ? "(+" + tat.toString() + ")" : ""),0xFF9933));
				//_propertys.push(new GoodsTipItem("   攻击",String(_info.Attack) + ((tat > 0) ? "(+" + tat.toString() + ")" : ""),0xFF9933));
			}
			if(_info.Defence != 0)
			{
				_propertys.push(new GoodsTipItem(LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.recovery"),String(_info.Defence) + ((tde > 0) ? "(+" + tde.toString() + ")" : ""),0xFF9933));
			}
			if(_info.Agility != 0)
			{
				_propertys.push(new GoodsTipItem(LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.agility"),String(_info.Agility) + ((tag > 0) ? "(+" + tag.toString() + ")" : ""),0xFF9933));
			}
			if(_info.Luck != 0)
			{
				_propertys.push(new GoodsTipItem(LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.lucky"),String(_info.Luck) + ((tlu > 0) ? "(+" + tlu.toString() + ")" : ""),0xFF9933));
			}
			
			setRule(0,5);//-----------
			
			//生成装备插孔显示
			createHoleItem();
			
			
			if(_info.NeedLevel > 1)
			{
				var tc:uint;
				if(PlayerManager.Instance.Self.Grade >= _info.NeedLevel)
				{
					tc = 0xcccccc;
				}
				else
				{
					tc = 0xff0000;
				}
				
				_propertys.push(new GoodsTipItem(LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.need"),String(_info.NeedLevel),tc));
				//_propertys.push(new GoodsTipItem("所需等级",String(_info.NeedLevel),tc));
			}
			
			if(_info.NeedSex == 1)
			{
				if(PlayerManager.Instance.Self.Sex)
				
					_propertys.push(new GoodsTipItem("",LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.man"),0x99FF33));
					//_propertys.push(new GoodsTipItem("","所需性别:男",0x99FF33));
				else _propertys.push(new GoodsTipItem("",LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.man"),0xff0000));
				//else _propertys.push(new GoodsTipItem("","所需性别:男",0xff0000));
			}
			else if(_info.NeedSex == 2)
			{
				if(!PlayerManager.Instance.Self.Sex)
				
					_propertys.push(new GoodsTipItem("",LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.woman"),0x99FF33));
					//_propertys.push(new GoodsTipItem("","所需性别:女",0x99FF33));
				else _propertys.push(new GoodsTipItem("",LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.woman"),0xff0000));
				//else _propertys.push(new GoodsTipItem("","所需性别:女",0xff0000));
			}
			
			if(_info.IsOnly)
			{
				_propertys.push(new GoodsTipItem("","唯一物品",0xff0000));
			}
			
//			var cantip:String = "";
//			
//			if(_info.Level >= 3)cantip = LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.display");
//			if(_info.Level >= 3)cantip = "(强化失败不消失)";
			var tipSmith : String ="";
			if(_info.CanStrengthen && _info.CanCompose)
			{
				tipSmith = LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.may");
				if(_info.FusionType != 0 && int(_info.Property1) != 6)
				{
					tipSmith += LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.melting");
//					tipSmith += "熔炼";
				}
				_propertys.push(new GoodsTipItem("",tipSmith,0x99FF33));
//				if(cantip != "")
//				{
//					_propertys.push(new GoodsTipItem("",cantip,0x99FF33));
//				}
				//_propertys.push(new GoodsTipItem("","可强化合成" + cantip,0x99FF33));
			}
			else if(_info.CanCompose)
			{
				tipSmith = LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.compose");
				if(_info.FusionType != 0 && int(_info.Property1) != 6)
				{
					tipSmith += LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.melting");
//					tipSmith += "熔炼";
				}
				_propertys.push(new GoodsTipItem("",tipSmith,0x99FF33));
				//_propertys.push(new GoodsTipItem("","可合成",0x99FF33));
			}
			else if(_info.CanStrengthen)
			{
				tipSmith = LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.strong");
				if(_info.FusionType != 0 && int(_info.Property1) != 6)
				{
					tipSmith += LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.melting");
//					tipSmith += "熔炼";
				}
				_propertys.push(new GoodsTipItem("",tipSmith,0x99FF33));
//				if(cantip != "")
//				{
//					_propertys.push(new GoodsTipItem("",cantip,0x99FF33));
//				}
				//_propertys.push(new GoodsTipItem("","可强化" + cantip,0x99FF33));
			}
			else if(_info.FusionType != 0 && int(_info.Property1) != 6)
			{
				tipSmith += LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.canmelting");
//				tipSmith = "可熔炼";
				_propertys.push(new GoodsTipItem("",tipSmith,0x99FF33));
			}
			
			
			if(tst > 0)
			{
				
//				_propertys.push(new GoodsTipItem("",LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.intensify",String(tst)),0x99FF00));
				//_propertys.push(new GoodsTipItem("","强化(" + String(tst) + "级)",0x99FF00));
				if(_hert != null)
					_hert.content_txt.text = _hert.content_txt.text + "(+" + StaticFormula.getHertAddition(int(_info.Property7),tst) + ")";
				if(tiprecover != null)
					tiprecover.content_txt.text = tiprecover.content_txt.text + "(+" + StaticFormula.getRecoverHPAddition(int(_info.Property7),tst) + ")";
				if(_defense != null)
					_defense.content_txt.text = String(_info.Property7) + "(+" + StaticFormula.getDefenseAddition(int(_info.Property7),tst) + ")";// + LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.free")+StaticFormula.getImmuneHertAddition(int(_info.Property7)+int(StaticFormula.getDefenseAddition(int(_info.Property7),tst)))+"%";
			}
//			if(tat > 0)
//			
//				_propertys.push(new GoodsTipItem(LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.he"),LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.z") + String(tat) ,0xFFCC00));
//				//_propertys.push(new GoodsTipItem("合成","朱雀加攻击" + String(tat) ,0xFFCC00));
//			if(tde > 0)
//				_propertys.push(new GoodsTipItem(LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.he"),LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.x") + String(tde) ,0xFFCC00));
//				//_propertys.push(new GoodsTipItem("合成","玄武加防御" + String(tde) ,0xFFCC00));
//			if(tag > 0)
//				_propertys.push(new GoodsTipItem(LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.he"),LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.q") + String(tag) ,0xFFCC00));
//				//_propertys.push(new GoodsTipItem("合成","青龙加敏捷" + String(tag) ,0xFFCC00));
//			if(tlu > 0)
//				_propertys.push(new GoodsTipItem(LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.he"),LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.b") + String(tlu) ,0xFFCC00));
//				//_propertys.push(new GoodsTipItem("合成","白虎加幸运" + String(tlu) ,0xFFCC00));
		}
		private function createRemainTime():void
		{
			var tempReman:Number;
			if(_info is InventoryItemInfo)
			{
				var ii:InventoryItemInfo = _info as InventoryItemInfo;
				var remain:Number = ii.getRemainDate();
				if(remain == int.MAX_VALUE)
				{
					_propertys.push(new GoodsTipItem("",LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.use"),0xffff00));
					//_propertys.push(new GoodsTipItem("","永久有效",0xffff00));
				}
				else if(remain > 0)
				{
					if(remain>=1)
					{
						tempReman = Math.ceil(remain);
						_propertys.push(new GoodsTipItem("", (ii.IsUsed ? LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.less") : LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.time")) + tempReman+LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.day"),0xffffff,"left",false,0x000000,true,1));	
					}else
					{
						tempReman = Math.floor(remain*24);
						
						if(tempReman<1)
						{
							tempReman = 1;
						}
						
						_propertys.push(new GoodsTipItem("", (ii.IsUsed ? LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.less") : LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.time")) + tempReman+LanguageMgr.GetTranslation("hours"),0xffffff,"left",false,0x000000,true,1));
					}
					//_propertys.push(new GoodsTipItem("", (ii.IsUsed ? "还剩 " : "有效时间 ") + remain+"天",0xffffff));
				}
				else if(!isNaN(remain))
				{
					tempReman = remain + 14;
					var str1:String;
					var str2:String;
					
					if(checkReworked() || disableShowDelTime)
					{
						_propertys.push(new GoodsTipItem("",LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.over"),0xff0000));
					}
					else
					{
						if(tempReman >= 1)
						{
							str1 = LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.over1",Math.ceil(tempReman));
							str2 = LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.over2",Math.ceil(tempReman));
						}
						else
						{
							tempReman = Math.floor(tempReman * 24);
							str1 = LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.over3",Math.ceil(tempReman));
							str2 = LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.over4",Math.ceil(tempReman));
						}
						_propertys.push(new GoodsTipItem("",str1,0xff0000));
						_propertys.push(new GoodsTipItem("",str2,0xff0000));
					}
					
					//_propertys.push(new GoodsTipItem("","已过期",0xff0000));
					
				}
				/* 战斗道具 */
				if(_info.CategoryID == EquipType.FRIGHTPROP)
				{
					_propertys.push(new GoodsTipItem(""," "+LanguageMgr.GetTranslation("ddt.view.common.RoomIIPropTip.consume")+_info.Property4,0xDD9200,"left",false,0x000000,false));
					//_propertys.push(new GoodsTipItem(""," 消耗体力"+_info.Property4,0xDD9200));	
				}
			}
		}
		
		/**设置是否需要生成装备对比的Tip
		 * 
		 * 
		 */		
		private function setIsNeedBalance():void
		{
			if(enableBalance)
			{
				//======================判断是否为当前装备的TIP并且判断是否需要装备对比===============
				var tmp:ItemTemplateInfo;
				// 从已装备的物品中找出与当前物品类型相同的装备列表
				_furnishedList = PlayerManager.Instance.Self.Bag.findBodyThingByCategory(_info.CategoryID);
				
				// 是否为		战斗道具					辅助道具					任务物品
				if(_info.CategoryID == 10 || _info.CategoryID == 11 || _info.CategoryID == 12)
				{
					_isBalance = false;
				}
				
				if(_furnishedList.length > 0)
				{
					for(var i:uint = 0; i < _furnishedList.length; i++)
					{
						tmp = _furnishedList[i] as ItemTemplateInfo;
						if(tmp == _info)
						{
							_isBalance = false;/* 是否需要装备对比 */
							_isFurnished = true;/* 是否已装备 */
						}
					}
				}
				else
				{
					_isBalance = false;
				}
				//======================判断是否为当前装备的TIP===============
			}
			else
			{
				_isBalance = false;
			}
		}
		
		private function setHeaderText():void
		{
			if(_isFurnished)
			{
				_head.head_txt.text = LanguageMgr.GetTranslation("ddt.view.bagII.dressed");
				_head.head_txt.textColor = 0x00dbff;
			}
		}
		
		//生成Tips上物品的名字
		private function createGoodsNameItem():void
		{
			tipname = new GoodsTipItemNameAsset();
			tipname.content_txt.text = String(_info.Name);
			tipname.content_txt.textColor = QualityType.QUALITY_COLOR[_info.Quality];
			_propertys.push(tipname);
			
//			_propertys.push(new MovieClip());
		}
		
		private function createQualityItem():void
		{
			tipquality = new GoodsTipQualityAsset();
			tipquality.content_txt.text = QualityType.QUALITY_STRING[_info.Quality];
			tipquality.content_txt.textColor = QualityType.QUALITY_COLOR[_info.Quality];
			_propertys.push(tipquality);
		}
		
		private function createCategoryItem():void
		{
			tiptype = new GoodsTipItemTypeAsset();
			tiptype.bound.gotoAndStop(1);
			_propertys.push(tiptype);
			tiptype.content_txt.text = EquipType.PARTNAME[_info.CategoryID];
		}
		
		private function createDeputyWeaponRecover():void
		{
			if(StaticFormula.isDeputyWeapon(_info))
			{
				tiprecover = new GoodsTipItemRecoverAsset();
				if(_info.Property3 == "32")
				{
					tiprecover.gotoAndStop(1);
				}
				else
				{
					tiprecover.gotoAndStop(2);
				}
				var layout:Object=getDefaultLayout();
				layout.paddingV=10;
				_layoutMap[_propertys[_propertys.length-1]]=layout;
				_propertys.push(tiprecover);
				tiprecover.content_txt.text = _info.Property7.toString();
			}
		}
		
		private function createAdditionLimitPHItem():void
		{
			if(_info.CategoryID == 14)
			{
				var phTip : Sprite = new GoodsTipItem(LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.life"),LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.advance")+_info.Property1+"%",0xFF9933);
				_propertys.push(phTip);
			}
		}
		
		private function createDefenseItem():void
		{
			if(EquipType.isEquip(_info)||_info.CategoryID==20)
			{
				if(int(_info.Property7) != 0)
				{
					_defense = new GoodsTipItemDefenceAsset();
					
					_defense.content_txt.text = String(_info.Property7);// + LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.free")+StaticFormula.getImmuneHertAddition(int(_info.Property7))+"%";

					_propertys.push(_defense);
				}
			}
			else if(EquipType.isArm(_info)||_info.CategoryID==19||_info.CategoryID==18)
			{	
				if(int(_info.Property7) != 0)
				{
					_hert = new GoodsTipItemHertAsset();
					_hert.content_txt.text = String(_info.Property7);
					_propertys.push(_hert);
					if(isShowLevelIcon())
					{
						var layout:Object=getDefaultLayout();
						layout.paddingV=20;
						_layoutMap[_propertys[_propertys.length-1]]=layout;
					}
				}
			}
		}
		
		private function setBindType():void
		{
			if(_info is InventoryItemInfo)
			{
				tiptype.bound.visible = true;
				tiptype.bound.gotoAndStop((_info as InventoryItemInfo).IsBinds ? 1 : 2);
				
				if(!(_info as InventoryItemInfo).IsBinds)
				{
					if(_info.BindType == 3)
					{
						_propertys.push(new GoodsTipItem("",LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.bangding")));
						//_propertys.push(new GoodsTipItem("","绑定类型：使用绑定"));
					}
					else if(_info.BindType == 2)
					{
						_propertys.push(new GoodsTipItem("",LanguageMgr.GetTranslation("ddt.view.bagII.GoodsTipPanel.zhuangbei")));
						//_propertys.push(new GoodsTipItem("","绑定类型：装备绑定"));
					}
				}
			}
			else
			{
				tiptype.bound.visible = false;
			}
		}
		
		private function showStrenghtLevelIcon():void
		{
			if((_info is InventoryItemInfo) && ((_info as InventoryItemInfo).StrengthenLevel > 0))
				tipname.content_txt.text = _info.Name + "("+GetStrengthenString((_info as InventoryItemInfo).StrengthenLevel).toString()+")";
			else
				return;
			
			var level:int = (_info as InventoryItemInfo).StrengthenLevel;
			
			if(level > 0)
			{
				tipname.strengthicon.visible = true;
				tipname.strengthicon.gotoAndStop(level);
				tiptype.bound.x = tipname.strengthicon.x + tipname.strengthicon.width/2 - tiptype.bound.width/2 + 5;
				tiptype.bound.y += tipname.strengthicon.y - 43;
			}
		}
		
		/*
		青铜Ⅰ
		青铜Ⅱ
		青铜Ⅲ
		白银Ⅰ
		白银Ⅱ
		白银Ⅲ
		黄金Ⅰ
		黄金Ⅱ
		黄金Ⅲ
		白金Ⅰ
		白金Ⅱ
		白金Ⅲ
		钻石Ⅰ
		钻石Ⅱ
		钻石Ⅲ
		大师Ⅰ
		大师Ⅱ
		大师Ⅲ
		王者
		 */
		private function GetStrengthenString(level:int):String
		{
			switch(level)
			{
				case 1:
					return "青铜Ⅰ";
				case 2 :
					return "青铜Ⅱ";
				case 3 :
					return "青铜Ⅲ";
				case 4 :
					return "白银Ⅰ";
				case 5 :
					return "白银Ⅱ";
				case 6 :
					return "白银Ⅲ";
				case 7 :
					return "黄金Ⅰ";
				case 8 :
					return "黄金Ⅱ";
				case 9 :
					return "黄金Ⅲ";
				case 10 :
					return "白金Ⅰ";
				case 11 :
					return "白金Ⅱ";
				case 12 :
					return "白金Ⅲ";
				case 13 :
					return "钻石Ⅰ";
				case 14 :
					return "钻石Ⅱ";
				case 15 :
					return "钻石Ⅲ";
				case 16 :
					return "大师Ⅰ";
				case 17 :
					return "大师Ⅱ";
				case 18 :
					return "大师Ⅲ";
				case 19 :
					return "王者";					
				default:
					return "";
			}
		}
		
		
		
		
		private function updateText():void
		{
			var w:int = 0;
			var h:int = 0;
			w = _list.contentWidth;
			
			w = (w > itemMaxWidth ? w : itemMaxWidth);
			
			h = _list.contentHeight;
			_list.width=w;
			_list.height=h;
			
			
			descript.width = w - 3;
			descript.height = descript.textHeight + 10;
			_list.updataChildPosition();
		}
		
		private function initWeaponStrenghtLevelIcon():void
		{
			tipname.strengthicon.visible = false;
			tipname.strengthicon.gotoAndStop(1);
		}
		private var _layoutMap:Dictionary=new Dictionary;
		private function getLayOut(property:DisplayObject):Object
		{
			return _layoutMap[property]||getDefaultLayout();
		}
		private function getDefaultLayout():Object
		{
			return {height:25};
		}
		private function initializeList():void
		{
			for(var i:int = 0; i < _propertys.length; i++)
			{
				if(!((i==_propertys.length-1)&&(_propertys[i] is HRuleAsset)))
				{
					_list.appendItem(_propertys[i],getLayOut(_propertys[i]));
				}
				if(_propertys[i] is GoodsTipItem)
				{
					var tmp:int = (_propertys[i] as GoodsTipItem).getTextWidth();
					itemMaxWidth = (itemMaxWidth > tmp ? itemMaxWidth : tmp);
				}
			}
			itemMaxWidth = (_list.contentWidth > itemMaxWidth ? _list.contentWidth : itemMaxWidth);
			_list.width=itemMaxWidth;
			_list.updataChildPosition();
		}
		
		private function initializeDescription():void
		{
			descript = new TextField();
			descript.width = _list.contentWidth - 3;
			descript.setTextFormat(new TextFormat("Arial"));
			descript.multiline = true;
			descript.wordWrap = true;
			descript.x = 4;
			descript.y = _list.contentHeight + 39;
			descript.text = (String(_info.Description) == "" || _info.Description == null) ? "" : String(_info.Description);
			descript.selectable = false;
			descript.height = descript.textHeight + 10;
			descript.textColor = 0xffffff;
		}
		
		private function drawBackground():void
		{
			_bg.width = _list.contentWidth + 4;
			_bg.height = _list.contentHeight + descript.height +  39;
			setSize(_bg.width,_bg.height + 5);
		}
		
		protected function clearList(delReference:Boolean = false):void
		{
			if(_list)
			{
				_list.removeAllChildren();
				for(var i:int = 0;i<_propertys.length;i++)
				{
					if(_propertys[i].parent)_propertys[i].parent.removeChild(_propertys[i]);
					if(_propertys[i] is GoodsTipItem)
					{
						_propertys[i].dispose();
					}
				}
				_propertys = [];
				if(delReference)
				{
					if(_list.parent)
					{
						_list.parent.removeChild(_list);
					}
					
					_list = null;
					_propertys = null;
				}
			}
		}
		
		public function dispose():void
		{
			clearList(true);
			if(_bg && _bg.parent)
			{
				_bg.parent.removeChild(_bg);
			}
			if(_head && _head.parent)
			{
				_head.parent.removeChild(_head);
			}
			if(descript && descript.parent)
			{
				descript.parent.removeChild(descript);
			}
			descript = null;
			if(parent) parent.removeChild(this);
			
			if(_curretnContains && _curretnContains.parent)
			{
				_curretnContains.parent.removeChild(_curretnContains);
			}
			_curretnContains = null;
			
			if(_furnishedContains)
			{
				var i:uint = 0;
				while(_furnishedContains.numChildren)
				{
					var child:GoodsTipPanel = _furnishedContains.getChildAt(i) as GoodsTipPanel;
					if(child != null)
					{
						child.dispose();
						child = null;
					}
					else
					{
						i++;
					}
				}
				if(_furnishedContains.parent)
				{
					_furnishedContains.parent.removeChild(_furnishedContains);
				}
			}
			
			_info = null;
			tiptype = null;
			tiprecover = null;
			_hert = null;
			_defense = null;
			
			if(parent)
				parent.removeChild(this);
		}
	}
}