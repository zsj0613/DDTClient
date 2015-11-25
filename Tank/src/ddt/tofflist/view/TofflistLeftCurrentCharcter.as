package ddt.tofflist.view
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import game.crazytank.view.tofflist.CurrentPlayerAsset;
	import game.crazytank.view.tofflist.PlayerRankNd;
	import game.crazytank.view.tofflist.PlayerRankNum0;
	import game.crazytank.view.tofflist.PlayerRankNum1;
	import game.crazytank.view.tofflist.PlayerRankNum2;
	import game.crazytank.view.tofflist.PlayerRankNum3;
	import game.crazytank.view.tofflist.PlayerRankNum4;
	import game.crazytank.view.tofflist.PlayerRankNum5;
	import game.crazytank.view.tofflist.PlayerRankNum6;
	import game.crazytank.view.tofflist.PlayerRankNum7;
	import game.crazytank.view.tofflist.PlayerRankNum8;
	import game.crazytank.view.tofflist.PlayerRankNum9;
	import game.crazytank.view.tofflist.PlayerRankRd;
	import game.crazytank.view.tofflist.PlayerRankSt;
	import game.crazytank.view.tofflist.PlayerRankTh;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.utils.ComponentHelper;
	
	import ddt.data.player.PlayerInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PersonalInfoManager;
	import ddt.manager.PlayerManager;
	import ddt.tofflist.TofflistEvent;
	import ddt.tofflist.TofflistModel;
	import ddt.view.characterII.CharactoryFactory;
	import ddt.view.characterII.ICharacter;
	import ddt.view.common.LevelIcon;
	
	public class TofflistLeftCurrentCharcter extends CurrentPlayerAsset
	{
		private var _info : PlayerInfo;
		private var _levelIcon : LevelIcon;
		private var _player     : ICharacter;
		private var _rankNumber:Sprite;
		private var _lookEquip_btn:HBaseButton;
		public function TofflistLeftCurrentCharcter()
		{
			super();
			init();
			addEvent();
		}
		private function init() : void
		{
			_levelIcon = new LevelIcon("b",1,0,0,0,0);
			_levelIcon.visible = false;
			ComponentHelper.replaceChild(this,levelPos,_levelIcon);
			
			removeChild(textBoxPos);
			initTextField(Txt1);
			initTextField(consortiaName);
			initTextField(nameTxt);
			initTextField(chairmanNameTxt);
			initTextField(chairmanNameTxtII);
			NO1.visible = false;
			NO1.gotoAndStop(1);
			removeChild(rank_pos);
			_lookEquip_btn = new HBaseButton(lookEquip_btn);
			addChild(_lookEquip_btn);
		}
		private function addEvent() : void
		{
			TofflistModel.addEventListener(TofflistEvent.TOFFLIST_CURRENT_PLAYER,  __upCurrentPlayerHandler);
			_lookEquip_btn.addEventListener(MouseEvent.CLICK					, __lookBtnClick);
		}
		private function removeEvent() : void
		{
			TofflistModel.removeEventListener(TofflistEvent.TOFFLIST_CURRENT_PLAYER,  __upCurrentPlayerHandler);
			_lookEquip_btn.removeEventListener(MouseEvent.CLICK					, __lookBtnClick);
		}
		
		private function __upCurrentPlayerHandler(evt : TofflistEvent) : void
		{
			_info = TofflistModel.currentPlayerInfo;
			upView();
		}
		
		private function __lookBtnClick(evt:Event):void
		{
			SoundManager.instance.play("008");
			if(TofflistModel.firstMenuType == TofflistStairMenu.PERSONAL && _info)
			{
				PersonalInfoManager.instance.addPersonalInfo(_info.ID , PlayerManager.Instance.Self.ZoneID);
			}
		}
		
		private function upView() : void
		{
			refreshCharater();
			upStyle();
			NO1Effect();
			if(TofflistModel.firstMenuType == TofflistStairMenu.PERSONAL)
			{
				_lookEquip_btn.enable = true;
			}else
			{
				_lookEquip_btn.enable = false;
			}
		}
		/**第一名的显示效果**/
		private function NO1Effect() : void
		{
			if(TofflistModel.currentIndex == 1)
			{
				NO1.visible = true;
				NO1.gotoAndPlay(1);
			}
			else
			{
				NO1.visible = false;
				NO1.gotoAndStop(1);
			}
		}
		private function initTextField(txt : TextField) : void
		{
			txt.selectable = false;
			txt.mouseEnabled = false;
		}
		/***********
		 * 两种样式*
		 * 玩家，会长*/
		private function upStyle() : void
		{
			nameTxt.text = "";
			chairmanNameTxt.text = "";
			chairmanNameTxtII.text = "";
			Txt1.text = "";
			consortiaName.text = "";
			if(!_info)
			{
				if(_rankNumber)
				{
					removeChild(_rankNumber)
					_rankNumber = null;
				}
				if(_levelIcon)
				{
					this.addChild(levelPos);
					if(_levelIcon.parent)_levelIcon.parent.removeChild(_levelIcon);
					_levelIcon.dispose();
					_levelIcon = null;
				}
				return;
			}
			if(TofflistModel.firstMenuType == TofflistStairMenu.PERSONAL || TofflistModel.firstMenuType== TofflistStairMenu.CROSS_SERVER_PERSONAL)
			{
				upLevelIcon();
				if(_levelIcon)
				{
					_levelIcon.visible=true;
				}
				if(levelPos)
				{
					levelPos.visible=true;
				}
				nameTxt.text = _info.NickName;
				chairmanNameTxt.text = "";
				chairmanNameTxtII.text = "";
				
				_levelIcon.x=(textBoxPos.width-_levelIcon.width-nameTxt.textWidth)/2+textBoxPos.x;
				nameTxt.x=_levelIcon.x+_levelIcon.width;
			}
			else
			{
				if(_levelIcon)
				{
					_levelIcon.visible=false;
				}
				if(levelPos)
				{
					levelPos.visible=false;
				}
				chairmanNameTxt.text = LanguageMgr.GetTranslation("ddt.tofflist.view.TofflistLeftCurrentCharcter.cdr");
				chairmanNameTxtII.text = _info.NickName;
				
				chairmanNameTxt.x=(textBoxPos.width-chairmanNameTxt.textWidth-chairmanNameTxtII.textWidth)/2+textBoxPos.x;
				chairmanNameTxtII.x=chairmanNameTxt.x+chairmanNameTxt.textWidth+10;
			}
			this.Txt1.text = String(TofflistModel.currentText);
			this.consortiaName.text = String(TofflistModel.currentPlayerInfo.ConsortiaName);
			getRank(TofflistModel.currentIndex);
		}
		/**更新等级图标**/
		private function upLevelIcon() : void
		{
			if(_levelIcon)
			{
				if(_levelIcon.parent)_levelIcon.parent.removeChild(_levelIcon);
				_levelIcon.dispose();
				_levelIcon = null;
			}
			if(_info)
			{
				_levelIcon = new LevelIcon("b",1,0,0,0,0);
//				ComponentHelper.replaceChild(this,levelPos,_levelIcon);
				addChild(_levelIcon)
				_levelIcon.x = levelPos.x;
				_levelIcon.y = levelPos.y;
				_levelIcon.level = _info.Grade;
				_levelIcon.setRepute(_info.Repute);
				_levelIcon.setRate(_info.WinCount,_info.TotalCount);
				_levelIcon.Battle = _info.FightPower;
			}
			
		}
		/***更新人物图象**/
		private function refreshCharater():void
		{
			if(_player)
			{
				_player.dispose();
				_player = null;
			}
			
			if(_info)
			{
				_player = CharactoryFactory.createCharacter(_info);
				
				_player.setShowLight(true,null);
				figure1_pos.addChild(_player as DisplayObject);
				_player.show(false,-1);
				_player.showGun = false;
				_player.visible = true;
			}
		}
		
		/**
		 * 取得排名(图片方式)
		 * @return
		 */		
		private function getRank(rankNumber:int):void
		{
			if(!_rankNumber)
			{
				_rankNumber=new Sprite();
				_rankNumber.visible = true;
			}
			
			for(var j:int=0;j<_rankNumber.numChildren;)
			{
				_rankNumber.removeChildAt(j);
			}
			
			var bmpData:BitmapData;
			var bmp:Bitmap;
			var strNumber:String=rankNumber.toString();
			var len:int=strNumber.length;
			for(var i:int=0;i<len;i++)
			{
				bmp=getRankBitmap(int(strNumber.substr(i,1)));
				bmp.x=i*30;
				_rankNumber.addChild(bmp);
			}
			
			switch(rankNumber)
			{
				case 1:
					bmpData=new PlayerRankSt(0,0);
					bmp=new Bitmap(bmpData);
					bmp.x=25;
					bmp.y=8;
					_rankNumber.addChild(bmp);
					break
				case 2:
					bmpData=new PlayerRankNd(0,0);
					bmp=new Bitmap(bmpData);
					bmp.x=34;
					bmp.y=8;
					_rankNumber.addChild(bmp);
					break
				case 3:
					bmpData=new PlayerRankRd(0,0);
					bmp=new Bitmap(bmpData);
					bmp.x=30;
					bmp.y=8;
					_rankNumber.addChild(bmp);
					break
				default:
					bmpData=new PlayerRankTh(0,0);
					bmp=new Bitmap(bmpData);
					bmp.x=len*30;
					bmp.y=8;
					_rankNumber.addChild(bmp);
					break
			}
			
			addChild(_rankNumber);
			_rankNumber.x=rank_pos.x+(rank_pos.width-_rankNumber.width)/2;
			_rankNumber.y=rank_pos.y;
			if(this.contains(rank_pos))
			{
				removeChild(rank_pos);
			}
			bmpData=null;
		}
		
		private function getRankBitmap(rankCell:int):Bitmap
		{
			var bmpData:BitmapData;
			var bmp:Bitmap;
			
			switch(rankCell)
			{
				case 0:
					bmpData=new PlayerRankNum0(0,0);
					break;
				case 1:
					bmpData=new PlayerRankNum1(0,0);
					break;
				case 2:
					bmpData=new PlayerRankNum2(0,0);
					break;
				case 3:
					bmpData=new PlayerRankNum3(0,0);
					break;
				case 4:
					bmpData=new PlayerRankNum4(0,0);
					break;
				case 5:
					bmpData=new PlayerRankNum5(0,0);
					break;
				case 6:
					bmpData=new PlayerRankNum6(0,0);
					break;
				case 7:
					bmpData=new PlayerRankNum7(0,0);
					break;
				case 8:
					bmpData=new PlayerRankNum8(0,0);
					break;
				case 9:
					bmpData=new PlayerRankNum9(0,0);
					break;
			}
			bmp=new Bitmap(bmpData);
			bmpData=null;
			return bmp;
		}
		
		public function dispose() :  void
		{
			removeEvent();
			if(_player)
			{
				_player.dispose();
				_player = null;
			}
			if(_levelIcon)
			{
				if(_levelIcon.parent)_levelIcon.parent.removeChild(_levelIcon);
				_levelIcon.dispose();
			}
			_levelIcon =  null;
			if(_lookEquip_btn)
			{
				if(_lookEquip_btn.parent)_lookEquip_btn.parent.removeChild(_lookEquip_btn);
				_lookEquip_btn.dispose();
			}
			_lookEquip_btn = null
			if(this.parent)this.parent.removeChild(this);
			if(_rankNumber && _rankNumber.parent) _rankNumber.parent.removeChild(_rankNumber);
			_rankNumber=null;
		}
		
	}
}