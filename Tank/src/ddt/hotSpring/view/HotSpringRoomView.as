package ddt.hotSpring.view
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	
	import game.crazyTank.view.LevelUpFaileMC;
	
	import road.comm.PackageIn;
	import road.data.DictionaryData;
	import road.manager.SoundManager;
	import road.ui.manager.TipManager;
	
	import ddt.data.player.PlayerPropertyEvent;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.events.SceneCharacterEvent;
	import tank.hotSpring.*;
	import ddt.hotSpring.controller.HotSpringRoomController;
	import ddt.hotSpring.events.HotSpringRoomEvent;
	import ddt.hotSpring.model.HotSpringRoomModel;
	import ddt.hotSpring.player.HotSpringPlayer;
	import ddt.hotSpring.view.frame.RoomPlayerContinueConfirmView;
	import ddt.hotSpring.view.frame.RoomRenewalFeeView;
	import ddt.hotSpring.vo.MapVO;
	import ddt.hotSpring.vo.PlayerVO;
	import ddt.manager.BossBoxManager;
	import ddt.manager.ChatManager;
	import ddt.manager.HotSpringManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.view.bossbox.SmallBoxButton;
	import ddt.view.common.BellowStripViewII;
	import ddt.view.common.GradeContainer;
	import ddt.view.sceneCharacter.SceneCharacterDirection;
	import ddt.view.scenePathSearcher.PathMapHitTester;
	import ddt.view.scenePathSearcher.SceneScene;
	
	public class HotSpringRoomView extends Sprite
	{
		private var _model:HotSpringRoomModel;
		private var _controller:HotSpringRoomController;
		private var _hotSpringViewAsset:HotSpringViewAsset;
		private var _mapVO:MapVO;
		private var _playerLayer:MovieClip;//人物加载层
		private var _defaultPoint:Point=new Point(480, 560);//玩家进入场景后默认的坐标
		private var _selfPlayer:HotSpringPlayer;
		private var _mouseMovie:MouseClickMovie;
		private var _waterAreaPointPixel:uint=0;//针对于水区域的当前点像素值
		private var _playerWalkPath:Array;//玩家当前行走路径
		private var _sceneScene:SceneScene;
		private var _lastClick:Number=0;
		private var _clickInterval:Number=200;
		private var _chatFrame:Sprite;
		private var _roomMenuView:RoomMenuView;
		private var _roomToolMenuAsset:RoomToolMenuAsset;
		private var _roomTimeAsset:RoomTimeAsset;
		private var _isShowName:Boolean=true;//是否显示玩家名称
		private var _isChatBall:Boolean=true;//是否显示玩家聊天泡泡
		private var _isShowPalyer:Boolean=true;//是否显示当前玩家之外的玩家
		private var _sysDateTime:Date//当前时间
		private var _grade:GradeContainer; // 显示升级动画
		private var _roomRenewalFeeView:RoomRenewalFeeView;
		private var _roomPlayerContinueConfirmView:RoomPlayerContinueConfirmView;
		private var _sceneFront:MovieClip;//场景前景
		private var _sceneFront2:MovieClip;//场景前景-树、花、阳光等
		private var _sceneBack:MovieClip;//场景后景
		private var _sceneFrontNight:MovieClip;//场景前景2(用与效果切换)
		private var _sceneFrontNight2:MovieClip;//场景前景2(用与效果切换)，树、营火虫等
		private var _sceneBackNight:MovieClip;//场景后景2(用与效果切换)
		private var _sceneBackBox:Sprite;//用与存放场景后景
		private var _playerList:DictionaryData=new DictionaryData();//存放玩家临时列表数据，用来队列加载
		private var _playerListFailure:DictionaryData=new DictionaryData();//存放玩家临时失败列表数据，用来再次队列加载
		private var _playerListCellLoadCount:DictionaryData=new DictionaryData();//存放玩家加载次数集(如果已加载成功的，将移除单项)
		private var _isPlayerListLoading:Boolean=false;//队列是否正在运行中
		private var _boxButton:SmallBoxButton;
		private var _hotSpringPlayerList:DictionaryData=new DictionaryData();//玩家形象对象列表
		private var _expUpAsset:ExpUpAsset;
		private var _currentLoadingPlayer:HotSpringPlayer;
		private var _SceneType:int=0;//场景类型:1=白天，2＝晚上,3=白天与晚上交替
		private var _dayStart:Date;
		private var _dayEnd:Date;
		private var _nightStart:Date;
		private var _nightEnd:Date;
		
		public function HotSpringRoomView(controller:HotSpringRoomController,model:HotSpringRoomModel)
		{
			_controller=controller;
			_model=model;
			initialize();
		}
		
		/**
		 * 初始化运行
		 */		
		protected function initialize():void
		{
			_sysDateTime=HotSpringManager.instance.playerEnterRoomTime;
			_mapVO=new MapVO();
			
			BellowStripViewII.Instance.hide();
			
			SoundManager.instance.playMusic("3004");
			
			_sceneBackBox=new Sprite();
			addChild(_sceneBackBox);
			
			_hotSpringViewAsset=new HotSpringViewAsset();
			if(_hotSpringViewAsset)
			{
				_hotSpringViewAsset.x=0;
				_hotSpringViewAsset.y=-210;
				addChild(_hotSpringViewAsset);
				_hotSpringViewAsset.maskPath.visible=false;
				_hotSpringViewAsset.layerWater.visible=false;
				_waterArea=_hotSpringViewAsset.layerWater;
				_sceneScene = new SceneScene();
				_sceneScene.setHitTester(new PathMapHitTester(_hotSpringViewAsset.maskPath));
			}
			
			_playerLayer=_hotSpringViewAsset.playerLayer;
			sysDateTimeScene(_sysDateTime);//白天及晚上场景转换
			
			_mouseMovie = new MouseClickMovie();
			_mouseMovie.mouseChildren = false;
			_mouseMovie.mouseEnabled = false;
			_mouseMovie.stop();
			_hotSpringViewAsset.addChild(_mouseMovie);
			
			_roomMenuView=new RoomMenuView(_controller, _model, HotSpringManager.instance.roomCurrently.playerID==PlayerManager.Instance.Self.ID);
			_roomMenuView.x=1000-_roomMenuView.width;
			_roomMenuView.y=600-_roomMenuView.height-10;
			addChild(_roomMenuView);
			
			_roomToolMenuAsset=new RoomToolMenuAsset();
			_roomToolMenuAsset.x=10;
			_roomToolMenuAsset.y=10;
			addChild(_roomToolMenuAsset);
			_roomToolMenuAsset.btnShowName.gotoAndStop(1);
			_roomToolMenuAsset.btnShowPao.gotoAndStop(1);
			_roomToolMenuAsset.btnShowPlayer.gotoAndStop(1);
			_roomToolMenuAsset.btnShowName.buttonMode=_roomToolMenuAsset.btnShowPao.buttonMode=_roomToolMenuAsset.btnShowPlayer.buttonMode=true;
			
			_roomTimeAsset=new RoomTimeAsset();
			_roomTimeAsset.x=1000-_roomTimeAsset.width+20;
			_roomTimeAsset.y=10;
			addChild(_roomTimeAsset);
			
			_roomTimeAsset.RoomNumber.lblNumber.text=HotSpringManager.instance.roomCurrently.roomNumber.toString();
			if(HotSpringManager.instance.roomCurrently.roomType==1 || HotSpringManager.instance.roomCurrently.roomType==2)
			{//公共房间不显示房间有效时间，只显示玩家时间
				_roomTimeAsset.gotoAndStop(2);
				_roomTimeAsset.PlayerTime.lblPlayerTime.text=HotSpringManager.instance.playerEffectiveTime + LanguageMgr.GetTranslation("ddt.hotSpring.room.time.minute");
			}
			else
			{
				_roomTimeAsset.gotoAndStop(1);
				_roomTimeAsset.RoomTime.lblRoomTime.text= HotSpringManager.instance.roomCurrently.effectiveTime+ LanguageMgr.GetTranslation("ddt.hotSpring.room.time.minute");
			}
			
			//聊天窗体
			ChatManager.Instance.state = HotSpringManager.instance.roomCurrently.roomType==1 ? ChatManager.CHAT_HOTSPRING_ROOM_GOLD_VIEW : ChatManager.CHAT_HOTSPRING_ROOM_VIEW;
			_chatFrame = ChatManager.Instance.view;
			addChild(_chatFrame);
			_chatFrame.addEventListener(Event.ADDED_TO_STAGE, setChatFrameFocus);
			
			if(BossBoxManager.instance.isShowBoxButton())
			{
				_boxButton = new SmallBoxButton();
				_boxButton.x = 930;
				_boxButton.y = 220;
				BossBoxManager.instance.smallBoxButton = _boxButton;
				addChild(_boxButton);
			}
			
			setEvent();
			
			//场景是否加载成功
			if(!_hotSpringViewAsset && !this.contains(_hotSpringViewAsset))
			{
				_controller.roomPlayerRemoveSend(LanguageMgr.GetTranslation("ddt.hotSpring.room.load.error"));
				return;
			}
		}
		
		private function __onStageAddInitMapPath(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,__onStageAddInitMapPath);
			_hotSpringViewAsset.maskPath.mouseEnabled = false;
			_hotSpringViewAsset.layerWater.mouseEnabled = false;
			stage.addChild(_hotSpringViewAsset.maskPath);
			stage.addChild(_hotSpringViewAsset.layerWater);
		}
		
		/**
		 * 设置事件
		 */		
		private function setEvent():void
		{
			_roomToolMenuAsset.btnShowName.addEventListener(MouseEvent.CLICK, roomToolMenu);
			_roomToolMenuAsset.btnShowPao.addEventListener(MouseEvent.CLICK, roomToolMenu);
			_roomToolMenuAsset.btnShowPlayer.addEventListener(MouseEvent.CLICK, roomToolMenu);
			_model.addEventListener(HotSpringRoomEvent.ROOM_PLAYER_ADD, addPlayer);//增加一个玩家
			_model.addEventListener(HotSpringRoomEvent.ROOM_PLAYER_REMOVE, removePlayer);//移除一个玩家
			_hotSpringViewAsset.addEventListener(MouseEvent.CLICK, onMouseClick);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_RENEWAL_FEE, roomRenewalFee);//通知玩家房间续费
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_TIME_UPDATE, roomTimeUpdate);//房间时间更新
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_CONTINUE,roomPlayerContinueIncept);//系统房间刷新时，针对于玩家的继续提示(扣费)	接收
			addEventListener(Event.ADDED_TO_STAGE,__onStageAddInitMapPath);
			SocketManager.Instance.out.sendHotSpringRoomEnterView(0);//玩家成功进入房间视图
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/**
		 * 队列加载玩家开始
		 */		
		private function playerLoad():void
		{
			if(_playerList && _playerList.list && _playerList.length>0)
			{//当总加载列表存在队列
				_isPlayerListLoading=true;
				playerLoadEnter(_playerList.list[0]);
			}
			else if(_playerListFailure && _playerListFailure.list && _playerListFailure.length>0)
			{//当总加载列表不存在队列，有可能失败列表存在队列
				_isPlayerListLoading=true;
				playerLoadEnter(_playerListFailure.list[0]);
			}
		}
		
		/**
		 * 队列加载玩家过程
		 */		
		private function playerLoadEnter(playerVO:PlayerVO):void
		{
			var count:int=0;
			if(_playerListCellLoadCount && _playerListCellLoadCount.length>0)
			{
				count=_playerListCellLoadCount[playerVO.playerInfo.ID] ? int(_playerListCellLoadCount[playerVO.playerInfo.ID]) : 0;//取得玩家加载次数
				if(count>=3)
				{//如果其中有玩家加载超过3次，则退出房间，并提示重新进入
					_controller.roomPlayerRemoveSend(LanguageMgr.GetTranslation("ddt.hotSpring.room.load.error"));
					return;
				}
			}
			_playerListCellLoadCount.add(playerVO.playerInfo.ID, count+1);//更新玩家加载次数(+1)
			
			_currentLoadingPlayer =new HotSpringPlayer(playerVO, addPlayerCallBack);
		}
		
		/**
		 *增加房间内玩家返回成功
		 */		
		private function addPlayerCallBack(hotSpringPlayer:HotSpringPlayer, isLoadSucceed:Boolean):void
		{
			_currentLoadingPlayer=null;
			
			if(!isLoadSucceed)
			{//如果加载失败：1.从总加载列表中移除失败玩家；2.将失败玩家加入到失败列表
				var playerVO:PlayerVO=hotSpringPlayer.playerVO.clone();
				_playerList.remove(playerVO.playerInfo.ID);//从全部列表中移除当前已成功加载的玩家(避免重复)
				_playerListFailure.add(playerVO.playerInfo.ID, playerVO);//加载到失败队列列表
				
				if(hotSpringPlayer) hotSpringPlayer.dispose();
				hotSpringPlayer=null;
				_isPlayerListLoading=false;
				return;
			}
			
			hotSpringPlayer.playerPoint = hotSpringPlayer.playerVO.playerPos;
			hotSpringPlayer.sceneScene=_sceneScene;
			hotSpringPlayer.setSceneCharacterDirectionDefault=hotSpringPlayer.sceneCharacterDirection=hotSpringPlayer.playerVO.scenePlayerDirection;
			
			//根据玩家当前位置点取得区域
			hotSpringPlayer.playerVO.currentlyArea = getCurrentAreaType(hotSpringPlayer.playerVO.playerPos.x, hotSpringPlayer.playerVO.playerPos.y);
			
			if(!_selfPlayer && hotSpringPlayer.playerVO.playerInfo.ID==PlayerManager.Instance.Self.ID)
			{
				_selfPlayer=hotSpringPlayer;
				_playerLayer.addChild(_selfPlayer);
				setCenter();
				_selfPlayer.addEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,setCenter);
				_selfPlayer.addEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE, playerActionChange);
				PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, playerPropChanged);//玩家升级
			}
			else
			{
				_playerLayer.addChild(hotSpringPlayer);
			}
			
			_hotSpringPlayerList.add(hotSpringPlayer.playerVO.playerInfo.ID, hotSpringPlayer);
			_playerList.remove(hotSpringPlayer.playerVO.playerInfo.ID);//移除当前已成功加载的玩家(避免重复)
			_playerListFailure.remove(hotSpringPlayer.playerVO.playerInfo.ID);//从失败列表中移除当前已成功加载的玩家(避免重复)
			_playerListCellLoadCount.remove(hotSpringPlayer.playerVO.playerInfo.ID);//玩家加载次数集移除
			_isPlayerListLoading=false;
			
			hotSpringPlayer.isShowName = _isShowName;
			hotSpringPlayer.isChatBall = _isChatBall;
			hotSpringPlayer.isShowPlayer = _isShowPalyer;
		}
		
		/**
		 * 通知玩家续费
		 */		
		private function roomRenewalFee(event:CrazyTankSocketEvent):void
		{
			if(_roomRenewalFeeView)
			{
				if(_roomRenewalFeeView.parent) _roomRenewalFeeView.parent.removeChild(_roomRenewalFeeView);
				_roomRenewalFeeView.dispose();
				_roomRenewalFeeView=null;
			}
			
			_roomRenewalFeeView = new RoomRenewalFeeView(_controller, HotSpringManager.instance.roomCurrently);
			TipManager.AddTippanel(_roomRenewalFeeView,true);
			_roomRenewalFeeView.setFoucs();
		}
		
		/**
		 * 系统房间刷新时，针对于玩家的继续(扣费)是否继续操作接收
		 */		
		private function roomPlayerContinueIncept(event:CrazyTankSocketEvent):void
		{
			_roomPlayerContinueConfirmView = new RoomPlayerContinueConfirmView(_controller, HotSpringManager.instance.roomCurrently);
			TipManager.AddTippanel(_roomPlayerContinueConfirmView,true);
			_roomPlayerContinueConfirmView.setFoucs();
		}
		
		/**
		 *玩家经验增加动画/白天晚上处理
		 */		
		private function roomTimeUp(isFirst:Boolean=false):void
		{
			if(PlayerManager.Instance.Self.Grade<40)
			{//只有在小于40级时
				expUpPlayer();//播放升级动画
			}
			
			_sysDateTime.seconds+=60;//时间加60秒
			
			sysDateTimeScene(_sysDateTime);
		}
		
		/**
		 *玩家升级动画
		 */		
		private function playerPropChanged(event:PlayerPropertyEvent):void
		{
			if(event.changedProperties["Grade"] && PlayerManager.Instance.Self.IsUpdate)
			{
				_grade = new GradeContainer(true); // 升级动画
				_grade.y = -122;
				_grade.x = -40;
				_grade.setGrade(new LevelUpFaileMC());  //播放升级动画
				_selfPlayer.addChild(_grade);
				
				PlayerManager.Instance.Self.IsUpdate=false;
			}
		}
		
		/**
		 *房间时间更新(每60秒更新一次)
		 */		
		private function roomTimeUpdate(evt:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = evt.pkg;
			var effectiveTime:int=pkg.readInt();
			HotSpringManager.instance.roomCurrently.effectiveTime=effectiveTime;
			HotSpringManager.instance.playerEffectiveTime=effectiveTime;
			
			if(HotSpringManager.instance.roomCurrently.roomType==1 || HotSpringManager.instance.roomCurrently.roomType==2)
			{//公共房间不显示房间有效时间，只显示玩家时间
				_roomTimeAsset.gotoAndStop(2);
				_roomTimeAsset.PlayerTime.lblPlayerTime.text=effectiveTime + LanguageMgr.GetTranslation("ddt.hotSpring.room.time.minute");
			}
			else
			{
				_roomTimeAsset.gotoAndStop(1);
				_roomTimeAsset.RoomTime.lblRoomTime.text=effectiveTime + LanguageMgr.GetTranslation("ddt.hotSpring.room.time.minute");
			}
			
			roomTimeUp();//玩家经验增加动画/白天晚上处理
		}
		
		private function setChatFrameFocus(event:Event):void
		{
			ChatManager.Instance.setFocus();
			_chatFrame.removeEventListener(Event.ADDED_TO_STAGE,setChatFrameFocus);
		}
		
		/**
		 *白天及晚上场景转换
		 */
		private function sysDateTimeScene(dateTime:Date):void
		{
			_sysDateTime=dateTime;
			var nowHour:int=_sysDateTime.getHours();
			var nowMinute:int=_sysDateTime.getUTCMinutes();
			
			_dayStart= new Date(_sysDateTime.getFullYear(), _sysDateTime.getMonth(), _sysDateTime.getDate(), 5, 30);
			_dayEnd= new Date(_sysDateTime.getFullYear(), _sysDateTime.getMonth(), _sysDateTime.getDate(), 6, 30);
			_nightStart= new Date(_sysDateTime.getFullYear(), _sysDateTime.getMonth(), _sysDateTime.getDate(), 17, 30);
			_nightEnd= new Date(_sysDateTime.getFullYear(), _sysDateTime.getMonth(), _sysDateTime.getDate(), 18, 30);
			
			if(_sysDateTime>=_dayEnd && _sysDateTime<=_nightStart)
			{//白天段
				if(_SceneType==1) return;
				_SceneType=1;
				removeSceneNight();//移除晚上场景资源
				addSceneDay();//加载白天场景
			}
			else if(_sysDateTime>=_nightEnd || _sysDateTime<_dayStart)
			{//晚上段
				if(_SceneType==2) return;
				_SceneType=2;
				removeSceneDay();//移除白天场景资源
				addSceneNight();//加载晚上场景
			}
			else
			{//晚上白天交替段
				if(_SceneType!=3)
				{//如果前面的状态不为交替类型
					removeSceneDay();//移除白天场景资源
					removeSceneNight();//移除晚上场景资源
				}
				_SceneType=3;
				dayAndNight();
			}
		}
		
		/**
		 * 加载白天场景
		 */		
		private function addSceneDay():void
		{
			if(!_sceneFront) _sceneFront = new HotSpringDaySceneFrontAsset();//设置为白天前景
			if(!_sceneFront2) _sceneFront2 = new HotSpringDaySceneFront2Asset();
			if(!_sceneBack) _sceneBack = new HotSpringDaySceneBackAsset();//设置白天后景
			
			if(_playerLayer.house.dayHouse && !_playerLayer.house.contains(_playerLayer.house.dayHouse)) _playerLayer.house.addChild(_playerLayer.house.dayHouse);
			if(_playerLayer.tree.dayTree && !_playerLayer.tree.contains(_playerLayer.tree.dayTree)) _playerLayer.tree.addChild(_playerLayer.tree.dayTree);
			if(_playerLayer.stove.dayStove && !_playerLayer.stove.contains(_playerLayer.stove.dayStove)) _playerLayer.stove.addChild(_playerLayer.stove.dayStove);
			
			if(!_sceneBackBox.contains(_sceneBack)) _sceneBackBox.addChild(_sceneBack);
			if(!_hotSpringViewAsset.contains(_sceneFront)) _hotSpringViewAsset.addChildAt(_sceneFront, 0);
			_sceneFront2.x=0.1;
			_sceneFront2.y=81.7;
			if(!_hotSpringViewAsset.contains(_sceneFront2)) _hotSpringViewAsset.addChild(_sceneFront2);
		}
		
		/**
		 * 移除白天场景
		 */		
		private function removeSceneDay():void
		{
			if(_sceneFront && _sceneFront.parent) _sceneFront.parent.removeChild(_sceneFront);
			_sceneFront=null;
			
			if(_sceneFront2 && _sceneFront2.parent) _sceneFront2.parent.removeChild(_sceneFront2);
			_sceneFront2=null;
			
			if(_sceneBack && _sceneBack.parent) _sceneBack.parent.removeChild(_sceneBack);
			_sceneBack=null;
			
			if(_playerLayer.house.dayHouse && _playerLayer.house.dayHouse.parent) _playerLayer.house.dayHouse.parent.removeChild(_playerLayer.house.dayHouse);
			if(_playerLayer.tree.dayTree && _playerLayer.tree.dayTree.parent) _playerLayer.tree.dayTree.parent.removeChild(_playerLayer.tree.dayTree);
			if(_playerLayer.stove.dayStove && _playerLayer.stove.dayStove.parent) _playerLayer.stove.dayStove.parent.removeChild(_playerLayer.stove.dayStove);
		}
		
		/**
		 * 加载晚上场景
		 */		
		private function addSceneNight():void
		{
			if(!_sceneFront) _sceneFront=new HotSpringNightSceneFrontAsset();//设置为晚上前景
			if(!_sceneFront2) _sceneFront2 = new HotSpringNightSceneFront2Asset();
			if(!_sceneBack) _sceneBack=new HotSpringNightSceneBackAsset();//设置晚上后景
			
			if(_playerLayer.house.nightHouse && !_playerLayer.house.contains(_playerLayer.house.nightHouse)) _playerLayer.house.addChild(_playerLayer.house.nightHouse);
			if(_playerLayer.tree.nightTree && !_playerLayer.tree.contains(_playerLayer.tree.nightTree)) _playerLayer.tree.addChild(_playerLayer.tree.nightTree);
			if(_playerLayer.stove.nightStove && !_playerLayer.stove.contains(_playerLayer.stove.nightStove)) _playerLayer.stove.addChild(_playerLayer.stove.nightStove);
			
			if(!_sceneBackBox.contains(_sceneBack)) _sceneBackBox.addChild(_sceneBack);
			if(!_hotSpringViewAsset.contains(_sceneFront)) _hotSpringViewAsset.addChildAt(_sceneFront, 0);
			_sceneFront2.x=0.1;
			_sceneFront2.y=81.7;
			if(!_hotSpringViewAsset.contains(_sceneFront2)) _hotSpringViewAsset.addChild(_sceneFront2);
		}
		
		/**
		 * 移除晚上场景
		 */
		private function removeSceneNight():void
		{
			if(_sceneFrontNight && _sceneFrontNight.parent) _sceneFrontNight.parent.removeChild(_sceneFrontNight);
			_sceneFrontNight=null;
			
			if(_sceneFrontNight2 && _sceneFrontNight2.parent) _sceneFrontNight2.parent.removeChild(_sceneFrontNight2);
			_sceneFrontNight2=null;
			
			if(_sceneBackNight && _sceneBackNight.parent) _sceneBackNight.parent.removeChild(_sceneBackNight);
			_sceneBackNight=null;
			
			if(_playerLayer.house.nightHouse && _playerLayer.house.nightHouse.parent) _playerLayer.house.nightHouse.parent.removeChild(_playerLayer.house.nightHouse);
			if(_playerLayer.tree.nightTree && _playerLayer.tree.nightTree.parent) _playerLayer.tree.nightTree.parent.removeChild(_playerLayer.tree.nightTree);
			if(_playerLayer.stove.nightStove && _playerLayer.stove.nightStove.parent) _playerLayer.stove.nightStove.parent.removeChild(_playerLayer.stove.nightStove);
		}
		
		/**
		 * 白天与晚上交替
		 */		
		private function dayAndNight():void
		{
			if(!_sceneFront) _sceneFront = new HotSpringDaySceneFrontAsset();//设置白天前景
			if(!_sceneFront2) _sceneFront2 = new HotSpringDaySceneFront2Asset();//设置白天前景2
			if(!_sceneBack) _sceneBack = new HotSpringDaySceneBackAsset();//设置白天后景
			
			if(!_sceneFrontNight) _sceneFrontNight=new HotSpringNightSceneFrontAsset();//设置晚上前景
			if(!_sceneFrontNight2) _sceneFrontNight2=new HotSpringNightSceneFront2Asset();//设置晚上前景2
			if(!_sceneBackNight) _sceneBackNight=new HotSpringNightSceneBackAsset();//设置晚上后景
			
			_sceneFront2.x=_sceneFrontNight2.x=0.1;
			_sceneFront2.y=_sceneFrontNight2.y=81.7;
			
			var alphaValueCount:Number=60;//60分钟(1小时时间用来透明渐变,每1分钟计为一个透明点)
			var minutesCount:Number;
			var resultAlphaValue:Number;
			
			if(_sysDateTime>=_dayStart && _sysDateTime<=_dayEnd)
			{//天亮中
				if(!_sceneBackBox.contains(_sceneBackNight)) _sceneBackBox.addChild(_sceneBackNight);//加载晚上后景
				if(!_hotSpringViewAsset.contains(_sceneFrontNight)) _hotSpringViewAsset.addChildAt(_sceneFrontNight, 0);//加载晚上前景
				if(!_hotSpringViewAsset.contains(_sceneFrontNight2)) _hotSpringViewAsset.addChild(_sceneFrontNight2);//加载晚上前景2
				
				if(!_sceneBackBox.contains(_sceneBack)) _sceneBackBox.addChild(_sceneBack);//加载白天后景
				if(!_hotSpringViewAsset.contains(_sceneFront)) _hotSpringViewAsset.addChildAt(_sceneFront, 1);//白天前景
				if(!_hotSpringViewAsset.contains(_sceneFront2)) _hotSpringViewAsset.addChild(_sceneFront2);//白天前景2
				
				if(_playerLayer.house.nightHouse && !_playerLayer.house.contains(_playerLayer.house.nightHouse)) _playerLayer.house.addChild(_playerLayer.house.nightHouse);
				if(_playerLayer.tree.nightTree && !_playerLayer.tree.contains(_playerLayer.tree.nightTree)) _playerLayer.tree.addChild(_playerLayer.tree.nightTree);
				if(_playerLayer.stove.nightStove && !_playerLayer.stove.contains(_playerLayer.stove.nightStove)) _playerLayer.stove.addChild(_playerLayer.stove.nightStove);
				
				_playerLayer.house.dayHouse.y-=1;
				_playerLayer.house.nightHouse.y+=1;
				if(_playerLayer.house.dayHouse && !_playerLayer.house.contains(_playerLayer.house.dayHouse)) _playerLayer.house.addChild(_playerLayer.house.dayHouse);
				if(_playerLayer.tree.dayTree && !_playerLayer.tree.contains(_playerLayer.tree.dayTree)) _playerLayer.tree.addChild(_playerLayer.tree.dayTree);
				if(_playerLayer.stove.dayStove && !_playerLayer.stove.contains(_playerLayer.stove.dayStove)) _playerLayer.stove.addChild(_playerLayer.stove.dayStove);
				
				minutesCount=((_sysDateTime.getHours()-5)*60-30)+_sysDateTime.minutes;//取得当前时间针对于5点30后的总分钟时间
				resultAlphaValue=Number(((minutesCount/alphaValueCount)*100).toFixed(2));//计算透明值比例
				
				//移除掉阳光，只在白天段才显示
				if(_sceneFront2.daySun && _sceneFront2.daySun.parent) _sceneFront2.daySun.parent.removeChild(_sceneFront2.daySun);
				_sceneFront2.daySun=null;					
				
				//移除掉飘落的樱花效果，只在白天段才显示
				if(_sceneFront2.dayFlower && _sceneFront2.dayFlower.parent) _sceneFront2.dayFlower.parent.removeChild(_sceneFront2.dayFlower);
				_sceneFront2.dayFlower=null;
				
				_sceneFront.alpha=_sceneFront2.alpha=_sceneBack.alpha=_playerLayer.house.dayHouse.alpha=_playerLayer.tree.dayTree.alpha=_playerLayer.stove.dayStove.alpha=resultAlphaValue/100;
				_sceneFrontNight2.nightFirefly.alpha=1-resultAlphaValue/100;
				
				if(resultAlphaValue/100>=1)
				{
					removeSceneNight();
				}
			}
			else if(_sysDateTime>=_nightStart && _sysDateTime<=_nightEnd)
			{//天黑中
				_sceneBackBox.addChild(_sceneBack);//加载白天后景
				_hotSpringViewAsset.addChildAt(_sceneFront, 0);//白天前景
				_hotSpringViewAsset.addChild(_sceneFront2);//白天前景2
				
				if(!_sceneBackBox.contains(_sceneBackNight)) _sceneBackBox.addChild(_sceneBackNight);//加载晚上后景
				if(!_hotSpringViewAsset.contains(_sceneFrontNight)) _hotSpringViewAsset.addChildAt(_sceneFrontNight, 1);//加载晚上前景
				if(!_hotSpringViewAsset.contains(_sceneFrontNight2)) _hotSpringViewAsset.addChild(_sceneFrontNight2);//加载晚上前景2
				
				if(_playerLayer.house.dayHouse && !_playerLayer.house.contains(_playerLayer.house.dayHouse)) _playerLayer.house.addChild(_playerLayer.house.dayHouse);
				if(_playerLayer.tree.dayTree && !_playerLayer.tree.contains(_playerLayer.tree.dayTree)) _playerLayer.tree.addChild(_playerLayer.tree.dayTree);
				if(_playerLayer.stove.dayStove && !_playerLayer.stove.contains(_playerLayer.stove.dayStove)) _playerLayer.stove.addChild(_playerLayer.stove.dayStove);
				
				if(_playerLayer.house.nightHouse && !_playerLayer.house.contains(_playerLayer.house.nightHouse)) _playerLayer.house.addChild(_playerLayer.house.nightHouse);
				if(_playerLayer.tree.nightTree && !_playerLayer.tree.contains(_playerLayer.tree.nightTree)) _playerLayer.tree.addChild(_playerLayer.tree.nightTree);
				if(_playerLayer.stove.nightStove && !_playerLayer.stove.contains(_playerLayer.stove.nightStove)) _playerLayer.stove.addChild(_playerLayer.stove.nightStove);
				
				minutesCount=((_sysDateTime.getHours()-17)*60-30)+_sysDateTime.minutes;//取得当前时间针对于17点30后的总分钟时间
				resultAlphaValue=Number(((minutesCount/alphaValueCount)*100).toFixed(2));//计算透明值比例
				
				//移除掉阳光，只在白天段才显示
				if(_sceneFront2.daySun && _sceneFront2.daySun.parent) _sceneFront2.daySun.parent.removeChild(_sceneFront2.daySun);
				_sceneFront2.daySun=null;	
				
				//移除掉萤火虫效果，只在晚上段显示
				if(_sceneFrontNight2.nightFirefly && _sceneFrontNight2.nightFirefly.parent) _sceneFrontNight2.nightFirefly.parent.removeChild(_sceneFrontNight2.nightFirefly);
				_sceneFrontNight2.nightFirefly=null;
				
				_sceneFrontNight.alpha=_sceneFrontNight2.alpha=_sceneBackNight.alpha=_playerLayer.house.nightHouse.alpha=_playerLayer.tree.nightTree.alpha=_playerLayer.stove.nightStove.alpha=resultAlphaValue/100;
				_sceneFront2.dayFlower.alpha=1-resultAlphaValue/100;
				
				if(resultAlphaValue/100>=1)
				{
					removeSceneDay();
				}
			}
		}
		
		/**
		 * 操作菜单
		 */		
		private function roomToolMenu(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			switch(evt.target)
			{
				case _roomToolMenuAsset.btnShowName://显示/隐藏玩家
					_isShowName=!_isShowName;
					_roomToolMenuAsset.btnShowName.gotoAndStop(_isShowName ? 1 : 2);
					break;
				case _roomToolMenuAsset.btnShowPao://显示/隐藏泡泡
					_isChatBall=!_isChatBall;
					_roomToolMenuAsset.btnShowPao.gotoAndStop(_isChatBall ? 1 : 2);
					break;
				case _roomToolMenuAsset.btnShowPlayer://显示/隐藏玩家
					_isShowPalyer=!_isShowPalyer;
					_roomToolMenuAsset.btnShowPlayer.gotoAndStop(_isShowPalyer ? 1 : 2);
					break;
			}
			setPlayerShowItem();
		}
		
		/**
		 * 设置玩家人物显示项
		 */		
		private function setPlayerShowItem():void
		{
//			for each(var hotSpringPlayer:HotSpringPlayer in _hotSpringPlayerList.list)
//			{
//				hotSpringPlayer.isShowName=_isShowName;
//				hotSpringPlayer.isChatBall=_isChatBall;
//				hotSpringPlayer.visible= hotSpringPlayer.playerVO.playerInfo.ID!=PlayerManager.Instance.Self.ID ? _isShowPalyer : true;
//			}

			for(var i:int=0;i<_playerLayer.numChildren;i++)
			{
				var hotSpringPlayer:HotSpringPlayer=_playerLayer.getChildAt(i) as HotSpringPlayer;
				if(hotSpringPlayer)
				{
					hotSpringPlayer.isShowName=_isShowName;
					hotSpringPlayer.isChatBall=_isChatBall;
					hotSpringPlayer.visible= hotSpringPlayer.playerVO.playerInfo.ID!=PlayerManager.Instance.Self.ID ? _isShowPalyer : true;
				}
			}
		}
		
		/**
		 * 加载玩家到场景
		 */		
		private function addPlayer(evt:HotSpringRoomEvent):void
		{
			var playerVO:PlayerVO=evt.data as PlayerVO;
			_playerList.add(playerVO.playerInfo.ID, playerVO);//增加玩家至队列列表
		}
		
		/**
		 * 重绘所有玩家
		 */		
		private function onEnterFrame(evt:Event):void
		{
			if(!_isPlayerListLoading)
			{//只有当当前没有加载时执行加载
				playerLoad();//玩家加载
			}
			
			if(!_hotSpringPlayerList || _hotSpringPlayerList.length<=0) return;
			
			for each(var hotSpringPlayer:HotSpringPlayer in _hotSpringPlayerList.list)
			{
				hotSpringPlayer.updatePlayer();
			}
			
			BuildEntityDepth();
		}
		
		private function getPointDepth(x : Number,y : Number) : Number
		{
			return _mapVO.mapWidth * y + x;
		}
		
		/**
		 * 调整物品的层次
		 */
		private function BuildEntityDepth() : void
		{
			var count : int = _playerLayer.numChildren;
			for(var i : int = 0;i < count - 1;i++)
			{
				var obj : DisplayObject = _playerLayer.getChildAt(i);
				var depth : Number = this.getPointDepth(obj.x, obj.y);
				
				var minIndex : int ;
				var minDepth : Number = Number.MAX_VALUE;
				for(var j : int = i + 1;j < count;j++)
				{
					var temp :DisplayObject = _playerLayer.getChildAt(j);
					var tempDepth : Number = this.getPointDepth(temp.x, temp.y);
					
					if(tempDepth < minDepth)
					{
						minIndex = j;
						minDepth = tempDepth;
					}
				}
				
				if(depth > minDepth)
				{
					_playerLayer.swapChildrenAt(i, minIndex);	
				}
			}
		}
		
		/**
		 * 玩家退出/移除出房间成功后处理
		 */		
		private function removePlayer(evt:HotSpringRoomEvent):void
		{
			var playerID:int=int(evt.data);
			var hotSpringPlayer:HotSpringPlayer=_hotSpringPlayerList[playerID] as HotSpringPlayer;
			_hotSpringPlayerList.remove(playerID);
			
			if(!hotSpringPlayer)
			{//如果通过查找列表不存在玩家对象，则再一次通过玩家加载层去查找
				for(var i:int=0;i<_playerLayer.numChildren;i++)
				{
					hotSpringPlayer=_playerLayer.getChildAt(i) as HotSpringPlayer;
					if(hotSpringPlayer && hotSpringPlayer.playerVO.playerInfo.ID==playerID)
					{//如果存在
						break;
					}
				}
			}
			
//			if(!hotSpringPlayer) return;

			hotSpringPlayer.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE, playerActionChange);
			if(hotSpringPlayer.parent) hotSpringPlayer.parent.removeChild(hotSpringPlayer);
			hotSpringPlayer.dispose();
			hotSpringPlayer=null;
			
			if(playerID==PlayerManager.Instance.Self.ID)
			{//如果移除的玩家是自已
				_selfPlayer.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,setCenter);
				PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, playerPropChanged);//玩家升级
				dispose();
				_controller.roomPlayerRemove();
			}
		}
		
		private function onMouseClick(evt:MouseEvent):void
		{
			if(!_selfPlayer) return;
			
			var targetPoint:Point=_hotSpringViewAsset.globalToLocal(new Point(evt.stageX,evt.stageY));
			
			if(flash.utils.getTimer() - _lastClick > _clickInterval)
			{
				_lastClick = flash.utils.getTimer();
				if(!_sceneScene.hit(targetPoint))
				{//如果为可行走区域
					_selfPlayer.playerVO.walkPath = _sceneScene.searchPath(_selfPlayer.playerPoint, targetPoint);
					_selfPlayer.playerVO.walkPath.shift();
					_selfPlayer.playerVO.scenePlayerDirection=SceneCharacterDirection.getDirection(_selfPlayer.playerPoint, _selfPlayer.playerVO.walkPath[0]);
					_selfPlayer.playerVO.currentWalkStartPoint = _selfPlayer.currentWalkStartPoint;
					_controller.roomPlayerTargetPointSend(_selfPlayer.playerVO);//发送玩家当前数据
					_mouseMovie.x = targetPoint.x;
					_mouseMovie.y = targetPoint.y;
					_mouseMovie.play();
				}
			}
		}
		
		/**
		 * 地图居中
		 */		
		private function setCenter(event:SceneCharacterEvent=null):void
		{
			var xf : Number = -(_selfPlayer.x - stage.stageWidth / 2);
			var yf : Number = -(_selfPlayer.y - stage.stageHeight / 2)+50;
			
			if(xf > 0)xf = 0;
			if(xf < stage.stageWidth - _model.mapVO.mapWidth)
				xf = stage.stageWidth - _model.mapVO.mapWidth;
			if(yf > 0)yf = 0;
			if(yf < stage.stageHeight - _model.mapVO.mapHeight)
				yf = stage.stageHeight - _model.mapVO.mapHeight;
			
			if(xf>0) xf=0;
			if(yf>0) yf = 0;
			
			_hotSpringViewAsset.x = xf;
			_hotSpringViewAsset.y = yf;
			
			_sceneBackBox.x = xf*0.6-40;
			_sceneBackBox.y = yf*0.6-10;
		}
		
		private function playerActionChange(evt:SceneCharacterEvent):void
		{
			var type:String=evt.data.toString();
			if(type == "naturalStandFront" || type == "naturalStandBack" || type == "waterFrontEyes" || type == "waterStandBack")
			{//人物在站立时
				_mouseMovie.gotoAndStop(1);
			}
		}
		
		/**
		 * 播放加经验值动画
		 */		
		public function expUpPlayer():void
		{
			if(!_selfPlayer) return;
			
			if(!_expUpAsset) _expUpAsset=new ExpUpAsset();
			_expUpAsset.x=(_selfPlayer.playerWitdh-75)/2-_selfPlayer.playerWitdh/2;
			_expUpAsset.y=_selfPlayer.playerVO.currentlyArea==1 ? -_selfPlayer.playerHeight-30 : -_selfPlayer.playerHeight+33;
			_selfPlayer.addChild(_expUpAsset);
			_expUpAsset.ExpMsg.lblMsg.text="EXP " + _model.getExpUpValue(HotSpringManager.instance.roomCurrently.roomType, PlayerManager.Instance.Self.Grade).toString();
			
			_expUpAsset.removeEventListener(Event.ENTER_FRAME, expUpEnterFrame);
			_expUpAsset.addEventListener(Event.ENTER_FRAME, expUpEnterFrame);
			_expUpAsset.gotoAndPlay(1);
		}
		
		/**
		 * 逐帧播放增加经验值动画
		 */		
		private function expUpEnterFrame(evt:Event):void
		{
			if (_expUpAsset && _expUpAsset.currentFrame>=_expUpAsset.totalFrames)
			{
				_expUpAsset.removeEventListener(Event.ENTER_FRAME, expUpEnterFrame);
				_expUpAsset.gotoAndStop(1);
				if(_expUpAsset.parent) _expUpAsset.parent.removeChild(_expUpAsset);
				_expUpAsset=null;
			}
		}
		private static var _waterArea:MovieClip;
		public static function getCurrentAreaType(xPos:int,yPos:int):int
		{
			var g:Point = _waterArea.localToGlobal(new Point(xPos,yPos));
			if(_waterArea.hitTestPoint(g.x,g.y,true))
			{
				return 2;
			}else
			{
				return 1;
			}
			return 0;
		}
		/**
		 * 显示视图
		 */		
		public function show():void
		{
			_controller.addChild(this);
		}
		
		/**
		 * 隐藏视图
		 */		
		public function hide():void
		{
			_controller.removeChild(this);
		}
		
		public function dispose():void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			removeEventListener(MouseEvent.CLICK, onMouseClick);
			if(_chatFrame) _chatFrame.removeEventListener(Event.ADDED_TO_STAGE, setChatFrameFocus);
			_roomToolMenuAsset.btnShowName.removeEventListener(MouseEvent.CLICK, roomToolMenu);
			_roomToolMenuAsset.btnShowPao.removeEventListener(MouseEvent.CLICK, roomToolMenu);
			_roomToolMenuAsset.btnShowPlayer.removeEventListener(MouseEvent.CLICK, roomToolMenu);
			if(_selfPlayer) _selfPlayer.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,setCenter);
			if(_selfPlayer) _selfPlayer.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE, playerActionChange);
			_model.removeEventListener(HotSpringRoomEvent.ROOM_PLAYER_ADD, addPlayer);
			_model.removeEventListener(HotSpringRoomEvent.ROOM_PLAYER_REMOVE, removePlayer);
			PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, playerPropChanged);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_RENEWAL_FEE, roomRenewalFee);//通知玩家房间续费
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_TIME_UPDATE, roomTimeUpdate);//房间进间更新
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_CONTINUE,roomPlayerContinueIncept);//系统房间刷新时，针对于玩家的继续提示(扣费)接收
			removeEventListener(Event.ADDED_TO_STAGE,__onStageAddInitMapPath);
			
			if(_grade) _grade.dispose();
			_grade = null;
			
			if(_roomRenewalFeeView)
			{
				if(_roomRenewalFeeView.parent) _roomRenewalFeeView.parent.removeChild(_roomRenewalFeeView);
				_roomRenewalFeeView.dispose();
			}
			_roomRenewalFeeView=null;
			
			if(_roomPlayerContinueConfirmView)
			{
				if(_roomPlayerContinueConfirmView.parent) _roomPlayerContinueConfirmView.parent.removeChild(_roomPlayerContinueConfirmView);
				_roomPlayerContinueConfirmView.dispose();
			}
			_roomPlayerContinueConfirmView=null;			
			
			_waterArea=null;
			
			if(_sceneScene) _sceneScene.dispose();
			_sceneScene=null;
			
			if(_roomMenuView)
			{
				if(_roomMenuView.parent) _roomMenuView.parent.removeChild(_roomMenuView);
				_roomMenuView.dispose();
			}
			_roomMenuView=null;
			
			if(_roomToolMenuAsset && _roomToolMenuAsset.parent) _roomToolMenuAsset.parent.removeChild(_roomToolMenuAsset);
			_roomToolMenuAsset=null;
			
			if(_roomTimeAsset && _roomTimeAsset.parent) _roomTimeAsset.parent.removeChild(_roomTimeAsset);
			_roomTimeAsset=null;			
			
			if(_chatFrame && _chatFrame.parent) _chatFrame.parent.removeChild(_chatFrame);
			_chatFrame=null;
			
			if(_sceneFront && _sceneFront.parent)_sceneFront.parent.removeChild(_sceneFront);
			_sceneFront=null;
			
			if(_sceneFront2 && _sceneFront2.parent)_sceneFront2.parent.removeChild(_sceneFront2);
			_sceneFront2=null;
			
			if(_sceneBack && _sceneBack.parent)_sceneBack.parent.removeChild(_sceneBack);
			_sceneBack=null;	
			
			if(_sceneFrontNight && _sceneFrontNight.parent)_sceneFrontNight.parent.removeChild(_sceneFrontNight);
			_sceneFrontNight=null;
			
			if(_sceneFrontNight2 && _sceneFrontNight2.parent)_sceneFrontNight2.parent.removeChild(_sceneFrontNight2);
			_sceneFrontNight2=null;
			
			if(_sceneBackNight && _sceneBackNight.parent)_sceneBackNight.parent.removeChild(_sceneBackNight);
			_sceneBackNight=null;
			
			if(_hotSpringViewAsset.maskPath && _hotSpringViewAsset.maskPath.parent)_hotSpringViewAsset.maskPath.parent.removeChild(_hotSpringViewAsset.maskPath);
			if(_hotSpringViewAsset.layerWater && _hotSpringViewAsset.layerWater.parent)_hotSpringViewAsset.layerWater.parent.removeChild(_hotSpringViewAsset.layerWater);
			
			if(_sceneBackBox && _sceneBackBox.parent) _sceneBackBox.parent.removeChild(_sceneBackBox);
			_sceneBackBox=null;			
			
			if(_mouseMovie && _mouseMovie.parent) _mouseMovie.parent.removeChild(_mouseMovie);
			_mouseMovie=null;
			
			while(_model.roomPlayerList && _model.roomPlayerList.list.length>0)
			{
				var playerVO:PlayerVO =_model.roomPlayerList.list[0] as PlayerVO;
				if(playerVO) playerVO.dispose();
				playerVO=null;
				
				_model.roomPlayerList.list.shift();
			}
			_model.roomPlayerList.clear();
			
			while(_playerList && _playerList.length>0)
			{
				var playerVO2:PlayerVO=_playerList.list[0] as PlayerVO;
				if(playerVO2) playerVO2.dispose();
				playerVO2=null;
				_playerList.list.shift();
			}
			_playerList.clear();
			_playerList=null;
			
			if(_selfPlayer) _selfPlayer.dispose();
			_selfPlayer=null;
			
			while(_hotSpringPlayerList && _hotSpringPlayerList.length>0)
			{
				var player:HotSpringPlayer=_hotSpringPlayerList.list[0] as HotSpringPlayer;
				if(player) player.dispose();
				player=null;
				_hotSpringPlayerList.list.shift();
			}
			_hotSpringPlayerList=null;
			
			if(_playerLayer)
			{
				while(_playerLayer.numChildren>0)
				{
					var hotSpringPlayer:HotSpringPlayer=_playerLayer.getChildAt(0) as HotSpringPlayer;
					if(hotSpringPlayer) hotSpringPlayer.dispose();
					hotSpringPlayer=null;
					_playerLayer.removeChildAt(0);
				}
			}
			if(_playerLayer && _playerLayer.parent) _playerLayer.parent.removeChild(_playerLayer);
			_playerLayer=null;
			
			if(_boxButton)
			{
				BossBoxManager.instance.deleteBoxButton();
				_boxButton.dispose();
			}
			_boxButton = null;
			
			while(_playerWalkPath && _playerWalkPath.length>0)
			{
				_playerWalkPath[0]=null;
				_playerWalkPath.shift();
			}
			_playerWalkPath=null;
			
			if(_currentLoadingPlayer)_currentLoadingPlayer.dispose();
			_currentLoadingPlayer = null;
			
			if(_expUpAsset)
			{
				_expUpAsset.removeEventListener(Event.ENTER_FRAME, expUpEnterFrame);
				if(_expUpAsset.parent) _expUpAsset.parent.removeChild(_expUpAsset);
			}
			_expUpAsset=null;
			
			if(_hotSpringViewAsset && _hotSpringViewAsset.parent){_hotSpringViewAsset.parent.removeChild(_hotSpringViewAsset);}
			_hotSpringViewAsset=null;
			
			_defaultPoint=null;
			_mapVO=null;
		}
	}
}