package ddt.game
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import game.crazyTank.view.TurnNumAsset;
	
	import road.comm.PackageIn;
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HFrameButton;
	
	import ddt.data.MissionInfo;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.manager.GameManager;
	import ddt.manager.StateManager;
	import ddt.states.StateType;
//	import ddt.utils.DebugUtil;

    
    /**
    * 关卡信息
    */
	public class DungeonInfoView extends Sprite
	{
		private var _turnNumMc : TurnNumAsset;
		private var _info      : MissionInfo;
		private var _txt1      : TextField;
		private var _missionHelp : DungeonHelpView;
		private var _helpBtn   : HFrameButton;
		private var _glowFilters:Array;
		public function DungeonInfoView()
		{
			super();
			_turnNumMc = new TurnNumAsset();
			addChild(_turnNumMc);
			
			
			initTextField(_turnNumMc.contextTxt1);
			initTextField(_turnNumMc.contextTxt2);
			initTextField(_turnNumMc.contextTxt3);
			initTextField(_turnNumMc.contextTxt4);
			initTextField(_turnNumMc.titleTxt1);
			initTextField(_turnNumMc.titleTxt2);
			initTextField(_turnNumMc.titleTxt3);
			initTextField(_turnNumMc.titleTxt4);
			_glowFilters = [new GlowFilter(0x000000,1,4,4,10)];
			_turnNumMc.contextTxt1.filters = _glowFilters;
			_turnNumMc.contextTxt2.filters = _glowFilters;
			_turnNumMc.contextTxt3.filters = _glowFilters;
			_turnNumMc.contextTxt4.filters = _glowFilters;
			_turnNumMc.titleTxt1.filters   = _glowFilters;
			_turnNumMc.titleTxt2.filters   = _glowFilters;
			_turnNumMc.titleTxt3.filters   = _glowFilters;
			_turnNumMc.titleTxt4.filters   = _glowFilters;
			
			_info = GameManager.Instance.Current.missionInfo;
			_turnNumMc.gotoAndStop(_info.missionIndex);
			if(_info.title1)_turnNumMc.titleTxt1.text = _info.title1;
			if(_info.title2)_turnNumMc.titleTxt2.text = _info.title2;
			if(_info.title3)_turnNumMc.titleTxt3.text = _info.title3;
			if(_info.title4)_turnNumMc.titleTxt4.text = _info.title4;
			
			_missionHelp = new DungeonHelpView();
			_missionHelp.x = -512;
			_missionHelp.y = -148;
			addChild(_missionHelp);
			
			_turnNumMc.bgAsset.mouseChildren = _turnNumMc.bgAsset.mouseEnabled = false;
			_helpBtn = new HFrameButton(_turnNumMc.helpBtn);
			_helpBtn.useBackgoundPos = true;
			_turnNumMc.addChild(_helpBtn);
			addEvent();
		}
		private function addEvent(): void
		{
			_helpBtn.addEventListener(MouseEvent.CLICK, __openHelpHandler);
		}
		
		private function removeEvent() : void
		{
			if(_helpBtn)_helpBtn.removeEventListener(MouseEvent.CLICK, __openHelpHandler);
		}
		private function __openHelpHandler(evt : MouseEvent) : void
		{
			SoundManager.Instance.play("008");
			_missionHelp.switchVisible();
		}
		public function barrierInfoHandler(evt : CrazyTankSocketEvent) : void
		{
			_info = GameManager.Instance.Current.missionInfo;
			var pkg: PackageIn     = evt.pkg;
			_info.currentValue1    = pkg.readInt();//可以是杀敌数， 可以是达到的木板数
			_info.currentValue2    = pkg.readInt();//当前第几轮
			_info.currentValue3    = pkg.readInt();
			_info.currentValue4    = pkg.readInt();
			upView();
		}
		
		private var _totalTrunTrainer : int = 100;
		public function trainerView($currentTrun : int) : void
		{
			_turnNumMc.titleTxt1.text   = "TRUN";
			if($currentTrun == -1)
			{
				_turnNumMc.contextTxt1.text = "";
				return;
			}
			_turnNumMc.contextTxt1.text = $currentTrun.toString() +"/"+_totalTrunTrainer.toString();
			if(_totalTrunTrainer == $currentTrun)
			{
				StateManager.setState(StateType.MAIN);
			}
		}
		
		private var _Vy : int;
		private function upView() : void
		{
			if(_info.currentValue1 != -1 && _info.totalValue1 > 0)_turnNumMc.contextTxt1.text  = _info.currentValue1 +  "/" + _info.totalValue1;
			if(_info.currentValue2 != -1 && _info.totalValue2 > 0)_turnNumMc.contextTxt2.text  = _info.currentValue2 +  "/" + _info.totalValue2;
			if(_info.currentValue3 != -1 && _info.totalValue3 > 0)_turnNumMc.contextTxt3.text  = _info.currentValue3 +  "/" + _info.totalValue3;
			if(_info.currentValue4 != -1 && _info.totalValue4 > 0)_turnNumMc.contextTxt4.text  = _info.currentValue4 +  "/" + _info.totalValue4;
			if(_turnNumMc && _info)_turnNumMc.gotoAndStop(_info.missionIndex);
		}
		public function dispose() : void
		{
			removeEvent();
			if(_missionHelp)_missionHelp.dispose();
			if(_helpBtn)_helpBtn.dispose();
			_missionHelp = null;
			_helpBtn = null;
			if(this.parent)this.parent.removeChild(this);
		}
		
		
		public function initTextField(txt : TextField) : void
		{
			txt.mouseEnabled = false;
			txt.selectable   = false;
			txt.text         = "";
		}
		private function creatTextField($old : TextField):TextField
		{
			var field:TextField = new TextField();
			field.multiline = false;
			field.wordWrap = true;
			field.autoSize = TextFieldAutoSize.RIGHT;
			field.x = $old.x;
			field.y = $old.y;
			field.width = $old.width;
			field.height = $old.height;
			
			return field;
		}
	}
}