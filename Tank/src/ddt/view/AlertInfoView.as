package ddt.view
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.HButton.HLabelButton;
	import road.ui.manager.TipManager;
	import road.ui.manager.UIManager;
	
	import tank.command.fightLibCommands.AlertAsset;
	import ddt.manager.LanguageMgr;
	public class AlertInfoView extends AlertAsset
	{
		private var _infoStr:String;
		private var _txt:TextField;
		
		private var _okLabel:String = LanguageMgr.GetTranslation("continue");
		private var _okBtn:HLabelButton;
		private var _okFun:Function;
		
		private var _cancelLabel:String = LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.watchAgain");
		private var _cancelBtn:HLabelButton;
		private var _cancelFun:Function;
		
		private var _showOkBtn:Boolean;
		private var _showCancelBtn:Boolean;
		
		public function AlertInfoView(infoString:String,okLabel:String=null,okFun:Function=null,cancelLabel:String=null,cancelFun:Function=null,showOkBtn:Boolean = true,showCancelBtn:Boolean=false)
		{
			_infoStr = infoString;
			if(okLabel)_okLabel = okLabel;
			_okFun = okFun;
			if(cancelLabel)_cancelLabel = cancelLabel;
			_cancelFun = cancelFun;
			_showOkBtn = showOkBtn;
			_showCancelBtn = showCancelBtn;
			
			initView();
			initEvents();
		}
		
		private function initView():void
		{
			_txt = new TextField();
			_txt.x = infoText.x;
			_txt.y = infoText.y;
			_txt.defaultTextFormat = infoText.defaultTextFormat;
			_txt.filters = infoText.filters;
			_txt.width = infoText.width;
			_txt.wordWrap = true;
			_txt.text = _infoStr;
			_txt.autoSize = TextFieldAutoSize.LEFT;
			_txt.selectable = false;
			addChild(_txt);
			removeChild(infoText);
			
			bg.height = _txt.height+75;
			littleGirl.y = bg.height-littleGirl.height;
			
			_okBtn = new HLabelButton();
			_okBtn.label = _okLabel;
			
			_cancelBtn = new HLabelButton();
			_cancelBtn.label = _cancelLabel;
			
			if(!_showCancelBtn)
			{
				_okBtn.x = (this.width - _okBtn.width)*0.5;
			}else
			{
				_okBtn.x = width*.25-_okBtn.width*.5 + 10;
				_cancelBtn.x = width*.75-_cancelBtn.width*.5 - 10;
			}
			_okBtn.y = _cancelBtn.y = 40 + _txt.textHeight;
			
			if(_showOkBtn)
			{
				addChild(_okBtn);
			}
			if(_showCancelBtn)
			{
				addChild(_cancelBtn);
			}
		}
		
		private function initEvents():void
		{
			_okBtn.addEventListener(MouseEvent.CLICK,__okClickHandler);
			_cancelBtn.addEventListener(MouseEvent.CLICK,__cancelClickHandler);
		}
		
		private function removeEvents():void
		{
			_okBtn.removeEventListener(MouseEvent.CLICK,__okClickHandler);
			_cancelBtn.removeEventListener(MouseEvent.CLICK,__cancelClickHandler);
		}
		
		private function __okClickHandler(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			if(_okFun!=null)
			{
				_okFun();
			}
		}
		
		private function __cancelClickHandler(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			if(_cancelFun!=null)
			{
				_cancelFun();
			}
		}
		
		public function show():void
		{
			x = (1000 - width)/2;
			y = (800 - height)/2-100;
			UIManager.AddDialog(this);
		}
		
		public function hide():void
		{
			UIManager.RemoveDialog(this);
		}
		
		public function dispose():void
		{
			removeEvents();
			_okFun = null;
			_cancelFun = null;
			_okBtn.dispose();
			_okBtn = null;
			_cancelBtn.dispose();
			_cancelFun = null;
			if(parent)
			{
				parent.removeChild(this);
			}
		}
	}
}