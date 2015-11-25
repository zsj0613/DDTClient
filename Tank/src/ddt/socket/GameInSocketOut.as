package ddt.socket
{
	import flash.geom.Point;
	
	import road.comm.ByteSocket;
	import road.comm.PackageOut;
	
	import ddt.data.socket.CrazyTankPackageType;
	import ddt.data.socket.ePackageType;
	import ddt.manager.SocketManager;
	
	/**
	 * 游戏中发送socket 
	 * @author SYC
	 * 
	 */	
	public class GameInSocketOut
	{
		private static var _socket:ByteSocket = SocketManager.Instance.socket;
		
		public function GameInSocketOut()
		{
		}
		
		/**
		 *获取全部房间列表 
		 * 
		 */		
		public static function sendGetAllRoom():void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_ROOM_LIST);
			sendPackage(pkg);
		}
		
		public static function sendGetScenePlayer(index:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.SCENE_USERS_LIST);
			pkg.writeByte(index);
			pkg.writeByte(6);
			sendPackage(pkg);
		}
		
		public static function sendInviteGame(playerid:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_INVITE);
			pkg.writeInt(playerid);
			sendPackage(pkg);
		}
		
		
		/**********************************道具**********************************************/
		public  static function sendBuyProp(id:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.PROP_BUY);
			pkg.writeInt(id);
			sendPackage(pkg);
		}
		
		public  static function sendSellProp(id:int,GoodsID:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.PROP_SELL);
			pkg.writeInt(id);
			pkg.writeInt(GoodsID);
			sendPackage(pkg);
		}
		
		public static function sendGameRoomSetUp(id:int,type:int,secondType:int = 2,permission:int=0,levelLimits:int=0,allowCrossZone:Boolean = false):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_ROOM_SETUP_CHANGE);
			pkg.writeInt(id);
			pkg.writeByte(type);
			pkg.writeByte(secondType);
			pkg.writeByte(permission);//难度
			pkg.writeInt(levelLimits);
			pkg.writeBoolean(allowCrossZone);
			sendPackage(pkg);
		}
		
		/**
		 *创建房间 
		 * @param name
		 * @param roomType
		 * @param gameMode
		 * @param timeType
		 * @param pass
		 * 
		 */		
		public static function sendCreateRoom(name:String,roomType:int,timeType:int = 2,pass:String = ""):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_ROOM_CREATE);
			pkg.writeByte(roomType);
			pkg.writeByte(timeType);
			pkg.writeUTF(name);
			pkg.writeUTF(pass);
			sendPackage(pkg);
		}
		
		/**
		 * 踢人或者关闭或者打开 
		 * 
		 */		
		public  static function sendGameRoomPlaceState(index:int,isOpened:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_ROOM_UPDATE_PLACE);
			pkg.writeByte(index);
			pkg.writeInt(isOpened);
			sendPackage(pkg);
		}
		
		public static function sendGameRoomKick(index:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_ROOM_KICK);
			pkg.writeByte(index);
			sendPackage(pkg);
		}
		
		/**
		 * 自己退出房间列表
		 * 
		 */		
		public static function sendExitScene():void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.SCENE_REMOVE_USER);
			sendPackage(pkg);
		}
		
		/**
		 * 用户退出房间 
		 * 
		 */		
		public static function sendGamePlayerExit():void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_ROOM_REMOVEPLAYER);
			sendPackage(pkg);
		}
		
		/**
		 *组队 
		 * @param team
		 * 
		 */	
		public static function sendGameTeam(team:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_TEAM);
			pkg.writeByte(team);
			sendPackage(pkg);
		}
		
		/**
		 * 发送夺旗
		 * 
		 */		
		public static function sendFlagMode(flag:Boolean):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
			pkg.writeByte(CrazyTankPackageType.WANNA_LEADER);
			pkg.writeBoolean(flag);
			sendPackage(pkg);
		}
		
		/**
		 * 游戏开始 
		 * 
		 */		
		public static function sendGameStart():void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_START);
			sendPackage(pkg);
		}
		/**
		 * 开始下一关副本
		 */
		 public static function sendGameMissionStart(isStart : Boolean):void
		{
//			var pkg:PackageOut = new PackageOut(ePackageType.GAME_MISSION_START);
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
			pkg.writeByte(CrazyTankPackageType.GAME_MISSION_START);
			pkg.writeBoolean(isStart);
			sendPackage(pkg);
		}
		
		/**
		 * 关卡结算准备
		 * @param place
		 * @param isRead
		 * @return 
		 * 
		 */		
		public static function sendGameMissionPrepare(place:int,isRead:Boolean):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
			pkg.writeByte(CrazyTankPackageType.GAME_MISSION_PREPARE);
//			pkg.writeInt(place);
			pkg.writeBoolean(isRead);
			sendPackage(pkg);
		}

		/**
		 * 发送加载进度 
		 * @param progress
		 * 
		 */		
		public static function sendLoadingProgress(progress:Number):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
			pkg.writeByte(CrazyTankPackageType.LOAD);
			pkg.writeInt(progress);
			sendPackage(pkg);
		}
		
		/**
		 * 玩家准备和取消，加载完成(1,0,2) 
		 * @param ready
		 * 
		 */		
		public static function sendPlayerState(ready:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_PLAYER_STATE_CHANGE);
			pkg.writeByte(ready);
			sendPackage(pkg);
		}
		

		/**
		 * 子弹爆炸 
		 * @param x
		 * @param y
		 * 
		 */		
		public  static function sendGameCMDBlast(id:int,x:int,y:int,t:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
			pkg.writeByte(CrazyTankPackageType.BLAST);
			pkg.writeInt(id);
			pkg.writeInt(x);
			pkg.writeInt(y);
			pkg.writeInt(t);
			sendPackage(pkg);
		}
		
		public static function sendGameCMDChange(id:int,bombPosX:int,bombPosY:int,vx:int,vy:int):void
		{
			//trace("改变点:",bombPosX,bombPosY,vx,vy)
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
			pkg.writeByte(CrazyTankPackageType.CHANGEBALL);
			pkg.writeInt(id);
			pkg.writeInt(bombPosX);
			pkg.writeInt(bombPosY);
			pkg.writeInt(vx);
			pkg.writeInt(vy);
			sendPackage(pkg);
		}
		
		/**
		 * 改变方向 
		 * @param direction
		 * 
		 */		
		public static function sendGameCMDDirection(direction:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
			pkg.writeByte(CrazyTankPackageType.DIRECTION);
			pkg.writeInt(direction);
			sendPackage(pkg);
		}
		
		/**
		 * 必杀 
		 * 
		 */		
		public  static function sendGameCMDStunt():void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
			pkg.writeByte(CrazyTankPackageType.STUNT);
			sendPackage(pkg);
		}
		
		/**
		 * 发射子弹　 
		 *(炸弹数量，炸弹id,发射点x,发射点y,x速度，y速度)
		 */		
		public static function sendGameCMDShoot(x:int,y:int,force:int,angle:int):void //vx:int,vy:int):void
		{	
 			var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
			pkg.writeByte(CrazyTankPackageType.FIRE);
			pkg.writeInt(int(x));
			pkg.writeInt(int(y));
			pkg.writeInt(int(force));
			pkg.writeInt(int(angle));
			sendPackage(pkg);
		}

		/**
		 * 跳过 
		 * @param time
		 * 
		 */		
		public  static function sendGameSkipNext(time:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
			pkg.writeByte(CrazyTankPackageType.SKIPNEXT);
			pkg.writeByte(time);
			sendPackage(pkg);
		}
		
		/**
		 * 开始移动 
		 * 0 爬行 1 掉落 2 鬼魂飘动 3 服务器
		 */		
		public static function sendGameStartMove(type:Number,x:int,y:int,dir:Number,isLiving:Boolean,turnIndex:Number):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
			pkg.writeByte(CrazyTankPackageType.MOVESTART);
			pkg.writeByte(type);
			pkg.writeInt(x);
			pkg.writeInt(y);
			pkg.writeByte(dir);
			pkg.writeBoolean(isLiving);
			pkg.writeShort(turnIndex);
			sendPackage(pkg);
		}
		
		/**
		 * 停止移动 
		 * isUser 对模拟客端起作用 true:模拟客户端执行相应的代码否不执行
		 */		
		public static function sendGameStopMove(posX:int,posY:int,isUser:Boolean):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
			pkg.writeByte(CrazyTankPackageType.MOVESTOP);
			pkg.writeInt(posX);
			pkg.writeInt(posY);
			pkg.writeBoolean(isUser);
			sendPackage(pkg);
		}
		
		/**
		 * 游戏中点箱子 
		 * @param place
		 * 
		 */		
		public static function sendGameTakeOut(place:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
			pkg.writeByte(CrazyTankPackageType.TAKE_CARD);
			pkg.writeByte(place);
			sendPackage(pkg);
		}
		
		public static function sendBossTakeOut(place:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
			pkg.writeByte(CrazyTankPackageType.BOSS_TAKE_CARD);
			pkg.writeByte(place);
			sendPackage(pkg);
		}
		
		/**
		 * 将战利品移动背包中 
		 * 
		 */		
		public static function sendGetTropToBag(place:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_TAKE_TEMP);
			pkg.writeInt(place);
			sendPackage(pkg);
		}
		
		public static function sendShootTag(b:Boolean,time:int = 0):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
			pkg.writeByte(CrazyTankPackageType.FIRE_TAG);
			pkg.writeBoolean(b);
			if(b)
			{
				pkg.writeByte(time);
			}
			sendPackage(pkg);
		}
		
		public static function sendBeat(x:Number,y:Number,angle:Number):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
			pkg.writeByte(CrazyTankPackageType.BEAT);
			pkg.writeShort(x);
			pkg.writeShort(y);
			pkg.writeShort(angle);
			sendPackage(pkg);
			
		}
		
		public static function sendThrowProp(place:int):void
		{
			var pkg:PackageOut = new PackageOut(CrazyTankPackageType.PROP_DELETE);
			pkg.writeInt(place);
			sendPackage(pkg);
		}
		
		/**
		 * 使用道具 
		 * @param place
		 *  type：道具栏的种类 1 为背包中 2为道具栏中
		 * 	place:道具栏的位置
		 */	
		public static function sendUseProp(type:int,place:int,tempid:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
			pkg.writeByte(CrazyTankPackageType.PROP);
			pkg.writeByte(type);
			pkg.writeInt(place);
			pkg.writeInt(tempid);
			sendPackage(pkg);
		}

		/**
		 * 取消戳和
		 * 
		 */
		 public static function sendCancelWait():void
		 {
		 	var pkg:PackageOut = new PackageOut(ePackageType.GAME_PICKUP_CANCEL);
		 	sendPackage(pkg); 	
		 }
		 
		 //公会战 or 自由战
		 public static function sendGameStyle(style:int):void
		 {
		 	var pkg:PackageOut = new PackageOut(ePackageType.GAME_PICKUP_STYLE);
			pkg.writeInt(style);
			sendPackage(pkg);	
		 }
		 
		 public static function sendGhostTarget(pos:Point):void
		 {
		 	var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
		 	pkg.writeByte(CrazyTankPackageType.GHOST_TARGET);
		 	pkg.writeInt(pos.x);
		 	pkg.writeInt(pos.y);
		 	sendPackage(pkg);
		 }
		 /**
		  * 付费翻牌
		  * @param place
		  * 
		  */		 
		 public static function sendPaymentTakeCard(place:int):void
		 {
		 	var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
		 	pkg.writeByte(CrazyTankPackageType.PAYMENT_TAKE_CARD);
		 	pkg.writeByte(place);
		 	sendPackage(pkg);
		 }
		 
		 /**
		  * 关卡失败，再试一次
		  * @param tryAgain
		  * 
		  */		 
		 public static function sendMissionTryAgain(tryAgain:Boolean,isHost:Boolean):void
		 {
		 	var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
		 	pkg.writeByte(CrazyTankPackageType.GAME_MISSION_TRY_AGAIN);
		 	pkg.writeBoolean(tryAgain);
		 	pkg.writeBoolean(isHost);
		 	sendPackage(pkg);
		 }
		 
		public static function sendFightLibInfoChange(id:int,difficult:int=-1):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
			pkg.writeByte(CrazyTankPackageType.FIGHT_LIB_INFO_CHANGE);
			pkg.writeInt(id);
			pkg.writeInt(difficult);
			sendPackage(pkg);
		}
		
		/**
		 *发送跳过剧情动画 
		 * 
		 */		
		public static function sendPassStory():void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
			pkg.writeByte(CrazyTankPackageType.PASS_STORY);
			pkg.writeBoolean(true);
			sendPackage(pkg);
		}
		
		/**
		 *战斗实验室相关 
		 * 
		 */		
		/**
		 *通知服务器客户端开始执行脚本 
		 * 控制权交给客户端
		 */		
		public static function sendClientScriptStart():void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
			pkg.writeByte(CrazyTankPackageType.GENERAL_COMMAND);
			pkg.writeInt(3);
			sendPackage(pkg);
		}
		/**
		 *通知服务器客户端脚本执行完毕 
		 * 控制权交给服务器
		 */		
		public static function sendClientScriptEnd():void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
			pkg.writeByte(CrazyTankPackageType.GENERAL_COMMAND);
			pkg.writeInt(2);
			sendPackage(pkg);
		}
		/**
		 * 发送答案 
		 * @param questionID
		 * @param answerID
		 * 
		 */		
		public static function sendFightLibAnswer(questionID:int,answerID:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
			pkg.writeByte(CrazyTankPackageType.GENERAL_COMMAND);
			pkg.writeInt(4);
			pkg.writeInt(questionID);
			pkg.writeInt(answerID);
			sendPackage(pkg);
		}
		/**
		 * 重新开始回答问题 
		 * 
		 */		
		public static function sendFightLibReanswer():void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
			pkg.writeByte(CrazyTankPackageType.GENERAL_COMMAND);
			pkg.writeInt(5);
			sendPackage(pkg);
		}
		 		 
		/*************************************************************************************************************/
		private static function sendPackage(pkg:PackageOut):void
		{
			//crazyTank.output.text += "发送数据:" + ByteUtils.ToHexDump("Receive Pkg:",pkg,0,pkg.length) + "\n"
			//Debug.trace("发送数据:" + ByteUtils.ToHexDump("Receive Pkg:",pkg,0,pkg.length) + "\n");
			_socket.send(pkg);
		}
	}
}