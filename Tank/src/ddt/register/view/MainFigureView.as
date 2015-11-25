package ddt.register.view
{
	import choicefigure.view.MainFigureAsset;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import ddt.register.request.LoadCheckName;
	import ddt.register.tween.Spring;
	import ddt.register.view.part.*;

	public class MainFigureView extends MainFigureAsset
	{
		public static const CHECKREPEAT:String = "check_Repeat";// 重名检测事件
		public static const ANIMATION_OUT_COMPLETE:String = "animationOutComplete";// 进入游戏事件
		public static const ANIMATION_IN_COMPLETE:String = "animationInComplete";
		public static const TRY_ENTER_GAME:String = "tryEnterGame";
		
		private var _figure:FigureView;
		private var _girl:GirlView;
		private var _boy:BoyView;
		
		private var _spring:Spring;
		
		private var _username:String;
		private var _password:String;
		public function MainFigureView(username:String,password:String)
		{
			super();
			_username = username;
			_password = password;
			initialize();
			initEvent();
		}
		
		protected function initialize():void
		{
			this.x = -300;
			this.y = -300;
			showFigureView();
			//根据代理商提供过来的数据接口，如有男女性别区分，我们在角色性别选择那提供类试的接口，
			//平台传过来为男性信息，我们注册角色默认为男，是女的默认为女
//			getAgentsSex();
		}
		
		protected function initEvent():void
		{
			addEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);
		}
		
		protected function removeEvent():void
		{
			if(_figure)
			{
				_figure.removeEventListener(FigureView.SEXCHANGE, __sexChangeHandler);
				_figure.removeEventListener(FigureView.EnterGame, __enterGameHandler);
				_figure.removeEventListener(FigureView.CheckRepeat, __checkRepeatHandler);
			}
			if(_girl)
				_girl.removeEventListener(Event.COMPLETE, __checkSexHandler);
			if(_boy)
				_boy.removeEventListener(Event.COMPLETE, __checkSexHandler);
		}
		
		private function __addToStageHandler(e:Event):void
		{
			getAgentsSex();
		}

		private function showFigureView():void
		{
			_figure = new FigureView();
			_figure.addEventListener(FigureView.SEXCHANGE, __sexChangeHandler);
			_figure.addEventListener(FigureView.EnterGame, __enterGameHandler);
			_figure.addEventListener(FigureView.CheckRepeat, __checkRepeatHandler);
			
			figure_pos.addChild(_figure);
			
			_spring = new Spring(figure_pos,new Point(figure_pos.x, figure_pos.y));
			_spring.addEventListener(Event.CLOSE, __hideHandler);
			_spring.addEventListener(Event.COMPLETE, __animationIntroComplete);
			_spring.start();
			
			figure_pos.y = -200;
			
			_girl = new GirlView();
			_girl.addEventListener(Event.COMPLETE, __checkSexHandler);
			girl_pos.addChild(_girl);
			
			_boy = new BoyView();
			_boy.addEventListener(Event.COMPLETE, __checkSexHandler);
			boy_pos.addChild(_boy);
			
			_girl.show();
			
//			SoundManager.instance.play("001");
		}
		
		private function getAgentsSex():void
		{
			var sex:int;
			if(stage)
				sex = int(stage.loaderInfo.parameters["sex"]);
			// 1为男，2为女
			if(sex == 1)
				_figure.Sex = true;
			else if(sex == 2)
				_figure.Sex = false;
		}
		
		private function __hideHandler(e:Event):void
		{
			if(_spring)
			{
				_spring.removeEventListener(Event.CLOSE, __hideHandler);
				_spring.dispose();
			}
			_spring = null;
			dispatchEvent(new Event(ANIMATION_OUT_COMPLETE));
		}
		
		private function __animationIntroComplete(event:Event):void
		{
			if(_spring)
			{
				_spring.removeEventListener(Event.COMPLETE, __animationIntroComplete);
			}
			dispatchEvent(new Event(ANIMATION_IN_COMPLETE));
			_figure.animationInComplete = true;
		}
		
		private var timeh:int = 0;
		private function __checkSexHandler(e:Event):void
		{
			
			if(timeh != 0)
			{
				clearTimeout(timeh);
				timeh = 0;
			}
			timeh = setTimeout(showFigure, 500);
		}
		
		private function __sexChangeHandler(e:Event):void
		{
			RegisterSoundManager.instance.play("005");
			showFigure();
		}
		
		private function showFigure():void
		{
			if(_figure.GirlSelected)
			{
				_girl.show();
				_boy.hide();
			}
			else if(_figure.BoySelected)
			{
				_girl.hide();
				_boy.show();
			}
		}
		
		public function get TipText():String
		{
			return _figure.TipText;
		}
		// 检测提示
		public function set TipText(value:String):void
		{
			_figure.TipText = value;
		}
		
		//false 为girl, true 为boy
		public function get Sex():Boolean
		{
			return _figure.Sex;
		}
		// 选择角色女时为true
		public function get GirlSelected():Boolean
		{
			return _figure.GirlSelected;
		}
		// 选择角色男时为true
		public function get BoySelected():Boolean
		{
			return _figure.BoySelected;
		}
		
		public function get Nickname():String
		{
			return _figure.Nickname;
		}
		
		// 进入游戏
		private function __enterGameHandler(e:Event):void
		{
			RegisterSoundManager.instance.play("003");
			dispatchEvent(new Event(TRY_ENTER_GAME));
		}
		
		// 重名检测
		private function __checkRepeatHandler(e:Event):void
		{
			RegisterSoundManager.instance.play("003");
			new LoadCheckName(_figure.Nickname).loadSync(setCheckTxt);
		}
		
		public function setCheckTxt(loader:LoadCheckName):void
		{
			_figure.TipText = loader.message;
			if(loader.isSuccess)
			{
				_figure.texttip.textColor = 0xAEFF00;
			}
			else
			{
				_figure.texttip.textColor = 0xFF4800;
			}
		}
		
		public function AnimateHide():void
		{
			if(_spring)
				_spring.hide();
			if(_girl)
				_girl.hideAndStop();
			if(_boy)
				_boy.hideAndStop();
		}
		
		public function doHideAnimation():void
		{
			if(_spring)
			{
				_spring.hide();
				if(_figure.GirlSelected)
				{
					_girl.hideAndStop();
				}else{
					_boy.hideAndStop();
				}
	//			SoundManager.instance.play("002");
//				AnimateHide();
			}
		}
		
		public function setFoucs():void
		{
			_figure.setFocus();
		}
		
		public function dispose():void
		{
			removeEvent();
			
			if(_figure)
				_figure.dispose();
			_figure = null;
			
			if(_girl)
				_girl.dispose();
			_girl = null;
			
			if(_boy)
				_boy.dispose();
			_boy = null;
			
			if(_spring)
			{
				_spring.removeEventListener(Event.CLOSE, __hideHandler);
				_spring.dispose()
			}
			_spring = null;
			
			if(parent)
				parent.removeChild(this);
		}
	}
}