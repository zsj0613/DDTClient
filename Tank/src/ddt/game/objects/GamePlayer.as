package ddt.game.objects
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ddt.command.PlayerAction;
	import ddt.data.game.Player;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.events.LivingEvent;
	import ddt.game.AutoPropEffect;
	import ddt.game.actions.GhostMoveAction;
	import ddt.game.actions.PlayerBeatAction;
	import ddt.game.actions.PlayerFallingAction;
	import ddt.game.actions.PlayerWalkAction;
	import ddt.game.actions.PrepareShootAction;
	import ddt.game.actions.ShootBombAction;
	import ddt.game.player.ConsortiaNameView;
	import ddt.game.smallmap.SmallMapPlayer;
	import ddt.manager.ChatManager;
	import ddt.manager.GameManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.manager.QueueManager;
	import ddt.utils.Helpers;
	import ddt.view.characterII.GameCharacter;
	import ddt.view.characterII.ShowCharacter;
	import ddt.view.chatsystem.ChatData;
	import ddt.view.chatsystem.ChatEvent;
	import ddt.view.common.ChatBallView;
	import ddt.view.common.ConsortiaIcon;
	import ddt.view.common.FaceContainer;
	import ddt.view.common.LevelIcon;
	import ddt.view.common.VIPLiteIcon;
	import ddt.view.items.PropItemView;
	
	import game.crazyTank.view.AttackCiteAsset;
	import game.crazyTank.view.EatPropAsset;
	import game.crazyTank.view.SpecialSkillAsset;
	
	import phy.maps.Map;
	import phy.object.PhysicalObj;
	
	import road.display.MovieClipWrapper;
	import road.manager.SoundManager;

	public class GamePlayer extends GameTurnedLiving
	{
		/**
		 * 人物容器
		 */
		protected var _player:Sprite;

		/**
		 * 当前人物提示
		 */
		protected var _attackPlayerCite:AttackCiteAsset;

		private var _levelIcon:LevelIcon;
		/**
		 * 公会名称
		 */
		protected var _consortiaName:ConsortiaNameView;

		/**
		 * 工会图标
		 * */
		private var _cIcon:ConsortiaIcon;
		/**
		 * 表情
		 */
		private var _facecontainer:FaceContainer;

		private var _ballpos:Point;
		
		private var _vipIcon:VIPLiteIcon;



		public function GamePlayer(player:Player, character:ShowCharacter, movie:GameCharacter=null)
		{
			_character=character;
			_body=movie;
			super(player);
			_ballpos=new Point(30, -20);
		}

		override protected function initView():void
		{
			super.initView();
			_player=new Sprite();
			_player.y=-3;
			addChild(_player);
			_nickName.x=-19;
			_body.x=0;
			_body.doAction(GameCharacter.STAND);
			_player.addChild(_body as DisplayObject);
			_chatballview=new ChatBallView();

			_attackPlayerCite=new AttackCiteAsset();
			_attackPlayerCite.y=-75;
			if (player.isAttacking)
			{
				_attackPlayerCite.gotoAndStop(_info.team);
				_attackPlayerCite.visible=true;
			}
			else
			{
				_attackPlayerCite.visible=false;
			}
			addChild(_attackPlayerCite);


			_levelIcon=new LevelIcon("s", player.playerInfo.Grade, player.playerInfo.Repute, player.playerInfo.WinCount, player.playerInfo.TotalCount, player.playerInfo.FightPower, false);

			_levelIcon.x=-53;
			_levelIcon.y=28 - _levelIcon.height / 2 + 5;

			_levelIcon.stop();
			addChild(_levelIcon);
			
			_vipIcon = new VIPLiteIcon(player.playerInfo);
			_vipIcon.x=-53;
			_vipIcon.y=28 + _vipIcon.height / 2 + 5;
			addChild(_vipIcon);
			
			
			
			
			
			
			
			
			if (player.playerInfo.ConsortiaName)
			{
				_consortiaName=new ConsortiaNameView(player.playerInfo);
				_consortiaName.x=_nickName.x;
				_consortiaName.y=_nickName.y + _nickName.height / 2 + 5;
				addChild(_consortiaName);
				if (_consortiaName.isShowIcon)
				{
					_cIcon=new ConsortiaIcon(player.playerInfo.ConsortiaID, "small", true);
					_levelIcon.visible=false;
					addChild(_cIcon);
					_cIcon.x=_levelIcon.x+(_levelIcon.width - _cIcon.width)*0.5-5;
					_cIcon.y=_levelIcon.y;
				}
			}
			/* facecontainer*/
			_facecontainer=new FaceContainer();
			addChild(_facecontainer);
			_facecontainer.y=-100;
			addWing();
			_propArray=new Array();
			__dirChanged(null);
		}
		

		override protected function initListener():void
		{
			super.initListener();
			player.addEventListener(LivingEvent.ADD_STATE, __addState);
			player.addEventListener(LivingEvent.POS_CHANGED, __posChanged);
			player.addEventListener(LivingEvent.USING_ITEM, __usingItem);
			player.addEventListener(LivingEvent.USING_SPECIAL_SKILL, __usingSpecialKill);
			player.addEventListener(LivingEvent.DANDER_CHANGED, __danderChanged);
			player.addEventListener(LivingEvent.PLAYER_MOVETO, __playerMoveTo);
			ChatManager.Instance.model.addEventListener(ChatEvent.ADD_CHAT, __getChat);
			ChatManager.Instance.addEventListener(ChatEvent.SHOW_FACE, __getFace);
			_info.addEventListener(LivingEvent.BOX_PICK, __boxPickHandler);
		}

		override protected function removeListener():void
		{
			super.removeListener();
			player.removeEventListener(LivingEvent.ADD_STATE, __addState);
			player.removeEventListener(LivingEvent.POS_CHANGED, __posChanged);
			player.removeEventListener(LivingEvent.USING_ITEM, __usingItem);
			player.removeEventListener(LivingEvent.USING_SPECIAL_SKILL, __usingSpecialKill);
			player.removeEventListener(LivingEvent.DANDER_CHANGED, __danderChanged);
			player.removeEventListener(LivingEvent.PLAYER_MOVETO, __playerMoveTo);
			if (_weaponMovie)
				_weaponMovie.addEventListener(Event.ENTER_FRAME, checkCurrentMovie);
			ChatManager.Instance.model.removeEventListener(ChatEvent.ADD_CHAT, __getChat);
			ChatManager.Instance.removeEventListener(ChatEvent.SHOW_FACE, __getFace);

			_info.removeEventListener(LivingEvent.BOX_PICK, __boxPickHandler);
		}
		
		override public function get movie():Sprite{
			return _player;
		}
		protected function __boxPickHandler(e:LivingEvent):void
		{
			if (PlayerManager.Instance.Self.FightBag.itemNumber > 3)
			{
//				ChatManager.Instance.sysChatRed(LanguageMgr.GetTranslation("ddt.game.gameplayer.proplist.full"));
			}
		}

		protected function __addState(event:LivingEvent):void
		{

		}

		private var _propArray:Array;

		protected function __usingItem(event:LivingEvent):void
		{
			if (event.paras[0] is ItemTemplateInfo)
			{
				var prop:ItemTemplateInfo=event.paras[0];
				_propArray.push(prop.Pic);
				doUseItemAnimation();
			}
			else if (event.paras[0] is DisplayObject)
			{
				_propArray.push(event.paras[0]);
				doUseItemAnimation();
			}

		}

		protected function __usingSpecialKill(event:LivingEvent):void
		{
			//特殊标示必杀技能
			_propArray.push("-1");
			doUseItemAnimation();
		}

		protected function doUseItemAnimation():void
		{
			var using:MovieClipWrapper=new MovieClipWrapper(new EatPropAsset(), true, false);
			using.addFrameScriptAt(12, headPropEffect);
			using.addEventListener(Event.COMPLETE, __usingAnimationComplete);
			SoundManager.Instance.play("039");
			using.x=0;
			using.y=-10;
			addChild(using);
			if (_isLiving)
				doAction(GameCharacter.HANDCLIP);
		}

		private function __usingAnimationComplete(e:Event):void
		{
			var mc:MovieClipWrapper=e.currentTarget as MovieClipWrapper;
			if (mc)
				mc.removeEventListener(Event.COMPLETE, __usingAnimationComplete);
			if (mc && mc.parent)
				mc.parent.removeChild(mc);
		}

		private function headPropEffect():void
		{
			var movie:DisplayObject;
			var head:AutoPropEffect;
			if (_propArray[0] is String)
			{
				var pic:String=_propArray.shift();
				if (pic == "-1")
				{
					movie=new SpecialSkillAsset();
				}
				else
				{
					movie=PropItemView.createView(pic, 62, 62);
				}
				head=new AutoPropEffect(movie);
				head.x=-5;
				head.y=-140;
			}
			else
			{
				movie=_propArray.shift() as DisplayObject;

				head=new AutoPropEffect(movie);
				head.x=5;
				head.y=-140;
			}

			addChild(head);
		}

		/**
		 * 怒气改变
		 */
		private var _danderFire:danderAsset;

		protected function __danderChanged(event:LivingEvent):void
		{
			if (player.dander >= Player.TOTAL_DANDER)
			{
				if (!_danderFire && _isLiving)
				{
					_danderFire=new danderAsset();
					_danderFire.x=3;
					_danderFire.y=_body.y + 5;
					_player.addChild(_danderFire);
				}
			}
			else
			{
				if (_danderFire)
				{
					_player.removeChild(_danderFire);
					_danderFire=null;
				}
			}
		}

		override protected function __posChanged(event:LivingEvent):void
		{
			pos=player.pos;
			if (_isLiving)
			{
				_player.rotation=calcObjectAngle();
				player.playerAngle=_player.rotation;
			}
			playerMove();
			if (map)
			{
				map.smallMap.updatePos(smallView, pos);
			}
		}


		/**
		 *捡箱子
		 *
		 */
		public function playerMove():void
		{
			if (!_isLiving)
			{
				var rect:Rectangle=getTestRect();
				rect.offset(x, y);
				var list:Array=_map.getBoxesByRect(rect);
				for each (var obj:SimpleBox in list)
				{
					_info.pick(obj.Id);
					obj.die();
				}
			}
		}


		/**
		 * 改变人物方向
		 * @param event
		 *
		 */
		override protected function __dirChanged(event:LivingEvent):void
		{
			_player.scaleX=-player.direction;
			if (_facecontainer)
			{
				_facecontainer.scaleX= 1;//-player.direction;
			}
			if (!player.isLiving)
			{
				setSoulPos();
			}
		}

		/**
		 * 攻击状态改变
		 * @param event
		 *
		 */
		override protected function __attackingChanged(event:LivingEvent):void
		{
			attackingViewChanged();
		}

		protected function attackingViewChanged():void
		{
			if (player.isAttacking && player.isLiving)
			{
				_attackPlayerCite.gotoAndStop(_info.team);
				_attackPlayerCite.visible=true;
			}
			else
			{
				_attackPlayerCite.visible=false;
			}
		}

		override protected function __hiddenChanged(event:LivingEvent):void
		{
			super.__hiddenChanged(event)
			if (_info.isHidden && _info.team != GameManager.Instance.Current.selfGamePlayer.team)
			{
				_nickName.visible=false;
				if(_chatballview)_chatballview.visible = false;
			}
			else
			{
				_nickName.visible=true;
			}
		}

		override protected function __say(event:LivingEvent):void
		{
			if (!_info.isHidden)
			{
//				var data:ChatMsg = event.paras[0] as ChatMsg;
				var data:String=event.paras[0];
				if (!_info.isLiving)
				{
					_chatballview.x=18;
					_chatballview.y=-20;
				}
				else
				{
					_chatballview.x=17;
					_chatballview.y=-40;
				}
				var type:int=0;
				if (event.paras[1])
					type=event.paras[1];
				if (type != 9)
					type=player.playerInfo.paopaoType; //9宝珠效果
				_chatballview.setText(data, type);
				addChild(_chatballview);
			}
		}

		override protected function __bloodChanged(event:LivingEvent):void
		{
			super.__bloodChanged(event);
			if (event.paras[0] != 0)
			{
				if (_isLiving)
					_body.doAction(GameCharacter.CRY);
			}
			_smallBlood.updateBlood(_info.blood);
		}

		public var isShootPrepared:Boolean;

		override protected function __shoot(event:LivingEvent):void
		{
			//开炮放在map中执行，在人物中执行会阻塞人物移动，特别是炸自己后的人物移动。
			var bombs:Array=event.paras[0];
			player.currentBomb=bombs[0].Template.ID;
			if (!isShootPrepared)
			{
				map.act(new PrepareShootAction(this));
			}
			map.act(new ShootBombAction(this, bombs, event.paras[1], Player.SHOOT_INTERVAL));
		}

		override protected function __beat(event:LivingEvent):void
		{
			act(new PlayerBeatAction(this));
		}

		protected function __playerMoveTo(event:LivingEvent):void
		{
			var type:int=event.paras[0];
			switch (type)
			{
				case 0:
					act(new PlayerWalkAction(this, event.paras[1], event.paras[2]));
					break;
				case 1:
					act(new PlayerFallingAction(this, event.paras[1], event.paras[3], false));
					break;
				case 2:
					act(new GhostMoveAction(this, event.paras[1]));
					break;
				case 3:
					act(new PlayerFallingAction(this, event.paras[1], event.paras[3], true));
					break;
			}
		}

		override protected function __fall(event:LivingEvent):void
		{
			act(new PlayerFallingAction(this, event.paras[0], true, false));
		}

		override protected function __moveTo(event:LivingEvent):void
		{
		}

		override protected function __jump(event:LivingEvent):void
		{
		}

		private function setSoulPos():void
		{
			if (_player.scaleX == -1)
			{
				_body.x=-6;
			}
			else
			{
				_body.x=-13;
			}
		}


		private var _character:ShowCharacter;

		public function get character():ShowCharacter
		{
			return _character;
		}

		private var _body:GameCharacter;

		public function get body():GameCharacter
		{
			return _body;
		}

		public function get player():Player
		{
			return info as Player
		}

		public function setWingRotation():void
		{
			if (_body.wing == null)
				return;
			_body.WingState=GameCharacter.GAME_WING_SHOT;
		}

		public function setWingNoRotation():void
		{
			if (_body.wing == null)
				return;
			_body.WingState=GameCharacter.GAME_WING_WAIT;
		}

		private function addWing():void
		{
			if (_body.wing == null)return;
			_body.setWingPos(_body.weaponX * _body.scaleX, _body.weaponY * _body.scaleY);
			_body.setWingScale(_body.scaleX, _body.scaleY);
			if (_body.leftWing && _body.leftWing.parent != _player)
			{
				_player.addChild(_body.rightWing);
				_player.addChildAt(_body.leftWing, 0);
			}
			_body.switchWingVisible(true);
			_body.WingState=GameCharacter.GAME_WING_WAIT;
		}

		private var _weaponMovie:MovieClip;

		public function get weaponMovie():MovieClip
		{
			return _weaponMovie;
		}

		/**
		 *
		 * @param 掏枪动画影片，包含各种炼化等级的掏枪动画
		 *
		 */
		public function set weaponMovie(value:MovieClip):void
		{
			if (value != _weaponMovie)
			{
				if (_weaponMovie && _weaponMovie.parent)
				{
					_weaponMovie.removeEventListener(Event.ENTER_FRAME, checkCurrentMovie);
					_weaponMovie.parent.removeChild(_weaponMovie);
				}
				_weaponMovie=value;
				_currentWeaponMovie=null;
				_currentWeaponMovieAction="";
				if (_weaponMovie)
				{
					_weaponMovie.stop();
					_weaponMovie.addEventListener(Event.ENTER_FRAME, checkCurrentMovie);
					_weaponMovie.x=_body.weaponX * _body.scaleX;
					_weaponMovie.y=_body.weaponY * _body.scaleY;
					_weaponMovie.scaleX=_body.scaleX;
					_weaponMovie.scaleY=_body.scaleY;
					_weaponMovie.visible=false;
					_player.addChild(_weaponMovie);
					if (_body.wing)
					{
						addWing();
					}
				}
			}
		}
		/**
		 *当前掏枪动画的影片 只有一个炼化等级的动画影片
		 */
		private var _currentWeaponMovie:MovieClip;

		private function checkCurrentMovie(e:Event):void
		{
			if (_weaponMovie == null)
				return;
			_currentWeaponMovie=_weaponMovie.getChildAt(0) as MovieClip;
			if (_currentWeaponMovie && _currentWeaponMovieAction != "")
			{
				_weaponMovie.removeEventListener(Event.ENTER_FRAME, checkCurrentMovie);
				setWeaponMoiveActionSyc(_currentWeaponMovieAction);
			}
		}

		/**
		 * 设置掏枪动画的播放状态，
		 * 采用异步设置的方式，因为此时可能影片还没有初始化
		 */
		private var _currentWeaponMovieAction:String="";

		public function setWeaponMoiveActionSyc(action:String):void
		{
			if (_currentWeaponMovie)
			{
				_currentWeaponMovie.gotoAndPlay(action);
			}
			else
			{
				_currentWeaponMovieAction=action;
			}
		}

		override public function die():void
		{
			super.die();
			player.isSpecialSkill=false;
			SoundManager.Instance.play("042");
			weaponMovie=null;
			_player.rotation=0;
			_player.y=25;
			_attackPlayerCite.visible=false;
			_smallBlood.visible=false;

			var tomb:TombView=new TombView();
			tomb.pos=this.pos;
			_map.addPhysical(tomb);
			tomb.startMoving();

			player.pos=new Point(x, y - 70);
			player.startMoving();
			doAction(GameCharacter.SOUL);
			setSoulPos();

			_map.setTopPhysical(this);
			if (_danderFire && _danderFire.parent)
			{
				_danderFire.parent.removeChild(_danderFire);
			}
			_danderFire=null;
		}

		override protected function __beginNewTurn(event:LivingEvent):void
		{
			super.__beginNewTurn(event);
			if (_isLiving)
			{
				_body.doAction(GameCharacter.STAND);
			}
			weaponMovie=null;
			isShootPrepared=false;
			_attackPlayerCite.visible=false;
		}

		private function __getChat(evt:ChatEvent):void
		{
			if (player.isHidden)
			{
				if (!player.isSelf)
					return;
			}
			var data:ChatData=ChatData(evt.data).clone();
			data.msg = Helpers.deCodeString(data.msg);
			if(data.channel == 2 || data.channel == 3){
				return;
			};
			_chatballview.x=17;
			_chatballview.y=-40;
			if(data.zoneID == -1)
			{
				if (data.senderID == player.playerInfo.ID)
				{
					if (!player.isLiving)
					{
						_chatballview.x=18;
						_chatballview.y=-20;
					}
					_chatballview.setText(data.msg, player.playerInfo.paopaoType);
					addChild(_chatballview);
				}
			}else
			{
				if (data.senderID == player.playerInfo.ID && data.zoneID == player.playerInfo.ZoneID)
				{
					if (!player.isLiving)
					{
						_chatballview.x=18;
						_chatballview.y=-20;
					}
					_chatballview.setText(data.msg, player.playerInfo.paopaoType);
					addChild(_chatballview);
				}
			}
		}

		private function __getFace(evt:ChatEvent):void
		{
			if (player.isHidden)
			{
				if (!player.isSelf)
					return;
			}
			var data:Object=evt.data;
			if (data["playerid"] == player.playerInfo.ID)
			{
				_facecontainer.scaleX= 1;//-1 * player.direction;
				_facecontainer.setFace(data["faceid"]);
			}
		}

		public function shootPoint():Point
		{
			var p:Point=_ballpos;
			p=_body.localToGlobal(p);
			p=_map.globalToLocal(p);
			return p;
		}

		override public function doAction(actionType:*):void
		{
			if (actionType is PlayerAction)
			{
				_body.doAction(actionType);
			}
		}

		override public function dispose():void
		{
			removeListener();
			super.dispose();
			if (_chatballview)
			{
				_chatballview.dispose();
				_chatballview=null;
			}
			if (_facecontainer)
			{
				_facecontainer.dispose();
				_facecontainer=null;
			}
			if (_cIcon)
			{
				_cIcon.dispose();
			}
			_cIcon=null;
			if (_attackPlayerCite)
			{
				if (_attackPlayerCite.parent)
					_attackPlayerCite.parent.removeChild(_attackPlayerCite);
			}
			_attackPlayerCite=null;
			_character=null;
			_body=null;
			if (_weaponMovie)
			{
				_weaponMovie.stop();
				_weaponMovie=null;
			}
			if (_levelIcon)
			{
				if (_levelIcon.parent)
					_levelIcon.parent.removeChild(_levelIcon);
				_levelIcon.dispose();
			}
			_levelIcon=null;
		}


		override public function setMap(map:Map):void
		{
			super.setMap(map);
			if (map)
			{
				//添加入地图的时候，更新人物的角度。
				__posChanged(null);
			}
		}


		
	}
}