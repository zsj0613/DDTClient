package ddt.game.playerThumbnail
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import game.crazyTank.view.GoodsTipBgAsset;
	import game.crazyTank.view.common.LevelTipAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.bitmap.BlackTipBG;
	import road.ui.manager.TipManager;
	import road.utils.ComponentHelper;
	
	import tank.church.MarryIconTipAsset;
	import ddt.data.game.Player;
	import ddt.events.LivingEvent;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PersonalInfoManager;
	import ddt.utils.Helpers;
	import ddt.view.common.Battle;
	import ddt.view.common.LevelIcon;
	import ddt.view.common.Repute;
	import ddt.view.common.ShineObject;
	import ddt.view.common.WinRate;
	
	import webgame.crazytank.game.view.playerThumbnailAsset;
	import webgame.crazytank.game.view.thumbnailShineAsset;

	public class PlayerThumbnail extends playerThumbnailAsset
	{
		private var _info:Player;
		private var _headFigure:HeadFigure;
		private var _blood:BloodItem;
		private var _name:TextField;
		
		private var _shiner:ShineObject;
		
		private var _tipContainer:Sprite;
		private var _tip:LevelTipAsset;
		private var _repute:Repute;
		private var lightingFilter:BitmapFilter;
		private var _winRate:WinRate;
		private var _marryedTip:Sprite;
		private var _battle:Battle;
		
		public function PlayerThumbnail(info:Player)
		{
			super();
			_info = info;
			init();
			initEvents();
		}
		
		private function init():void
		{
			_headFigure = new HeadFigure(this.headFigure.width,this.headFigure.height,_info);
			_headFigure.x = this.headFigure.x;
			_headFigure.y = this.headFigure.y;
			removeChild(this.headFigure);
			addChild(_headFigure);
			
			_blood = new BloodItem(_info.maxBlood);
			_blood.width = this._bloodItem.width;
			_blood.height = this._bloodItem.height;
			_blood.x = this._bloodItem.x;
			_blood.y = this._bloodItem.y;
			this._bloodItem.visible = false;
			addChild(_blood);
			
			_name = new TextField();
			_name.defaultTextFormat = name_txt.getTextFormat();
			_name.filters = name_txt.filters;
			_name.autoSize = "left";
			_name.wordWrap = false;
			_name.text = _info.playerInfo.NickName;
			if(_name.width>65)
			{
				var tempIndex:int = _name.getCharIndexAtPoint(50,5);
				_name.text = _name.text.substring(0,tempIndex)+"...";
			}
			_name.x = name_txt.x;
			_name.y = name_txt.y;
			_name.mouseEnabled = false;
			name_txt.visible = false;
			addChild(_name)
			
			_shiner = new ShineObject(new thumbnailShineAsset(),false);
			_shiner.mouseChildren = false;
			_shiner.mouseEnabled = false;
			addChild(_shiner);
			
			createLevelTip();
			buttonMode = true;
			setUpLintingFilter();
		}
		
		private function createLevelTip():void
		{
			_tip = new LevelTipAsset();
			Helpers.hidePosMc(_tip);
			ComponentHelper.replaceChild(_tip,_tip.bg_pos,new GoodsTipBgAsset);
			
			var _tmp:uint;
			var _lt1:MovieClip;
			var _lt2:MovieClip;
			var levelTipClass:Class;
			var _level:int = _info.playerInfo.Grade;
			if(_level > 9)
			{
				_tmp = Math.floor(_level / 10);
				levelTipClass = LevelIcon.LevelTipClasses[_tmp];
				_lt1 = new levelTipClass();
				_lt1.x = _tip.level_tip_pos_mc.x - 4;
				_lt1.y = _tip.level_tip_pos_mc.y;
				_tip.addChild(_lt1);
				
				_tmp = _level % 10;
				levelTipClass = LevelIcon.LevelTipClasses[_tmp];
				_lt2 = new levelTipClass();
				_lt2.x = _lt1.x + _lt1.width - 3;
				_lt2.y = _lt1.y;
				_tip.addChild(_lt2);
			}
			else
			{
				_tmp = 0; // 计算十位数部分
				levelTipClass = LevelIcon.LevelTipClasses[_tmp];
				_lt1 = new levelTipClass();
				_lt1.x = _tip.level_tip_pos_mc.x - 4;
				_lt1.y = _tip.level_tip_pos_mc.y;
				_tip.addChild(_lt1);
				
				_tmp = _level;
				levelTipClass = LevelIcon.LevelTipClasses[_tmp];
				_lt2 = new levelTipClass();
				_lt2.x = _lt1.x + _lt1.width - 3;
				_lt2.y = _lt1.y;
				_tip.addChild(_lt2);
			}
			
			_tip.level_tip_pos_mc.parent.removeChild(_tip.level_tip_pos_mc);
			
			_tipContainer = new Sprite();
			creatMarryTip();
			
			_repute = new Repute(_info.playerInfo.Repute,_info.playerInfo.Grade);
			_repute.align = Repute.LEFT;
			_winRate = new WinRate(_info.playerInfo.WinCount,_info.playerInfo.TotalCount);
			_battle = new Battle(_info.playerInfo.FightPower);
			
			_repute.x = _winRate.x = _battle.x = 10;
			_repute.y = 27;
			_winRate.y = 52;
			_battle.y = 77;
			_tipContainer.addChild(_tip);
			_tipContainer.addChild(_repute);
			_tipContainer.addChild(_winRate);
			_tipContainer.addChild(_battle);
			_tipContainer.addChild(_marryedTip);
		}
		
		private function creatMarryTip():void
		{
			_marryedTip = new Sprite();
			if(_info.playerInfo.IsMarried)
			{
				var marryTipbg:BlackTipBG = new BlackTipBG();
				marryTipbg.height = 25;
				
				var _label:MarryIconTipAsset = new MarryIconTipAsset();
				_label.name_txt.text = _info.playerInfo.SpouseName?_info.playerInfo.SpouseName:"";
				_label.name_txt.autoSize = TextFieldAutoSize.LEFT;
				_label.nameSub_txt.text = _info.playerInfo.Sex ? LanguageMgr.GetTranslation("MarryIcon.hubby") : LanguageMgr.GetTranslation("MarryIcon.wife");
				_label.nameSub_txt.autoSize = TextFieldAutoSize.LEFT;
				_label.nameSub_txt.x = _label.name_txt.x +_label.name_txt.width+2;
				
				marryTipbg.width = _label.width+10;
				_label.x = 5;
				_label.y = (marryTipbg.height - _label.height)/2;
				
				_marryedTip.addChild(marryTipbg);
				_marryedTip.addChild(_label);
				_marryedTip.y = 110;
			}
		}
		
		protected function overHandler(evt:MouseEvent):void
		{
			this.filters = [lightingFilter];
			TipManager.setCurrentTarget(this,_tipContainer);
		}
		
		protected function outHandler(evt:MouseEvent):void
		{
//			_thumbnailTip.hide();
			this.filters = null;
			TipManager.setCurrentTarget(null,_tipContainer);
		}
		
		protected function clickHandler(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			PersonalInfoManager.instance.addPersonalInfo(_info.playerInfo.ID,_info.playerInfo.ZoneID);
		}
		
		private function initEvents():void
		{
			_info.addEventListener(LivingEvent.BLOOD_CHANGED,__updateBlood);
			_info.addEventListener(LivingEvent.DIE,__die);
			_info.addEventListener(LivingEvent.ATTACKING_CHANGED,__shineChange);
			
			addEventListener(MouseEvent.ROLL_OVER,overHandler);
			addEventListener(MouseEvent.ROLL_OUT,outHandler);
			addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		private function setUpLintingFilter():void
		{
			var matrix:Array = new Array();
			matrix = matrix.concat([1, 0, 0, 0, 25]);// red
			matrix = matrix.concat([0, 1, 0, 0, 25]);// green
			matrix = matrix.concat([0, 0, 1, 0, 25]);// blue
			matrix = matrix.concat([0, 0, 0, 1, 0]);// alpha
			lightingFilter = new ColorMatrixFilter(matrix);   //这里好像是 new BitmapFilter(matrix);
		}
		
		private function __shineChange(evt:LivingEvent):void
		{
			if(_info&&_info.isAttacking)
			{
				_shiner.shine();
			}else
			{
				_shiner.stopShine();
			}
		}
		
		private function __die(evt:LivingEvent):void
		{
			if(_headFigure)_headFigure.gray();
			if(_blood)_blood.visible = false;
		}
		
		private function removeEvents():void
		{
			if(_info)
			{
				_info.removeEventListener(LivingEvent.BLOOD_CHANGED,__updateBlood);
				_info.removeEventListener(LivingEvent.DIE,__die);
				_info.removeEventListener(LivingEvent.ATTACKING_CHANGED,__shineChange);
			}
			removeEventListener(MouseEvent.ROLL_OVER,overHandler);
			removeEventListener(MouseEvent.ROLL_OUT,outHandler);
			removeEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		private function __updateBlood(evt:LivingEvent):void
		{
			_blood.bloodNum = _info.blood;
		}
		
		public function dispose():void
		{
			if(_tipContainer)
			{
				if(_repute)_tipContainer.removeChild(_repute);
				_repute = null;
				if(_winRate)_tipContainer.removeChild(_winRate);
				_winRate = null;
				if(_tip)_tipContainer.removeChild(_tip);
				_tip = null;
				if(_tipContainer.parent)
				{
					_tipContainer.parent.removeChild(_tipContainer);
				}
				_tipContainer = null;
			}
			
			removeEvents();
			if(parent)
			{
				parent.removeChild(this);
			}
			if(_headFigure)_headFigure.dispose();
			_headFigure = null;
			if(_blood)
				_blood.dispose();
			_blood = null;
			_info = null;
		}
	}
}