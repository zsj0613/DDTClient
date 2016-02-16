package ddt.view.personalinfoII
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Dictionary;
	
	import game.crazyTank.view.personalinfoII.PersonalInfoIIBgAsset;
	
	import road.data.DictionaryData;
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.HButton.HCheckBox;
	import road.ui.controls.HButton.HTipButton;
	import road.ui.manager.TipManager;
	import road.utils.StringHelper;
	
	import ddt.data.EquipType;
	import ddt.data.Experience;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.data.goods.StaticFormula;
	import ddt.data.player.PlayerInfo;
	import ddt.data.player.PlayerPropertyEvent;
	import ddt.data.player.SelfInfo;
	import ddt.events.TaskEvent;
	import ddt.manager.EffortManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.manager.StateManager;
	import ddt.manager.TaskManager;
	import ddt.states.StateType;
	import ddt.view.bagII.BagEvent;
	import ddt.view.bagII.bagStore.BagStore;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;
	import ddt.view.buffControl.BuffControl;
	import ddt.view.cells.CellFactory;
	import ddt.view.cells.PersonalInfoCell;
	import ddt.view.characterII.CharactoryFactory;
	import ddt.view.characterII.ICharacter;
	import ddt.view.common.LevelIcon;
	import ddt.view.common.MarryIcon;
	import ddt.view.common.OfferText;
	import ddt.view.common.Repute;
	import ddt.view.common.VIPIcon;
	import ddt.view.effort.EffortMainFrame;
	import ddt.view.im.IMController;

	public class PersonalInfoIIView extends PersonalInfoIIBgAsset
	{
		private var _model:IPersonalInfoIIModel;
		private var _info:PlayerInfo;
		private var _cells:Dictionary;
		private var _controller:IPersonalInfoIIController;
		private var _playerview:ICharacter;
		private var _backcontainer:PersonalInfoIIDragInArea;
		private var _levelIcon:LevelIcon;
		private var _mIcon:MarryIcon;
		private var _hidehat:HCheckBox;
		private var _offerText:OfferText;
		private var _hideGlass:HCheckBox;
		private var _hideSuites:HCheckBox;
		private var _buffs:BuffControl;
		private var _vipicon:VIPIcon;
		
		private var _addFriendBtn:HBaseButton;
		private var _storeBtn:HBaseButton;
		private var _shenqiBtn:HBaseButton;
		private var _backBtn:HBaseButton;
		//private var _effortBtn:HBaseButton;
		private var _honorView:PersonalInfoEffortHonorView;
		public function PersonalInfoIIView(controller:IPersonalInfoIIController,model:IPersonalInfoIIModel)
		{
			_controller = controller;
			_model = model;
			_info = _model.getPlayerInfo();
			super();
			init();
			initEvent();
		}
	
		private function init():void
		{
			hide_option.visible = false;
			hideGlass_pos.visible = false;
			hideSuits_pos.visible = false;
			
			_backcontainer = new PersonalInfoIIDragInArea();
			_backcontainer.x = 0;
			_backcontainer.y = 0;
			_backcontainer.mouseEnabled = false;
			addChild(_backcontainer);
			
			_offerText = new OfferText(_info.Offer);
			_offerText.x = offer_pos.x;
			_offerText.y = offer_pos.y;
			removeChild(offer_pos);
			addChild(_offerText);
			
			_levelIcon = new LevelIcon("",_info.Grade,_info.Repute,_info.WinCount,_info.TotalCount,_info.FightPower);
			_levelIcon.x = level_pos.x;
			_levelIcon.y = level_pos.y;
			level_pos.visible = false;
			addChild(_levelIcon);
		
			_storeBtn = new HTipButton(storeBtn,"",LanguageMgr.GetTranslation("ddt.view.shortcutforge.tip"));
			_shenqiBtn = new HTipButton(shenqiBtn,"","十方神器");
			_backBtn = new HTipButton(backBtn,"","返回")
			
			
			_storeBtn.useBackgoundPos = true;
			_shenqiBtn.useBackgoundPos = true;
			_backBtn.useBackgoundPos = true;
			addChild(_backBtn);
			addChild(_shenqiBtn);
			addChild(_storeBtn);
			_shenqiBtn.visible = true;
			_storeBtn.visible = false;
			_backBtn.visible = false;
		//	if(TaskManager.achievementQuest.data.progress[0] <= 0)
		//	{
		//		light_mc.visible = true;
		//		light_mc.buttonMode = true;
		//		light_mc.play();
		//	}else
		//	{
		//		light_mc.visible = false;
		//		light_mc.stop();
		//	}
			//	去除成就
			//_effortBtn= new HBaseButton(effortBtn)
			//_effortBtn.useBackgoundPos = true;
			//addChildAt(_effortBtn,this.getChildIndex(light_mc)-1);
			//_honorView = new PersonalInfoEffortHonorView(EffortManager.Instance.getHonorArray());
			//_honorView.x = honorView_pos.x;
			//_honorView.y = honorView_pos.y;
			//addChild(_honorView);
			
//			hide_option.visible = _controller.getShowOption();
			if(_controller.getShowOption())
			{
				_hidehat = new HCheckBox(LanguageMgr.GetTranslation("shop.ShopIITryDressView.hideHat"));
				_hidehat.fireAuto = true;
				_hidehat.x = hide_option.x;
				_hidehat.y = hide_option.y;
				addChild(_hidehat);
				_hidehat.selected = _info.getHatHide();
				
			
				_hideGlass = new HCheckBox(LanguageMgr.GetTranslation("ddt.view.changeColor.ChangeColorLeftView.glass"));
				//_hideGlass = new HCheckBox("隐藏眼镜");
				_hideGlass.fireAuto = true;
				_hideGlass.x = hideGlass_pos.x;
				_hideGlass.y = hideGlass_pos.y;
				addChild(_hideGlass);
				_hideGlass.selected = _info.getGlassHide();
				
				_hideSuites = new HCheckBox(LanguageMgr.GetTranslation("ddt.view.changeColor.ChangeColorLeftView.suit"));
				//_hideSuites = new HCheckBox("隐藏套装");
				_hideSuites.fireAuto = true;
				_hideSuites.x = hideSuits_pos.x;
				_hideSuites.y = hideSuits_pos.y;
				addChild(_hideSuites);
				_hideSuites.selected = _info.getSuitesHide();
				
				_buffs = new BuffControl();
//				_buffs.ShowTip = false;
//				_buffs.CanClick = false;
				_buffs.x = buff_pos.x-_backcontainer.x;
				_buffs.y = buff_pos.y-_backcontainer.y;
				if((_info is SelfInfo)&&StateManager.currentStateType != StateType.SERVER_LIST)
				{
					_backcontainer.addChild(_buffs);
					_storeBtn.visible = true;
				}
				//_effortBtn.visible = true;
				//_honorView.visible = true;
				//honor_txt.visible  = false;
				addFriend.visible = false;
			}else if(_info is SelfInfo || (_info.ZoneID != PlayerManager.Instance.Self.ZoneID && _info.ZoneID!=0))
			{
				addFriend.visible = false;
				//_effortBtn.visible = false;
				//light_mc.visible   = false;
				//_honorView.visible = false;
				//honor_txt.visible  = true;
			}else if(!_controller.getEnabled())
			{
				_addFriendBtn = new HBaseButton(addFriend);
				_addFriendBtn.useBackgoundPos = true;
				addChild(_addFriendBtn);
				//_effortBtn.visible = false;
				//light_mc.visible   = false;
				//_honorView.visible = false
				//honor_txt.visible  = true;
			}
			
			_cells = new Dictionary();
			for(var i:int = 0; i <= 27; i++)
			{
				var cell:PersonalInfoCell = CellFactory.instance.createPersonalInfoCell(i) as PersonalInfoCell;
				cell.x = this["cell_" + i].x - 2.5;
				cell.y = this["cell_" + i].y - 2.5;
				cell.width = this["cell_" + i].width;
				cell.height = this["cell_" + i].height;
				cell.addEventListener(MouseEvent.CLICK,__mouseClick);
				removeChild(this["cell_" + i]);
				_backcontainer.addChild(cell);
				_cells[cell.place] = cell;
			}
			for (var a:int = 18;a <= 27; a++)
			{	
				(_cells[a] as PersonalInfoCell).visible = false;
			}
			shenqibeijing.visible = false;
			initTextTip();
			updateInfo();
		}
		/**
		 *	仅仅是初始化人物数值的tip
		 * 
		 */		
		private function initTextTip():void
		{
			var tip_dispatcher:Array=[attack_cover,defense_cover,energy_txt,celerity_cover,luck_cover,damage_txt,hp_txt,recovery_txt]
			attack_cover.useHandCursor=defense_cover.useHandCursor=celerity_cover.useHandCursor=luck_cover.useHandCursor=false;
			for each(var i:DisplayObject in tip_dispatcher)
			{
				i.addEventListener(MouseEvent.MOUSE_OVER,onPropertyMouseOver);
				i.addEventListener(MouseEvent.MOUSE_OUT,onPropertyMouseOut);
			}
		}
		private function onPropertyMouseOut(e:Event):void
		{
			TipManager.setCurrentTarget(null,null);
		}
		private function onPropertyMouseOver(e:Event):void
		{
			TipManager.setCurrentTarget(DisplayObject(e.currentTarget),getTextTipPanel(DisplayObject(e.currentTarget)));
		}
		private function getTextTipPanel(target:DisplayObject):DisplayObject
		{
			var tip:TextTipPanel=new TextTipPanel();
			switch(target)
			{
				case attack_cover:
					tip.propertyTextColor=0xFF1361;
					tip.propertyText="["+LanguageMgr.GetTranslation("ddt.view.personalinfoII.attact")+"]";
					tip.detailText=LanguageMgr.GetTranslation("ddt.view.personalinfoII.attactDetail");
				break;
				case defense_cover:
					tip.propertyTextColor=0x3ec4FF;
					tip.propertyText="["+LanguageMgr.GetTranslation("ddt.view.personalinfoII.defense")+"]";
					tip.detailText=LanguageMgr.GetTranslation("ddt.view.personalinfoII.defenseDetail");
				break;
				case energy_txt:
					tip.propertyTextColor=0x00FF00;
					tip.propertyText="["+LanguageMgr.GetTranslation("ddt.view.personalinfoII.energy")+"]";
					tip.detailText=LanguageMgr.GetTranslation("ddt.view.personalinfoII.energyDetail");
				break;
				case celerity_cover:
					tip.propertyTextColor=0x65e936;
					tip.propertyText="["+LanguageMgr.GetTranslation("ddt.view.personalinfoII.agility")+"]";
					tip.detailText=LanguageMgr.GetTranslation("ddt.view.personalinfoII.agilityDetail");
					
				break;
				case luck_cover:
					tip.propertyTextColor=0xFeba01;
					tip.propertyText="["+LanguageMgr.GetTranslation("ddt.view.personalinfoII.luck")+"]";
					tip.detailText=LanguageMgr.GetTranslation("ddt.view.personalinfoII.luckDetail");
					
				break;
				case damage_txt:
					tip.propertyTextColor=0xFF6600;
					tip.propertyText="["+LanguageMgr.GetTranslation("ddt.view.personalinfoII.damage")+"]";
					tip.detailText=LanguageMgr.GetTranslation("ddt.view.personalinfoII.damageDetail");
				break;
				case hp_txt:
					tip.propertyTextColor=0xFF0000;
					tip.propertyText="["+LanguageMgr.GetTranslation("ddt.view.personalinfoII.hp")+"]";
					tip.detailText=LanguageMgr.GetTranslation("ddt.view.personalinfoII.hpDetail");
					
				break;
				case recovery_txt:
					tip.propertyTextColor=0x0066FF;
					tip.propertyText="["+LanguageMgr.GetTranslation("ddt.view.personalinfoII.recovery")+"]";
					tip.detailText=LanguageMgr.GetTranslation("ddt.view.personalinfoII.recoveryDetail");
				break;
				default:
				break;
			}
			return tip;
		}
		private function initEvent():void
		{
			_info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__propertyChange);
			_info.Bag.addEventListener(BagEvent.UPDATE,__update);
			if(_controller.getShowOption())
			{
				_hidehat.addEventListener(MouseEvent.CLICK,__hideHatChange);
				_hideGlass.addEventListener(MouseEvent.CLICK,__hideGlassChnage);
				_hideSuites.addEventListener(MouseEvent.CLICK,__hideSuitesChange);
				_storeBtn.addEventListener(MouseEvent.CLICK,__openBagStore);
			}else if(!(_info is SelfInfo) && !_controller.getEnabled() && (_info.ZoneID == PlayerManager.Instance.Self.ZoneID || _info.ZoneID==0))
			{
				_addFriendBtn.addEventListener(MouseEvent.CLICK,__addFriend);
			}
			_shenqiBtn.addEventListener(MouseEvent.CLICK,__showShenqi);
			_backBtn.addEventListener(MouseEvent.CLICK,__hideShenqi);
			//_effortBtn.addEventListener(MouseEvent.CLICK , __effortBtnClick);
			//light_mc.addEventListener(MouseEvent.CLICK , __effortBtnClick);
			//TaskManager.addEventListener(TaskEvent.CHANGED , __lightPlay);
		}
		
		private function __lightPlay(evt:TaskEvent):void
		{
			//if(TaskManager.achievementQuest.data.progress[0] <= 0)
			//{
			//	light_mc.buttonMode = true;
			//	light_mc.visible = true;
			//	light_mc.play();
			//}else
			//{
				//light_mc.visible = false;
				//light_mc.stop();
			//}
		}
		
		private function __update(evt:BagEvent):void
		{
			updateStyle();
		}
		private function __showShenqi(evt:MouseEvent):void
		{
			zhuangbeibejing.visible = false;
			shenqibeijing.visible = true;
			for (var a:int = 18;a <= 27; a++)
			{	
				(_cells[a] as PersonalInfoCell).visible = true;
			}
			
			for (var b:int = 0;b <= 17; b++)
			{	
				(_cells[b] as PersonalInfoCell).visible = false;
			}
			_shenqiBtn.visible = false;
			_backBtn.visible = true;			
		}
		private function __hideShenqi(evt:MouseEvent):void
		{
			zhuangbeibejing.visible = true
			shenqibeijing.visible = false;
			for (var a:int = 18;a <= 27; a++)
			{	
				(_cells[a] as PersonalInfoCell).visible = false;
			}
			
			for (var b:int = 0;b <= 17; b++)
			{	
				(_cells[b] as PersonalInfoCell).visible = true;
			}
			_shenqiBtn.visible = true;
			_backBtn.visible = false;			
		}
		private function __addFriend(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			IMController.Instance.addFriend(_info.NickName);
		}
		
		private function __openBagStore(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			BagStore.Instance.show();
			dispatchEvent(new Event(BagStore.OPEN_BAGSTORE));
		}
		
		private function __effortBtnClick(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			EffortManager.Instance.isSelf = true;
			EffortMainFrame.Instance.switchVisible();
		}
		
		private function __propertyChange(evt:PlayerPropertyEvent):void
		{
			if(evt.changedProperties["AttackDefense"])
			{
				updateStyle();
			}
			if(evt.changedProperties["Luck"] || evt.changedProperties["Agility"] || evt.changedProperties["Defence"] ||evt.changedProperties["Attack"])
			{
				updateStyle();
			}
			if(evt.changedProperties["Repute"])
			{
				repute.txt.text = String(_info.Repute);
				_levelIcon.resetLevelTip(_info.Grade,_info.Repute,_info.WinCount,_info.TotalCount);
			}
			if(evt.changedProperties["GP"])
			{
				var percent:Number = Experience.getExpPercent(_info.Grade,_info.GP);
				if(percent>=0)
				{
					exp_txt.text = String(percent) + "%";
				}else
				{
					exp_txt.text = "";
				}
				exp_mask.width = 171 * (percent / 100);
			}
			if(evt.changedProperties["Offer"])
			{
				_offerText.Offer = String(_info.Offer);
//				exploit_txt.text = String(_info.Offer);
			}
			if(evt.changedProperties["Grade"] || evt.changedProperties["FightPower"])
			{
				levelIcon.level = _info.Grade;
				level_txt.text = _info.Grade.toString();
				levelIcon.Battle = _info.FightPower;
			}
			if(evt.changedProperties["Hide"])
			{
				if(_hidehat)_hidehat.selected = _info.getHatHide();
				if(_hideGlass)_hideGlass.selected = _info.getGlassHide();
				if(_hideSuites)_hideSuites.selected = _info.getSuitesHide();
			}
			if(evt.changedProperties["SpouseName"] || evt.changedProperties["IsMarried"])
			{
				updateMarriedIcon();
			}
			if(evt.changedProperties["ChargedMoney"] || evt.changedProperties["VIPLevel"])
			{
				updateVIPIcon();
			}
			
		}
		
		private function updateMarriedIcon():void
		{
			if(_mIcon && !PlayerManager.Instance.Self.IsMarried)
			{
				_mIcon.dispose()
				_mIcon=null;
			}else if(!_mIcon && PlayerManager.Instance.Self.IsMarried && _info && levelIcon)
			{
				_mIcon = new MarryIcon(_info);
				_mIcon.x = levelIcon.x + 4;  
				_mIcon.y = levelIcon.y+levelIcon.height - 14;
				addChild(_mIcon);
			}
		}
		
		private function updateVIPIcon():void
		{
			
			if(_vipicon && !PlayerManager.Instance.Self.VIPLevel == 0)
			{
				_vipicon.dispose()
				_vipicon=null;
			}else if(!_vipicon && PlayerManager.Instance.Self.VIPLevel > 0 && _info && levelIcon)
			{
				_vipicon = new VIPIcon(_info,true);
				_vipicon.x = levelIcon.x ;
				if(_mIcon == null)
				{
					_vipicon.y = levelIcon.y+levelIcon.height - 14;
				}
				else
				{
					_vipicon.y = _mIcon .y+_mIcon.height - 14;
				}
				addChild(_vipicon);
			}
		}
		
		public function updateStyle():void
		{
			if(_info.ZoneID != 0 && _info.ZoneID != PlayerManager.Instance.Self.ZoneID)
			{
				attack_txt.htmlText = getHtmlTextByString(String(_info.Attack <= 0 ? "" : _info.Attack),0);
				defense_txt.htmlText = getHtmlTextByString(String(_info.Defence <= 0 ? "" : _info.Defence),0);
				celerity_txt.htmlText = getHtmlTextByString(String(_info.Agility <= 0 ? "" : _info.Agility),0);
				lucky_txt.htmlText = getHtmlTextByString(String(_info.Luck <= 0 ? "" : _info.Luck),0);
				damage_txt.htmlText= getHtmlTextByString(String(Math.round(StaticFormula.getDamage(_info))<=0 ? "" : Math.round(StaticFormula.getDamage(_info))),1);
				recovery_txt.htmlText = getHtmlTextByString(String(StaticFormula.getRecovery(_info)<=0 ? "" : StaticFormula.getRecovery(_info)),1);
				hp_txt.htmlText = getHtmlTextByString(String(StaticFormula.getMaxHp(_info)),1);
				energy_txt.htmlText = getHtmlTextByString(String(StaticFormula.getEnergy(_info)<=0 ? "" : StaticFormula.getEnergy(_info)),1);
				actionValue_txt.htmlText = getHtmlTextByString(String(_info.FightPower),2);
				levelIcon.Battle = _info.FightPower;
			}else
			{
				attack_txt.htmlText = getHtmlTextByString(String(_info.Attack < 0 ? 0 : _info.Attack),0);
				defense_txt.htmlText = getHtmlTextByString(String(_info.Defence < 0 ? 0 : _info.Defence),0);
				celerity_txt.htmlText = getHtmlTextByString(String(_info.Agility < 0 ? 0 : _info.Agility),0);
				lucky_txt.htmlText = getHtmlTextByString(String(_info.Luck < 0 ? 0 : _info.Luck),0);
				damage_txt.htmlText= getHtmlTextByString(String(Math.round(StaticFormula.getDamage(_info))),1);
				recovery_txt.htmlText = getHtmlTextByString(String(StaticFormula.getRecovery(_info)),1);
				hp_txt.htmlText = getHtmlTextByString(String(StaticFormula.getMaxHp(_info)),1);
				energy_txt.htmlText = getHtmlTextByString(String(StaticFormula.getEnergy(_info)),1);
				actionValue_txt.htmlText = getHtmlTextByString(String(_info.FightPower),2);
				levelIcon.Battle = _info.FightPower;
			}
		}
		
		private function getHtmlTextByString(value:String , choiceHtmlText:int):String
		{
			var sourceBegin:String;
			var sourceEnding:String;
			switch (choiceHtmlText)
			{
				case 0:
					sourceBegin = "<TEXTFORMAT LEADING='2'><P ALIGN='CENTER'><FONT FACE='Arial' SIZE='15' COLOR='#000000' LETTERSPACING='0' KERNING='0'><B>"
					sourceEnding = "</B></FONT></P></TEXTFORMAT>"
					break;
				case 1:
					sourceBegin = "<TEXTFORMAT LEADING='-1'><P ALIGN='CENTER'><FONT FACE='Tahoma' SIZE='14' COLOR='#fff4ba' LETTERSPACING='0' KERNING='1'><B>"
					sourceEnding = "</B></FONT></P></TEXTFORMAT>"
				break;
				case 2:
					sourceBegin = "<TEXTFORMAT LEADING='-1'><P ALIGN='CENTER'><FONT FACE='Tahoma' SIZE='14' COLOR='#fff000' LETTERSPACING='0' KERNING='1'><B>"
					sourceEnding = "</B></FONT></P></TEXTFORMAT>"
				break;
			}
			return sourceBegin+value+sourceEnding;
		}
		
		public function setData(list:DictionaryData):void
		{
			for(var i:String in list)
			{
				if(_cells[i] != null)
					_cells[i].info = list[i];
			}
		}
		
		public function startShine(info:ItemTemplateInfo):void
		{
			if(info.NeedSex == 0||info.NeedSex == (PlayerManager.Instance.Self.Sex?1:2))
			{
				var shineIndex:Array = getCellIndex(info).split(",");
				for(var i:int = 0;i<shineIndex.length;i++)
				{
					if(int(shineIndex[i])>=0)
					{
						(_cells[int(shineIndex[i])] as PersonalInfoCell).shine();
					}
				}
			}
		}
		
		public function stopShine():void
		{
			for each(var ds:PersonalInfoCell in _cells)
			{
				(ds as PersonalInfoCell).stopShine();
			}
		}
		
		private function getCellIndex(info:ItemTemplateInfo):String
		{
			if(EquipType.isWeddingRing(info))
			{
				return "16";
			}
			switch(info.CategoryID)
			{
				case EquipType.HEAD:
				    return "0";
			    case EquipType.GLASS:
				    return "1";
			    case EquipType.HAIR:
				    return "2";
			    case EquipType.EFF:
				    return "3";
			    case EquipType.CLOTH:
				    return "4";
			    case EquipType.FACE:
				    return "5";
			    case EquipType.ARM:
				    return "6";
			    case EquipType.ARMLET:
				    return "7,8";
			    case EquipType.RING:
				    return "9,10";
				case EquipType.SUITS:
				    return "11";
			    case EquipType.NECKLACE:
				    return "12";
				case EquipType.WING:
				    return "13";
			    case EquipType.CHATBALL:
				    return "14";
				case EquipType.OFFHAND:
					return "15";
				case EquipType.PET:
					return "17";
				case EquipType.ShenQi1:
				case EquipType.ShenQi2:
					return "18,19,20,21,22,23,24,25,26,27";
				default:
				    return "-1";
			}
		}
	
		public function updateInfo():void
		{
			updateStyle();
			if(_info.ZoneID != 0 && _info.ZoneID != PlayerManager.Instance.Self.ZoneID)
			{
				_offerText.Offer = "";
			}else
			{
				_offerText.Offer = String(_info.Offer);		
			}
			level_txt.text = String(_info.Grade);
			if(_playerview == null && _info.Style!=null)
			{
				_playerview = CharactoryFactory.createCharacter(_info);
				_playerview.show(false,-1);
				_playerview.showGun = false;
				_playerview.setShowLight(true,null);
				figure_pos.addChild(_playerview as DisplayObject);
			}
			name_txt.text = _info.NickName ? _info.NickName : "";
			//honor_txt.text = _info.honor ? _info.honor : "";
			if(_info.ConsortiaName)
			{
				consortia_txt.autoSize = TextFieldAutoSize.LEFT;
				consortia_txt.htmlText = "<b>" + StringHelper.rePlaceHtmlTextField(_info.ConsortiaName) + "</b>";
				dutyName_txt.autoSize  = TextFieldAutoSize.LEFT;
				if(_info.DutyName)
				{
					dutyName_txt.htmlText = "<b><font COLOR='#0000ff'>"+StringHelper.rePlaceHtmlTextField("<" +(_info.DutyName?_info.DutyName:"") + ">")+"</font></b>";
				}else
				{
					dutyName_txt.text = "";
				}
				
				dutyName_txt.x         = consortia_txt.x + consortia_txt.textWidth;
			}else
			{
				consortia_txt.text = dutyName_txt.text = "";
			}
			var percent:Number = Experience.getExpPercent(_info.Grade,_info.GP);
			if(StateManager.currentStateType == StateType.FIGHTING && (_info.ZoneID != -1 && _info.ZoneID != PlayerManager.Instance.Self.ZoneID))
			{
				percent = 0;
			}
			if(percent>=0)
			{
				exp_txt.text = String(percent) + "%";
			}else
			{
				exp_txt.text = "";
			}
			exp_mask.width = 104 * (percent>100?1:(percent / 100));
			repute.txt.text = String(_info.Repute);
			levelIcon.resetLevelTip(_info.Grade,_info.Repute,_info.WinCount,_info.TotalCount);
			if(_info.Repute >= 100000)
			{
				repute.x = 235; 
			}else
			{
				repute.x = 250.5;
			}
			
			if(_info.IsMarried && _mIcon == null)
			{
				_mIcon = new MarryIcon(_info);
				_mIcon.x = levelIcon.x + 4;  
				_mIcon.y = levelIcon.y+levelIcon.height - 14;
				addChild(_mIcon);
			}
			if(!_info.IsMarried && _mIcon)
			{
				_mIcon.dispose();
				_mIcon = null;
			}
			if(_info.VIPLevel>0&&_vipicon == null)
			{				
				if(_info.ID!=PlayerManager.Instance.Self.ID)
				{
					_vipicon = new VIPIcon(_info,false);
				}
				else
				{
					_vipicon = new VIPIcon(_info,true);
				}
				_vipicon.x = levelIcon.x;  
				if(_mIcon == null)
				{
					_vipicon.y = levelIcon.y+levelIcon.height - 14;
				}
				else
				{
					_vipicon.y = _mIcon.y+_mIcon.height - 14;
				}
				addChild(_vipicon);
			}
			if(_info.VIPLevel == 0 && _vipicon)
			{
				_vipicon.dispose();
				_vipicon = null;
			}
		}
		
		
		private function __mouseClick(evt:MouseEvent):void
		{
			var cell:PersonalInfoCell = evt.currentTarget as PersonalInfoCell;
			if(_controller.getEnabled())
			{
				evt.stopImmediatePropagation();
				if(cell.itemInfo){
					SoundManager.Instance.play("008");
				}
				
				if(PlayerManager.Instance.Self.bagLocked)
				{
					new BagLockedGetFrame().show();
				}
				else
				{
					cell.dragStart();
				}
			}
		}
		
		public function setCellInfo(index:int,info:InventoryItemInfo):void
		{
			if(index <= 27)
			{
				if(info == null)
				{
					_cells[String(index)].info = null;
					return;
				}
				if(info.Count == 0)
				{
					_cells[String(index)].info = null;
				}
				else
				{
					_cells[String(index)].info = info;
				}
			}
		}
		
		private function __hideHatChange(evt:Event):void
		{
			SoundManager.Instance.play("008");
			SocketManager.Instance.out.sendHideLayer(EquipType.HEAD,_hidehat.selected);
		}
		private function __hideGlassChnage(evt:Event):void
		{
			SoundManager.Instance.play("008");
			SocketManager.Instance.out.sendHideLayer(EquipType.GLASS,_hideGlass.selected);
		}
		
		private function __hideSuitesChange(evt:Event):void
		{
			SoundManager.Instance.play("008");
			SocketManager.Instance.out.sendHideLayer(EquipType.SUITS,_hideSuites.selected);
		}
		private function get levelIcon():LevelIcon{
			if(_levelIcon == null)
			{
				_levelIcon = new LevelIcon("",_info.Grade,_info.Repute,_info.WinCount,_info.TotalCount,_info.FightPower);
				_levelIcon.x = level_pos.x;
				_levelIcon.y = level_pos.y;
				addChild(_levelIcon);
			}
			return _levelIcon;
		}
		
	
		public function dispose():void
		{
			_info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__propertyChange);
			_info.Bag.removeEventListener(BagEvent.UPDATE,__update);
			//light_mc.addEventListener(MouseEvent.CLICK , __effortBtnClick);
			TaskManager.addEventListener(TaskEvent.CHANGED , __lightPlay);
			if(_storeBtn)
			{
				_storeBtn.removeEventListener(MouseEvent.CLICK,__openBagStore);
				_storeBtn.dispose();
				_storeBtn = null;
			}
			//if(_effortBtn)
			//{
			//	_effortBtn.removeEventListener(MouseEvent.CLICK , __effortBtnClick);
			//	_effortBtn.dispose();
			//	_effortBtn = null;
			//}
			_info = null;
			_model = null;
			_controller = null;
			if(parent)parent.removeChild(this);
			for each(var i:PersonalInfoCell in _cells)
			{
				if(i == null)continue;
				i.removeEventListener(MouseEvent.CLICK,__mouseClick);
				i.dispose();
				if(i.parent)i.parent.removeChild(i);
			}
			_cells = null;
			if(_playerview != null)
			{
				_playerview.dispose();
				_playerview = null;
			}
			if(OfferText)
			{
				_offerText = null;
			}
			if(_buffs)
			{
				_buffs.dispose();
			}
			_buffs = null;
			if(_mIcon)
			{
				_mIcon.dispose();
				_mIcon = null;
			}
			if(_addFriendBtn)
			{
				_addFriendBtn.removeEventListener(MouseEvent.CLICK,__addFriend);
				_addFriendBtn.dispose();
				_addFriendBtn = null;
			}
			if(_levelIcon)
			{
				_levelIcon.dispose();
				_levelIcon = null;
			}
			if(_vipicon)
			{
				_vipicon.dispose();
				_vipicon = null;
			}
		}
	}
}