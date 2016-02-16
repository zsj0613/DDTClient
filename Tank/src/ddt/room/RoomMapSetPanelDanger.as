package ddt.room
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import game.crazyTank.view.roomII.DangerRoomSetPanelAsset;
	
	import road.data.DictionaryData;
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HFrameButton;
	
	import ddt.data.RoomInfo;
	import ddt.data.player.RoomPlayerInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.RoomManager;
	import ddt.socket.GameInSocketOut;
	import ddt.utils.DisposeUtils;

   //探险地图设置
	public class RoomMapSetPanelDanger extends RoomMapSetPanelBase
	{
		private var _asset             : DangerRoomSetPanelAsset;
		private var _currentPermission : HFrameButton;
		private var _currentLevelBtn   : HFrameButton;
		private var _permissionType    : int;//难度
		private var _levelType         : int;//等级
		
		private var _permissionBtn1    : HFrameButton;
		private var _permissionBtn2    : HFrameButton;
		private var _permissionBtn3    : HFrameButton;
		private var _permissionBtn4    : HFrameButton;
		private var _levelBtn1         : HFrameButton;
		private var _levelBtn2         : HFrameButton;
		private var _levelBtn3         : HFrameButton;
		private var _levelBtn4         : HFrameButton;
		private var _levelBtn5         : HFrameButton;		
		
		public function RoomMapSetPanelDanger(controller:RoomIIController,room:RoomInfo)
		{
			super(controller,room);
		}
		override protected function init() : void
		{
			super.init();
			_bg.x           = 25;
			_bg.setSize(475,515);
			
			_asset = new DangerRoomSetPanelAsset();
			addChild(_asset);
			
			_confirmBtn.x = 380	;
			_confirmBtn.y = 475;
			
			_permissionBtn1 = new HFrameButton(_asset.PermissionBtn1);
			_permissionBtn1.useBackgoundPos = true;
			_asset.addChild(_permissionBtn1);
			_permissionBtn2 = new HFrameButton(_asset.PermissionBtn2);
			_permissionBtn2.useBackgoundPos = true;
			_asset.addChild(_permissionBtn2);
			_permissionBtn3 = new HFrameButton(_asset.PermissionBtn3);
			_permissionBtn3.useBackgoundPos = true;
			_asset.addChild(_permissionBtn3);
			_permissionBtn4 = new HFrameButton(_asset.PermissionBtn4);
			_permissionBtn4.useBackgoundPos = true;
			_asset.addChild(_permissionBtn4);
			_permissionBtn4.visible = false;
			
			
			_levelBtn1 = new HFrameButton(_asset.levelBtn1);
			_levelBtn1.useBackgoundPos = true;
			_asset.addChild(_levelBtn1);
			_levelBtn2 = new HFrameButton(_asset.levelBtn2);
			_levelBtn2.useBackgoundPos = true;
			_asset.addChild(_levelBtn2);
			_levelBtn3 = new HFrameButton(_asset.levelBtn3);
			_levelBtn3.useBackgoundPos = true;
			_asset.addChild(_levelBtn3);
			_levelBtn4 = new HFrameButton(_asset.levelBtn4);
			_levelBtn4.useBackgoundPos = true;
			_asset.addChild(_levelBtn4);
			_levelBtn5 = new HFrameButton(_asset.levelBtn5);
			_levelBtn5.useBackgoundPos = true;
			_asset.addChild(_levelBtn5);
			
			_levelBtn2.visible = /*_room.selfLevelLimits >= 2 ? true :*/ false;
			_levelBtn3.visible = /*_room.selfLevelLimits >= 3 ? true :*/  false;
			_levelBtn4.visible = /*_room.selfLevelLimits >= 4 ? true :*/  false;
			_levelBtn5.visible = /*_room.selfLevelLimits >= 5 ? true :*/  false;
			
			//_levelType               = _room.levelLimits;
			
			//if(this["_levelBtn"+_levelType])
			//{
			//	this["_levelBtn"+_levelType].selected      = true;
			//	_currentLevelBtn         = this["_levelBtn"+_levelType];
			//}
			
			_permissionType = _room.hardLevel;
			switch(_permissionType){
				case 1:
					_permissionBtn2.selected = true;
					_currentPermission       = _permissionBtn2;
					break;
				case 2:
					_permissionBtn3.selected = true;
					_currentPermission       = _permissionBtn3;
					break;
				case 3:
					_permissionBtn4.selected = true;
					_currentPermission       = _permissionBtn4;
					break;
				default:
					_permissionBtn1.selected = true;
					_currentPermission       = _permissionBtn1;
					break;
			}
			
		}
		
		private function checkLevel($level : int) : Boolean
		{
			if($level <= 1) return true;
			var level : int = ($level - 1)*5 + 1;
			var arr : DictionaryData = RoomManager.Instance.current.players;
			for each(var obj : RoomPlayerInfo in arr)
			{
				if(obj.info.Grade <= level)
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.somebodyInvalidate"));
					return false;
				}
			}
			return true;
		}
		override protected function addEvent() : void
		{
			super.addEvent();
			_permissionBtn1.addEventListener(MouseEvent.CLICK, __onClickPermissionHandler);
			_permissionBtn2.addEventListener(MouseEvent.CLICK, __onClickPermissionHandler);
			_permissionBtn3.addEventListener(MouseEvent.CLICK, __onClickPermissionHandler);
			_permissionBtn4.addEventListener(MouseEvent.CLICK, __onClickPermissionHandler);
			
			_levelBtn1.addEventListener(MouseEvent.CLICK,      __onClickLevelHandler);
			_levelBtn2.addEventListener(MouseEvent.CLICK,      __onClickLevelHandler);
			_levelBtn3.addEventListener(MouseEvent.CLICK,      __onClickLevelHandler);
			_levelBtn4.addEventListener(MouseEvent.CLICK,      __onClickLevelHandler);
			_levelBtn5.addEventListener(MouseEvent.CLICK,      __onClickLevelHandler);
		}
		override protected function removeEvent() : void
		{
			super.removeEvent();
			_permissionBtn1.removeEventListener(MouseEvent.CLICK, __onClickPermissionHandler);
			_permissionBtn2.removeEventListener(MouseEvent.CLICK, __onClickPermissionHandler);
			_permissionBtn3.removeEventListener(MouseEvent.CLICK, __onClickPermissionHandler);
			_permissionBtn4.removeEventListener(MouseEvent.CLICK, __onClickPermissionHandler);
			
			_levelBtn1.removeEventListener(MouseEvent.CLICK,      __onClickLevelHandler);
			_levelBtn2.removeEventListener(MouseEvent.CLICK,      __onClickLevelHandler);
			_levelBtn3.removeEventListener(MouseEvent.CLICK,      __onClickLevelHandler);
			_levelBtn4.removeEventListener(MouseEvent.CLICK,      __onClickLevelHandler);
			_levelBtn5.removeEventListener(MouseEvent.CLICK,      __onClickLevelHandler);
		}
		private function __onClickPermission1(evt:MouseEvent):void{
			SoundManager.Instance.play("008");
			if(_permissionBtn1 == _currentPermission)return;
			_permissionType = 0;
			if(_currentPermission)_currentPermission.selected = false;
			_currentPermission =  _permissionBtn1;
			if(_currentPermission)_currentPermission.selected = true;
			_hadChange = true;
		}
		private function __onClicklevel1(evt:MouseEvent):void{
			SoundManager.Instance.play("008");
			if(_levelBtn1 == _currentLevelBtn)return;
			var $levelType : int = 1;
			$levelType = 1;
				
			if(!checkLevel($levelType))return;
			_levelType = $levelType;
			if(_currentLevelBtn)_currentLevelBtn.selected = false;
			_currentLevelBtn =  _levelBtn1;
			if(_currentLevelBtn)_currentLevelBtn.selected = true;
			_hadChange = true;
		}
		private function __onClickPermissionHandler(evt : MouseEvent) : void
		{
			SoundManager.Instance.play("008");
			if(evt.currentTarget == _currentPermission)return;
			switch(evt.currentTarget)
			{
				case _permissionBtn1:
				_permissionType = 0;
				break;
				case _permissionBtn2:
				_permissionType = 1;
				break;
				case _permissionBtn3:
				_permissionType = 2;
				break;
				case _permissionBtn4:
				_permissionType = 3;
				break;
			}
			if(_currentPermission)_currentPermission.selected = false;
			_currentPermission =  evt.currentTarget as HFrameButton;
			if(_currentPermission)_currentPermission.selected = true;
			_hadChange = true;
			
		}
		private function __onClickLevelHandler(evt : MouseEvent) : void
		{
			SoundManager.Instance.play("008");
			if(evt.currentTarget == _currentLevelBtn)return;
			var $levelType : int = 1;
			switch(evt.currentTarget)
			{
				case _levelBtn1:
				$levelType = 1;
				break;
				case _levelBtn2:
				$levelType = 2;
				break;
				case _levelBtn3:
				$levelType = 3;
				break;
				case _levelBtn4:
				$levelType = 4;
				break;
				case _levelBtn5:
				$levelType = 5;
				break;
			}
			if(!checkLevel($levelType))return;
			_levelType = $levelType;
			if(_currentLevelBtn)_currentLevelBtn.selected = false;
			_currentLevelBtn =  evt.currentTarget as HFrameButton;
			if(_currentLevelBtn)_currentLevelBtn.selected = true;
			_hadChange = true;
		}
		override protected function __confirmClick(evt : MouseEvent) : void
		{
			SoundManager.Instance.play("008");
			if(_hadChange)
			{
				GameInSocketOut.sendGameRoomSetUp(_room.mapId,_room.roomType,2,_permissionType,_levelType);
			}
			hide();
		}
		
		override protected function __onKeyDownd(evt : KeyboardEvent) : void
		{
			if(evt.keyCode == Keyboard.ESCAPE)
			{
				SoundManager.Instance.play("008");
				hide();
			}
		}
		
		override public function dispose() : void
		{
			super.dispose();
			DisposeUtils.disposeHBaseButton(_permissionBtn1);
			DisposeUtils.disposeHBaseButton(_permissionBtn2);
			DisposeUtils.disposeHBaseButton(_permissionBtn3);
			DisposeUtils.disposeHBaseButton(_permissionBtn4);
			
			
			DisposeUtils.disposeHBaseButton(_levelBtn1);
			DisposeUtils.disposeHBaseButton(_levelBtn2);
			DisposeUtils.disposeHBaseButton(_levelBtn3);
			DisposeUtils.disposeHBaseButton(_levelBtn4);
			DisposeUtils.disposeHBaseButton(_levelBtn5);
			if(this.parent)this.parent.removeChild(this);
		}
	}
}