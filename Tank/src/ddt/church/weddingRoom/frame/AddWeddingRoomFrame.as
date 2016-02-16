package ddt.church.weddingRoom.frame
{
	import ddt.church.weddingRoom.WeddingRoomControler;
	
	import fl.controls.TextArea;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.HButton.HLabelButton;
	import road.ui.controls.hframe.HFrame;
	import road.utils.ComponentHelper;
	
	import tank.assets.ScaleBMP_17;
	import tank.church.JoinWeddingFrameAccect;
	import ddt.data.ChurchRoomInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.SocketManager;
	import ddt.manager.TimeManager;
	import ddt.utils.DisposeUtils;

	public class AddWeddingRoomFrame extends HFrame
	{
		private var _asset:JoinWeddingFrameAccect;
		private var _assetBg : ScaleBMP_17;
		private var _enterBtn:HBaseButton;
		private var _cancelBtn:HBaseButton;
		private var _info:ChurchRoomInfo;
		private var _controler:WeddingRoomControler;
		
		private var _remark_txt:TextArea;
		
		public function AddWeddingRoomFrame(control:WeddingRoomControler)
		{
			super();
			_controler = control;
			init();
			initEvents();
		}
		
		private function init():void
		{
			setSize(580,325);
			titleText = LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.titleText");
			//titleText = "参加婚礼";
			this.moveEnable = false;
			
			_asset = new JoinWeddingFrameAccect();
			_assetBg = new ScaleBMP_17();
			ComponentHelper.replaceChild(_asset,_asset.BgPos,_assetBg);
			addContent(_asset,true);
			
			_enterBtn = new HLabelButton();
			_enterBtn.label = LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.into");
			//_enterBtn.label = "进入";
			_enterBtn.x = 160;
			_enterBtn.y = 285;
			addChild(_enterBtn);
			
			_cancelBtn = new HLabelButton();
			_cancelBtn.label = LanguageMgr.GetTranslation("cancel");
			//_cancelBtn.label = "取消";
			_cancelBtn.x = 350;
			_cancelBtn.y = 285;
			addChild(_cancelBtn);
			
			_remark_txt = new TextArea();
			var format:TextFormat = new TextFormat();
			format.font = "Arial";
			format.size = 16;
			format.color = 0x000000;
			format.leading = 4;
			_remark_txt.setStyle("disabledTextFormat",format);
			_remark_txt.setStyle("textFormat",format);
			_remark_txt.setSize(_asset.remark_pos.width,_asset.remark_pos.height);
			_remark_txt.textField.defaultTextFormat = new TextFormat("Arial",16,0x013465);
			_remark_txt.x = _asset.remark_pos.x;
			_remark_txt.y = _asset.remark_pos.y;
			_asset.addChild(_remark_txt);
			_remark_txt.maxChars = 300;
			_remark_txt.editable = false;
		}
		
		private function initEvents():void
		{
			_enterBtn.addEventListener(MouseEvent.CLICK,__enter);
			_cancelBtn.addEventListener(MouseEvent.CLICK,__cancel);
			addEventListener(Event.ADDED_TO_STAGE,__addToStage);
		}
		private function removeEvent() : void
		{
			_enterBtn.removeEventListener(MouseEvent.CLICK,__enter);
			_cancelBtn.removeEventListener(MouseEvent.CLICK,__cancel);
			removeEventListener(Event.ADDED_TO_STAGE,__addToStage);
			removeEventListener(KeyboardEvent.KEY_DOWN,__onKeyDown);
		}
		override public function dispose() : void
		{
			removeEvent();
			_info = null;
			_controler = null;
			DisposeUtils.disposeDisplayObject(_assetBg);
			DisposeUtils.disposeDisplayObject(_asset);
			DisposeUtils.disposeDisplayObject(_remark_txt);
			DisposeUtils.disposeHBaseButton(_enterBtn);
			DisposeUtils.disposeHBaseButton(_cancelBtn);
			super.dispose();
			if(this.parent)this.parent.removeChild(this);
			
		}
		
		private function __onKeyDown(evt:KeyboardEvent):void
		{
			evt.stopImmediatePropagation();
			if(evt.keyCode == Keyboard.ESCAPE)
			{
				SoundManager.Instance.play("008");
				hide();
			}else if(evt.keyCode == Keyboard.ENTER)
			{
				__enter(null);
			}
		}
		
		override protected function __addToStage(evt:Event):void
		{
			super.__addToStage(evt);
			stage.focus = this;
			addEventListener(KeyboardEvent.KEY_DOWN,__onKeyDown);
		}
		
		public function setRoomInfo(value:ChurchRoomInfo):void
		{
			_info = value;
			updateView();
		}
		
		private function __enter(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			if(_info.isLocked)
			{
				var _passinput:ChurchRoomPassInput = new ChurchRoomPassInput();;
				_passinput.info = _info;
				_passinput.okBtnEnable = false;
				_passinput.show();
			}else
			{
				SocketManager.Instance.out.sendEnterRoom(_info.id,"");
			}
			dispose();
		}
		
		private function __cancel(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			dispose();
		}
		
		private function hide():void
		{
			dispose();
		}
		
		private function updateView():void
		{
			_asset.roomName.text = _info.roomName;
			_asset.manName.text = _info.groomName;
			_asset.girlName.text = _info.brideName;
			_asset.currentCount.text = _info.currentNum.toString();
			_remark_txt.text = _info.discription;
			var hour:int = (_info.valideTimes*60 - (TimeManager.Instance.Now().time/(1000*60) - _info.creactTime.time/(1000*60)))/60;
			if(hour>=0)
			{
				hour = Math.floor(hour);
			}else
			{
				hour = Math.ceil(hour);
			}
			var min:int = (int((_info.valideTimes*60 - (TimeManager.Instance.Now().time/(1000*60) - _info.creactTime.time/(1000*60)))))%60;
			
			if(hour<0||min<0)
			{
				_asset.restTime.text = LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.time");
				//_asset.restTime.text = "0小时0分";
			}else
			{
				_asset.restTime.text = hour.toString() + LanguageMgr.GetTranslation("hours") + min.toString() + LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.minute");
			}
		}
		
	}
}