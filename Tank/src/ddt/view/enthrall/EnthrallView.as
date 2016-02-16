package ddt.view.enthrall
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.manager.TipManager;
	
	import ddt.manager.EnthrallManager;
	import tank.view.enthrall.*;
	import ddt.manager.TimeManager;
	
	public class EnthrallView extends Sprite
	{
		//游戏状态
		public static const HALL_VIEW_STATE:uint = 0;       //100%经验
		public static const ROOMLIST_VIEW_STATE:uint = 1;   //50%
		public static const GAME_VIEW_STATE:uint = 2;       //无经验奖励
		
		private var _enthrall:EnthrallViewAccect;
//		private var _timeLight:HGlowButton;
        private var _info:TimeAccect;
        private var _approveBtn:HBaseButton;
        
        private var _manager:EnthrallManager;
				
		public function EnthrallView(manager:EnthrallManager)
		{
			_manager = manager;
			initUI();
		}
		private function initUI():void
		{
			_enthrall = new EnthrallViewAccect();
			_enthrall.light_mc.visible = false;
			
			_approveBtn = new HBaseButton(new approveAsset());
			_approveBtn.y = 25;
			addChild(_approveBtn);

//			_enthrall.visible = false;  //bret  隐藏 防沉迷 提示框

			addChild(_enthrall);
			
			/* 文本提示框 ******************************************/
			_info = new TimeAccect();
			_info.info_txt.selectable = false;
			_info.info_txt.mouseEnabled = false;
			_info.visible = false;
			_info.info_txt.text = ""; //计时器 初始化
			_info.x = 25;
			_info.y = 35;
			addChild(_info);
			//**********************************************
			
			addEvent();
		}
		
		private function addEvent():void
		{
			_enthrall.addEventListener(MouseEvent.MOUSE_OVER, __mouseOverHandler);
			_enthrall.addEventListener(MouseEvent.MOUSE_OUT,  __mouseOutHandler);
			TimeManager.addEventListener(TimeManager.CHANGE,  __changeHandler);
			_approveBtn.addEventListener(MouseEvent.CLICK,popFrame);
		}
		
		private function popFrame(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			_manager.showCIDCheckerFrame();
		}
		
		public function update():void
		{
			upGameTimeStatus();
		}
		
		private function __changeHandler(evt : Event) : void
		{
			upGameTimeStatus();
		}
		private function __mouseOverHandler(evt : MouseEvent) : void
		{
			upGameTimeStatus();
			_info.visible = true;
		}
		private function upGameTimeStatus() : void
		{
			var time  : Number = TimeManager.Instance.totalGameTime;
            _info.info_txt.text = getTimeTxt(time);
            setViewState(time);
		}
		private function getTimeTxt(time : Number) : String
		{
			var hours : Number = Math.floor(time/60);
			var min   : Number = Math.floor(time % 60);
			var str   : String = (min < 10 ?  (hours + ":0" +  min) : (hours + ":" +  min)) + " / 5:00";
			return str;
			
		}
		private function __mouseOutHandler(evt : MouseEvent) : void
		{
			 _info.info_txt.text = ""; //联调测试
			 setViewState(TimeManager.Instance.totalGameTime);
            _info.visible = false;
		}
		
		private function setViewState(time : Number):void
		{
			var minute : Number = Math.floor(time);

			/* 根据$state设置显示样式 */

			if(minute < 180)

			{
				_enthrall.light_mc.gotoAndStop(1);
				_enthrall.bg_mc.gotoAndStop(1);
//				_enthrall.light_btn.gotoAndStop(1);
			}

			else if(minute < 300)

			{
				_enthrall.light_mc.gotoAndStop(2);
				_enthrall.bg_mc.gotoAndStop(2);
//				_enthrall.light_btn.gotoAndStop(2);
			}

			else if(minute > 300)

			{
				_enthrall.light_mc.gotoAndStop(3);
				_enthrall.bg_mc.gotoAndStop(3);
//				_enthrall.light_btn.gotoAndStop(3);
			}
		}
		
		public function show(view:EnthrallView):void
		{
			TipManager.AddToLayerNoClear(view);
			setViewState(TimeManager.Instance.totalGameTime);
		}
		
		public function changeBtn(showBtn:Boolean):void
		{
			_approveBtn.visible = showBtn;
		}
		
		public function changeToGameState(flag:Boolean):void
		{
			_enthrall.light_mc.visible = flag;
	    	_enthrall.bg_mc.visible = !flag;
    		_enthrall.bg_pic.visible = !flag;
		}
		
		public function dispose() : void
		{
			this.removeChild(_enthrall);
			this.removeChild(_info);
			TimeManager.removeEventListener(TimeManager.CHANGE,  __changeHandler);
			_enthrall.removeEventListener(MouseEvent.MOUSE_OVER, __mouseOverHandler);
			_enthrall.removeEventListener(MouseEvent.MOUSE_OUT,  __mouseOutHandler);
			_approveBtn.removeEventListener(MouseEvent.CLICK,popFrame);
		}
		
		public function get enthrall():EnthrallViewAccect
		{
			return _enthrall;
		}
	}
}