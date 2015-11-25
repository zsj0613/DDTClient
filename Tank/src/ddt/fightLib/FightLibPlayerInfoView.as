package ddt.fightLib
{
	import road.utils.StringHelper;
	
	import ddt.data.player.PlayerInfo;
	import ddt.data.player.PlayerPropertyEvent;
	import ddt.events.PlayerEvent;
	import ddt.view.buffControl.BuffControl;
	import ddt.view.characterII.CharactoryFactory;
	import ddt.view.characterII.ICharacter;
	import ddt.view.characterII.ShowCharacter;
	import ddt.view.common.ConsortiaIcon;
	import ddt.view.common.LevelIcon;
	import ddt.view.common.MarryIcon;
	import tank.fightLib.FightLibPlayerInfoViewAsset;

	/**
	 * 
	 * @author WickiLA
	 * @time 0607/2010
	 * @description 战斗实验室界面左边人物形象界面
	 */	
	public class FightLibPlayerInfoView extends FightLibPlayerInfoViewAsset
	{
		private var _info:PlayerInfo;
		private var _figure:ICharacter;
		private var _levelIcon:LevelIcon;
		private var _guildIcon:ConsortiaIcon;
		private var _marryIcon:MarryIcon;
		private var _buff:BuffControl;
		
		public function FightLibPlayerInfoView(info:PlayerInfo)
		{
			_info = info;
			initView();
			initEvents();
		}
		
		private function initView():void
		{
			_figure = CharactoryFactory.createCharacter(_info);
			_figure.showGun = true;
			_figure.x = 50;
			_figure.y = 160;
			_figure.show(true,-1);
			_figure.setShowLight(true,null);
			addChild(_figure as ShowCharacter);
			
			_buff = new BuffControl();
			_buff.x = 34;
			_buff.y = 324;
			addChild(_buff);
			
			updateView();
		}
		
		private function updateView():void
		{
			updateName();
			updateLevelIcon();
			updateGuildIcon();
			updateMarryIcon();
		}
		
		private function updateName():void
		{
			var name:String = _info.NickName;
			if(_info.ConsortiaName!=null && _info.ConsortiaName!="")
			{
				consortiaNameTxt.text = _info.ConsortiaName;
			}
			nameTxt.htmlText = name;
			
			reputeTxt.text = String(_info.Repute);
			gesteTxt.text = String(_info.Offer);
		}
		
		private function updateLevelIcon():void
		{
			if(_levelIcon)
			{
				_levelIcon.dispose();
			}
			_levelIcon = new LevelIcon("",_info.Grade,_info.Repute,_info.WinCount,_info.TotalCount,_info.FightPower);
			_levelIcon.x = 185;
			_levelIcon.y = 160;
			addChild(_levelIcon);
		}
		
		private function updateGuildIcon():void
		{
			if(_guildIcon)
			{
				_guildIcon.dispose();
				_guildIcon = null;
			}
			if(_info.ConsortiaID>0)
			{
				_guildIcon = new ConsortiaIcon(_info.ConsortiaID);
				_guildIcon.x = _levelIcon.x + 3;
				_guildIcon.y = _levelIcon.y + _levelIcon.height - 10;
				addChild(_guildIcon);
			}
		}
		
		private function updateMarryIcon():void
		{
			if(_marryIcon)
			{
				_marryIcon.dispose();
				_marryIcon = null;
			}
			if(_info.SpouseName!=null && _info.SpouseName!="")
			{
				_marryIcon = new MarryIcon(_info);
				if(_info.ConsortiaID>0)
				{
					_marryIcon.x = _levelIcon.x + 4;
					_marryIcon.y = _levelIcon.y + 72;
				}else
				{
					_marryIcon.x = _levelIcon.x + 4;
					_marryIcon.y = _levelIcon.y + _marryIcon.height - 8;
				}
				
				addChild(_marryIcon);
			}	
		}
		
		private function __updateView(evt:PlayerPropertyEvent):void
		{
			if(evt.changedProperties["Effectiveness"] ||
				evt.changedProperties["DutyLevel"] ||
				evt.changedProperties["ConsortiaName"] ||
				evt.changedProperties["SpouseName"] ||
				evt.changedProperties["Grade"] ||
				evt.changedProperties["Repute"])
			updateView();
		}
		
		private function initEvents():void
		{
			_info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__updateView);
		}
		
		private function removeEvents():void
		{
			_info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__updateView);
		}
		
		public function dispose():void
		{
			removeEvents();
			_info = null
			_figure.dispose();
			_figure = null;
			_levelIcon.dispose();
			_levelIcon = null;
			if(_guildIcon)
			{
				_guildIcon.dispose();
				_guildIcon = null;
			}
			if(_marryIcon)
			{
				_marryIcon.dispose();
				_marryIcon = null;
			}
			_buff.dispose();
			_buff = null;
			
			if(parent)
			{
				parent.removeChild(this);
			}
		}
	}
}