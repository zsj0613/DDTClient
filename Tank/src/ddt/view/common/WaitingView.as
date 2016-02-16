package ddt.view.common
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.common.WaitingTipAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HTipButton;
	import road.ui.manager.TipManager;
	import road.ui.manager.UIManager;
	
	import ddt.manager.PlayerManager;
	import ddt.manager.StateManager;
	import ddt.states.StateType;
	public class WaitingView extends WaitingTipAsset
	{
		
		public static const LOAD:int = 1;
		public static const LOGIN:int = 2;
		public static const DEFAULT:int = 3;
				
		public static const WAITING_CANCEL:String = "waitingcancel";
		
//		private var _bg:HFrame;
//		private var _cancelBtn:HLabelButton;   bret 09.9.23
		private var _closeBtn:HTipButton;
		private static var _instance:WaitingView;
		private var _cancelable:Boolean;
		public function WaitingView()
		{
			super();
			init();
		}
		
		private function init():void
		{
			
/* 			_bg = new HFrame();
			_bg.setSize(427,202);
			_bg.moveEnable = false;
			_bg.showBottom = false;
			addChildAt(_bg,0);
			_bg.closeCallBack = __mouseClick;  */ //bret 09.9.23
			
			
//			_cancelBtn = new HLabelButton();
//			_cancelBtn.x = 305;
//			_cancelBtn.y = 198;
//			_cancelBtn.label = LanguageMgr.GetTranslation("cancel");
//			addChild(_cancelBtn);
//			_cancelBtn.addEventListener(MouseEvent.CLICK,__mouseClick);  bret 09.9.23
//			_cancelBtn.visible = false;
			//不可选
			percent_txt.selectable = false;
			//关闭按钮 
			_closeBtn   = new HTipButton(this.closeButton,'','关闭');
			_closeBtn.useBackgoundPos = true;
			addChild(_closeBtn);
			_closeBtn.addEventListener(MouseEvent.CLICK,__closeClick);
			_cancelable = true;
			cancel_btn.visible = false;
//			cancel_btn.addEventListener(MouseEvent.CLICK,__mouseClick);  bret 09.9.23
			state_mc.play();
		}
		
		
		
		private function __mouseClick(/*evt:MouseEvent*/):void
		{
			if(_cancelable)
			{
				hide();
				SoundManager.Instance.play("008");
			}
			dispatchEvent(new Event(WAITING_CANCEL));
		}
		private function __closeClick(e:MouseEvent):void
		{
			SoundManager.Instance.play("008");
            __mouseClick();
        }
		public function set percent(p:Number):void
		{
			percent_txt.text = String(p) + "%";
		}
		
		public static function get instance():WaitingView
		{
			if(_instance == null)
			{
				_instance = new WaitingView();
				UIManager.setChildCenter(instance);
			}
			return _instance;
		}
		
		public function show(state:int = 1,content:String = "",cancelable:Boolean = true):void
		{
			this.graphics.clear();
			hide();
			checkShowCancel();
			_cancelable = cancelable;
			if(_closeBtn)_closeBtn.visible = cancelable;
			content_txt.text = content ? content : "";
			content_txt.visible = false; //bret 09.9.23
			percent_txt.text = "";
			TipManager.AddToLayerNoClear(instance,true);
			drawBlackGound();
		}
		private function drawBlackGound() : void
		{
			this.graphics.clear();
			this.graphics.beginFill(0x000000,.7);
			this.graphics.drawRect(-3000,-3000,6000,6000);
			this.graphics.endFill();
		}
		
		private function checkShowCancel ():void
		{		
			if(StateManager.currentStateType == StateType.LODING_TRAINER)
			{
				_closeBtn.visible = false; 
			}
			else
			{
				_closeBtn.visible = true; 
			}
		}
		
		public function hide():void
		{
			    if(instance.parent)
				instance.parent.removeChild(instance);    
		}
		
		public function dispose():void
		{
			if(_closeBtn)
			{
                _closeBtn.removeEventListener(MouseEvent.CLICK, __closeClick);
                _closeBtn.dispose();
			};
			_closeBtn = null; 
			if(instance.parent)
				instance.parent.removeChild(instance);
		}
	}
}