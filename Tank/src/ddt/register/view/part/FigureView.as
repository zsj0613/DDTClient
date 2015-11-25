package ddt.register.view.part
{
	import choicefigure.view.*;
	
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.*;
	
	import ddt.register.view.RegisterSoundManager;

	public class FigureView extends SelectFigureAsset
	{
		public static const EnterGame:String = "enterGame";
		public static const CheckRepeat:String = "checkRepeat";
		public static const SEXCHANGE:String = "sexChange";
		public static const MAX_INPUT:int	 = 14;
		
		protected var sex:Boolean = false;//false 为girl, true 为boy
		
		private var myColorMatrix_filter:ColorMatrixFilter;
		
		public function FigureView()
		{
			super();
			initialize();
			initEvent();
		}
		
		protected function initialize():void
		{
			Sex = false;
			
			var myElements_array:Array = [0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0];
			myColorMatrix_filter = new ColorMatrixFilter(myElements_array);
			
			girl_mc.girl_btn.visible = true;
			boy_mc.boy_btn.visible = true;
			nickname.maxChars      = MAX_INPUT;
			setButtonEnable(checkrepeat_btn,false);
			setButtonEnable(entergame_btn,false);
			
			RegisterSoundManager.instance.playMusic("fin");
		}
		
		protected function initEvent():void
		{
			nickname.addEventListener(KeyboardEvent.KEY_UP, __keyupHandler);
			
			girl_mc.girl_btn.addEventListener(MouseEvent.CLICK, __girlClickHandler);
			boy_mc.boy_btn.addEventListener(MouseEvent.CLICK, __boyClickHandler);
			
//			checkrepeat_btn.addEventListener(MouseEvent.CLICK, __checkRepeatClickHandler);
//			entergame_btn.addEventListener(MouseEvent.CLICK, __enterGameClickHandler);
		}
		
		protected function removeEvent():void
		{
			nickname.removeEventListener(KeyboardEvent.KEY_UP, __keyupHandler);
			
			girl_mc.girl_btn.removeEventListener(MouseEvent.CLICK, __girlClickHandler);
			boy_mc.boy_btn.removeEventListener(MouseEvent.CLICK, __boyClickHandler);
			
			checkrepeat_btn.removeEventListener(MouseEvent.CLICK, __checkRepeatClickHandler);
			entergame_btn.removeEventListener(MouseEvent.CLICK, __enterGameClickHandler);
		}
		
		public var _hasNickName:Boolean = false;
		public function get hasNickName():Boolean
		{
			return _hasNickName;
		}
		public function set hasNickName(val:Boolean):void
		{
			if(_hasNickName == val)
				return;
			_hasNickName = val;
			trySetEnterGameBtnEnable();
		}
		public var _animationInComplete:Boolean = false;
		public function get animationInComplete():Boolean
		{
			return _animationInComplete;
		}
		public function set animationInComplete(val:Boolean):void
		{
			if(_animationInComplete == val)
				return;
			_animationInComplete = val;
			trySetEnterGameBtnEnable();
		}
		
		private function __keyupHandler(e:KeyboardEvent):void
		{
			var txt:String = nickname.text;
			txt = txt.replace(/(^\s*)|(\s*$)/g,"");
			if(txt == "")
			{
				setButtonEnable(checkrepeat_btn,false);
				checkrepeat_btn.removeEventListener(MouseEvent.CLICK, __checkRepeatClickHandler);
				hasNickName = false;
			}
			else
			{
				setButtonEnable(checkrepeat_btn,true);
				checkrepeat_btn.addEventListener(MouseEvent.CLICK, __checkRepeatClickHandler);
				hasNickName = true;
			}
		}
		
		private function trySetEnterGameBtnEnable():void
		{
			if(hasNickName && animationInComplete)
			{
				setButtonEnable(entergame_btn,true);
				entergame_btn.addEventListener(MouseEvent.CLICK, __enterGameClickHandler);
			}
			else
			{
				setButtonEnable(entergame_btn,false);
				entergame_btn.removeEventListener(MouseEvent.CLICK, __enterGameClickHandler);
			}
		}
		
		private function setButtonEnable(btn:SimpleButton, enable:Boolean):void
		{
			btn.enabled = enable;
			if(enable)
			{
				btn.filters = null;
			}
			else
			{
				btn.filters = [myColorMatrix_filter];
			}
		}
		
		// 选择女角色
		private function __girlClickHandler(e:MouseEvent):void
		{
			Sex = false;
		}
		// 选择男角色
		private function __boyClickHandler(e:MouseEvent):void
		{
			Sex = true;
		}
		// 重名检测
		private function __checkRepeatClickHandler(e:MouseEvent):void
		{
			dispatchEvent(new Event(CheckRepeat));
		}
		// 进入游戏
		private function __enterGameClickHandler(e:MouseEvent):void
		{
			dispatchEvent(new Event(EnterGame));
		}
		
		public function set Sex(value:Boolean):void
		{
			sex = value;
			
			if(sex)
			{
				girl_mc.gotoAndStop(2);
				boy_mc.gotoAndStop(1);
			}
			else
			{
				girl_mc.gotoAndStop(1);
				boy_mc.gotoAndStop(2);
			}
			
			dispatchEvent(new Event(SEXCHANGE));
		}
			
		public function get GirlSelected():Boolean
		{
			return (!sex);
		}
		
		public function get BoySelected():Boolean
		{
			return sex;
		}
		
		public function get Sex():Boolean
		{
			return sex;
		}
		
		public function get Nickname():String
		{
			return nickname.text;
		}
		// 昵称
		public function set Nickname(value:String):void
		{
			nickname.text = value;
		}
		
		public function get TipText():String
		{
			return texttip.text;
		}
		
		public function set TipText(value:String):void
		{
			texttip.htmlText = "<B>"+value+"</B>";
//			texttip.text = value;
		}
		
		public function setFocus():void
		{
			stage.focus = nickname;
		}
		
		public function dispose():void
		{
			removeEvent();
			
			if(parent)
				parent.removeChild(this);
		}
	}
}