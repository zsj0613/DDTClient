package ddt.view.bagII.baglocked
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import game.crazyTank.view.bagII.BagLockedExplainAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HLabelButton;
	import road.ui.controls.hframe.HFrame;
	import road.ui.manager.TipManager;
	
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.utils.DisposeUtils;
	import ddt.view.bagII.bagStore.BagStore;

	public class BagLockedExplainFrame extends HFrame
	{
		private var _bagAsset:BagLockedExplainAsset;
		private var _setButton:HLabelButton;
		private var _removeButton:HLabelButton;
		private var _updateButton:HLabelButton;
		private var _deleteButton:HLabelButton;
		
		public function BagLockedExplainFrame()
		{
			super();
			setContentSize(357,360);
			blackGound = false;
			centerTitle = false;
			alphaGound = true;
			titleText = LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.BagLockedHelpFrame.titleText");
			init();
			initEvents();
			BagStore.Instance.passwordOpen = false;
		}
		
		private function init():void{
			_bagAsset = new BagLockedExplainAsset();
			_setButton = new HLabelButton();
			_setButton.label = LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.setting");
			_removeButton = new HLabelButton();
			_removeButton.label = LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.unlock");
			_updateButton = new HLabelButton();
			_updateButton.label = LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.modify");
			_deleteButton = new HLabelButton();
			_deleteButton.label = LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.delete");
			
			_setButton.x = _bagAsset.bt1.x;
			_setButton.y = _bagAsset.bt1.y;
			_deleteButton.x = _bagAsset.bt1.x;
			_deleteButton.y = _bagAsset.bt1.y;
			_removeButton.x = _bagAsset.bt2.x;
			_removeButton.y = _bagAsset.bt2.y;
			_updateButton.x = _bagAsset.bt3.x;
			_updateButton.y = _bagAsset.bt3.y;
			
			_bagAsset.addChild(_setButton);
			_bagAsset.addChild(_deleteButton);
			_bagAsset.addChild(_removeButton);
			_bagAsset.addChild(_updateButton);
			addContent(_bagAsset);
			
			_removeButton.enable = PlayerManager.Instance.Self.bagLocked;
			_updateButton.enable = PlayerManager.Instance.Self.bagPwdState;
			
			_setButton.visible = !PlayerManager.Instance.Self.bagPwdState;
			_deleteButton.visible = !_setButton.visible;
			
			_bagAsset.bt1.visible = false;
			_bagAsset.bt2.visible = false;
			_bagAsset.bt3.visible = false;
		}
		
		private function initEvents():void{
			_setButton.addEventListener(MouseEvent.CLICK,onSetButtonClickHandler);
			_deleteButton.addEventListener(MouseEvent.CLICK,onDeleteButtonClikHandler);
			_removeButton.addEventListener(MouseEvent.CLICK,onRemoveButtonClickHandler);
			_updateButton.addEventListener(MouseEvent.CLICK,onUpdateButtonClickHandler);
			addEventListener(Event.ADDED_TO_STAGE,addtoStageHandler);
		}
		
		override public function show():void
		{
			TipManager.AddTippanel(this,true);
		}
		
		private function onSetButtonClickHandler(event:MouseEvent):void{
			close();
			SoundManager.instance.play("008");
			if(PlayerManager.Instance.Self.questionOne == ""){
				var frame:BagLockedSetPasswordFrame = new BagLockedSetPasswordFrame();
				frame.show();	
			}else{
				var frameTwo:BagLockedSetPasswordFrame = new BagLockedSetPasswordFrame();
				frameTwo.changeView();
				frameTwo.show();
			}
		}
		
		private function onDeleteButtonClikHandler(event:MouseEvent):void{
			close();
			SoundManager.instance.play("008");
			if(PlayerManager.Instance.Self.questionOne != ""){
				var _frame:PasswordDeleteFrame = new PasswordDeleteFrame();
				_frame.initText(PlayerManager.Instance.Self.questionOne,PlayerManager.Instance.Self.questionTwo,PlayerManager.Instance.Self.leftTimes);
				_frame.show();
			}
			else{
				new NoneProtectionDelFrame().show();
			}
		}
		
		private function onRemoveButtonClickHandler(event:MouseEvent):void{
			close();
			new BagLockedGetFrame().show();
			SoundManager.instance.play("008");
		}
		
		private function onUpdateButtonClickHandler(event:MouseEvent):void{
			close();
			var frame:PasswordUpdateFrame = new PasswordUpdateFrame();
			frame.show();
			SoundManager.instance.play("008");
		}
		
		
		private function addtoStageHandler(event:Event):void{
			addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
		}
		
		private function keyDownHandler(event:KeyboardEvent):void{
			if(event.keyCode == Keyboard.ESCAPE){
				event.stopImmediatePropagation();
				SoundManager.instance.play("008");
				close();
			}
		}
		
		override public function close():void{
			removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			super.close();
			dispose();
		}
		
		override public function dispose():void
		{
			removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			BagStore.Instance.passwordOpen = true;
			removeEventListener(Event.ADDED_TO_STAGE,addtoStageHandler);
			_deleteButton.removeEventListener(MouseEvent.CLICK,onDeleteButtonClikHandler);
			_removeButton.removeEventListener(MouseEvent.CLICK,onRemoveButtonClickHandler);
			_setButton.removeEventListener(MouseEvent.CLICK,onSetButtonClickHandler);
			_updateButton.removeEventListener(MouseEvent.CLICK,onUpdateButtonClickHandler);
			
			if(_setButton.parent)_setButton.parent.removeChild(_setButton);
			_setButton.dispose();
			_setButton = null;
			
			if(_removeButton.parent)_removeButton.parent.removeChild(_removeButton);
			_removeButton.dispose();
			_removeButton = null;
			
			if(_updateButton.parent)_updateButton.parent.removeChild(_updateButton);
			_updateButton.dispose();
			_updateButton = null;
			
			if(_deleteButton.parent)_deleteButton.parent.removeChild(_deleteButton);
			_deleteButton.dispose();
			_deleteButton = null;
			
			if(_bagAsset.parent)_bagAsset.parent.removeChild(_bagAsset);
			_bagAsset = null;
			super.dispose();
		}
	}
}