package ddt.church.churchScene.scene
{
	import ddt.church.action.ActionType;
	import ddt.church.churchScene.fire.FireEffectItem;
	import ddt.church.player.Player;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import road.data.DictionaryData;
	import road.data.DictionaryEvent;
	
	import tank.church.MouseClickMovie;
	import ddt.data.player.ChurchPlayerInfo;
	import ddt.events.ChurchRoomEvent;
	import ddt.manager.ChurchRoomManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.utils.DisposeUtils;

	public class SceneMap extends Sprite
	{
		public static const SCENE_ALLOW_FIRES:int = 6;
		private const CLICK_INTERVAL:Number = 200;

		//可交换层次物体层
		protected var articleLayer:Sprite;
		//不可行走区域层
		protected var meshLayer:Sprite;
		//背景层
		protected var bgLayer:Sprite;
		protected var skyLayer:Sprite;
		
		public var scene:Scene;
		protected var _data:DictionaryData;
		protected var _characters:DictionaryData;
		protected var localPlayer:Player;

		private var last_click:Number;
		
		private var current_display_fire:int = 0;
		private var mouseMovie:MouseClickMovie;
		private var mapWidth:Number;
		private var mapHeight:Number;
		
		public function SceneMap(scene:Scene,data:DictionaryData,bg:Sprite,mesh:Sprite,acticle:Sprite = null,sky:Sprite = null)
		{
			this.scene = scene;
			this._data = data;
			
			if(bg == null)
			{
				this.bgLayer = new Sprite();
			}else
			{
				this.bgLayer = bg;
			}

			this.meshLayer = mesh == null ? new Sprite() : mesh;
			this.meshLayer.alpha = 0;
			this.articleLayer = acticle == null ? new Sprite():acticle;
			this.skyLayer =  sky == null ? new Sprite():sky;
			
			this.addChild(meshLayer);
			this.addChild(bgLayer);
			this.addChild(articleLayer);
			this.addChild(skyLayer);
			
			this.mapWidth = scene.info.mapW;
			this.mapHeight = scene.info.mapH;
			
			init();
			addEvent();
		}
		
		protected function init():void
		{
			_characters = new DictionaryData(true);
			
			mouseMovie = new MouseClickMovie();
			mouseMovie.mouseChildren = false;
			mouseMovie.mouseEnabled = false;
			mouseMovie.stop();
			bgLayer.addChild(mouseMovie);
			
			last_click = 0;
		}
		
		protected function addEvent():void
		{
			ChurchRoomManager.instance.addEventListener(ChurchRoomEvent.ROOM_HIDE_NAME,__hideName);
			ChurchRoomManager.instance.addEventListener(ChurchRoomEvent.ROOM_HIDE_PAO,__hidePao);
			
			addEventListener(MouseEvent.CLICK,__click);
			addEventListener(Event.ENTER_FRAME,updateMap);
			
			_data.addEventListener(DictionaryEvent.ADD,__addPlayer);
			_data.addEventListener(DictionaryEvent.REMOVE,__removePlayer);
		}
		
		protected function __hideName(event:ChurchRoomEvent):void
		{
			for each(var p:Player in _characters)
			{
				p.setNameVisible(ChurchRoomManager.instance.isHideName);
			}
		}
		
		protected function __hidePao(event:ChurchRoomEvent):void
		{
			for each(var p:Player in _characters)
			{
				p.setPaoVisible(ChurchRoomManager.instance.isHidePao);
			}
		}
		
		protected function updateMap(event:Event):void
		{
			for each(var player:Player in _characters)
			{
				player.update();
			}

			BuildEntityDepth();
		}
		
		protected function __click(event:MouseEvent):void
		{
			var local:Point = this.globalToLocal(new Point(event.stageX,event.stageY));
			
			if(flash.utils.getTimer() - last_click > CLICK_INTERVAL)
			{
				last_click = flash.utils.getTimer();
				if(!scene.hit(local))
				{
					var path:Array = scene.searchPath(localPlayer.position,local);
					path.shift();
					
					if(path.length<=0)return;
					
					mouseMovie.x = local.x;
					mouseMovie.y = local.y;
					mouseMovie.play();
					sendMyPosition(path.concat());
					
					localPlayer.Type = ActionType.WALK;
					localPlayer.walk(path);
				}
			}
		}
		
		/**
		 * 发送自己的行走路径 
		 * @param p
		 */		
		public function sendMyPosition(p:Array):void
		{
			var arr:Array = [];
			
			for(var i:uint;i<p.length;i++)
			{
				arr.push(int(p[i].x),int(p[i].y));
			}
			var pathStr:String = arr.toString();
			SocketManager.Instance.out.sendChurchMove(p[p.length-1].x,p[p.length-1].y,pathStr);
		}
		
		public function useFire(id:int,fireID:int):void
		{
			if(_characters[id] == null) return;
			if(_characters[id])
			{
				if(_characters[id].isExcuteingFire && id == PlayerManager.Instance.Self.ID)return;
				var fire:FireEffectItem = new FireEffectItem(fireID);
				if(!ChurchRoomManager.instance.isHideFire)
				{
					fire.x = (_characters[id] as Player).x;
					fire.y = (_characters[id] as Player).y - 190;
					addChild(fire);
				}
				fire.owerID = id;
				fire.fire();
				if(id == PlayerManager.Instance.Self.ID)
				{
					fire.addEventListener(Event.COMPLETE,fireEnterFrameHandler);
					_characters[id].isExcuteingFire = true;
					ChurchRoomManager.instance.fireEnable = false;
					if(ChurchRoomManager.instance.isHideFire)
					{
						MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.churchScene.scene.SceneMap.lihua"));
						//MessageTipManager.getInstance().show("礼花效果已关闭");
					}
				}
			}
		}
		
		public function setSalute(id:int):void
		{
			
		}
		
		protected function fireEnterFrameHandler(e:Event):void
		{
			var fire:FireEffectItem = e.currentTarget as FireEffectItem;
			fire.removeEventListener(Event.COMPLETE,fireEnterFrameHandler);
			if(_characters[fire.owerID])
			{
				_characters[fire.owerID].isExcuteingFire = false;
				ChurchRoomManager.instance.fireEnable = true;
			}
			fire = null;
		}
		
		public function movePlayer(id:int,p:Array):void
		{
			if(_characters[id])
			{
				(_characters[id] as Player).Type = ActionType.WALK;
				(_characters[id] as Player).walk(p);
			}
		}
		
		public function setCenter(event:ChurchRoomEvent =null):void
		{
			var xf : Number = -(reference.x - 1000 / 2);
			var yf : Number = -(reference.y - 600 / 2)+50;
			
			if(xf > 0)xf = 0;
			if(xf < 1000 - scene.info.mapW)
				xf = 1000 - scene.info.mapW;
			if(yf > 0)yf = 0;
			if(yf < 600 - scene.info.mapH)
				yf = 600 - scene.info.mapH;
					
			x = xf;
			y = yf;
		}
		
		public function addLocalPlayer(localPos:Point = null) : void 
		{
			if(!localPlayer)
			{
				localPlayer = new Player(new ChurchPlayerInfo(PlayerManager.Instance.Self));
				localPlayer.x = localPos?localPos.x:scene.info.defaultX;
				localPlayer.y = localPos?localPos.y:scene.info.defaultY;
				
				ajustScreen(localPlayer);
				
				localPlayer.addEventListener(ChurchRoomEvent.ACTION_CHANGE,__actionChange);
				
				articleLayer.addChild(localPlayer);
				_characters.add(PlayerManager.Instance.Self.ID,localPlayer);
			}
		}
		
		protected function __actionChange(event:ChurchRoomEvent):void
		{
			if(localPlayer.Type == ActionType.STAND)
			{
				mouseMovie.gotoAndStop(1);
			}
		}
		
		protected var reference:Player;
		
		protected function ajustScreen(player:Player):void
		{
			if(player == null)
			{
				if(reference)
				{
					reference.removeEventListener(ChurchRoomEvent.MOVEMENT,setCenter);
					reference = null;
				}
				return;
			}
			
			if(reference)
			{
				reference.removeEventListener(ChurchRoomEvent.MOVEMENT,setCenter);
			}
			
			reference = player;
			reference.addEventListener(ChurchRoomEvent.MOVEMENT,setCenter);
		}

		protected function __addPlayer(event:DictionaryEvent) : void 
		{
			var info:ChurchPlayerInfo = event.data as ChurchPlayerInfo;
			var player:Player = new Player(info);
			
			player.x = info.posX;
			player.y = info.posY;
			
			articleLayer.addChild(player);
			_characters.add(info.info.ID,player);
			
		}
		
		protected function __removePlayer(event:DictionaryEvent):void
		{
			var id:int = (event.data as ChurchPlayerInfo).info.ID;
			var player:Player = _characters[id] as Player;
			
			if(player)
			{
				player.dispose();
			}
			
			_characters.remove(id);
		}
		
		/**
		 * 调整物品的层次  直接排序法
		 */
		protected function BuildEntityDepth() : void
		{
			var count : int = articleLayer.numChildren;
			for(var i : int = 0;i < count - 1;i++)
			{
				var obj : DisplayObject = articleLayer.getChildAt(i);
				var depth : Number = this.getPointDepth(obj.x, obj.y);
				
				var minIndex : int ;
				var minDepth : Number = Number.MAX_VALUE;
				for(var j : int = i + 1;j < count;j++)
				{
					var temp : DisplayObject = articleLayer.getChildAt(j);
					var tempDepth : Number = this.getPointDepth(temp.x, temp.y);
					
					if(tempDepth < minDepth)
					{
						minIndex = j;
						minDepth = tempDepth;
					}
				}
				
				if(depth > minDepth)
				{
					articleLayer.swapChildrenAt(i, minIndex);	
				}
			}
		}
		
		protected function getPointDepth(x : Number,y : Number) : Number
		{
			return mapWidth * y + x;
		}
		
		protected function removeEvent():void
		{
			removeEventListener(MouseEvent.CLICK,__click);
			removeEventListener(Event.ENTER_FRAME,updateMap);
			_data.removeEventListener(DictionaryEvent.ADD,__addPlayer);
			_data.removeEventListener(DictionaryEvent.REMOVE,__removePlayer);
			ChurchRoomManager.instance.removeEventListener(ChurchRoomEvent.ROOM_HIDE_NAME,__hideName);
			ChurchRoomManager.instance.removeEventListener(ChurchRoomEvent.ROOM_HIDE_PAO,__hidePao);
			
		}
		
		public function dispose():void
		{
			if(reference)
			{
				reference.removeEventListener(ChurchRoomEvent.MOVEMENT,setCenter);
			}
			if(localPlayer)
			{
				localPlayer.removeEventListener(ChurchRoomEvent.ACTION_CHANGE,__actionChange);
			}
			removeEvent();

			this.scene = null;
			
			if(scene)scene.dispose();
			scene = null;
			DisposeUtils.disposeDisplayObject(articleLayer);
			DisposeUtils.disposeDisplayObject(meshLayer);
			DisposeUtils.disposeDisplayObject(bgLayer);
			DisposeUtils.disposeDisplayObject(skyLayer);
			DisposeUtils.disposeDisplayObject(mouseMovie);

			if(this.parent)
			{
				this.parent.removeChild(this);
			}
			for each(var p:Player in _characters)
			{
				p.dispose();
			}
			_characters = null;
		}
		
		
	}
}