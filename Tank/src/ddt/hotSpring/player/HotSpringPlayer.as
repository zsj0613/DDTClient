package ddt.hotSpring.player
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import ddt.events.SceneCharacterEvent;
	import tank.hotSpring.InWaterShowAsset;
	import tank.hotSpring.WavePlayerAsset;
	import ddt.hotSpring.events.HotSpringRoomPlayerEvent;
	import ddt.hotSpring.view.HotSpringRoomView;
	import ddt.hotSpring.vo.PlayerVO;
	import ddt.manager.ChatManager;
	import ddt.manager.LanguageMgr;
	import ddt.utils.Helpers;
	import ddt.view.chatsystem.ChatData;
	import ddt.view.chatsystem.ChatEvent;
	import ddt.view.chatsystem.ChatInputView;
	import ddt.view.common.ChatBallView;
	import ddt.view.common.FaceContainer;
	import ddt.view.sceneCharacter.SceneCharacterDirection;
	import ddt.view.scenePathSearcher.SceneScene;
	
	public class HotSpringPlayer extends HotSpringPlayerBase
	{
		private var _playerVO:PlayerVO;
		private var _wavePlayerAsset:WavePlayerAsset;
		private var _inWaterShowAsset:InWaterShowAsset;
		private var _sceneScene:SceneScene;
		private var _spName:Sprite;
		private var _lblName:TextField;//玩家名称
		private var _isShowName:Boolean=true;//是否显示玩家名称
		private var _isChatBall:Boolean=true;//是否显示玩家聊天泡泡
		private var _isShowPlayer:Boolean=true;//是否显示玩家		
		private var _chatBallView:ChatBallView;
		private var _face:FaceContainer;
		
		public function HotSpringPlayer(playerVO:PlayerVO, callBack:Function=null)
		{
			_playerVO=playerVO;
			_currentWalkStartPoint = _playerVO.playerPos;
			super(_playerVO.playerInfo, callBack);
			initialize();
		}
		
		private function initialize():void
		{
			moveSpeed=_playerVO.playerMoveSpeed;//玩家移动速度
			if(_isShowName)
			{//加载玩家昵称
				if(!_lblName) _lblName=new TextField();
				_lblName.selectable = false;
				_lblName.mouseEnabled = false;
				_lblName.autoSize = TextFieldAutoSize.LEFT;
				_lblName.text = playerVO && playerVO.playerInfo && playerVO.playerInfo.NickName ? playerVO.playerInfo.NickName : "";
				_lblName.setTextFormat(new TextFormat(LanguageMgr.GetTranslation("ddt.auctionHouse.view.BaseStripView.Font"),16,0x5BFF09,true));
				
				if(!_spName) _spName = new Sprite();
				_spName.addChild(_lblName);
				_spName.x=(playerWitdh-_spName.width)/2-playerWitdh/2;
				_spName.y=-playerHeight+10;
				_spName.graphics.beginFill(0x000000,0.5);
				_spName.graphics.drawRoundRect(-4,0,_lblName.textWidth+8,22,5,5);
				_spName.graphics.endFill();
				
				addChild(_spName);
			}
			else
			{
				if(_lblName && _lblName.parent) _lblName.parent.removeChild(_lblName);
				_lblName=null;
			}
			
			if(_isChatBall)
			{
				if(!_chatBallView) _chatBallView = new ChatBallView();
				_chatBallView.x =(playerWitdh-_chatBallView.width)/2-playerWitdh/2;
				_chatBallView.y = -playerHeight+40;
				addChild(_chatBallView);
			}
			else
			{
				if(_chatBallView)
				{
					_chatBallView.clear();
					if(_chatBallView.parent) _chatBallView.parent.removeChild(_chatBallView);
					_chatBallView.dispose();
				}
				_chatBallView=null;
			}
			
			_face = new FaceContainer(true);
			_face.x =(playerWitdh-_face.width)/2-playerWitdh/2;
			_face.y = -90;
			addChild(_face);
			
			setEvent();
		}
		
		/**
		 * 设置事件
		 */		
		private function setEvent():void
		{
			addEventListener(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE, characterDirectionChange);
			_playerVO.addEventListener(HotSpringRoomPlayerEvent.PLAYER_POS_CHANGE,__onplayerPosChangeImp);
			ChatManager.Instance.model.addEventListener(ChatEvent.ADD_CHAT,__getChat);
			ChatManager.Instance.addEventListener(ChatEvent.SHOW_FACE,__getFace);
		}
		
		private function __onplayerPosChangeImp(event:HotSpringRoomPlayerEvent):void
		{
			playerPoint = _playerVO.playerPos;
		}
		
		/**
		 * 当形象方向有改变时
		 */		
		private function characterDirectionChange(evt:SceneCharacterEvent):void
		{
			_playerVO.scenePlayerDirection=sceneCharacterDirection;
			if(Boolean(evt.data))
			{//行动状态下
				if(sceneCharacterDirection==SceneCharacterDirection.LT || sceneCharacterDirection==SceneCharacterDirection.RT)
				{
					if(sceneCharacterStateType=="natural")
					{//如当前为正常状态下
						sceneCharacterActionType="naturalWalkBack";//背面行走
					}
					else
					{//为水上状态下
						sceneCharacterActionType="waterBack";//非运动状态下背面行走
					}
				}
				else if(sceneCharacterDirection==SceneCharacterDirection.LB || sceneCharacterDirection==SceneCharacterDirection.RB)
				{
					if(sceneCharacterStateType=="natural")
					{//如当前为正常状态下
						sceneCharacterActionType="naturalWalkFront";//正面行走
					}
					else
					{//为水上状态下
						sceneCharacterActionType="waterFront";//正面行走
					}
				}
			}
			else
			{//站立状态下
				if(sceneCharacterDirection==SceneCharacterDirection.LT || sceneCharacterDirection==SceneCharacterDirection.RT)
				{
					if(sceneCharacterStateType=="natural")
					{//如当前为正常状态下
						sceneCharacterActionType="naturalStandBack";//背面站立
					}
					else
					{//为水上状态下
						sceneCharacterActionType="waterStandBack";//背面站立
					}
				}
				else if(sceneCharacterDirection==SceneCharacterDirection.LB || sceneCharacterDirection==SceneCharacterDirection.RB)
				{
					if(sceneCharacterStateType=="natural")
					{//如当前为正常状态下
						sceneCharacterActionType="naturalStandFront";//正面站立
					}
					else
					{//为水上状态下
						sceneCharacterActionType="waterFrontEyes";//正面站立
					}
				}
			}
		}
		
		/**
		 * 设置玩家默认方向
		 */
		public function set setSceneCharacterDirectionDefault(value:SceneCharacterDirection):void
		{
			if(value==SceneCharacterDirection.LT || value==SceneCharacterDirection.RT)
			{
				if(sceneCharacterStateType=="natural")
				{//如当前为正常状态下
					sceneCharacterActionType="naturalStandBack";//背面站立
				}
				else
				{//为水上状态下
					sceneCharacterActionType="waterStandBack";//背面站立
				}
			}
			else if(value==SceneCharacterDirection.LB || value==SceneCharacterDirection.RB)
			{
				if(sceneCharacterStateType=="natural")
				{//如当前为正常状态下
					sceneCharacterActionType="naturalStandFront";//正面站立
				}
				else
				{//为水上状态下
					sceneCharacterActionType="waterFrontEyes";//正面站立
				}
			}
		}
		
		public function updatePlayer():void
		{
			areaTest();
			characterMirror();
			setPlayer();
			playerWalkPath();
			update();
		}
		
		
		
		private function characterMirror():void
		{
			//形象镜像
			character.scaleX = sceneCharacterDirection.isMirror ? -1 : 1;
			character.x=sceneCharacterDirection.isMirror ? playerWitdh/2 : -playerWitdh/2;
			character.y=_playerVO.currentlyArea==1 ? -playerHeight+12 : -playerHeight+63;
		}
		
		/**
		 * 人物行走路径处理及发送行走命令
		 */		
		private function playerWalkPath():void
		{
			if(_walkPath != null && _walkPath.length > 0 && _playerVO.walkPath.length > 0 && _walkPath != _playerVO.walkPath)
			{
				fixPlayerPath();
			}
			if(_playerVO && _playerVO.walkPath && _playerVO.walkPath.length<=0 && !_tween.isPlaying)
			{
				return;
			}
			playerWalk(_playerVO.walkPath);
		}
		
		/**
		 * 玩家行走 
		 * @param walkPath 行走路径
		 * @param moveSpeed 行走速度
		 */			
		override public function playerWalk(walkPath:Array) : void
		{
			if(_walkPath != null && _tween.isPlaying && _walkPath == _playerVO.walkPath)return;
			_walkPath = _playerVO.walkPath;
			if(_walkPath.length>0)
			{
				_currentWalkStartPoint = _walkPath[0];
				sceneCharacterDirection = SceneCharacterDirection.getDirection(playerPoint,_currentWalkStartPoint);
				dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE, true));
				var dis:Number = Point.distance(_currentWalkStartPoint,playerPoint);
				_tween.start(dis/_moveSpeed, "x", _currentWalkStartPoint.x, "y", _currentWalkStartPoint.y);
				_walkPath.shift();
			}
			else
			{
				dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE, false));
			}
		}
		private function fixPlayerPath():void
		{
			if(_playerVO.currentWalkStartPoint == null)return;
			var startPointIndex:int = -1;
			for(var i:int = 0;i<_walkPath.length;i++)
			{
				if(_walkPath[i].x == _playerVO.currentWalkStartPoint.x && _walkPath[i].y == _playerVO.currentWalkStartPoint.y)
				{
					startPointIndex = i;
					break;
				}
			}
			if(startPointIndex > 0)
			{
				var lastPath:Array = _walkPath.slice(0,startPointIndex);
				_playerVO.walkPath = lastPath.concat(_playerVO.walkPath);
			}
		}
		
		private var _currentWalkStartPoint:Point;
		public function get currentWalkStartPoint():Point
		{
			return _currentWalkStartPoint;
		}
		
		/**
		 * 设置玩家在水中或陆地时相关信息
		 */		
		private function setPlayer():void
		{
			if(_playerVO.currentlyArea==2)
			{//在水中
				if(!_wavePlayerAsset)
				{
					_wavePlayerAsset=new WavePlayerAsset();
					_wavePlayerAsset.y = -playerHeight+63;
				}
				if(!_wavePlayerAsset.parent)
				{
					_wavePlayerAsset.gotoAndPlay(1);
					addChild(_wavePlayerAsset);
				}
				if(sceneCharacterDirection.isMirror)
				{
					_wavePlayerAsset.scaleX = _playerVO.playerInfo.Sex ? -1.1 : -1;
					if(sceneCharacterDirection==SceneCharacterDirection.LT || sceneCharacterDirection==SceneCharacterDirection.RT)
					{//背面方向
						_wavePlayerAsset.x = _playerVO.playerInfo.Sex ? playerWitdh/2+4 : playerWitdh/2-2;
					}
					else
					{
						_wavePlayerAsset.x = _playerVO.playerInfo.Sex ? playerWitdh/2+4 : playerWitdh/2;
					}
				}
				else
				{
					_wavePlayerAsset.scaleX = _playerVO.playerInfo.Sex ? 1.1 : 1;
					if(sceneCharacterDirection==SceneCharacterDirection.LT || sceneCharacterDirection==SceneCharacterDirection.RT)
					{//背面方向
						_wavePlayerAsset.x = _playerVO.playerInfo.Sex ? -playerWitdh/2-4 : -playerWitdh/2+2;
					}
					else
					{
						_wavePlayerAsset.x = _playerVO.playerInfo.Sex ? -playerWitdh/2-4 : -playerWitdh/2;
					}
				}
				
				if(_inWaterShowAsset) _inWaterShowAsset.y=-playerHeight+63;
				if(_spName) _spName.y=-playerHeight+63;
				if(_face) _face.y = -38;
				if(_chatBallView) _chatBallView.y = -playerHeight+90;
				addChildAt(_chatBallView, numChildren);
			}
			else
			{//在陆地区
				if(_wavePlayerAsset)
				{
					if(_wavePlayerAsset.parent) _wavePlayerAsset.parent.removeChild(_wavePlayerAsset);
					_wavePlayerAsset.gotoAndStop(1);
				}
				
				if(_inWaterShowAsset) _inWaterShowAsset.y=-playerHeight;
				if(_spName) _spName.y=-playerHeight+10;
				if(_face) _face.y = -90;
				if(_chatBallView) _chatBallView.y = -playerHeight+40;
				addChildAt(_chatBallView, numChildren);
			}
		}
		
		/**
		 * 出入水区域检测
		 */		
		private function areaTest():void
		{
			var nextState:int = HotSpringRoomView.getCurrentAreaType(x,y);
			if(nextState != _playerVO.currentlyArea)
			{
				playChangeStateMovie();
			}else
			{
				checkHidePlayerStageChangeMovie();
			}
			_playerVO.currentlyArea = nextState;
			refreshCharacterState();
		}
		
		private function playChangeStateMovie():void
		{
			if(_inWaterShowAsset)
			{
				if(_inWaterShowAsset.parent) _inWaterShowAsset.parent.removeChild(_inWaterShowAsset);
				_inWaterShowAsset=null;
			}
			
			character.visible=false;
			_spName.visible=false;
			_face.visible=false;
			if(_chatBallView && _chatBallView.parent) _chatBallView.parent.removeChild(_chatBallView);
			_inWaterShowAsset=new InWaterShowAsset();
			_inWaterShowAsset.x=-(playerWitdh/2);
			_inWaterShowAsset.y=-playerHeight;
			addChild(_inWaterShowAsset);
		}
		
		private function checkHidePlayerStageChangeMovie():void
		{
			if(_inWaterShowAsset)
			{
				if(_inWaterShowAsset.currentFrame >= _inWaterShowAsset.totalFrames)
				{
					showPlayer();
					if( _inWaterShowAsset.parent) _inWaterShowAsset.parent.removeChild(_inWaterShowAsset);
					_inWaterShowAsset=null;
				}
			}
		}
		
		public function refreshCharacterState():void
		{
			if(_playerVO.currentlyArea==1)
			{//如果玩家当前在水中，而下一个目的点是陆地
				sceneCharacterStateType="natural";//切换形象为正常状态
				if((sceneCharacterDirection==SceneCharacterDirection.LT || sceneCharacterDirection==SceneCharacterDirection.RT) && _tween.isPlaying)
				{
					sceneCharacterActionType="naturalWalkBack";
				}
				else if((sceneCharacterDirection==SceneCharacterDirection.LB || sceneCharacterDirection==SceneCharacterDirection.RB) && _tween.isPlaying)
				{
					sceneCharacterActionType="naturalWalkFront";
				}
			}
			else
			{//如果玩家当前在陆地，而下一个目的点是水中
				sceneCharacterStateType="water";//切换形象为水中状态
				
				if((sceneCharacterDirection==SceneCharacterDirection.LT || sceneCharacterDirection==SceneCharacterDirection.RT) && _tween.isPlaying)
				{
					sceneCharacterActionType="waterBack";
				}
				else if((sceneCharacterDirection==SceneCharacterDirection.LB || sceneCharacterDirection==SceneCharacterDirection.RB) && _tween.isPlaying)
				{
					sceneCharacterActionType="waterFront";
				}
			}
			moveSpeed=_playerVO.playerMoveSpeed;
		}
		
		/**
		 * 当出入水效果播放后的显示玩家处理
		 */		
		private function showPlayer():void
		{
			character.visible=_isShowPlayer;
			_spName.visible=_isShowName;
			_face.visible=true;
			if(_isChatBall)
			{
				addChildAt(_chatBallView, 0)
			}
			else
			{
				if(_chatBallView && _chatBallView.parent) _chatBallView.parent.removeChild(_chatBallView);
			}
		}
		
		private function __getChat(evt:ChatEvent):void
		{
			if(!_isChatBall || !evt.data)return;
			
			var data:ChatData = ChatData(evt.data).clone();
			if(!data) return;
			data.msg = Helpers.deCodeString(data.msg);
			if(data.channel == ChatInputView.PRIVATE || data.channel == ChatInputView.CONSORTIA){
				return;
			}
			if(data && _playerVO.playerInfo && data.senderID == _playerVO.playerInfo.ID)
			{
				_chatBallView.setText(data.msg, _playerVO.playerInfo.paopaoType);
			}
		}
		
		private function __getFace(evt:ChatEvent):void
		{
			var data:Object = evt.data;
			if(data["playerid"] == _playerVO.playerInfo.ID)
			{
				_face.setFace(data["faceid"]);
			}
		}
		
		/**
		 * 取得当前玩家信息
		 */		
		public function get playerVO():PlayerVO
		{
			return _playerVO;
		}
		
		/**
		 * 设置当前玩家信息
		 */		
		public function set playerVO(value:PlayerVO):void
		{
			_playerVO=value;
		}
		
		/**
		 * 取得是否显示玩家名称
		 */		
		public function get isShowName():Boolean
		{
			return _isShowName;
		}
		
		/**
		 * 设置是否显示玩家名称
		 */		
		public function set isShowName(value:Boolean):void
		{
			if(_isShowName==value || !_spName) return;
			_isShowName = value;
			_spName.visible=_isShowName;
		}
		
		/**
		 * 取得是否显示玩家聊天泡泡
		 */		
		public function get isChatBall():Boolean
		{
			return _isChatBall;
		}
		
		/**
		 * 设置是否显示玩家聊天泡泡
		 */		
		public function set isChatBall(value:Boolean):void
		{
			if(_isChatBall==value || !_chatBallView) return;
			_isChatBall = value;
			if(_isChatBall)
			{
				addChildAt(_chatBallView, 0)
			}
			else
			{
				if(_chatBallView) _chatBallView.parent.removeChild(_chatBallView);
			}
		}
		
		/**
		 *取得是否显示玩家 
		 */		
		public function get isShowPlayer():Boolean
		{
			return _isShowPlayer;
		}
		
		/**
		 *设置是否显示玩家
		 */		
		public function set isShowPlayer(value:Boolean):void
		{
			if(_isShowPlayer==value || !_isShowPlayer) return;
			_isShowPlayer = value;
			this.visible=_isShowPlayer;
		}
		
		public function get sceneScene():SceneScene
		{
			return _sceneScene;
		}
		
		public function set sceneScene(value:SceneScene):void
		{
			_sceneScene = value;
		}
		
		override public function dispose():void
		{
			removeEventListener(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE, characterDirectionChange);
			ChatManager.Instance.model.removeEventListener(ChatEvent.ADD_CHAT,__getChat);
			ChatManager.Instance.removeEventListener(ChatEvent.SHOW_FACE,__getFace);
			if(_playerVO) _playerVO.removeEventListener(HotSpringRoomPlayerEvent.PLAYER_POS_CHANGE,__onplayerPosChangeImp);
			
			if(_inWaterShowAsset && _inWaterShowAsset.parent) _inWaterShowAsset.parent.removeChild(_inWaterShowAsset);
			_inWaterShowAsset=null;
			
			if(_lblName && _lblName.parent) _lblName.parent.removeChild(_lblName);
			_lblName=null;
			
			if(_chatBallView)
			{
				_chatBallView.clear();
				if(_chatBallView.parent) _chatBallView.parent.removeChild(_chatBallView);
				_chatBallView.dispose();
			}
			_chatBallView=null;
			
			if(_face)
			{
				_face.clearFace();
				if(_face.parent) _face.parent.removeChild(_face);
				_face.dispose();
			}
			_face=null;
			
			if(_playerVO) _playerVO.dispose();
			_playerVO=null;
			
			if(_spName && _spName.parent) _spName.parent.removeChild(_spName);
			_spName=null;			
			
			super.dispose();
		}
	}
}