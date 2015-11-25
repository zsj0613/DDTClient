package ddt.church.player
{
	import ddt.church.action.ActionType;
	import ddt.church.churchScene.fire.FireEffectItem;
	import ddt.church.utils.MTween;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import road.manager.SoundManager;
	
	import tank.church.ChurchNameAsset;
	import tank.church.DefaultPlayerAsset;
	import ddt.data.ChurchRoomInfo;
	import ddt.data.player.ChurchPlayerInfo;
	import ddt.events.ChurchRoomEvent;
	import ddt.manager.ChatManager;
	import ddt.manager.ChurchRoomManager;
	import ddt.manager.LanguageMgr;
	import ddt.utils.Helpers;
	import ddt.view.chatsystem.ChatData;
	import ddt.view.chatsystem.ChatEvent;
	import ddt.view.chatsystem.ChatInputView;
	import ddt.view.common.ChatBallView;
	import ddt.view.common.FaceContainer;
	import ddt.church.player.Direction;
	
	public class BasePlayer extends Sprite
	{
		public var posX:Number;
		public var posY:Number;

		public var currentFrame:uint =0;
		
		public var tween:MTween;
		public var path:Array;
		
		public var _body:Bitmap;
		
		private var dir:Direction;
		private var actionType:ActionType;
		
		private var _info:ChurchPlayerInfo;
		private var loader:ChurchLoader;
		
		private var bitmapData:BitmapData;
		private var _bodyW:Number = 120;
		private var _bodyH:Number = 175;
		private var frames:Array = [];
		private var actualFrames:Array = [];
		private var _col:uint = 7;
		private var _row:uint = 2;
		/* 移动速度 */	
		private var speed:Number = 0.15;
		
		private var _nameTF:TextField;
		private var _nameView:Sprite;
		private var _chatballview:ChatBallView;
		
		private var _fireEffects:Array;
		
		public var isExcuteingFire:Boolean;
		
		private var _face:FaceContainer;
		
		public function get info():ChurchPlayerInfo
		{
			return _info;
		}
		
		public function BasePlayer(info:ChurchPlayerInfo = null)
		{
			this._info = info;
			
			init();
			addEvent();
		}
		private function init():void
		{
			actualFrames = [0,1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6];
			
			actionType = ActionType.STAND;
			dir = Direction.RB;

			//TODO
			tween = new MTween(this);
			
//			bitmapData = new BitmapData(_bodyW,_bodyH,true,0x00000000);
			bitmapData = new DefaultPlayerAsset(_bodyW,_bodyH);
			
			getFrames()
			
			_body = new Bitmap(bitmapData);
			_body.x = -_bodyW/2;
			_body.y = -_bodyH+20;
			addChild(_body);
		
//			new DrawPoint(this);

			_nameView = new Sprite();
			
			_nameTF = new ChurchNameAsset().name_txt;
			_nameTF.selectable = false;
			_nameTF.mouseEnabled = false;
			_nameTF.autoSize = TextFieldAutoSize.LEFT;
			_nameTF.text = _info?_info.info.NickName:"";
			var TFcolor:int;
			if(_info.info.ID == ChurchRoomManager.instance.currentRoom.brideID)
			{
				TFcolor = 0xFF98C5;
			}else if(_info.info.ID == ChurchRoomManager.instance.currentRoom.groomID)
			{
				TFcolor = 0x02FFFB;
			}else
			{
				TFcolor = 0x5BFF09;
			}
			
			_nameTF.setTextFormat(new TextFormat(LanguageMgr.GetTranslation("ddt.auctionHouse.view.BaseStripView.Font"),16,TFcolor,true));
			//_nameTF.setTextFormat(new TextFormat("宋体",16,TFcolor,true));
			
			_nameView.addChild(_nameTF);
			_nameView.graphics.beginFill(0x000000,0.5);
			_nameView.graphics.drawRoundRect(-4,0,_nameTF.width+8,22,5,5);
			_nameView.graphics.endFill();
			_nameView.x = -_nameView.width/2;
			_nameView.y = -_body.height;
			_nameView.visible = !ChurchRoomManager.instance.isHideName;
			addChild(_nameView);
			
			_chatballview = new ChatBallView();
			_chatballview.y = -_bodyW/2 + 4
			_chatballview.y = -_bodyH + 54;
			addChild(_chatballview);
			
			if(_info)
			{
				loader = new ChurchLoader(_info.info);
				loader.load(__characterLoaded);
			}
//			_fireEffects = [];
			
			
			_face = new FaceContainer(false);
			_face.y = -90;
			addChild(_face);
		}
		
		private function addEvent():void
		{
			tween.addEventListener(MTween.FINISH, __finish);
			tween.addEventListener(MTween.CHANGE, __change);
			
			ChatManager.Instance.model.addEventListener(ChatEvent.ADD_CHAT,__getChat);
			ChatManager.Instance.addEventListener(ChatEvent.SHOW_FACE,__getFace);			
		}
		
		private function __getChat(evt:ChatEvent):void
		{
			if(ChurchRoomManager.instance.isHidePao)return;
			var data:ChatData = ChatData(evt.data).clone();
			data.msg = Helpers.deCodeString(data.msg);
			if(data.channel == ChatInputView.PRIVATE || data.channel == ChatInputView.CONSORTIA){
				return;
			}
			if(data.senderID == _info.info.ID)
			{
				_chatballview.setText(data.msg,_info.info.paopaoType);
			}
		}
		
		private function __characterLoaded(loader:ChurchLoader):void
		{
			var bmd:BitmapData = loader.getContent()[0] as BitmapData;
			bitmapData = bmd;
			stand();

			if(loader != null)
			{
				loader.dispose();
				loader = null;
			}
		}
		
		public function setNameVisible(value:Boolean):void
		{
			_nameView.visible = !value;
		}
		
		public function setPaoVisible(value:Boolean):void
		{
			if(visible)
			{
				if(value)
				{
					if(_chatballview && _chatballview.parent)
					{
						removeChild(_chatballview);
					}
				}else
				{
					addChild(_chatballview);
				}
			}
		}
		
		public function get ID():int
		{
			return _info.info.ID;
		}
		
		public function get position():Point
		{
			return new Point(x,y);
		}
		
		public function set Type(type:ActionType):void
		{
			this.actionType = type;
			
			dispatchEvent(new ChurchRoomEvent(ChurchRoomEvent.ACTION_CHANGE,actionType));
		}
		
		public function get Type():ActionType
		{
			return this.actionType;
		}
		
		public function set Dir(dir:Direction):void
		{
			this.dir = dir;
			
			if(this.actionType == ActionType.STAND)
			{
				stand();
			}
		}
		
		private function __change(event:Event):void
		{
			dispatchEvent(new ChurchRoomEvent(ChurchRoomEvent.MOVEMENT,null));
		}
		/**
		 * 走下一步 
		 * @param event
		 */		
		private function __finish(event:Event):void
		{
			walk(path);
			dispatchEvent(new ChurchRoomEvent(ChurchRoomEvent.ARRIVED_NEXT_STEP));
		}

		public function update():void
		{
			if(actionType == ActionType.STAND)return;
			
			currentFrame++;
			if(currentFrame>18)currentFrame = 1;
			
			drawFrame(currentFrame);
		}
	
		public function walk(p : Array) : void {
			if(!ChurchRoomManager.instance.currentRoom)return;
			
			path = p;
			if(path.length>0) {
				dir = Direction.getDirection(new Point(this.x,this.y),path[0]);
				 
				var dis:Number = Point.distance(path[0] as Point,new Point(this.x,this.y));
				
				if(ChurchRoomManager.instance.currentRoom.status == ChurchRoomInfo.WEDDING_ING&&!ChurchRoomManager.instance.currentScene)
				{
					tween.start(dis/speed*2, "x", path[0].x, "y", path[0].y);
				}else
				{
					tween.start(dis/speed, "x", path[0].x, "y", path[0].y);
				}
				
				path.shift();
			} else {
				Type = ActionType.STAND;
				this.stand();
			}
		}
		
		public function stand():void
		{
			drawFrame(0);
			
			currentFrame = 1;
		}
		
		private function getFrames():Array
		{
			for(var i:uint=0;i<_row;i++)
			{
				var arr:Array = new Array();
				for(var j:uint=0;j<_col;j++)
				{
					var rec:Rectangle = new Rectangle(j*_bodyW,i*_bodyH,_bodyW,_bodyH);
					arr.push(rec);
				}
				frames.push(arr);
			}
			return frames;
		}
		
		public function drawFrame(frame:uint):void
		{
			if(bitmapData)
			{
				if(dir.isMirror)
				{
					_body.scaleX = -1;
					_body.x = _bodyW/2;
					_body.y = -_bodyH+20;
				}else
				{
					_body.scaleX = 1;
					_body.x = -_bodyW/2;
					_body.y = -_bodyH+20;
				}
				if(dir == Direction.LB || dir == Direction.LT)
				{
					_face.scaleX = 1;
				}
//				else
//				{
//					_face.scaleX = -1;
//				}
				
				
				_body.bitmapData.copyPixels(bitmapData,frames[dir.toward][actualFrames[frame]],new Point(0,0));
			}
		}

		public function hasFire():Boolean
		{
			return _fireEffects.length > 0;
		}
		
		public function setFire(fireItem:FireEffectItem):void
		{
			_fireEffects.push(fireItem);
		}
		
		public function excuteFire():void
		{
			isExcuteingFire = false;
			if(hasFire())
			{
				var fire:FireEffectItem = _fireEffects.shift();
				fire.addEventListener(Event.COMPLETE,onFireComplete);
				fire.fire();
				isExcuteingFire = true;
				fire.y = -100;
				addChild(fire);
				SoundManager.instance.play("117");
			}else
			{
				dispatchEvent(new ChurchPlayerEvent(ChurchPlayerEvent.FIRE_COMPLETE));
			}
		}
		
		private function onFireComplete(e:Event):void
		{
			isExcuteingFire = false;
			e.currentTarget.removeEventListener(Event.COMPLETE,onFireComplete);
			dispatchEvent(new ChurchPlayerEvent(ChurchPlayerEvent.FIRE_COMPLETE));
		}

		private function removeEvent():void
		{
			tween.removeEventListener(MTween.FINISH, __finish);
			tween.removeEventListener(MTween.CHANGE, __change);			
		}
		
		private function __getFace(evt:ChatEvent):void
		{
			if(_info == null)return;
			var data:Object = evt.data;
			if(data["playerid"] == _info.info.ID)
			{
				_face.setFace(data["faceid"]);
			}
		}
		
		public function dispose():void
		{
			if(loader)loader.dispose();
			if(tween)
			{
				tween.removeEventListener(MTween.FINISH, __finish);
				tween.removeEventListener(MTween.CHANGE, __change);
				tween.dispose();
				tween = null;
			}
			ChatManager.Instance.model.removeEventListener(ChatEvent.ADD_CHAT,__getChat);
			ChatManager.Instance.removeEventListener(ChatEvent.SHOW_FACE,__getFace);
			_face.clearFace();
			if(this.parent)parent.removeChild(this);
		}
		public function clearFace():void
		{
			if(_face != null)
			{
				_face.clearFace();
			}
			if(_chatballview != null)
				_chatballview.clear();
		}
	}
}