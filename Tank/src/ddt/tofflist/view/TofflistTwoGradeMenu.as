package ddt.tofflist.view
{
	import flash.events.MouseEvent;
	
	import game.crazytank.view.tofflist.TofflistChildMenuAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HFrameButton;
	
	import ddt.tofflist.TofflistEvent;
	import ddt.utils.DisposeUtils;

	public class TofflistTwoGradeMenu extends TofflistChildMenuAsset
	{
		public static const BATTLE:String = "battle";//战斗力
		public static const LEVEL:String = "level";//等级
		public static const GESTE:String = "geste";//功勋
		public static const ASSETS:String = "assets";//资产
		public static const ACHIEVEMENTPOINT:String = "achievementpoint";//成就点
		
		private var _type            : String;
		private var _currentItem     : HFrameButton;
		private var battleBtn:HFrameButton;
		private var levelBtn:HFrameButton;
		private var gesteBtn:HFrameButton;
		private var assetsBtn:HFrameButton;
		private var achievementpointBtn:HFrameButton;
		
		public function TofflistTwoGradeMenu()
		{
			super();
			init();
			addEvent();
		}
		private function init() : void
		{
			battleBtn = new HFrameButton(battleBtnAsset);
			levelBtn = new HFrameButton(gradeOrderBtnAsset);
			gesteBtn = new HFrameButton(exploitOrderBtnAsset);
			assetsBtn = new HFrameButton(meansBtnAsset);
			achievementpointBtn = new HFrameButton(achievementpointBtnAsset);
			battleBtn.useBackgoundPos = levelBtn.useBackgoundPos = gesteBtn.useBackgoundPos = assetsBtn.useBackgoundPos = achievementpointBtn.useBackgoundPos = true;
			battleBtn.visible = levelBtn.visible = gesteBtn.visible = assetsBtn.visible = achievementpointBtn.visible = false;
			
			addChild(battleBtn);
			addChild(levelBtn);
			addChild(gesteBtn);
			addChild(assetsBtn);
			addChild(achievementpointBtn);
			
		}
		private function addEvent() : void
		{
			battleBtn.addEventListener(MouseEvent.CLICK,__selectChildToolBarHandler);
			levelBtn.addEventListener(MouseEvent.CLICK,__selectChildToolBarHandler);
			gesteBtn.addEventListener(MouseEvent.CLICK,__selectChildToolBarHandler);
			assetsBtn.addEventListener(MouseEvent.CLICK,__selectChildToolBarHandler);
			achievementpointBtn.addEventListener(MouseEvent.CLICK,__selectChildToolBarHandler);
		}
		private function removeEvent() : void
		{
			battleBtn.removeEventListener(MouseEvent.CLICK,__selectChildToolBarHandler);
			levelBtn.removeEventListener(MouseEvent.CLICK,__selectChildToolBarHandler);
			gesteBtn.removeEventListener(MouseEvent.CLICK,__selectChildToolBarHandler);
			assetsBtn.removeEventListener(MouseEvent.CLICK,__selectChildToolBarHandler);
			achievementpointBtn.removeEventListener(MouseEvent.CLICK,__selectChildToolBarHandler);
		}
		public function dispose() : void
		{
			removeEvent();
			DisposeUtils.disposeHBaseButton(battleBtn);
			DisposeUtils.disposeHBaseButton(levelBtn);
			DisposeUtils.disposeHBaseButton(gesteBtn);
			DisposeUtils.disposeHBaseButton(assetsBtn);
			DisposeUtils.disposeHBaseButton(achievementpointBtn);
			if(this.parent)this.parent.removeChild(this);
		}
		public function setParentType(parentType : String) : void
		{
			if(_currentItem)_currentItem.selected = false;
			//此处的if-else里面执行的内容是一样的是有原因的，就写成这样，方便他们以后又要改
			if(parentType == TofflistStairMenu.PERSONAL)
			{
				_currentItem = battleBtn;
				_type = BATTLE;
			}else
			{
				_currentItem = battleBtn;
				_type = BATTLE;
			}
			setVisible(parentType);
			_currentItem.selected = true;
			this.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_TOOL_BAR_SELECT,_type));
		}
		
		private function setVisible(parentType : String) : void
		{
			battleBtn.visible = levelBtn.visible = gesteBtn.visible = assetsBtn.visible = achievementpointBtn.visible = false;
			if(parentType == TofflistStairMenu.PERSONAL || parentType == TofflistStairMenu.CROSS_SERVER_PERSONAL)
			{
				battleBtn.visible = levelBtn.visible = gesteBtn.visible = achievementpointBtn.visible = true;
				gesteBtn.x = 667;
				achievementpointBtn.x = 747;
			}else
			{
				levelBtn.visible = assetsBtn.visible = gesteBtn.visible = battleBtn.visible = true;
				gesteBtn.x = 746;
			}
		}
		
		private function __selectChildToolBarHandler(evt : MouseEvent) : void
		{
			SoundManager.Instance.play("008");
			if(_currentItem)_currentItem.selected = false;
			_currentItem = evt.target.parent.parent as HFrameButton;
			_currentItem.selected = true;
			switch(evt.target.name)
			{
				case "gradeOrderBtnAsset":
				_type = LEVEL;
				break;
				case "exploitOrderBtnAsset":
				_type = GESTE;
				break;
				case "battleBtnAsset":
				_type = BATTLE;
				break;
				case "meansBtnAsset":
				_type = ASSETS;
				break;
				case "achievementpointBtnAsset":
				_type = ACHIEVEMENTPOINT;
				break;
			}
			this.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_TOOL_BAR_SELECT,_type));
		}
		public function get type() : String
		{
			return this._type;
		}
		
	}
}