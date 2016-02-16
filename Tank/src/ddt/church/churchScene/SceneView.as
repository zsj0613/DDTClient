package ddt.church.churchScene{
	import ddt.church.churchScene.path.MapHitTester;
	import ddt.church.churchScene.scene.MoonSceneMap;
	import ddt.church.churchScene.scene.Scene;
	import ddt.church.churchScene.scene.SceneMap;
	import ddt.church.churchScene.scene.SceneMapInfo;
	import ddt.church.churchScene.scene.WeddingSceneMap;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import road.manager.SoundManager;
	import road.utils.ClassUtils;
	
	import ddt.data.ChurchRoomInfo;
	import ddt.data.player.ChurchPlayerInfo;
	import ddt.manager.ChatManager;
	import ddt.manager.ChurchRoomManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.utils.DisposeUtils;


	public class SceneView extends Sprite 
	{
		private var _controler:SceneControler;
		private var _model:SceneModel;
		
		private var _scene:Scene;
		private var _sceneMap:SceneMap;
		
		private var _sceneUI:SceneUI;
		private var _sceneMenu:SceneMenu;
		private var _sceneMask:SceneMask;
		private var chatFrame:Sprite;
		
		public function SceneView(controler:SceneControler,model:SceneModel) {
			this._controler = controler;
			this._model = model;
			
			init();
		}
		
		private function init():void
		{
			_controler.addChild(this);
			
			_scene = new Scene();			
			
			_sceneUI = new SceneUI(_controler);
			addChild(_sceneUI);
			
			_sceneMenu = new SceneMenu(_controler,_model);
			addChild(_sceneMenu);
			
			setMap();
			
			//TODO  测试用
//		    var btn:DrawPoint = new DrawPoint(this,500,50);
//			btn.addEventListener(MouseEvent.CLICK,__click);
			
			ChatManager.Instance.state = ChatManager.CHAT_CHURCH_CHAT_VIEW;
			chatFrame = ChatManager.Instance.view;
			addChild(chatFrame);
			
			chatFrame.addEventListener(Event.ADDED_TO_STAGE,__setFocus);
		}
		
		private function __setFocus(event:Event):void
		{
			ChatManager.Instance.setFocus();
			chatFrame.removeEventListener(Event.ADDED_TO_STAGE,__setFocus);
		}
		
		/**
		 * 设置地图 
		 * @param mapInfo
		 * @param isWeddingMap  是否主婚礼地图
		 */		
		public function setMap(localPos:Point = null):void
		{
			clearMap();
			
			var mapRes:MovieClip = ClassUtils.CreatInstance(getMapRes()) as MovieClip;
			
			var entity:Sprite = mapRes.getChildByName("entity") as Sprite;
			var sky:Sprite = mapRes.getChildByName("sky") as Sprite;
			var mesh:Sprite = mapRes.getChildByName("mesh") as Sprite;
			var bg:Sprite = mapRes.getChildByName("bg") as Sprite;

			_scene.info = getSceneMapInfo();
			_scene.setHitTester(new MapHitTester(mesh));
			
			if(!_sceneMap)
			{
				_sceneMap = ChurchRoomManager.instance.currentScene?new MoonSceneMap(_scene,_model.getPlayers(),bg,mesh,entity,sky):new WeddingSceneMap(_scene,_model.getPlayers(),bg,mesh,entity,sky);
				addChildAt(_sceneMap,0);
			}
			
			_sceneUI.reset();
			_sceneMenu.reset();
			_sceneMap.addLocalPlayer(localPos);
			_sceneMap.setCenter();
		}
		
		//TODO 预留
		public function getSceneMapInfo():SceneMapInfo
		{
			var info:SceneMapInfo = new SceneMapInfo();
			
			if(ChurchRoomManager.instance.currentScene)
			{
				info.mapName = "月光场景";
				info.mapW = 1208;
				info.mapH = 835;
				info.defaultX = 800;
				info.defaultY = 763;	
			}
			return info;
		} 
		
		public function getMapRes():String
		{
			return ChurchRoomManager.instance.currentScene?"ddt.church.Map02":"ddt.church.Map01";
		}

		public function useFire(id:int,fireID:int):void
		{
			_sceneMap.useFire(id,fireID);
		}
		
		public function setSaulte(id:int):void
		{
			_sceneMap.setSalute(id);
		}
		
		private function __click(event:MouseEvent):void
		{
//			for(var i:uint; i<15;i++)
//			{
//				var playerInfo:PlayerInfo = new PlayerInfo();
//				playerInfo.NickName = "测试账号"+i;
//				playerInfo.ID = 9999+i;
//				playerInfo.Style = PlayerManager.Instance.Self.Style;
//				var info:ChurchPlayerInfo = new ChurchPlayerInfo(playerInfo);
//				
//				_model.addPlayer(info);
//			}
			
//			_sceneMap.playFireMovie();
			
//			_sceneMap.rangeGuest();
//			ChurchRoomManager.instance.currentRoom.isStarted = true;
//			ChurchRoomManager.instance.currentRoom.status = ChurchRoomInfo.WEDDING_ING;

			ChurchRoomManager.instance.currentScene = true;
		}
		
		public function playerWeddingMovie():void
		{
			this.swapChildren(_sceneMask,_sceneMenu);
			addChild(chatFrame);
			(_sceneMap as WeddingSceneMap).playWeddingMovie();
		}
		
		public function switchWeddingView():void 
		{
			if(ChurchRoomManager.instance.currentRoom.status == ChurchRoomInfo.WEDDING_ING)
			{
				SoundManager.Instance.stopMusic();
				readyStartWedding();
			}else
			{
				_sceneUI.revertConfig();

				_sceneMask.showMaskMovie();
				_sceneMask.addEventListener(SwitchMovie.SWITCH_COMPLETE,__stopWeddingMovie);
			}
			
			_sceneUI.reset();
		}
		
		private function __stopWeddingMovie(event:Event):void
		{
			SoundManager.Instance.playMusic("3002");
			MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.churchScene.SceneView.stopWeddingMovie"));
			//MessageTipManager.getInstance().show("典礼现在结束");
			(_sceneMap as WeddingSceneMap).stopWeddingMovie();
			_sceneMask.removeEventListener(SwitchMovie.SWITCH_COMPLETE,__stopWeddingMovie);
			_sceneMask.dispose();
		}
		
		private function readyStartWedding():void
		{
			_sceneMask = new SceneMask(_controler);
			_sceneMask.addEventListener(SwitchMovie.SWITCH_COMPLETE,__playWeddingMovie);
			addChild(_sceneMask);
		}
		
		private var preHides:Array = [];
		
		private function __playWeddingMovie(event:Event):void
		{
			playerWeddingMovie();
			
			_sceneUI.backupConfig();

			_sceneMask.removeEventListener(SwitchMovie.SWITCH_COMPLETE,__playWeddingMovie);
		}
		
		public function movePlayer(id:int,p:Array):void
		{
			if(_sceneMap)
			{
				_sceneMap.movePlayer(id,p);
			}
		}

		/**
		 * 清除地图 
		 */		
		private function clearMap():void
		{
			if(!_sceneMap)return;
			_sceneMap.dispose();
			_sceneMap = null;
		}

		public function dispose():void
		{
			if(_sceneMask)_sceneMask.removeEventListener(SwitchMovie.SWITCH_COMPLETE,__playWeddingMovie);
			if(chatFrame)chatFrame.removeEventListener(Event.ADDED_TO_STAGE,__setFocus);
			if(chatFrame&&chatFrame.parent)chatFrame.parent.removeChild(chatFrame);
			chatFrame = null;
			_controler = null;
			_model = null;
			
			if(_sceneUI)_sceneUI.dispose();
			_sceneUI = null;
			
			if(_sceneMenu)_sceneMenu.dispose()
			_sceneMenu = null;
			
			if(_scene)
			{
				_scene.dispose();
				_scene = null;
			}
			
			if(_sceneMap && _sceneMap.parent)_sceneMap.parent.removeChild(_sceneMap);
			if(_sceneMap)_sceneMap.dispose();
			_sceneMap = null;
			if(_sceneMask && _sceneMask.parent)_sceneMask.parent.removeChild(_sceneMask);
			if(_sceneMask)_sceneMask.dispose();
			_sceneMask= null;
			
			DisposeUtils.disposeDisplayObject(chatFrame);
			if(this.parent)this.parent.removeChild(this);
		}
	}
}
