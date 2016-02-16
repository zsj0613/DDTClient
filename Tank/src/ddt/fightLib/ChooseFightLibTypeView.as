package ddt.fightLib
{
	import flash.events.MouseEvent;
	
	import road.manager.SoundManager;
	
	import ddt.command.fightLibCommands.script.FightLibGuideScripit;
	import ddt.data.FightLibInfo;
	import ddt.data.player.PlayerPropertyEvent;
	import tank.fightLibChooseFightLibTypeView.BookShine;
	import tank.fightLibChooseFightLibTypeView.BtnShine;
	import ddt.manager.FightLibManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.socket.GameInSocketOut;
	import ddt.view.common.HSelectableShineButton;
	import tank.fightLib.ChooseExcersiseTypeAsset;

	/**
	 * 
	 * @author WickiLA
	 * @time 0526/2010
	 * @description 作战实验室里面选择训练模式的面板
	 */	
	public class ChooseFightLibTypeView extends ChooseExcersiseTypeAsset
	{
		private var _measureScreenBtn:HSelectableShineButton;
		private var _twentyDegreeBtn:HSelectableShineButton;
		private var _sixtyDegreeBtn:HSelectableShineButton;
		private var _highThrowBtn:HSelectableShineButton;
		private var _highGapBtn:HSelectableShineButton;
		
		private var _easyBtn:HSelectableShineButton;
		private var _normalBtn:HSelectableShineButton;
		private var _difficultBtn:HSelectableShineButton;
		
		private var _awardView:FightLibAwardView;
		
		private var _infoBtns:Array = [];
		private var _difficultyBtns:Array = [];
		
		private var _sencondType:int = 3;//1、5秒   2、7秒   3、 10秒   4、 15秒   5、 20秒   6、 30秒
		
		public function ChooseFightLibTypeView()
		{
			initView();
			initEvents();
		}
		
		private function initView():void
		{
			_easyBtn = new HSelectableShineButton(easyBtn,new BtnShine());
			_normalBtn = new HSelectableShineButton(normalBtn,new BtnShine());
			_difficultBtn = new HSelectableShineButton(difficultBtn,new BtnShine());
			_easyBtn.useBackgoundPos = _normalBtn.useBackgoundPos = _difficultBtn.useBackgoundPos = true;
			
			addChild(_easyBtn);
			addChild(_normalBtn);
			addChild(_difficultBtn);
			_difficultyBtns.push(_easyBtn);
			_difficultyBtns.push(_normalBtn);
			_difficultyBtns.push(_difficultBtn);
			
			_measureScreenBtn = new HSelectableShineButton(measureScreenBtn,new BookShine());
			_twentyDegreeBtn = new HSelectableShineButton(twentyDegreeBtn,new BookShine());
			_sixtyDegreeBtn = new HSelectableShineButton(sixtyDegreeBtn,new BookShine());
			_highThrowBtn = new HSelectableShineButton(highThrowBtn,new BookShine());
			_highGapBtn = new HSelectableShineButton(highGapBtn,new BookShine());
			_measureScreenBtn.useBackgoundPos = _twentyDegreeBtn.useBackgoundPos = _sixtyDegreeBtn.useBackgoundPos = _highThrowBtn.useBackgoundPos = _highGapBtn.useBackgoundPos = true;
			
			addChild(_measureScreenBtn);
			addChild(_twentyDegreeBtn);
			addChild(_sixtyDegreeBtn);
			addChild(_highThrowBtn);
			addChild(_highGapBtn);
			
			_infoBtns.push(_measureScreenBtn);
			_infoBtns.push(_twentyDegreeBtn);
			_infoBtns.push(_sixtyDegreeBtn);
			_infoBtns.push(_highThrowBtn);
			_infoBtns.push(_highGapBtn);
			
			startBtn.buttonMode = cancelBtn.buttonMode = true;
			cancelBtn.visible = false;
			
			_awardView = new FightLibAwardView();
			_awardView.x = 383;
			_awardView.y = 40;
			addChild(_awardView);
			_awardView.visible = false;
			
			textMc.mouseChildren = textMc.mouseEnabled = false;
			addChild(textMc);
			
			guideMc.mouseChildren = guideMc.mouseEnabled = false;
			addChild(guideMc);
			
			updateButtonState();
			udpateButtonStateII();
		}
		
		private function initEvents():void
		{
			_easyBtn.addEventListener(MouseEvent.CLICK,__btnClickII);
			_normalBtn.addEventListener(MouseEvent.CLICK,__btnClickII);
			_difficultBtn.addEventListener(MouseEvent.CLICK,__btnClickII);
			
			_measureScreenBtn.addEventListener(MouseEvent.CLICK,__btnClick);
			_twentyDegreeBtn.addEventListener(MouseEvent.CLICK,__btnClick);
			_sixtyDegreeBtn.addEventListener(MouseEvent.CLICK,__btnClick);
			_highThrowBtn.addEventListener(MouseEvent.CLICK,__btnClick);
			_highGapBtn.addEventListener(MouseEvent.CLICK,__btnClick);
			
			startBtn.addEventListener(MouseEvent.CLICK,__start);
			cancelBtn.addEventListener(MouseEvent.CLICK,__cancel);
			
			PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__update);
		}
		
		private function removetEvents():void
		{
			_easyBtn.removeEventListener(MouseEvent.CLICK,__btnClickII);
			_normalBtn.removeEventListener(MouseEvent.CLICK,__btnClickII);
			_difficultBtn.removeEventListener(MouseEvent.CLICK,__btnClickII);
			
			_measureScreenBtn.removeEventListener(MouseEvent.CLICK,__btnClick);
			_twentyDegreeBtn.removeEventListener(MouseEvent.CLICK,__btnClick);
			_sixtyDegreeBtn.removeEventListener(MouseEvent.CLICK,__btnClick);
			_highThrowBtn.removeEventListener(MouseEvent.CLICK,__btnClick);
			_highGapBtn.removeEventListener(MouseEvent.CLICK,__btnClick);
			
			startBtn.removeEventListener(MouseEvent.CLICK,__start);
			cancelBtn.removeEventListener(MouseEvent.CLICK,__cancel);
			
			PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__update);
		}
		
		private function updateButtonState():void
		{
			_twentyDegreeBtn.enable = _sixtyDegreeBtn.enable = _highThrowBtn.enable = _highGapBtn.enable = false;

			if(FightLibManager.Instance.getFightLibInfoByID(6).InfoCanPlay)
			{
				_twentyDegreeBtn.enable = true;
			}
			if(FightLibManager.Instance.getFightLibInfoByID(7).InfoCanPlay)
			{
				_sixtyDegreeBtn.enable = true;
			}
			if(FightLibManager.Instance.getFightLibInfoByID(8).InfoCanPlay)
			{
				_highThrowBtn.enable = true;
			}
			if(FightLibManager.Instance.getFightLibInfoByID(9).InfoCanPlay)
			{
				_highGapBtn.enable = true;
			}
		}
		
		private function udpateButtonStateII():void
		{
			_easyBtn.enable = _normalBtn.enable = _difficultBtn.enable = false;
			if(FightLibManager.Instance.currentInfo)
			{
				if(FightLibManager.Instance.currentInfo.easyCanPlay)
				{
					_easyBtn.enable = true;
				}
				if(FightLibManager.Instance.currentInfo.normalCanPlay)
				{
					_normalBtn.enable = true;
				}
				if(FightLibManager.Instance.currentInfo.difficultCanPlay)
				{
					_difficultBtn.enable = true;
				}
			}
		}
		
		private function __update(evt:PlayerPropertyEvent):void
		{
			if(evt.changedProperties["fightLibMission"])
			{
				updateButtonState();
				udpateButtonStateII();
				updateAward();
			}
		}
		
		private function __btnClick(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			if((evt.currentTarget as HSelectableShineButton).selected) return;
			for each(var btn:HSelectableShineButton in _infoBtns)
			{
				if(btn.enable)
				{
					btn.stopShine();
				}
			}
			if(evt.currentTarget == _measureScreenBtn && FightLibManager.Instance.script && FightLibManager.Instance.script is FightLibGuideScripit)
			{
				FightLibManager.Instance.script.continueScript();
			}
			setAllBtnUnselect();
			setAllBtnUnselectII();
			(evt.currentTarget as HSelectableShineButton).selected = true;
			updateModel();
			udpateButtonStateII();
		}
		
		private function updateModel():void
		{
			if(_measureScreenBtn.selected)
			{
				FightLibManager.Instance.currentInfoID = 5;
			}else if(_twentyDegreeBtn.selected)
			{
				FightLibManager.Instance.currentInfoID = 6;
			}else if(_sixtyDegreeBtn.selected)
			{
				FightLibManager.Instance.currentInfoID = 7;
			}else if(_highThrowBtn.selected)
			{
				FightLibManager.Instance.currentInfoID = 8;
			}else if(_highGapBtn.selected)
			{
				FightLibManager.Instance.currentInfoID = 9;
			}
			FightLibManager.Instance.currentInfo.difficulty = -1;
			updateAward();
		}
		
		private function setAllBtnUnselect():void
		{
			_measureScreenBtn.selected = false;
			_twentyDegreeBtn.selected = false;
			_sixtyDegreeBtn.selected = false;
			_highThrowBtn.selected = false;
			_highGapBtn.selected = false;
		}
		
		private function setAllBtnUnselectII():void
		{
			_easyBtn.selected = _normalBtn.selected = _difficultBtn.selected = false;
		}
		
		private function __btnClickII(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			if(FightLibManager.Instance.currentInfo == null)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.fightLib.ChooseFightLibTypeView.selectFightLibInfo"));
				for each(var btn:HSelectableShineButton in _infoBtns)
				{
					if(btn.enable)
					{
						btn.startShine();
					}
				}
				return;
			}
			for each(var btn1:HSelectableShineButton in _difficultyBtns)
			{
				if(btn1.enable)
				{
					btn1.stopShine();
				}
			}
			setAllBtnUnselectII();
			(evt.currentTarget as HSelectableShineButton).selected = true;
			updateModelII();
			updateAward();
			updateSencondType();
			GameInSocketOut.sendGameRoomSetUp(FightLibManager.Instance.currentInfo.id,5,_sencondType,FightLibManager.Instance.currentInfo.difficulty);
			if(evt.currentTarget == _easyBtn && FightLibManager.Instance.script && FightLibManager.Instance.script is FightLibGuideScripit)
			{
				FightLibManager.Instance.script.continueScript();
				FightLibManager.Instance.script.dispose();
				FightLibManager.Instance.script = null;
			}
		}
		
		private function updateModelII():void
		{
			if(_easyBtn.selected)
			{
				FightLibManager.Instance.currentInfo.difficulty = FightLibInfo.EASY;
			}else if(_normalBtn.selected)
			{
				FightLibManager.Instance.currentInfo.difficulty = FightLibInfo.NORMAL;
			}else if(_difficultBtn.selected)
			{
				FightLibManager.Instance.currentInfo.difficulty = FightLibInfo.DIFFICULT;
			}
		}
		
		private function updateAward():void
		{
			if(FightLibManager.Instance.currentInfo!=null && FightLibManager.Instance.currentInfo.difficulty > -1)
			{
				_awardView.visible = true;
				_awardView.setGiftAndExpNum(FightLibManager.Instance.currentInfo.getAwardGiftsNum(),FightLibManager.Instance.currentInfo.getAwardEXPNum());
				_awardView.setAwardItems(FightLibManager.Instance.currentInfo.getAwardItems());
				_awardView.symbolMc.visible = false;
				updateAwardGainedState();
			}else
			{
				_awardView.visible = false;
			}
		}
		
		private function updateSencondType():void
		{
			if(FightLibManager.Instance.currentInfo && (FightLibManager.Instance.currentInfo.id == 6||FightLibManager.Instance.currentInfo.id == 7||FightLibManager.Instance.currentInfo.id == 8))
			{
				if(FightLibManager.Instance.currentInfo.difficulty == 0)
				{
					_sencondType = 6;
				}else if(FightLibManager.Instance.currentInfo.difficulty == 1)
				{
					_sencondType = 5;
				}else
				{
					_sencondType = 3;
				}
			}else if(FightLibManager.Instance.currentInfo && FightLibManager.Instance.currentInfo.id == 9)
			{
				if(FightLibManager.Instance.currentInfo.difficulty == 0)
				{
					_sencondType = 5;
				}else if(FightLibManager.Instance.currentInfo.difficulty == 1)
				{
					_sencondType = 4;
				}else
				{
					_sencondType = 3;
				}
			}
		}
		
		private function updateAwardGainedState():void
		{
			if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.EASY)
			{
				if(FightLibManager.Instance.currentInfo.easyAwardGained)
				{
					_awardView.symbolMc.visible = true;
				}
			}else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.NORMAL)
			{
				if(FightLibManager.Instance.currentInfo.normalAwardGained)
				{
					_awardView.symbolMc.visible = true;
				}
			}else
			{
				if(FightLibManager.Instance.currentInfo.difficultAwardGained)
				{
					_awardView.symbolMc.visible = true;
				}
			}
		}
		
		private function __start(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			if(FightLibManager.Instance.currentInfo == null)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.fightLib.ChooseFightLibTypeView.selectFightLibInfo"));
				for each(var btn:HSelectableShineButton in _infoBtns)
				{
					if(btn.enable)
					{
						btn.startShine();
					}
				}
				return;
			}else if(FightLibManager.Instance.currentInfo.difficulty < 0)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.fightLib.ChooseFightLibTypeView.selectDifficulty"));
				for each(var btn1:HSelectableShineButton in _difficultyBtns)
				{
					if(btn1.enable)
					{
						btn1.startShine();
					}
				}
				return;
			}
			if(PlayerManager.Instance.Self.WeaponID <= 0)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.RoomIIController.weapon"));
				return;
			}
			startBtn.visible = false;
			cancelBtn.visible = true;
			GameInSocketOut.sendGameStart();
		}
		
		private function __cancel(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			GameInSocketOut.sendCancelWait();
			cancelBtn.visible = false;
			startBtn.visible = true;
		}
		
		public function dispose():void
		{
			removetEvents();
			_infoBtns = null;
			_difficultyBtns = null;
			_easyBtn.dispose();
			_normalBtn.dispose();
			_difficultBtn.dispose();
			
			_measureScreenBtn.dispose();
			_twentyDegreeBtn.dispose();
			_sixtyDegreeBtn.dispose();
			_highThrowBtn.dispose();
			_highGapBtn.dispose();
			
			_easyBtn = null;
			_normalBtn = null;
			_difficultBtn = null;
			
			_measureScreenBtn = null;
			_twentyDegreeBtn = null;
			_sixtyDegreeBtn = null;
			_highThrowBtn = null;
			_highGapBtn = null;
			if(parent)
			{
				parent.removeChild(this);
			}
		}
	}
}