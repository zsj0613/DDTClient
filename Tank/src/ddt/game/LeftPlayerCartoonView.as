package ddt.game
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import game.crazyTank.view.LeftPlayerCiteAssetII;
	
	import org.aswing.KeyStroke;
	import org.aswing.KeyboardManager;
	
	import road.manager.SoundManager;
	import road.ui.manager.TipManager;
	
	import ddt.data.game.Living;
	import ddt.data.game.LocalPlayer;
	import ddt.data.game.Player;
	import ddt.data.game.TurnedLiving;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.events.LivingEvent;
//	import ddt.gametrainer.TrainerTurnManager;
	import ddt.manager.GameManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.RoomManager;
	import ddt.view.common.RoomIIPropTip;

	public class LeftPlayerCartoonView extends LeftPlayerCiteAssetII
	{
		private var _info:Living;
		
		private var _recordInfo:Player;
		
		private var _body:DisplayObject;
		
		private var _countDown:CountDownView;
		
		private var _grid:PlayerStateContainer;
		
		private var _isClose : Boolean = false;
		
		public static const SHOW_BITMAP_WIDTH:int = 120;
		public static const SHOW_BITMAP_HEIGHT:int = 200;
		
		public function set isClose(b : Boolean) : void
		{
			_isClose = b;
		}
		
		public function get usedProp():PlayerStateContainer
		{
			return _grid;
		}
		
		public function LeftPlayerCartoonView()
		{
			initView();
		}
		
		private function initView():void
		{
			gotoAndStop(1);
			leftCite.skip_btn.addEventListener(MouseEvent.CLICK,__skip);
			leftCite.skip_btn.addEventListener(MouseEvent.MOUSE_OVER,__over);
			leftCite.skip_btn.addEventListener(MouseEvent.MOUSE_OUT,__out);
			_grid = new PlayerStateContainer(12);
			_grid.setSize(600,200);
			_grid.x = 210;// 664;
			_grid.y = 495;//465;
			leftCite.addChild(_grid);
		
			var time:int = 0;
			if(RoomManager.Instance.current.timeType == 1)time = 6;
			if(RoomManager.Instance.current.timeType == 2)time = 8;
			if(RoomManager.Instance.current.timeType == 3)time = 11;
			if(RoomManager.Instance.current.timeType == 4)time = 16;
			if(RoomManager.Instance.current.timeType == 5)time = 21;
			if(RoomManager.Instance.current.timeType == 6)time = 31;
			//*****************************************************
			_countDown = new CountDownView(time);
			_countDown.x = 154;
			_countDown.y = 75;
			_countDown.addEventListener(Event.COMPLETE,__skip);
			addChild(_countDown);
			update();
			KeyboardManager.getInstance().registerKeyAction(KeyStroke.VK_P,__skip);	
			addEventListener(Event.ENTER_FRAME,__frameFunctionHandler);
		}
		
		private function __frameFunctionHandler(event:Event):void
		{
			if(currentFrame == 7)
			{
				frameEasingIn();
			}
			if(currentFrame == (totalFrames - 1))
			{
				frameEasingOut();
			}
		}

		public function set info(living:Living):void
		{
			_grid.clearItems();
			updateTimerState(false,false);
			
			var needEasingOut:Boolean = _info != null;
			if(_info != living)
			{
				if(_info)
				{
					if(_info.isSelf)
					{
						_info.removeEventListener(LivingEvent.BEGIN_SHOOT,__stopCountDown);
						_info.removeEventListener(LivingEvent.ATTACKING_CHANGED,__isAttackingChanged);
					}
					_grid.info = null;
				}
				_info = living;
				if(_info)
				{
					if(_info.isSelf && !_isClose)
					{
						_info.addEventListener(LivingEvent.BEGIN_SHOOT,__stopCountDown);
						_info.addEventListener(LivingEvent.ATTACKING_CHANGED,__isAttackingChanged);
					}
					//else if(_isClose && TrainerTurnManager.isRegister)
					////{
					//	_info.addEventListener(LivingEvent.BEGIN_SHOOT,__stopCountDown);
					//	_info.addEventListener(LivingEvent.ATTACKING_CHANGED,__isAttackingChanged);
					//}
					else
					{
						if(_info is TurnedLiving)_grid.info = _info as TurnedLiving;
					}
				}
			}
			if(needEasingOut)
			{
				easingOut();
			}
			else
			{
				easingIn();
			}
		}
		
		public function get info():Living
		{
			return _info;
		}
		
		protected function update():void
		{
			if(_info)
			{
				leftCite.honorName_txt.text = "";
				if(	_info.isSelf)
				{
					(_info as LocalPlayer).shootTime = 0;
				}
				if(_info.isPlayer())
				{		
					if(_info.playerInfo)
					{
						if(RoomManager.Instance.current.allowCrossZone && _info.team!= GameManager.Instance.Current.selfGamePlayer.team)
						{
							leftCite.nickName_txt.text = "";
							leftCite.nickName_txt.htmlText ="<p>"+ _info.playerInfo.NickName + "</p>";
							leftCite.zoneName_txt.htmlText = "<p>"+ "<FONT FACE='宋体' COLOR='#ffd200' SIZE='12'>&lt;"+(_info as Player).zoneName+"&gt;</FONT></p>";
						}else
						{
							leftCite.nickName_txt.text = _info.playerInfo.NickName;
							leftCite.zoneName_txt.htmlText = "";
						}
						showHonorName();
					}	
					_grid.visible = !_info.isSelf;
					_info.character.showGun = false;
					_info.character.setShowLight(true,_showLightPoint);
					setBodyBitmap(_info.character.getShowBitmapBig(), true);
				}else
				{
					leftCite.nickName_txt.x = leftCite.honorName_txt.x;
					leftCite.nickName_txt.y = leftCite.honorName_txt.y + 3;
					leftCite.nickName_txt.text = _info.name;
					setBodyBitmap(_info.actionMovieBitmap);
				}
				leftCite.team_mc.gotoAndStop(_info.team);
			}
			else
			{
				setBodyBitmap(null);
				leftCite.nickName_txt.text = "";
			}
		}
		
		private function showHonorName():void
		{
			if(_info.playerInfo.honor == "" || !_info.playerInfo.honor)
			{
				leftCite.honorName_txt.text = "";
				leftCite.nickName_txt.x = leftCite.honorName_txt.x;
				leftCite.nickName_txt.y = leftCite.honorName_txt.y + 3;
			}else
			{
				leftCite.honorName_txt.text = _info.playerInfo.honor;
				leftCite.nickName_txt.x = leftCite.honorName_txt.x + leftCite.honorName_txt.width;
			}
		}
		
		private function setBodyBitmap(value:DisplayObject, isPlayer:Boolean = false):void
		{
			if(_body != value)
			{
				if(_body && _body.parent)
				{
					leftCite.body_mc.removeChild(_body);
				}
				_body = value;
				
				if(_body)
				{
					if(isPlayer)
					{
						_body.scaleX = -1;
					}
					else
					{
						if(_body.height > 120)
						{
							_body.x = 10;
							_body.y = 35 - _body.height + 115;
						}
						else
						{
							_body.x = 80 - _body.width*0.5;
							_body.y = 85 - _body.height*0.5;
						}
					}
					leftCite.body_mc.addChild(_body);
				}
			}
		}
		private var _showLightPoint : Point = new Point(0,2);
		
		private function easingIn():void
		{
			update();
			gotoAndPlay(1);
		}
		
		private function easingOut():void
		{
			gotoAndPlay(8);
		}
		
		private function frameEasingIn():void
		{
			stop();
		}
		
		private function frameEasingOut():void
		{
			if(_info)
			{
				easingIn();
			}
			else
			{
				stop();
			}
		}
		
	
		public function updateTimerState(visible:Boolean,enabled:Boolean):void
		{
			if(visible)
			{
				
				if(_info && _info.isSelf)
				{
					
					leftCite.skipUnabled_btn.visible = !enabled;
					leftCite.skip_btn.visible = enabled;
					_countDown.visible = true;
				}else
				{
					
					leftCite.skipUnabled_btn.visible = false;
					leftCite.skip_btn.visible = false;
					_countDown.stopCountDown();
					_countDown.visible = false;
				}	
				if(!enabled)
				{
					_countDown.stopCountDown();
				}
			}
			else
			{
				leftCite.skipUnabled_btn.visible = false;
				leftCite.skip_btn.visible = false;
				_countDown.stopCountDown();
				_countDown.visible = false;
			}
		}
		
		private function __isAttackingChanged(event:LivingEvent):void
		{
			if( (_info as TurnedLiving).isAttacking)
			{
				updateTimerState(true,true);
				if(_info.isSelf)
				{
					_countDown.startCountDown();
				}
			}
			else
			{
				updateTimerState(true,false);
			}
		}
		
		private function __stopCountDown(event:LivingEvent):void
		{
			if(_countDown)
			{
				updateTimerState(true,false);
			}
		}
		
		private function __skip(event:Event = null):void
		{
			if(_info && _info.isSelf && leftCite.skip_btn.visible )
			{
				SoundManager.instance.play("008");
				skip();
			}
		}
		
		public function skip():void
		{
			updateTimerState(true,false);
			(_info as LocalPlayer).skip();
		}
		
		private var _skipTip:RoomIIPropTip;
		private function __over(e:MouseEvent):void
		{
			var itemTempleteInfo:ItemTemplateInfo = new ItemTemplateInfo();
			itemTempleteInfo.Name = LanguageMgr.GetTranslation("ddt.game.LeftPlayerCartoonView.Name");
			//itemTempleteInfo.Name = "蓄力，快捷键[P]";
			itemTempleteInfo.Description = LanguageMgr.GetTranslation("ddt.game.LeftPlayerCartoonView.Description");
			//itemTempleteInfo.Description = "跳过一轮攻击，并积攒一定的怒气值。";
			_skipTip = new RoomIIPropTip(false,false,false);
			_skipTip.update(itemTempleteInfo,1);
			
			var skip_pos:Point = this.localToGlobal(new Point(e.currentTarget.x,e.currentTarget.y));
			_skipTip.x = skip_pos.x + leftCite.skip_btn.width + 6;
			_skipTip.y = skip_pos.y - e.currentTarget.height;
			TipManager.AddTippanel(_skipTip);
		}
		
		private function __out(e:MouseEvent):void
		{
			TipManager.RemoveTippanel(_skipTip);
		}
		
		public function gameOver():void
		{
			info = null;
			_countDown.visible = false;
		}
		
		public function dispose():void
		{
			if(_info)
			{
				_info.removeEventListener(LivingEvent.BEGIN_SHOOT,__stopCountDown);
				_info.removeEventListener(LivingEvent.ATTACKING_CHANGED,__isAttackingChanged);
			}
			_info = null;
			if(_grid)
			{
				if(_grid.parent) _grid.parent.removeChild(_grid);
				_grid.dispose();
				_grid = null;
			}
			gotoAndStop(1);
			_showLightPoint = null;
			
			leftCite.skip_btn.removeEventListener(MouseEvent.CLICK,__skip);
			leftCite.skip_btn.removeEventListener(MouseEvent.MOUSE_OVER,__over);
			leftCite.skip_btn.removeEventListener(MouseEvent.MOUSE_OUT,__out);
			KeyboardManager.getInstance().unregisterKeyAction(KeyStroke.VK_P,__skip);
			removeEventListener(Event.ENTER_FRAME,__frameFunctionHandler);
			_countDown.stopCountDown();
			_countDown.removeEventListener(Event.COMPLETE,__skip);
			_countDown.dispose();
			_countDown = null;
			if(parent)
			{
				parent.removeChild(this);
			}
		}
	}
}