package ddt.civil.view
{
	import ddt.civil.CivilControler;
	import ddt.civil.CivilDataEvent;
	import ddt.civil.CivilModel;
	
	import fl.controls.TextArea;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.utils.ComponentHelper;
	
	import tank.civil.LeftViewAsset;
	import ddt.data.player.CivilPlayerInfo;
	import ddt.manager.ChatManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PersonalInfoManager;
	import ddt.manager.PlayerManager;
	import ddt.view.characterII.CharactoryFactory;
	import ddt.view.characterII.ICharacter;
	import ddt.view.common.LevelIcon;
	import ddt.view.im.IMController;
	
	public class CivilLeftView extends LeftViewAsset
	{
		private var _controler:CivilControler;
		private var _model    : CivilModel;
		private var _addFriend:HBaseButton;
		private var _courtship:HBaseButton;
		private var _talk     :HBaseButton;
		private var _equip    :HBaseButton;
		private var _text     :TextArea;
		private var _player   :ICharacter;
		private var _levelIcon:LevelIcon;
		private var _info     :CivilPlayerInfo;
		public function CivilLeftView(controler:CivilControler,model:CivilModel)
		{
			_controler = controler;
			_model     = model;
			init();
			initEvent();
		}
		
		private function init():void
		{
			playerBg.gotoAndStop(2);
			_addFriend = new HBaseButton(addFriend);
			_addFriend.useBackgoundPos = true;
			addChild(_addFriend);
			_addFriend.enable =true;
			
			_courtship = new HBaseButton(courtship);
			_courtship.useBackgoundPos = true;
			addChild(_courtship);
			_courtship.enable =true;
			
			_talk 	   = new HBaseButton(talk);
			_talk.useBackgoundPos = true;
			addChild(_talk);
			_talk.enable =true;
			
			_equip     = new HBaseButton(equip);
			_equip.useBackgoundPos = true;
			addChild(_equip);
			_equip.enable =true;
			
			_levelIcon = new LevelIcon("s",1,0,0,0,0);
			ComponentHelper.replaceChild(this,levelPos,_levelIcon);
			levelPos.visible = false;
			_levelIcon.visible = false;
			
			_text = new TextArea();
			_text.x = introductionPos.x;
			_text.y = introductionPos.y - 1;
			_text.setStyle("upSkin",new Sprite());
			_text.setStyle("disabledSkin",new Sprite());
			_text.verticalScrollPolicy = "on";
			_text.horizontalScrollPolicy = "off";
			
			var format:TextFormat = new TextFormat();
			format.font = "Arial";
			format.size = 14;
			format.color = 0x013465;
			format.leading = 2;
			
			_text.setStyle("disabledTextFormat",format);
			_text.setStyle("textFormat",format);
			_text.setSize(introductionPos.width-3,introductionPos.height+2);
			_text.textField.defaultTextFormat = new TextFormat("Arial",16,0x013465);
			addChild(_text);
			introductionPos.visible = false;
			_text.editable = false;
			_text.textField.selectable = false;
			_text.textField.mouseEnabled = false;
		}
		
		private function initEvent():void
		{
			_courtship.addEventListener(MouseEvent.CLICK       , __onButtonClick)
			_addFriend.addEventListener(MouseEvent.CLICK       , __onButtonClick)
			_talk.addEventListener(MouseEvent.CLICK            , __onButtonClick)
			_equip.addEventListener(MouseEvent.CLICK           , __onButtonClick)
			_model.addEventListener(CivilDataEvent.CIVIL_PLAYERINFO_ARRAY_CHANGE,__updateView);
			_model.addEventListener(CivilDataEvent.CIVIL_UPDATE,__updateView);
		}
		
		private function removeEvent():void
		{
			if(_controler)_controler.removeEventListener(MouseEvent.CLICK       , __onButtonClick)
			if(_addFriend)_addFriend.removeEventListener(MouseEvent.CLICK       , __onButtonClick)
			if(_talk)	  _talk.removeEventListener(MouseEvent.CLICK            , __onButtonClick)
			if(_equip)	  _equip.removeEventListener(MouseEvent.CLICK           , __onButtonClick)
			if(_model)	  _model.removeEventListener(CivilDataEvent.CIVIL_PLAYERINFO_ARRAY_CHANGE,__updateView);
			if(_model)    _model.addEventListener(CivilDataEvent.CIVIL_UPDATE,__updateView);
		}
		
		private function __onButtonClick(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			var info:CivilPlayerInfo = _controler.currentcivilInfo
			if(info && info.info)
			{
				switch(evt.currentTarget)
				{
					case _talk:
						ChatManager.Instance.privateChatTo(info.info.NickName,info.info.ID);
						break;
					case _equip:
						if(info.IsPublishEquip)
						{
							PersonalInfoManager.instance.addPersonalInfo(info.info.ID,PlayerManager.Instance.Self.ZoneID);
						}
						else if(info.MarryInfoID == PlayerManager.Instance.Self.MarryInfoID && PlayerManager.Instance.Self.IsPublishEquit)
						{
							PersonalInfoManager.instance.addPersonalInfo(info.info.ID,PlayerManager.Instance.Self.ZoneID);
						}
						break;
					case _addFriend:
						IMController.Instance.addFriend(info.info.NickName);
						break;
					case _courtship:
						PlayerManager.Instance.sendValidateMarry(info.info);
				}
			}
		}
		
		private function __updateView(evt:CivilDataEvent):void
		{
			if(_model.sex)
			{
				playerBg.gotoAndStop(2)
			}else
			{
				playerBg.gotoAndStop(1)
			}
			if(_model.currentcivilItemInfo)
			{	
				updatePlayerView();
			}
			else
			{
				_levelIcon.visible = false;
				_equip.enable = false;
				_talk.enable = false;
				_courtship.enable = false;
				_addFriend.enable = false;
				
				playerName.text = "";
				consortiaName.text = "";
				repute.text = "";
				offer.text = "";
				married.text = "";
				_text.text = "";
			}
			refreshCharater();
		}
		
		private function updatePlayerView():void
		{
			var info : CivilPlayerInfo = _model.currentcivilItemInfo;	
			playerName.text = info.info.NickName;
			consortiaName.text = info.info.ConsortiaName?"<"+info.info.ConsortiaName+">":"";
			repute.text = String(info.info.Repute);
			offer.text = String(info.info.Offer);
			married.text = _model.currentcivilItemInfo.info.IsMarried?LanguageMgr.GetTranslation("civil.frame.CivilRegisterFrame.married") : LanguageMgr.GetTranslation("civil.frame.CivilRegisterFrame.marry");
			_text.text = info.Introduction;
			
			_levelIcon.visible = true;
			_levelIcon.level = _model.currentcivilItemInfo.info.Grade;
			_levelIcon.setRepute(_model.currentcivilItemInfo.info.Repute);
			_levelIcon.setRate(_model.currentcivilItemInfo.info.WinCount,_model.currentcivilItemInfo.info.TotalCount);
			_levelIcon.Battle = _model.currentcivilItemInfo.info.FightPower;
			
			//更新个人简介
			if(_model.currentcivilItemInfo.MarryInfoID == PlayerManager.Instance.Self.MarryInfoID && PlayerManager.Instance.Self.Introduction != null)
			{
				_text.text = PlayerManager.Instance.Self.Introduction;
			}
			//查看装备按钮状态
			if(!_model.currentcivilItemInfo.IsPublishEquip)
			{
				_equip.enable = false;
			}
			else
			{
				_equip.enable = true;
			}
			//求婚按钮状态
			if(PlayerManager.Instance.Self.Sex == _model.currentcivilItemInfo.info.Sex || PlayerManager.Instance.Self.IsMarried == true || _model.currentcivilItemInfo.info.IsMarried == true)
			{
				_courtship.enable = false;
				
				if(_model.currentcivilItemInfo.MarryInfoID == PlayerManager.Instance.Self.MarryInfoID)
				{
					_talk.enable = false;
					_addFriend.enable = false;
				}
				else
				{
					_talk.enable = true;
					_addFriend.enable = true;
				}
			}
			else
			{
				_courtship.enable = true;
				_talk.enable = true;
				_addFriend.enable = true;
			}
		}
		
		private function refreshCharater():void
		{
			_info = _controler.currentcivilInfo;
			if(_player)
			{
				_player.dispose();
				_player = null;
			}
			if(_info)
			{
				_player = CharactoryFactory.createCharacter(_info.info);
				_player.setShowLight(true,null);
				playerPos.addChild(_player as DisplayObject);
				_player.show(false,-1);
				_player.showGun = false;
				_player.visible = true;
			}
			
		}
		
		public function dispose():void
		{
			removeEvent();
			if(_addFriend)
			{
				removeChild(_addFriend);
				_addFriend.dispose();
			}
			_addFriend = null;
			if(_courtship)
			{
				removeChild(_courtship);
				_courtship.dispose();
			}
			_courtship = null;
			if(_equip)
			{
				removeChild(_equip);
				_equip.dispose();
			}
			_equip = null;
			if(_text)
			{
				removeChild(_text);
			}
			_text = null;
			if(_player)
			{
				_player.dispose();
			}
			_player = null;
			if(_levelIcon)
			{
				removeChild(_levelIcon);
				_levelIcon.dispose();
			}
			_levelIcon = null;
		}

	}
}