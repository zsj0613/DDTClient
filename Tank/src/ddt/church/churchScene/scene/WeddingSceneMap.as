package ddt.church.churchScene.scene
{
	import ddt.church.action.ActionType;
	import ddt.church.churchScene.fire.FireEffectItem;
	import ddt.church.churchScene.fire.FireView;
	import ddt.church.player.Direction;
	import ddt.church.player.Player;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	
	import road.data.DictionaryData;
	import road.manager.SoundManager;
	
	import tank.church.GuestLineAsset;
	import tank.church.KissMovie;
	import tank.church.Paopao;
	import ddt.data.ChurchRoomInfo;
	import ddt.events.ChurchRoomEvent;
	import ddt.manager.ChurchRoomManager;
	import ddt.manager.SocketManager;
	import ddt.utils.DisposeUtils;

	public class WeddingSceneMap extends SceneMap
	{
		private var father_read:MovieClip;
		private var father_com:MovieClip;

		private var bride:Player;
		private var groom:Player;
		
		public function WeddingSceneMap(scene:Scene,data:DictionaryData,bg:Sprite,mesh:Sprite,acticle:Sprite = null,sky:Sprite = null)
		{
			super(scene,data,bg,mesh,acticle,sky);
			
			SoundManager.Instance.playMusic("3002");
			
			initFather();
		}
		
		private function initFather():void
		{
			if(bgLayer!=null)
			{
				father_read = bgLayer.getChildByName("father_read") as MovieClip;
				father_com = bgLayer.getChildByName("father_com") as MovieClip;
				
				if(father_read)father_read.visible = false;
			}
		}
		
		public function fireImdily(pt:Point,type:uint,playSound:Boolean = false):void
		{
			if(type>1)return;
			var fireID:int = FireView.All_Fires[type];
			var fire:FireEffectItem = new FireEffectItem(fireID);
			fire.x = pt.x;
			fire.y = pt.y;
			addChild(fire);
			fire.fire(playSound);
		}
		
		private var dialogue:MovieClip;
		public function playWeddingMovie():void
		{
			bride = _characters[ChurchRoomManager.instance.currentRoom.brideID] as Player;
			groom = _characters[ChurchRoomManager.instance.currentRoom.groomID] as Player;
			
			bride.x = 715;
			bride.y = 1310;
			
			groom.x = 602;
			groom.y = 1308;
			
			rangeGuest();
			ajustScreen(bride);
			
			bride.addEventListener(ChurchRoomEvent.ARRIVED_NEXT_STEP,__arrive);
			
			bride.walk([new Point(1104,660)]);
			bride.Type = ActionType.WALK;
			groom.walk([new Point(1003,651)]);
			groom.Type = ActionType.WALK;
		}
		
		public function stopWeddingMovie():void
		{
			bride.x = 1094;
			bride.y = 743;
			bride.Dir = Direction.LB;
			
			ajustScreen(localPlayer);
			setCenter(null);

			if(father_read)father_read.visible = false;
			if(father_com)father_com.visible = true;
			
			hideDialogue(); 
			stopKissMovie();
			stopFireMovie();
			
			bride.removeEventListener(ChurchRoomEvent.ARRIVED_NEXT_STEP,__arrive);
		}
		/**
		 * 到达转身 
		 * @param event
		 * 
		 */		
		private function __arrive(event:ChurchRoomEvent):void
		{
			bride.removeEventListener(ChurchRoomEvent.ARRIVED_NEXT_STEP,__arrive);
			
			ajustScreen(null);
			
			bride.Dir = Direction.LB;
			groom.Dir = Direction.LB;
			
			playDialogue();
		}

		private var guestPos:Array;
		/**
		 * 排列宾客 
		 */		
		public function rangeGuest():void
		{
			getGuestPos();
			
			var playerArr:Array = _characters.list;
			playerArr.sortOn("ID",Array.NUMERIC);
			
			var j:uint;
			for(var i:uint;i<_characters.length;i++)
			{
				var player:Player = playerArr[i] as Player;
				if(ChurchRoomManager.instance.isAdmin(player.info.info))continue;
				
				if(j%2)
				{
					player.x = (guestPos[0][0] as Point).x;
					player.y = (guestPos[0][0] as Point).y;
					player.Dir = Direction.RT;
					(guestPos[0] as Array).shift();
				}else
				{
					player.x = (guestPos[1][0] as Point).x;
					player.y = (guestPos[1][0] as Point).y;
					player.Dir = Direction.LT;
					(guestPos[1] as Array).shift();
					
					if((guestPos[1] as Array).length == 0)
					{
						guestPos.shift();
						guestPos.shift();
					}
				}
				j++;
			}
		}
		
		private function getGuestPos():void
		{
			guestPos = [];
			
			var lineAsset:GuestLineAsset = new GuestLineAsset();
			addChild(lineAsset);
			
			var count:uint;
			for(var i:uint = 1;i<=8;i++)
			{
				if(i==1||i==2)
				{
					count = 19;
					guestPos.push(spliceLine(lineAsset["line"+i],count,false,false));
				}else if(i == 3||i==5||i==7)
				{
					count = 9;
					guestPos.push(spliceLine(lineAsset["line"+i],count,false,true));
				}else
				{
					count = 9;
					guestPos.push(spliceLine(lineAsset["line"+i],count,true,false));
				}
			}
			
			removeChild(lineAsset);
		}
		/**
		 * 以line x,y 为起点 
		 * @param line
		 * @param count 等份数量
		 * @param right 是否向右
		 * @param top 是否向上
		 * @return 
		 * 
		 */		
		private function spliceLine(line:DisplayObject,count:uint,right:Boolean,top:Boolean):Array
		{
			var stepX:Number = line.width/count;
			var stepY:Number = line.height/count;
			var dirX:int = right?1:-1;
			var dirY:int = top?-1:1;
			
			var arr:Array = [];
			for(var i:uint;i<=count;i++)
			{
				var point:Point = new Point();
				point.x = line.x + stepX*i*dirX;
				point.y = line.y + stepY*i*dirY;
				
				arr.push(point);
			}
			
			return arr;
		}
		
		private var frame:uint = 1;
		private var subObj:MovieClip;
		/**
		 * 神父泡泡动画 
		 */		
		private function playDialogue():void
		{
			if(father_read)father_read.visible = true;
			if(father_com)father_com.visible = false;
			
			dialogue = new Paopao();
			dialogue.x = 1039;
			dialogue.y = 370;
			addChild(dialogue);
			
			dialogue.stop();
			frame = 1;
			subObj = dialogue.getChildByName("subMovie") as MovieClip;
			addEventListener(Event.ENTER_FRAME,__updateDialogue);
			
		}
		
		private function __updateDialogue(event:Event):void
		{
			if(frame<=dialogue.totalFrames)
			{
				if(subObj.currentFrame == subObj.totalFrames)
				{
					clearnMCChildren();
					dialogue.nextFrame();
					
					if(frame<dialogue.totalFrames)
					{
						removeEventListener(Event.ENTER_FRAME,__updateDialogue);
						dialogue.addEventListener(Event.ENTER_FRAME,getChildFrameHander);
					}
					
					frame++;
				}
			}else
			{
				hideDialogue();
				
				/* 移动新人准备接吻 */
				readyForKiss();				
			}
		}
		
		private function readyForKiss():void
		{
			groom.Type = ActionType.WALK;
			groom.walk([new Point(1026,666)]);
			
			bride.Type = ActionType.WALK;
			bride.walk([new Point(1060,707),new Point(1044,694)]);
			
			playKissMovie();
			playFireMovie();
			
			ajustPosition();
		}
		
		private function ajustPosition():void
		{
			SocketManager.Instance.out.sendPosition(localPlayer.x,localPlayer.y);
		}
		
		private function clearnMCChildren():void
		{
			while(dialogue.numChildren > 0)
			{
				dialogue.removeChildAt(0);
			}
		}
		
		private function creatPlayerName(isMan:Boolean,xPos:Number,yPos:Number,mcParent:DisplayObjectContainer,width:Number):void
		{
			var field:TextField;
			if(isMan)
			{
				field = creatTextField(width);
				field.text = ChurchRoomManager.instance.currentRoom.groomName;
				field.autoSize = TextFieldAutoSize.CENTER;
			}else
			{
				field = creatTextField(width);
				field.text = ChurchRoomManager.instance.currentRoom.brideName;
				field.autoSize = TextFieldAutoSize.CENTER;
			}
			
			field.x = xPos+mcParent.x;
			field.y = yPos+mcParent.y;
			dialogue.addChild(field);
		}
		
		private function creatTextField($width:Number,color:int = 0):TextField
		{
			var textField:TextField = new TextField();
			var textFormat:TextFormat = new TextFormat(null,21,color,true);
			textFormat.align = TextFormatAlign.CENTER;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.defaultTextFormat = textFormat;
			textField.width = $width;
			return textField;
		}
		
		private function getChildFrameHander(e:Event):void
		{
			if(dialogue == null) return;
			if(dialogue.getChildByName("subMovie") as MovieClip)
			{
				subObj = dialogue.getChildByName("subMovie") as MovieClip;
				subObj.gotoAndPlay(1);
				if(dialogue.currentFrame == 3)
				{
					creatPlayerName(false,5,10,subObj,170);
				}else if(dialogue.currentFrame == 7)
				{
					creatPlayerName(true,2,7,subObj,170);
				}else if(dialogue.currentFrame == 22)
				{
					creatPlayerName(false,5,8,subObj,170);
					creatPlayerName(true,5,32,subObj,170);
				}
					
				
				dialogue.removeEventListener(Event.ENTER_FRAME,getChildFrameHander);
				addEventListener(Event.ENTER_FRAME,__updateDialogue);
			}
		}
		
		private function hideDialogue():void
		{
			if(dialogue)removeChild(dialogue);
			dialogue = null;
			removeEventListener(Event.ENTER_FRAME,__updateDialogue);
			
			if(father_read)father_read.visible = false;
			if(father_com)father_com.visible = true;
		}
		
		private var kissMovie:KissMovie;
		/**
		 * 接吻动画 
		 */		
		private function playKissMovie():void
		{
			kissMovie = new KissMovie();
			kissMovie.x = 1040;
			kissMovie.y = 610;
			addChild(kissMovie);
		}
		
		private function stopKissMovie():void
		{
			if(kissMovie)
			{
				removeChild(kissMovie);
				kissMovie = null;
			}
		}
			
		private var fireTimer:Timer;
		/**
		 * 播放烟花动画 
		 */	
		public function playFireMovie():void
		{
			fireTimer = new Timer(100);
			fireTimer.addEventListener(TimerEvent.TIMER,__fireTimer);
			fireTimer.start();
		}
		
		private function __fireTimer(event:TimerEvent):void
		{
			var pos:Point;
			var type:uint;
			var playSound:Boolean;
			
			pos = getFirePosition();
			type = Math.round(Math.random()*3);
			playSound = !(Math.round(Math.random()*9)%3)?true:false;
			
			fireImdily(pos,type,playSound);
		}
		
		private function getFirePosition():Point
		{
			var tempX:Number = Math.round(Math.random()*(1000-100))+50;
			var tempY:Number = Math.round(Math.random()*(600-100))+50;
			
			var point:Point;
			point = this.globalToLocal(new Point(tempX,tempY));
			
			return point;
		}
		
		private function __fireTimerComplete(event:TimerEvent):void
		{
			if(!fireTimer)return;
			fireTimer.stop();
			fireTimer.removeEventListener(TimerEvent.TIMER,__fireTimer);
			fireTimer = null
		}
		
		private function stopFireMovie():void
		{
			__fireTimerComplete(null);
		}
		
		override protected function __click(event:MouseEvent):void
		{
			if(ChurchRoomManager.instance.currentRoom.status == ChurchRoomInfo.WEDDING_ING)return;
			
			super.__click(event);
		}
		
		override public function dispose():void
		{
			if(dialogue)removeChild(dialogue);
			dialogue = null;
			removeEventListener(Event.ENTER_FRAME,__updateDialogue);
			
			stopKissMovie();
			stopFireMovie();
			
			DisposeUtils.disposeDisplayObject(father_read);
			DisposeUtils.disposeDisplayObject(father_com);
			
			super.dispose();
		}
	}
}