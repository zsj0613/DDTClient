package ddt.data.player
{
	import road.data.DictionaryData;
	
	import ddt.data.BuffInfo;
	import ddt.data.EquipType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.events.WebSpeedEvent;
	import ddt.manager.ItemManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	
	/**
	 *  
	 * @author SYC
	 * 扩展人物信息
	 */	
	public class PlayerInfo extends BasePlayer
	{
		public static const SEX:String = "Sex";
		public static const STYLE:String = "Style";
		public static const HIDE:String = "Hide";
		public static const SKIN:String = "Skin";
		public static const COLORS:String = "Colors";
		public static const NIMBUS:String = "Nimbus";
		public static const GOLD:String = "Gold";
		public static const MONEY:String = "Money";
		public static const GIFT:String = "Gift";
		public static const ARM:String = "WeaponID";
		
		override public function updateProperties():void
		{
			if(_changedPropeties[ARM] || _changedPropeties[SEX] || _changedPropeties[STYLE] || _changedPropeties[HIDE] || _changedPropeties[SKIN] || _changedPropeties[COLORS] || _changedPropeties[NIMBUS])
			{
				parseHide();
				parseStyle();
				parseColos();
				_showSuits = (_modifyStyle.split(",")[7] != "13101" && _modifyStyle.split(",")[7] != "13201");
				_changedPropeties[PlayerInfo.STYLE] = true;
			}
			super.updateProperties();
		}
		
		private function parseHide():void
		{
			_hidehat = String(_hide).charAt(8) == "2";
			_hideGlass = String(_hide).charAt(7) == "2";
			_suitesHide = String(_hide).charAt(6) == "2";
			//			_haveLight = String(_hide).charAt(9) == "2";
			//			_haveCircle = String(_hide).charAt(9) == "3";
		}
		
		private function parseStyle():void
		{
			if(_style == "")_style = ",,,,,,,,,";
			var s:Array = _style.split(",");
			for(var i:int = 0; i < s.length; i++)
			{
				if((s[i] == "" || s[i] == "0" || s[i] == "-1") && (i+1) != EquipType.ARM && i < 7)
				{
					s[i] = String(i + 1) + (Sex ? "1" : "2") + "01";
				}
				else if((s[i] == "" || s[i] == "0" || s[i] == "-1") && (i+1) == EquipType.ARM)
				{
					s[i] = "700" + (Sex ? "1" : "2");
				}
				
				if((s[i] == "" || s[i] == "0" || s[i] == "-1") && i == 7)
				{
					s[i] = "13"+(Sex ? "1" : "2") + "01";
				}
				
				if((s[i] == "" || s[i] == "0" || s[i] == "-1")  && i == 8)
				{
					s[i] = "15001";
				}
				
				if((s[i] == "" || s[i] == "0" || s[i] == "-1")  && i == 9)
				{
					s[i] = "16000";
				}
			}
			if(_hidehat || _hideGlass || _suitesHide)
			{
				if(_hidehat)
				{
					s[0] = "1" + (Sex ? "1" : "2") + "01";
				}
				if(_hideGlass)
				{
					s[1] = "2" + (Sex ? "1" : "2") + "01";
				}
				if(_suitesHide)
				{
					s[7] = "13"+ (Sex ? "1" : "2")+"01";
				}
			}
			_modifyStyle = s.join(",");
		}
		
		private function parseColos():void
		{
			var arr:Array = _colors.split(",");
			var t:Array = arr[EquipType.CategeryIdToPlace(EquipType.FACE)[0]].split("|");
			arr[EquipType.CategeryIdToPlace(EquipType.FACE)[0]] = t[0] + "|" + _skin + "|" + (t[2] == undefined ? "" : t[2]);
			t = arr[EquipType.CategeryIdToPlace(EquipType.CLOTH)[0]].split("|");
			arr[EquipType.CategeryIdToPlace(EquipType.CLOTH)[0]] = t[0] + "|" + _skin + "|" + (t[2] == undefined ? "" : t[2]);
			_colors = arr.join(",");
		}
		
		/**
		 * 人物正常情况下的长和宽 
		 */		
		public var playerWidth:Number;
		public var playerHeight:Number;
		
		
		public var ReputeOffer : int;
		/**
		 * 在代理商网站的注册名称
		 */		
		public var LoginName : String ;
		
		public var EscapeCount:int;
		
		
		
		/////////////////////////////////////隐藏相关////////////////////////////////////
		private var _hide:int;
		public function get Hide():int
		{
			return _hide;
		}
		public function set Hide(value:int):void{
			if(_hide == value)return;
			_hide = value;
			onPropertiesChanged("Hide");
		}
		
		private var _hidehat:Boolean;
		public function getHatHide():Boolean
		{
			return _hidehat;
		}
		public function setHatHide(value:Boolean):void
		{
			Hide = int(String(_hide).slice(0,8)+ (value ? "2" : "1") + String(_hide).slice(9));
		}
		
		private var _hideGlass:Boolean = false;
		public function getGlassHide():Boolean
		{
			return _hideGlass;
		}
		public function setGlassHide(value:Boolean):void
		{
			Hide = int(String(_hide).slice(0,7)+ (value ? "2" : "1") + String(_hide).slice(8,9));
		}
		
		private var _suitesHide:Boolean = false;
		public function getSuitesHide():Boolean
		{
			return _suitesHide;
		}
		public function setSuiteHide(value:Boolean):void
		{
			Hide = int(String(_hide).slice(0,6)+ (value ? "2" : "1") + String(_hide).slice(7,9));
		}
		
		private var _showSuits:Boolean = true;
		public function getShowSuits():Boolean
		{
			return _showSuits;
		}
		
		
		/**
		 *成就点 
		 */		
		private var _achievementPoint:int;
		public function get AchievementPoint():int
		{
			return _achievementPoint;
		}
		public function set AchievementPoint(value:int):void
		{
			_achievementPoint = value;
		}
		/**
		 *成就称号 
		 */		
		private var _honor:String;
		public function get honor():String
		{
			return _honor;
		}
		public function set honor(value:String):void
		{
			_honor = value;
		}
		/**
		 *人物身上的光环 
		 */		
		private var _nimbus : int;
		public function set Nimbus(nim : int) : void
		{
			if(_nimbus == nim)return;
			_nimbus = nim;
			onPropertiesChanged("Nimbus");
		}
		public function get Nimbus() : int
		{
			return _nimbus;
		}
		
		/**
		 * 
		 * 光圈，强化等级
		 * 
		 */
		public function getHaveLight():Boolean
		{
			
			if(Nimbus < 100)return false;
			if(Nimbus > 999)
			{
				return(String(Nimbus).charAt(0) != "0" || String(Nimbus).charAt(1) != "0");
			}
			else
			{
				return(String(Nimbus).charAt(0) != "0");
			}
			
		}
		public function getHaveCircle():Boolean
		{
			if(Nimbus == 0)return false;
			if(Nimbus > 999)
			{
				return (String(Nimbus).charAt(2) != "0" || String(Nimbus).charAt(3) != "0");
			}
			else if(Nimbus > 99)
			{
				return (String(Nimbus).charAt(1) != "0" || String(Nimbus).charAt(2) != "0");
			}
			else
			{
				return (String(Nimbus).charAt(0) != "0");
			}
		}
		//////////////////////////////////样式相关/////////////////////////////////////////////
		/**
		 * 
		 * 修饰过的Style
		 * 
		 */		
		private var _modifyStyle:String;
		public function get Style():String
		{
			if(_style == null)return null;
			return _modifyStyle;
		}
		public function set Style(value:String):void
		{
			if(_style == value)return;
			if(value == null)return;
			var styleValues:Array = value.split(",");
			if(styleValues.length < 10)
			{
				var addFixStyleCount:int = 10 - styleValues.length;
				for(var i:int = 0;i<addFixStyleCount;i++)
				{
					styleValues.push("");
				}
				value = styleValues.join(",");
			}
			_style = value;
			onPropertiesChanged("Style");
		}
		
		/**
		 * 
		 * @return 
		 * 1：不带帽 0：带帽
		 */		
		
		public function getHairType():int
		{
			return int(ItemManager.Instance.getTemplateById(_modifyStyle.split(",")[EquipType.CategeryIdToPlace(EquipType.HEAD)[0]]).Property1);
		}
		
		/**
		 *套装类型1为大套装，2为小套装 
		 */	
		public function getSuitsType():int
		{
			//Modified by Freeman
			var rInt:int = int(ItemManager.Instance.getTemplateById( _modifyStyle.split(",")[7]).Property1)
			if(rInt){
				return rInt;
			} else {
				return 2;
			}
			//Modified by Freeman
		}
		
		/**
		 * 人物形象
		 * 先设样式再设颜色
		 */		
		private var _style:String;
		public function getPrivateStyle():String
		{
			return _style;
		}
		
		/**
		 * 
		 *  新手教程的进度。
		 */	
		private var _tutorialProgress:int;
		public function get TutorialProgress():int
		{
			return _tutorialProgress;
		}
		public function set TutorialProgress(value:int):void
		{
			if(_tutorialProgress == value)return;
			_tutorialProgress = value;
			onPropertiesChanged("TutorialProgress");
		}
		
		/**
		 * 
		 * @param id 物品categeryID,
		 * @param needsex 物品所需性别
		 * @param style 物品 Pic
		 * @param templateId 物品模版ID，-1为默认，转为XX01
		 */	
		public function setPartStyle(categoryId:int,needsex:int,templateId:int = -1,color:String="",dispatch:Boolean = true):void
		{
			if(Style == null)return;
			var arr:Array = _style.split(",");
			if(categoryId == EquipType.ARM)
			{
				arr[EquipType.CategeryIdToPlace(categoryId)[0]] = (templateId == -1 || templateId == 0) ? "700" + String(PlayerManager.Instance.Self.Sex ? "1" : "2") : String(templateId);
			}
			else if(categoryId == EquipType.SUITS)
			{
				arr[7] = (templateId == -1 || templateId == 0) ? String(categoryId) + "101" : String(templateId);
			}else if(categoryId == EquipType.WING)
			{
				arr[8] = (templateId == -1 || templateId == 0) ? "15001" : String(templateId);
			}
			else
			{
				arr[EquipType.CategeryIdToPlace(categoryId)[0]] = (templateId == -1 || templateId == 0) ? String(categoryId) + String(needsex) + "01" : String(templateId);
			}
			_style = arr.join(",");
			onPropertiesChanged("Style");
			setPartColor(categoryId,color);
		}
		public function getPartStyle(categoryId:int):int
		{
			return int(Style.split(",")[categoryId - 1]);
		}
		
		/**
		 * 衣服颜色
		 */		
		private var _colors:String = "|,|,,,,||,,,,";
		public function get Colors():String
		{
			return _colors;
		}
		public function set Colors(value:String):void
		{
			if(colorEqual(_colors,value)) return;
			_colors = value;
			onPropertiesChanged("Colors");
		}
		
		private function colorEqual(color_1:String,color_2:String):Boolean
		{
			if(color_1 == color_2) return true;
			var colors1:Array = color_1.split(",");
			var colors2:Array = color_2.split(",");
			for(var i:int = 0;i < colors2.length;i++)
			{
				if(colors1[i] != colors2[i])
				{
					if((colors1[i] == "|" || colors1[i] == "||" || colors1[i] == "") && 
						(colors2[i] == "|" || colors2[i] == "||" || colors2[i] == ""))
					{
						continue;
					}else
					{
						return false;
					}
				}
			}
			return true;
		}
		
		public function setPartColor(id:int,color:String):void
		{
			var arr:Array = _colors.split(",");
			if(id != EquipType.SUITS)
			{
				arr[EquipType.CategeryIdToPlace(id)[0]] = color;
			}
			_colors = arr.join(",");
			onPropertiesChanged(PlayerInfo.COLORS);
		}
		public function getPartColor(id:int):String
		{
			var arr:Array = Colors.split(",");
			return arr[id - 1];
		}
		public function setSkinColor(color:String):void
		{
			Skin = color;
		}
		
		private var _skin:String;
		public function set Skin(color:String):void
		{
			if(_skin == color)return;
			_skin = color;
			onPropertiesChanged("Colors");
		}
		
		public function get Skin():String
		{
			return getSkinColor();
		}
		public function getSkinColor():String
		{
			var arr:Array = Colors.split(",");
			if(arr[EquipType.CategeryIdToPlace(EquipType.FACE)[0]] == undefined)return "";
			var t:String =  arr[EquipType.CategeryIdToPlace(EquipType.FACE)[0]].split("|")[1];
			return (t == null) ? "" : t;
		}
		public function clearColors():void
		{
			Colors = ",,,,,,,,";
		}
		
		public function updateStyle(sex:Boolean,hide:int,style:String,colors:String,skin:String):void
		{
			beginChanges();
			Sex = sex;
			Hide = hide;
			Style = style;
			Colors = colors;
			Skin = skin;
			commitChanges();
		}
		
		
		/**
		 *文字泡泡的类型 
		 */		
		private var _paopaoType:int = 0;
		public function get paopaoType():int
		{
			var st:String = _style.split(",")[9];
			if(st == null || st == "" || st == "0" || st == "-1")
			{
				return 0;
			}else
			{
				return int(st.charAt(4));
			}
			return 0;
		}
		
		
		
		/**
		 *在线状态 
		 */		
		private var _state:int;
		public function get State():int
		{
			return _state;
		}
		public function set State(value:int):void
		{
			if(_state == value)return;
			_state = value;
			onPropertiesChanged("State");
		}
		
		/************************************************************************
		 * 战斗属性
		 * 攻击、防御、幸运、暴击（隐藏）、敏捷、DELAY(隐藏)；幸运+1=暴击+0.1%、敏捷+1=DELAY*1-0.1%
		 * */
		public var SuperAttack:int;		
		public var Delay:int;
		/**
		 *攻击 
		 */		
		private var _attack:int;
		public function get Attack():int
		{
			return _attack;
		}
		public function set Attack(value:int):void
		{
			if(_attack == value)return;
			_attack = value;
			onPropertiesChanged("Attack");
		}
		
		
		/**
		 *新手进度
		 * 新手引导提示;弹出对话框； 4
		 * 新手战斗1;进入loading； 5
		 * 新手问答1；点正确答案；   6
		 * 新手问答2；点正确答案；   7
		 * 新手I完成                 10
		 */		
		public function set AnswerSite(I : int) : void
		{
			_answerSite = I;
			TutorialProgress = I;
			
		}
		public function get AnswerSite() : int
		{
			return _answerSite;
		}
		private var _answerSite : int;
		/**
		 *防御 
		 */		
		private var _defence:int;
		public function get Defence():int
		{
			return _defence;
		}
		public function set Defence(value:int):void
		{
			if(_defence == value)return;
			_defence = value;
			onPropertiesChanged("Defence");
		}
		
		/**
		 *幸运 
		 */		
		private var _luck:int;
		public function get Luck():int
		{
			return _luck;
		}
		public function set Luck(value:int):void
		{
			if(_luck == value)return;
			_luck = value;
			onPropertiesChanged("Luck");
		}
		/**
		 *敏捷 
		 */		
		private var _agility:int;
		public function get Agility():int
		{
			return _agility;
		}
		public function set Agility(value:int):void
		{
			if(_agility == value)return;
			_agility = value;
			onPropertiesChanged("Agility");
		}
		
		public function setAttackDefenseValues(attack:int,defense:int,agility:int,luck:int):void
		{
			Attack = attack;
			Defence = defense;
			Agility = agility;
			Luck = luck;
			onPropertiesChanged("setAttackDefenseValues");
		}
		
		/**
		 * 战斗力
		 * */
		private var _fightPower:int;
		public function get FightPower():int
		{
			//			if(Bag.itemNumber > 0)
			//			{
			//				return StaticFormula.getActionValue(this);
			//			}
			return _fightPower;
		}
		
		public function set FightPower(value:int):void
		{
			if(_fightPower == value) return;
			_fightPower = value;
			onPropertiesChanged("FightPower");
		}
		
		/**
		 * 背包资料
		 * 
		 * */
		private var _bag:BagInfo;
		
		public function get Bag():BagInfo
		{
			if(_bag == null)
				_bag = new BagInfo(BagInfo.EQUIPBAG);
			return _bag;
		}
		
		//		/**
		//		 * 副手武器 
		//		 */		
		public function get DeputyWeapon():InventoryItemInfo
		{
			var arr:Array = Bag.findBodyThingByCategory(EquipType.OFFHAND);
			if(arr.length > 0)return arr[0] as InventoryItemInfo;//取得副武器
			return null;
		}
		
		private var _deputyWeaponID:int = 0;
		public function set DeputyWeaponID(value:int):void
		{
			if(_deputyWeaponID == value) return;
			_deputyWeaponID = value;
			onPropertiesChanged("DeputyWeaponID");
		}
		
		public function get DeputyWeaponID():int
		{
			return _deputyWeaponID;
		}
		
		/**
		 * 金币 
		 */		
		private var _gold:Number;
		public function get Gold():Number
		{
			return _gold;
		}
		public function set Gold(value:Number):void
		{
			if(_gold == value)return;
			_gold = value;
			onPropertiesChanged(PlayerInfo.GOLD);
		}
		
		/**
		 * 点券 
		 */		
		private var _money:Number;
		public function get Money():Number
		{
			return _money;
		}
		public function set Money(value:Number):void
		{
			if(_money == value)return;
			_money = value;
			onPropertiesChanged(PlayerInfo.MONEY);
		}
		
		/**
		 * 礼券
		 * */
		private var _gift:Number;
		public function get Gift():Number
		{
			return _gift;
		}
		public function set Gift(value:Number):void
		{
			if(_gift == value) return;
			_gift = value;
			onPropertiesChanged(PlayerInfo.GIFT);
		}
		
		/**
		 *网速 
		 */		
		private var _webSpeed:int;
		public function get webSpeed():int
		{
			return _webSpeed;
		}
		public function set webSpeed(value:int):void
		{
			_webSpeed = value;
			dispatchEvent(new WebSpeedEvent(WebSpeedEvent.STATE_CHANE));
		}
		/**
		 *个人排名 
		 */		
		private var _repute:int;
		public function get Repute():int
		{
			return _repute;
		}
		public function set Repute(value:int):void
		{
			_repute = value;
			onPropertiesChanged("Repute");
		}
		/**
		 *更新所有人物信息 
		 * 
		 */		
		public function changeAllInfo():void
		{
			onPropertiesChanged("ALL_INFO");
		}
		/**
		 * 用户所带武器ID
		 */		
		private var _weaponID:int;
		public function get WeaponID():int
		{
			return _weaponID;
		}
		public function set WeaponID(value:int):void
		{
			if(_weaponID == value)return;
			_weaponID = value;
			onPropertiesChanged("WeaponID");
		}
		
		
		public function set paopaoType(type:int):void
		{
			_paopaoType = type;
			onPropertiesChanged("paopaoType");
		}
		
		
		
		////////////////////////////////////// buff信息///////////////////////////////////////////////////////////////
		
		/**
		 *buff信息
		 * 包含人物身上的所有buff所有的buff 
		 */		
		protected var _buffInfo:DictionaryData = new DictionaryData();
		public function get buffInfo():DictionaryData
		{
			return _buffInfo;
		}
		
		protected function set buffInfo(buffs:DictionaryData):void
		{
			_buffInfo = buffs;
			onPropertiesChanged("buffInfo");
		}
		/**
		 * 
		 * 添加buff
		 * 
		 */		
		public function addBuff(buff:BuffInfo):void
		{
			_buffInfo.add(buff.Type,buff);
		}
		/**
		 *清除buff
		 * 
		 */		
		public function clearBuff():void
		{
			_buffInfo.clear();
		}
		/**
		 *检测是否拥有某个Buff 
		 * 
		 */		
		public function hasBuff(buffType:int):Boolean
		{
			if(buffType == BuffInfo.FREE) return true;
			for(var i:String in _buffInfo)
			{
				if(_buffInfo[i]&&_buffInfo[i].Type == buffType&&_buffInfo[i].IsExist == true)
				{
					return true;
				}
			}
			return false;
		}
		
		///////////////////////////////////////////////工会相关信息///////////////////////////////////////////
		/**
		 *职位名称 
		 */		
		private  var _dutyName:String;
		public function set DutyName (dName:String):void
		{
			if(_dutyName == dName) return;
			_dutyName = dName;
			onPropertiesChanged("DutyName");
		}
		public function get DutyName():String {return _dutyName}
		/**
		 *公会权限 
		 */		
		private var _right:int;
		public function get Right():int
		{
			return _right;
		}
		public function set Right(value:int):void
		{
			_right = value;
			onPropertiesChanged("Right");
		}
		
		/**
		 *掠夺 
		 */		
		private  var _richesRob:int;
		public function set RichesRob (rob:int):void
		{
			if(_richesRob == rob) return;
			_richesRob = rob;
			onPropertiesChanged("RichesRob");
		}
		public function get RichesRob():int {return _richesRob};
		/**
		 *公会排名 
		 */		
		private var _consortiaRepute : int;
		public function set ConsortiaRepute (n:int):void
		{
			_consortiaRepute = n;
			onPropertiesChanged("ConsortiaRepute");
		}
		
		/**
		 *战斗力
		 */		
		private  var _effectiveness:int;
		public function set Effectiveness (effectiveness:int):void
		{
			if(_effectiveness == effectiveness) return;
			_effectiveness = effectiveness;
			onPropertiesChanged("Effectiveness");
		}
		public function get Effectiveness():int {return _effectiveness};
		
		
		
		public function get ConsortiaRepute ():int
		{
			return _consortiaRepute;
		}
		/**
		 *公会职位等级 
		 */		
		private var _dutyLevel:int;
		public function set DutyLevel (level:int):void
		{
			_dutyLevel = level;
			onPropertiesChanged("DutyLevel");
		}
		public function get DutyLevel():int
		{
			return _dutyLevel;
		}
		/**
		 * 
		 *公会等级
		 * 
		 */
		private var _consortiaLevel : int;		
		public function set ConsortiaLevel(i : int) : void
		{
			_consortiaLevel = i;
			onPropertiesChanged("ConsortiaLevel");
		}
		public function get ConsortiaLevel() : int
		{
			if(ConsortiaID != 0)_consortiaLevel = (_consortiaLevel == 0 ? 1 : _consortiaLevel);
			return this._consortiaLevel;
		}
		/**
		 *公会禁言 
		 */		
		private var _isBandChat:Boolean
		public function set IsBandChat(b:Boolean):void
		{
			_isBandChat = b;
			onPropertiesChanged("IsBandChat");
		}
		
		public function get IsBandChat():Boolean
		{
			return _isBandChat;
		}
		/**
		 *会长名称 
		 */		
		private var _charManName:String;
		public function set CharManName(name : String) : void
		{
			this._charManName = name;
			onPropertiesChanged("CharManName");
			
		}
		public function get CharManName() :String
		{
			return this._charManName;
		}
		
		/**公会功勋**/
		private var _consortiaHonor : int;
		public function set ConsortiaHonor(name : int) : void
		{
			this._consortiaHonor = name;
			onPropertiesChanged("ConsortiaHonor");
			
		}
		public function get ConsortiaHonor() : int
		{
			return this._consortiaHonor;
		}
		
		/**公会财富**/
		private var _consortiaRiches : int;
		public function set ConsortiaRiches(i : int) : void
		{
			this._consortiaRiches = i;
			onPropertiesChanged("ConsortiaRiches");
		}
		public function get ConsortiaRiches() : int
		{
			return this._consortiaRiches;
		}
		
		/**
		 *公会捐献 
		 */		
		private  var _richesOffer:int;
		public function set RichesOffer (offed:int):void
		{
			if(_richesOffer == offed) return;
			_richesOffer = offed;
			onPropertiesChanged("RichesOffer");
		}
		public function get RichesOffer():int 
		{
			return _richesOffer
		}
		
		/**
		 *公会铁匠铺等级 
		 */		
		private var _storeLevel : int;
		public function set StoreLevel($level : int) : void
		{
			if(_storeLevel == $level)return;
			_storeLevel = $level;
			onPropertiesChanged("StoreLevel");
		}
		public function get StoreLevel() : int
		{
			if(ConsortiaID == 0) _storeLevel = 0;
			return _storeLevel
		}
		
		/**
		 *公会商城等级 
		 */		
		private var _shopLevel : int;
		public function set ShopLevel($level : int) : void
		{
			if(_shopLevel == $level) return;
			_shopLevel = $level;
			onPropertiesChanged("ShopLevel");
		}
		public function get ShopLevel() : int
		{
			if(ConsortiaID == 0) _shopLevel = 0;
			return _shopLevel;
		}
		/**
		 *公会保管箱等级 
		 */		
		private var _smithLevel : int;
		public function set SmithLevel($level : int) : void
		{
			if(_smithLevel == $level) return;
			_smithLevel = $level;
			onPropertiesChanged("SmithLevel");
		}
		public function get SmithLevel() : int
		{
			if(ConsortiaID == 0) _smithLevel = 0;
			return _smithLevel;
		}
		
		private var _pvePermission:String
		public function get PvePermission():String
		{
			return _pvePermission;
		}
		
		
		public var _isDupSimpleTip:Boolean = false;
		
		public function set PvePermission(permission:String):void
		{
			if(_pvePermission == permission) return;
			if(permission == "")
			{
				//trace("PlayerInfo....................is NULL");
				_pvePermission = "11111111111111111111111111111111111111111111111111";
				//				var permitionData:BitArray = new BitArray();
				//				for(var i:int = 0;i< 50;i++)
				//				{
				////					permitionData[i] = 17;
				//					permitionData.writeByte(17);
				//				}
				//				permitionData.position = 0;
				//				_pvePermission = permitionData.readUTFBytes(50);
			}else
			{
				if(_pvePermission != null)
				{
					if(_pvePermission.substr(0,1) == "1" && permission.substr(0,1) == "3")
						_isDupSimpleTip = true;
				}	
				
				_pvePermission = permission;
			}
			onPropertiesChanged("PvePermission");
		}
		/**
		 *用来记录战斗实验室的完成情况 ex:
		 * ABCDEFGH,这个字符串按照两个一组来分隔，成为 AB CD EF GH 那AB就是第一种打法的记录，CD就是第二种打法的记录，依此类推
		 * 其中AB中的A代表这种打法的完成情况，0代表不能打，1代表可以打简单的，2代表可以打中等的，3代表可以打困难的
		 * B代表奖励的领取情况，0代表没领取，1代表领取过简单的奖励，2代表领取过中等的奖励 ，3代表领取过困难的奖励
		 */
		private var _fightLibMission:String;
		public function get fightLibMission():String
		{
			return (_fightLibMission == null || _fightLibMission == "")?"1000000000":_fightLibMission;
		}
		
		public function set fightLibMission(value:String):void
		{
			_fightLibMission = value;
			onPropertiesChanged("fightLibMission");
		}
		
		private var _lastSpaDate:Object;//玩家最后退出温泉房间的时间(费解的问题:为Date时，编译时说找不到类型)
		/**
		 * 取得玩家最后退出温泉房间的时间 
		 */
		public function get LastSpaDate():Object
		{
			return _lastSpaDate;
		}
		
		/**
		 * 设置玩家最后退出温泉房间的时间
		 */		
		public function set LastSpaDate(value:Object):void
		{
			_lastSpaDate = value;
		}
		private var _VIPLevel:int = 0;
		public function set VIPLevel(value:int):void
		{
			_VIPLevel = value;
		}
		public function get VIPLevel():int
		{
			return _VIPLevel;
		}
		
	}
}