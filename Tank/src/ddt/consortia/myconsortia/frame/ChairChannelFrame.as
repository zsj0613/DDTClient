package ddt.consortia.myconsortia.frame
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.manager.TipManager;
	
	import ddt.consortia.ConsortiaControl;
	import ddt.consortia.ConsortiaModel;
	import tank.consortia.accect.chairChannelAsset;

	public class ChairChannelFrame extends chairChannelAsset
	{
		private var _model        : ConsortiaModel;
		private var _contro       : ConsortiaControl;
		private var _btnNameItems : Array;
		private var _btnsItems    : Dictionary;
		private var _enableKeyDown: Sprite;
		public function ChairChannelFrame($model : ConsortiaModel, $contro : ConsortiaControl)
		{
			this._model = $model;
			this._contro = $contro;
			init();
			addEvent();
		}
		
		private function init():void {
			_btnNameItems = ["consortiaUpgradeBtnAccect", "transferConsortiaBtnAccect", "manifestoBtnAccect", "poseManagerBtnAccect"];
			_btnsItems = new Dictionary();
			for(var i:int=0;i<_btnNameItems.length;i++)
			{
				var btn : HBaseButton = new HBaseButton(this[_btnNameItems[i]]);
				btn.useBackgoundPos = true;
				addChild(btn);
				_btnsItems[_btnNameItems[i]] = btn;
			}
			_enableKeyDown = new Sprite();
			TipManager.AddTippanel(_enableKeyDown);
		}
		
		private function addEvent():void {
			for(var i:int=0;i<_btnNameItems.length;i++)
			{
				var btn : HBaseButton = _btnsItems[_btnNameItems[i]] as HBaseButton;
				btn.addEventListener(MouseEvent.CLICK,    __onClickHandler);
			}
			_enableKeyDown.parent.addEventListener(KeyboardEvent.KEY_DOWN,   __keyDownHandler);
		}
		
		private function __keyDownHandler(evt : KeyboardEvent) : void
		{
			if(evt.keyCode == Keyboard.ENTER)
				evt.stopPropagation();
		}
		
		private function __onClickHandler(evt : MouseEvent) : void
		{
			SoundManager.instance.play("008");
			switch(evt.target.name) {
				case "consortiaUpgradeBtnAccect":
					//公会升级
					__consortiaUpgradeHandler(evt);
					break;
				case "transferConsortiaBtnAccect":
					__alienationConsortiaHandler(evt);
					break;
				case "manifestoBtnAccect":
					__consortiaDeclarationHandler(evt);
					break;
				case "poseManagerBtnAccect" : 
					__poseManager(evt);
					break;
			}
		}
		
		private var _consortiaUpgrade : MyConsortiaUpgrade;
		private function __consortiaUpgradeHandler(evt : MouseEvent): void
		{
			if(!_consortiaUpgrade)_consortiaUpgrade = new MyConsortiaUpgrade();
			if(_consortiaUpgrade.parent)
			{
				_consortiaUpgrade.removeEvent();
				_consortiaUpgrade.parent.removeChild(_consortiaUpgrade);
			}
			else
			{
				TipManager.AddTippanel(_consortiaUpgrade,true);
			}
		}
		
		
		private var _alienationConsortia : AlienationConsortiaFrame;
		private function __alienationConsortiaHandler(evt : MouseEvent) : void
		{
			if(!_alienationConsortia)_alienationConsortia = new AlienationConsortiaFrame(_model);
			if(_alienationConsortia.parent)
			{
				_alienationConsortia.removeEvent();
				_alienationConsortia.parent.removeChild(_alienationConsortia);
				
			}
			else
			{
				TipManager.AddTippanel(_alienationConsortia,true);
				_alienationConsortia.okBtnEnable = false;//bret 09.7.14
				_alienationConsortia.addEvent();
			}
		}
		
		private var _manifestoFrame : MyConsortiaDeclarationFrame;
		private function __consortiaDeclarationHandler(evt : MouseEvent) : void
		{
			if(!_manifestoFrame)_manifestoFrame = new MyConsortiaDeclarationFrame();
			if(_manifestoFrame.parent)
			{
				_manifestoFrame.removeEvent();
				_manifestoFrame.parent.removeChild(_manifestoFrame);
			}
			else 
			{
				TipManager.AddTippanel(_manifestoFrame,true);
				_manifestoFrame.addEvent();
				if(_model.myConsortiaData && _model.myConsortiaData.Description)
				{
					_manifestoFrame.consortiaDeclaration = _model.myConsortiaData.Description;
				}
				else
				{
					_manifestoFrame.consortiaDeclaration = "";
				}
				
			}
		}
		
		private var _jobFrame   : MyConsortiaRightsFrame;
		private function __poseManager(evt : MouseEvent) : void
		{
			if(_jobFrame == null)_jobFrame = new MyConsortiaRightsFrame(_model);
			if(_jobFrame.parent)
			{
				_jobFrame.removeEvent();
				_jobFrame.parent.removeChild(_jobFrame);
				
			}
			else 
			{
				TipManager.AddTippanel(_jobFrame,true);
				_jobFrame.addEvent();
				_contro.loadConsoritaDutyList(_model.myConsortiaData.ConsortiaID);
			}
		}
		
		public function hide():void {
			if(parent)
			{
				parent.removeChild(this);
			}
		}
		
		private function removeEvent():void {
			for(var i:int=0;i<_btnNameItems.length;i++)
			{
				var btn : HBaseButton = _btnsItems[_btnNameItems[i]] as HBaseButton;
				if(btn)
				{
					btn.removeEventListener(MouseEvent.CLICK,    __onClickHandler);
				}
			}
			if(_enableKeyDown.parent)
			{
				_enableKeyDown.parent.removeEventListener(KeyboardEvent.KEY_DOWN,   __keyDownHandler);
				_enableKeyDown.parent.removeChild(_enableKeyDown);
			}
		}
		
		private function removeChilds():void {
			if(_consortiaUpgrade)_consortiaUpgrade.dispose();_consortiaUpgrade = null;
			if(_alienationConsortia)_alienationConsortia.dispose();_alienationConsortia = null;
			if(_manifestoFrame)_manifestoFrame.dispose();_manifestoFrame = null;
			if(_jobFrame)_jobFrame.dispose();_jobFrame = null;
		}
		public function dispose():void {
			removeEvent();
			removeChilds();		
			for(var i:int=0;i<_btnNameItems.length;i++)
			{
				var btn : HBaseButton = _btnsItems[_btnNameItems[i]] as HBaseButton;
				if(btn && btn.parent)btn.parent.removeChild(btn);
				if(btn)
				{
					btn.dispose();
					btn = null;
				} 
				delete _btnsItems[_btnNameItems[i]];
			}
			while(numChildren)
			{
				removeChildAt(0);
			}
			_btnNameItems = null;
			_btnsItems    = null;
			_enableKeyDown = null;
		}
	}
}