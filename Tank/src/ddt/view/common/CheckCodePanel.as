package ddt.view.common
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import game.crazyTank.view.common.CheckCodeBgAccect;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.SimpleGrid;
	import road.ui.controls.hframe.HFrame;
	import road.ui.manager.TipManager;
	
	import ddt.data.CheckCodeData;
	import ddt.manager.FilterWordManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.SocketManager;

	public class CheckCodePanel extends HFrame
	{
		public static const BACK_GOUND_GAPE:int = 3;
		private static const TIME:int = 60;
		
		private var list:SimpleGrid;
		private var bg:CheckCodeBgAccect;
		private var _isShowed:Boolean = true;
		
		private var coutTimer:Timer;
		private var coutTimer_1:Timer;
		
		private var checkCount:int = 0;;
		
		private var okBtn:HBaseButton;
		public function CheckCodePanel()
		{
			super();
			fireEvent = false;
			blackGound = true;
			titleText = LanguageMgr.GetTranslation("ddt.view.common.CheckCodePanel.titleText");
			//titleText = "验证码";
			alphaGound = false;
			showBottom = false;
			moveEnable = false;
			setSize(307,257);
			centerTitle = true;
			showClose = false;
			
			bg = new CheckCodeBgAccect();
			addChild(bg);
			
			bg.x+=4;
			
			bg.picPos.visible = false;
			bg.countdown.mouseEnabled = false;
			bg.inputTxt.restrict = "0-9 a-z A-Z";
			bg.inputTxt.multiline = false;
			bg.inputTxt.addEventListener(Event.CHANGE,textChange);
			
			okBtn = new HBaseButton(bg.okBtn);
			okBtn.useBackgoundPos = true;
			okBtn.addEventListener(MouseEvent.CLICK,__okBtnClick);
			okBtn.enable = false;
			addChild(okBtn);
			
			bg.tip_msg.selectable=false;
		
			bg.countdown.text = (TIME-1).toString();
			coutTimer = new Timer(TIME * 1000,1);
			coutTimer_1 = new Timer(1000,TIME);
		}

		private var currentPic:Bitmap;
		public function set data(d:CheckCodeData):void
		{
			if(currentPic && currentPic.parent)
			{
				removeChild(currentPic)
				currentPic.bitmapData.dispose();
				currentPic = null;
			}
			
			currentPic = d.pic;
			currentPic.width = bg.picPos.width - ( 2 * BACK_GOUND_GAPE);
			currentPic.height = bg.picPos.height - ( 2 * BACK_GOUND_GAPE);
			currentPic.x = bg.picPos.x + (Math.random() * 2 * BACK_GOUND_GAPE);
			currentPic.y = bg.picPos.y + (Math.random() * 2 * BACK_GOUND_GAPE);
			addChild(currentPic);
		}
		
		private function __onTimeComplete(e:TimerEvent):void
		{
			bg.inputTxt.text = "";
			coutTimer.stop();
			coutTimer.reset();
			sendSelected();
		}
		
		private function __onTimeComplete_1(e:TimerEvent):void
		{
			bg.countdown.text = (int(bg.countdown.text)-1).toString();
			if(stage)
			{
				stage.focus = bg.inputTxt;
			}
		}
		
		private function textChange(evt:Event):void
		{
			okBtn.enable = isValidText();
		}
		
		private function isValidText():Boolean
		{
			if(FilterWordManager.IsNullorEmpty(bg.inputTxt.text)) return false;
			if(bg.inputTxt.text.length != 4) return false;
			return true;
		}
		public function set tip(value:String):void
		{
			bg.tip_msg.text=value||"";
		}
		override public function show():void
		{
			isShowed = true;
			blackGound = false;
//			clearnBlackGound();
			this.x = 220+(Math.random()*150-75);
			this.y = 110+(Math.random()*200-100);
			TipManager.AddToLayerNoClear(this,false);
//			drawBlackGound();
			blackGound = true;
			stage.focus = bg.inputTxt;
			bg.inputTxt.text = "";
			restartTimer();
		}
		
		private function drawBlackGound():void
		{
			graphics.clear();
			graphics.beginFill(0x000000,.7);
			graphics.drawRect(-3000,-3000,6000,6000);
			graphics.endFill();
		}
		
		private function clearnBlackGound():void
		{
			graphics.clear();
		}
		
		
		override public function close():void
		{
			if(coutTimer)
			{
				coutTimer.stop();
				coutTimer.removeEventListener(TimerEvent.TIMER,__onTimeComplete);
			}
			if(coutTimer_1)
			{
				coutTimer_1.stop();
				coutTimer_1.removeEventListener(TimerEvent.TIMER,__onTimeComplete);
			}
			if(parent)
			{
				parent.removeChild(this);
			}
			checkCount = 0;
			bg.inputTxt.text = "";
			this.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		private function __okBtnClick(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			sendSelected();
		}
		
		override protected function __addToStage(e:Event):void
		{
//			super.__addToStage(e);
			stage.focus = this.bg.inputTxt;
			this.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
		}
		
		private function onKeyDown(evt:KeyboardEvent):void
		{
			evt.stopImmediatePropagation();
			if(evt.keyCode == Keyboard.ENTER && isValidText())
			{
				__okBtnClick(null);
			}
		}
		
		private function sendSelected():void
		{
			coutTimer.removeEventListener(TimerEvent.TIMER,__onTimeComplete);
			if(!FilterWordManager.IsNullorEmpty(bg.inputTxt.text))
			{
				SocketManager.Instance.out.sendCheckCode(bg.inputTxt.text);
			}else
			{
				SocketManager.Instance.out.sendCheckCode("");
				restartTimer();
			}
			bg.inputTxt.text = "";
			checkCount++;
			if(checkCount == 10)
			{
				checkCount = 0;
				coutTimer.removeEventListener(TimerEvent.TIMER,__onTimeComplete);
				close();
			}
		}
	
		private function restartTimer():void
		{
			coutTimer.stop();
			coutTimer.reset();
			coutTimer.addEventListener(TimerEvent.TIMER,__onTimeComplete);
			coutTimer.start();
			
			coutTimer_1.stop();
			coutTimer_1.reset();
			coutTimer_1.addEventListener(TimerEvent.TIMER,__onTimeComplete_1);
			coutTimer_1.start();
			bg.countdown.text = (TIME-1).toString();
			okBtn.enable = false;
		}
		private static var _instance:CheckCodePanel;
		public static function get Instance():CheckCodePanel
		{
			if(_instance == null)
			{
				_instance = new CheckCodePanel();
			}
			return _instance;
		}

		public function get isShowed():Boolean
		{
			return _isShowed;
		}

		public function set isShowed(value:Boolean):void
		{
			_isShowed = value;
		}

		
	}
}