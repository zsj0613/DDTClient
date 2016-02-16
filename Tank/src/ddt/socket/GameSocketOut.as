package ddt.socket
{
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	import road.comm.ByteSocket;
	import road.comm.PackageOut;
	import road.comm.SocketEvent;
	import road.math.randRange;
	
	import ddt.data.AccountInfo;
	import ddt.data.ChurchRoomInfo;
	import ddt.data.CrytoHelper;
	import ddt.data.socket.ChurchPackageType;
	import ddt.data.socket.CrazyTankPackageType;
	import ddt.data.socket.HotSpringPackageType;
	import ddt.data.socket.ePackageType;
	import ddt.manager.MailManager;
	import ddt.manager.PlayerManager;
	import ddt.utils.LeavePage;
	
	
	public class GameSocketOut
	{
		private var _socket:ByteSocket;
		
		public function GameSocketOut(socket:ByteSocket)
		{
			_socket = socket;
		}
		
		public  function sendLogin(acc:AccountInfo):void
		{
			var date:Date = new Date();
			var temp:ByteArray = new ByteArray();
			var fsm_key:int = randRange(100,10000);
			temp.writeShort(date.fullYearUTC);
			temp.writeByte(date.monthUTC + 1);
			temp.writeByte(date.dateUTC);
			temp.writeByte(date.hoursUTC);
			temp.writeByte(date.minutesUTC);
			temp.writeByte(date.secondsUTC);
			temp.writeShort(fsm_key);
			temp.writeUTFBytes(acc.Account+","+acc.Password);
			temp = CrytoHelper.rsaEncry5(acc.Key,temp);
			temp.position = 0;
			var pkg:PackageOut = new PackageOut(ePackageType.LOGIN);
			pkg.writeInt(Version.Build);
			pkg.writeInt(LeavePage.GetClientType());
			pkg.writeBytes(temp);
			sendPackage(pkg);
			
			_socket.setFsm(fsm_key,Version.Build);
		}
		
		
		/**
		 * 进入房间 0指定房进入  FREE = 1,
        BLANCE = 2,
        LUMP = 3,
        FLAG = 4,
        NOBLANCE = 5,
        NOFLAG = 6,
		 * hallType  大厅类型 1为PvP  2为pve
		 */		
		public  function sendGameLogin(hallType:int , isRnd:int,roomId:int = -1,pass:String = "" , isInvite:Boolean = false):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_ROOM_LOGIN);
			pkg.writeBoolean(isInvite);
			pkg.writeInt(hallType);
			pkg.writeInt(isRnd);
			if(isRnd == -1)
			{
				pkg.writeInt(roomId);
				pkg.writeUTF(pass);
			}
			sendPackage(pkg);
		}
		
		/**
		 * 返回房间列表 1PvP  2PvE
		 * 
		 */		
		public function sendSceneLogin(hellType:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.SCENE_LOGIN);
			pkg.writeInt(hellType);
			sendPackage(pkg);
		}
		
		/**
		 * 领取当日奖励
		 */
		public function sendDailyAward(getWay:int) : void
		{
			var pkg : PackageOut = new PackageOut(ePackageType.DAILY_AWARD);
			pkg.writeInt(getWay);
			sendPackage(pkg);
		}
		
		/**
		 * 玩家购买物品 
		 * @param id 物品的模板ID
		 * @param account 物品的类型
		 * @param buyFrom 0:放到普通背包里面
		 * 				  1：在强化页面买的东西
		 * 				  2：在合成页面买的东西
		 * 				  3: 在聊天框弹出的购买
		 *  			  4: 在熔炼页面买的东西
		 * 此方法的包长度超过60个物品就会造成服务器丢包，因此超过六十就分批次发过去
		 */		
		public  function sendBuyGoods(items:Array,types:Array,colors:Array,places:Array,dresses:Array,skin:Array = null,buyFrom:int = 0):void
		{
			if(items.length>50)
			{
				sendBuyGoods(items.splice(0,50),types.splice(0,50),colors.splice(0,50),places.splice(0,50),dresses.splice(0,50),skin.splice(0,50),buyFrom);
				sendBuyGoods(items,types,colors,places,dresses,skin,buyFrom);
				return;
			}
			var pkg:PackageOut = new PackageOut(ePackageType.BUY_GOODS);
			var count:int = items.length;
			pkg.writeInt(count);
			
			for(var i:uint =0;i<count;i++)
			{
				pkg.writeInt(items[i]);
				pkg.writeInt(types[i]);
				pkg.writeUTF(colors[i]);
				pkg.writeBoolean(dresses[i]);
				if(skin == null)
				{
					pkg.writeUTF("");
				}else
				{
					pkg.writeUTF(skin[i]);
				}
				pkg.writeInt(places[i]);
			}
			pkg.writeInt(buyFrom);
			
			sendPackage(pkg);
		}
		
		/**
		 *购买金币箱并直接兑换成金币 
		 * @param buyNumber 金币箱数量
		 * 
		 */		
		public function sendQuickBuyGoldBox(buyNumber:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.BUY_QUICK_GOLDBOX);
			pkg.writeInt(buyNumber);
			sendPackage(pkg);
		}
		
		/**
		 * 购买优惠大礼包
		 * type  1铁匠铺优惠大礼包
		 */
		 public function sendBuyGiftBag(type:int):void{
		 	var pkg:PackageOut = new PackageOut(ePackageType.BUY_GIFTBAG);
		 	pkg.writeInt(type);
		 	sendPackage(pkg);
		 }
		
		/**
		 * 赠送物品 
		 * @param ids
		 * @param types
		 * @param colors
		 * @param msg
		 * @param nick
		 * @param skin
		 * 
		 */		
		public  function sendPresentGoods(ids:Array,types:Array,colors:Array,msg:String,nick:String,skin:Array = null):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GOODS_PRESENT);
			var count:int = ids.length;
			
			pkg.writeUTF(msg);
			pkg.writeUTF(nick);
			pkg.writeInt(count);
			
			for(var i:uint =0;i<count;i++)
			{
				pkg.writeInt(ids[i]);
				pkg.writeInt(types[i]);
				pkg.writeUTF(colors[i]);
				if(skin == null)
				{
					pkg.writeUTF("");
				}else
				{
					pkg.writeUTF(skin[i]);
				}
			}
			
			sendPackage(pkg);
		}
		
		/**
		 *续费 
		 * 
		 */		
		public function sendGoodsContinue(data:Array):void
		{
			var count:int = data.length;
			
			var pkg:PackageOut = new PackageOut(ePackageType.ITEM_CONTINUE);
			pkg.writeInt(count);
			for(var i:uint = 0;i<count;i++)
			{
				pkg.writeByte(data[i][0]);
				pkg.writeInt(data[i][1]);
				pkg.writeInt(data[i][2]);
				pkg.writeByte(data[i][3]);
				pkg.writeBoolean(data[i][4]);
			}
			sendPackage(pkg);
		}
		
		/******************商店　********************************/
		public  function sendSellGoods(position:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.SEll_GOODS);
			pkg.writeInt(position);
			sendPackage(pkg);
		}
		
		public function sendUpdateGoodsCount():void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GOODS_COUNT);
			sendPackage(pkg);
		}
		/*****************************邮件************************/
		public  function sendEmail(param:Object):void
		{

			var pkg:PackageOut = new PackageOut(ePackageType.SEND_MAIL);
			pkg.writeUTF(param.NickName);
			pkg.writeUTF(param.Title);
			pkg.writeUTF(param.Content);
			pkg.writeBoolean(param.isPay);
			pkg.writeInt(param.hours);
			pkg.writeInt(param.SendedMoney);
			
			for(var i:uint;i<MailManager.Instance.NUM_OF_WRITING_DIAMONDS;i++)
			{
				if(param["Annex"+i])
				{
					pkg.writeByte(param["Annex"+i].split(",")[0]);
					pkg.writeInt(param["Annex"+i].split(",")[1]);
				}else
				{
					pkg.writeByte(0);
					pkg.writeInt(-1);
				}
			}
			
			sendPackage(pkg);
		}
		
		/**
		 * 改变已读未读标识 
		 * 
		 */
		public  function sendUpdateMail(id:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.UPDATE_MAIL);
			pkg.writeInt(id);
			sendPackage(pkg);
		}
		
		/**
		 * 删除邮件 
		 * 
		 */		
		public  function sendDeleteMail(id:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.DELETE_MAIL);
			pkg.writeInt(id);
			sendPackage(pkg);
		}
		/**
		 * 退回邮件
		 * 
		 */
		public function untreadEmail(id:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.MAIL_CANCEL);
			pkg.writeInt(id);
			sendPackage(pkg);
		}
		
		public  function sendGetMail(emailId:int,type:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GET_MAIL_ATTACHMENT);
			pkg.writeInt(emailId);
			pkg.writeByte(type);
			sendPackage(pkg);
		}

		public  function sendPint():void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.PING);
			sendPackage(pkg);
		}
		/**
		 * 跑到地图外 
		 * 
		 */		
		public  function sendSuicide(id:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
			pkg.writeByte(CrazyTankPackageType.SUICIDE);
			pkg.writeInt(id);
			sendPackage(pkg);
		}
		
		/**
		 * 自杀 
		 * @param id
		 * 
		 */		
		public  function sendKillSelf(id:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
			pkg.writeByte(CrazyTankPackageType.KILLSELF);
			pkg.writeInt(id);
			sendPackage(pkg);
		}

		/**
		 * 物品合成
		 * 
		 */
		public function sendItemCompose(consortiaState:Boolean):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.ITEM_COMPOSE);
//			for(var i:int = 0; i < places.length; i++)
//			{
//				pkg.writeInt(places[i]);
//			}			
			pkg.writeBoolean(consortiaState);
			sendPackage(pkg);
		}
		/**
		 * 转移
		 */
		 public function sendItemTransfer() : void
		 {
		 	var pkg : PackageOut = new PackageOut(ePackageType.ITEM_TRANSFER);
//		 	for(var i:int = 0; i < places.length; i++)
//			{
//				pkg.writeInt(places[i]);
//			}
		 	sendPackage(pkg);
		 }
		
		/**
		 * 
		 * @param places
		 * 强化
		 */		
		public function sendItemStrength(consortiaState:Boolean):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.ITEM_STRENGTHEN);
//			for(var i:int = 0; i < places.length; i++)
//			{
//				pkg.writeInt(places[i]);
//			}
			pkg.writeBoolean(consortiaState);
			sendPackage(pkg);
		}
		
		/**
		 * 炼化
		 * */
		public function sendItemLianhua(operation:int,count:int,matieria:Array,equipBagType:int,equipPlace:int,luckyBagType:int,luckyPlace:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.ITEM_REFINERY);
			pkg.writeInt(operation);
			pkg.writeInt(count);
			for(var i:int = 0; i<matieria.length; i++)
			{
				pkg.writeInt(matieria[i]);
			}
			pkg.writeInt(equipBagType);
			pkg.writeInt(equipPlace);
			pkg.writeInt(luckyBagType);
			pkg.writeInt(luckyPlace);
			sendPackage(pkg);
		}
		
		/**
		 * 镶嵌
		 * */
		public function sendItemEmbed(itemBagType:int,itemPlace:int,holePlace:int,stoneBagType:int,stonePlace:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.ITEM_INLAY);
			pkg.writeInt(itemBagType);
			pkg.writeInt(itemPlace);
			pkg.writeInt(holePlace);
			pkg.writeInt(stoneBagType);
			pkg.writeInt(stonePlace);
			sendPackage(pkg);
		}
		
		/**
		 * 拆除镶嵌
		 * */
		public function sendItemEmbedBackout(itemPlace:int,templateID:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.ITEM_EMBED_BACKOUT);
			pkg.writeInt(itemPlace);
			pkg.writeInt(templateID);
			sendPackage(pkg);
		}
		
		/**
		 * 转换
		 * */
		 public function sendItemTrend(itemBagType:int,itemPlace:int,propBagType:int,propPlace:int,trendType:int):void
		 {
		 	var pkg:PackageOut = new PackageOut(ePackageType.ITEM_TREND);
		 	pkg.writeInt(itemBagType);
		 	pkg.writeInt(itemPlace);
		 	pkg.writeInt(propBagType);
		 	pkg.writeInt(propPlace);
		 	pkg.writeInt(trendType);
		 	sendPackage(pkg);
		 }
		 
		/**
		 * 清空铁匠铺隐形背包
		 * */
		 public function sendClearStoreBag():void
		 {
		 	PlayerManager.Instance.Self.StoreBag.items.clear();
		 	var pkg:PackageOut = new PackageOut(ePackageType.CLEAR_STORE_BAG);
		 	sendPackage(pkg);
		 }
		
		/**
		 * 发送验证码
		 * 
		 *   */
		public function sendCheckCode(code:String):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.CHECK_CODE);
			pkg.writeUTF(code);
			sendPackage(pkg);
		}

		
		/**
		 * 
		 * @param count
		 * @param datas
		 *                  熔炼/预览
		 * type  类型(熔炼/预览)
		 * count 主熔品的个数
		 * datas 0 四个主熔品包类型,包位置
		 * ***** 1 熔炼公式的包类型,包位置
		 * ***** 2 附加熔炼品的个数
		 * ***** 3 附加熔炼品的包类型,包位置 
		 * 
		 */		
		public function sendItemFusion(type:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.ITEM_FUSION);
			pkg.writeByte(type);
//			pkg.writeInt(count);
//			for(var i:int = 0; i < datas[0].length; i++)
//			{
//				pkg.writeByte(datas[0][i][0]);
//				pkg.writeInt(datas[0][i][1]);			
//			}
//			pkg.writeByte(datas[1][0]);
//			pkg.writeInt(datas[1][1]);
//			pkg.writeInt(datas[2]);
//			for(var j:int=0;j<datas[3].length;j++)
//			{
//				pkg.writeByte(datas[3][j][0]);
//				pkg.writeInt(datas[3][j][1]);
//			}
			sendPackage(pkg);
		}
		
		public function sendSBugle(msg:String):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.S_BUGLE);
			pkg.writeInt(PlayerManager.Instance.Self.ID);
			pkg.writeUTF(PlayerManager.Instance.Self.NickName);
			pkg.writeUTF(msg);

			sendPackage(pkg);
		}
		
		public function sendBBugle(msg:String):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.B_BUGLE);
			pkg.writeInt(PlayerManager.Instance.Self.ID);
			pkg.writeUTF(PlayerManager.Instance.Self.NickName);
			pkg.writeUTF(msg);
			sendPackage(pkg);
		}
		public function sendCBugle(msg:String):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.C_BUGLE);
			pkg.writeInt(PlayerManager.Instance.Self.ID);
			pkg.writeUTF(PlayerManager.Instance.Self.NickName);
			pkg.writeUTF(msg);
			sendPackage(pkg);
		}
		/**
		 * 挑战公告
		 */		
		public function sendDefyAffiche(msg:String):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.DEFY_AFFICHE)
			pkg.writeUTF(msg);
			sendPackage(pkg);
		}
		
//		public function sendPersonalChat(fromnick:String,toNick:String, msg:String,id:int = 0):void
//		{
//			var pkg:PackageOut = new PackageOut(ePackageType.CHAT_PERSONAL);
//			pkg.writeInt(id);
//			var obj:Object = new Object();
//			obj["fromNick"] = fromnick;
//			obj["toNick"] = toNick;
//			obj["msg"] = msg;
//			pkg.writeJsonObject(obj);
//			sendPackage(pkg);
//		}
		
		public function sendAddFriend(nick:String,Relation:int):void
		{
			if(nick == "") return;
			var pkg:PackageOut = new PackageOut(ePackageType.FRIEND_ADD);
			pkg.writeUTF(nick);
			pkg.writeInt(Relation);
			sendPackage(pkg);
		}
		
		public function sendDelFriend(id:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.FRIEND_REMOVE);
			pkg.writeInt(id);
			sendPackage(pkg);
		}
		
		public function sendFriendState(state:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.FRIEND_STATE);
			pkg.writeByte(state);
			sendPackage(pkg);
		}
		
//		public function sendBagLocked(psw:String = "",questionOne:String = "",answerOne:String = "",
//									questionTwo:String = "",answerTwo:String = "") : void
//		{
//			var pkg : PackageOut = new PackageOut(ePackageType.BAG_LOCKED);
//			pkg.writeUTF(psw);
//			pkg.writeUTF(psw);
//			pkg.writeUTF();
//			pkg.writeUTF(questionOne);
//			pkg.writeUTF(answerOne);
//			pkg.writeUTF(questionTwo);
//			pkg.writeUTF(answerTwo);
//			sendPackage(pkg);
//		}
//		
		public function sendBagLocked(pwd:String,type:int,newPwd:String="",questionOne:String = "",answerOne:String = "",questionTwo:String = "",answerTwo:String = "") : void
		{
			var pkg : PackageOut = new PackageOut(ePackageType.BAG_LOCKED);
			pkg.writeUTF(pwd);
			pkg.writeUTF(newPwd);
			pkg.writeInt(type);
			pkg.writeUTF(questionOne);
			pkg.writeUTF(answerOne);
			pkg.writeUTF(questionTwo);
			pkg.writeUTF(answerTwo);
			sendPackage(pkg);
		}
		
		
		
		public function sendBagLockedII(psw:String,questionOne:String,answerOne:String,questionTwo:String,answerTwo:String):void{
			
		}
		/**公会设备使用各等级需要财富**/
		public function sendConsortiaEquipConstrol(arr : Array) : void
		{
			var pkg : PackageOut = new PackageOut(ePackageType.CONSORTIA_EQUIP_CONTROL);
			for(var i:int=0;i<arr.length;i++)
			{
				pkg.writeInt(arr[i]);
			}
			sendPackage(pkg);
		}
		
		public function sendErrorMsg(msg:String):void
		{
			//防止字符串过长，超出客户端缓存
			if(msg.length < 1000)
			{
				var pkg:PackageOut = new PackageOut(ePackageType.CLIENT_LOG);
				pkg.writeUTF(msg);
				sendPackage(pkg);
			}
		}
		
		public function sendItemOverDue(bagtype:int,place:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.ITEM_OVERDUE);
			pkg.writeByte(bagtype);
			pkg.writeInt(place);
			sendPackage(pkg);
		}
		
		public function sendHideLayer(categoryid:int,hide:Boolean):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.ITEM_HIDE);
			pkg.writeBoolean(hide);
			pkg.writeInt(categoryid);
			sendPackage(pkg);
		}
//		/**************************任务***********************************************************************************/
//		public function sendQiestAdd(id:int):void
//		{
//			var pkg:PackageOut = new PackageOut(ePackageType.QUEST_ADD);
//			pkg.writeInt(id);
//			sendPackage(pkg);
//		}
		public function sendQuestAdd(arr : Array):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.QUEST_ADD);
			pkg.writeInt(arr.length);
			for(var i:int=0;i<arr.length;i++)
			{
				pkg.writeInt(arr[i]);
			}
			sendPackage(pkg);
		}
		public function sendQuestRemove(id:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.QUEST_REMOVE);
			pkg.writeInt(id);
			sendPackage(pkg);
		}
		
		public function sendQuestFinish(id:int,itemId:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.QUEST_FINISH);
			pkg.writeInt(id);
			pkg.writeInt(itemId);
			sendPackage(pkg);
		}
		/** 
		 * 客户端判断完成的任务
		 * @param id 任务ID
		 * @param conid 条件序号
		 * @param value 数值，默认为1
		 * */
		public function sendQuestCheck(id:int,conid:int,value:int = 1):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.QUEST_CHECK);
			pkg.writeInt(id);
			pkg.writeInt(conid);
			pkg.writeInt(value);
			sendPackage(pkg);
		}
		
		
		
		public function sendItemOpenUp(bagtype:int,place:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.ITEM_OPENUP);
			pkg.writeByte(bagtype);
			pkg.writeInt(place);
			sendPackage(pkg);
		}
		
		/**
		 * 加载人物资料
		 * 
		 */		
		public function sendItemEquip(id:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.ITEM_EQUIP);
			pkg.writeInt(id);
			sendPackage(pkg);
		}
		
		/**
		 * 领取奖品 
		 * @param id
		 * @param pass
		 * 
		 */		
		public function sendActivePullDown(id:int,pass:String):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.ACTIVE_PULLDOWN);
			pkg.writeInt(id);
			pkg.writeUTF(pass);
			sendPackage(pkg);
		} 
		
//*******************************拍卖行****************************************************************//
		/*payType 0(金币) 1(点券)     validDate(0,)*/ 
		public function auctionGood(bagType:int,place:int,payType:int,price:int,mouthful:int,validDate:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.AUCTION_ADD);
			pkg.writeByte(bagType);
			pkg.writeInt(place);
			pkg.writeByte(payType);
			pkg.writeInt(price);
			pkg.writeInt(mouthful);
			pkg.writeInt(validDate);
			sendPackage(pkg);
		}
		
		public function auctionCancelSell(id:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.AUCTION_DELETE);
			pkg.writeInt(id);
			sendPackage(pkg);		
		}
		
		/**
		 * 竞拍 
		 * 
		 */		
		public function auctionBid(id:int,price:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.AUCTION_UPDATE);
			pkg.writeInt(id);
			pkg.writeInt(price);
			sendPackage(pkg);
		}
		/**
		 *新手答题 
		 * @param name
		 * 
		 */		
		 public function TrainerAnswer(id : int) : void
		 {
		 	var pkg : PackageOut = new PackageOut(ePackageType.USER_ANSWER);
		 	pkg.writeInt(id);
		 	sendPackage(pkg);
		 }
		
		public function sendCreateConsortia(name:String):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_CREATE);
			pkg.writeUTF(name);
			sendPackage(pkg);
		}
		
		public function sendConsortiaTryIn(consortiaid:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_TRYIN);
			pkg.writeInt(consortiaid);
			sendPackage(pkg);
		}
		
		public function sendConsortiaCancelTryIn():void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_TRYIN);
			pkg.writeInt(0);
			sendPackage(pkg);
		}
		/**
		 * 发送公会邀请
		 */
		public function sendConsortiaInvate(name:String):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_INVITE);
			pkg.writeUTF(name);
			sendPackage(pkg);
		}
		
		public function sendConsortiaInvatePass(id:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_INVITE_PASS);
			pkg.writeInt(id);
			sendPackage(pkg);
		}
		
		public function sendConsortiaInvateDelete(id:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_INVITE_DELETE);
			pkg.writeInt(id);
			sendPackage(pkg);
		}
		
		public function sendConsortiaUpdateDescription(description:String):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_DESCRIPTION_UPDATE);
			pkg.writeUTF(description);
			sendPackage(pkg);
		}
		
		public function sendConsortiaUpdatePlacard(placard:String):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_PLACARD_UPDATE);
			pkg.writeUTF(placard);
			sendPackage(pkg);
		}
		
		public function sendConsortiaUpdateDuty(dutyid:int,dutyname:String,right:int):void
		{
            var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_DUTY_UPDATE);
            pkg.writeInt(dutyid);
            pkg.writeByte(dutyid == -1 ? 1 : 2);
            pkg.writeUTF(dutyname);
            pkg.writeInt(right);
            sendPackage(pkg);
		}
		
		public function sendConsortiaUpgradeDuty(dutyid:int,updown:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_DUTY_UPDATE);
			pkg.writeInt(dutyid);
			pkg.writeByte(updown);
			sendPackage(pkg);
		}
		/**
		 * 是否容许其他人续继加入公会
		 */
		 public function sendConsoritaApplyStatusOut(b : Boolean) : void
		 {
		 	var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_APPLY_STATE);
		 	pkg.writeBoolean(b);
		 	sendPackage(pkg);
		 }
		
		/**
		 * 退出公会
		 * 踢出公会
		 */		
		public function sendConsortiaOut(playerid:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_RENEGADE);
			pkg.writeInt(playerid);
			sendPackage(pkg);
		}
		/**
		 * 升级公会会员
		 */
		public function sendConsortiaMemberGrade(id:int,isUpgrade:Boolean):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_USER_GRADE_UPDATE);
			pkg.writeInt(id);
			pkg.writeBoolean(isUpgrade);
			sendPackage(pkg);
		}
		/**
		 * 修改成员备注
		 */
		 public function sendConsortiaUserRemarkUpdate(id:int,msg:String):void
		 {
		 	var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_USER_REMARK_UPDATE);
			pkg.writeInt(id);
			pkg.writeUTF(msg);
			sendPackage(pkg);
		 }
		 
		
//		public function sendConsortiaMemberUpgrade(playerid:int):void
//		{
//			var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_USER_GRADE_UPDATE);
//			pkg.writeInt(playerid);
//			pkg.writeBoolean(true);
//			sendPackage(pkg);
//		}
//		
//		public function sendConsortiaMemberDesgrade(playerid:int):void
//		{
//			var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_USER_GRADE_UPDATE);
//			pkg.writeInt(playerid);
//			pkg.writeBoolean(false);
//			sendPackage(pkg);
//		}
		
		public function sendConsortiaDutyDelete(dutyid:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_DUTY_DELETE);
			pkg.writeInt(dutyid);
			sendPackage(pkg);
		}
		
		public function sendConsortiaTryinPass(id:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_TRYIN_PASS);
			pkg.writeInt(id);
			sendPackage(pkg);
		}
		
		public function sendConsortiaTryinDelete(id:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_TRYIN_DEL);
			pkg.writeInt(id);
			sendPackage(pkg);
		}
		
		/**
		 * 添加申请结盟
		 * @param consoritaID
		 * 
		 */		
		public function sendConsortiaAddApplyAlly(id:int,isAlly:Boolean):void
	  	{
	   		var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_ALLY_APPLY_ADD);
	   		pkg.writeInt(id);
	   		pkg.writeBoolean(isAlly);
	   		sendPackage(pkg);
	  	}
		public function sendConsortiaRemoveApplyAlly(id:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_ALLY_APPLY_DELETE);
			pkg.writeInt(id);
			sendPackage(pkg);
		}
		public function sendConsortiaAddAlly(id:int,isFright:Boolean):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_ALLY_UPDATE);
			pkg.writeInt(id);
			pkg.writeBoolean(isFright);
			sendPackage(pkg);
		}
		
		public function sendForbidSpeak(id:int,forbid:Boolean):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_BANCHAT_UPDATE);
			pkg.writeInt(id);
			pkg.writeBoolean(forbid);
			sendPackage(pkg);
		}
		
		public function sendConsortiaDismiss():void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_DISBAND);
			sendPackage(pkg);
		}
		
		public function sendConsortiaChangeChairman(nickName:String = ""):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_CHAIRMAN_CHAHGE);
			pkg.writeUTF(nickName);
			sendPackage(pkg);
		}
		
		public function sendConsortiaAllyApplyUpdate(id:uint):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_ALLY_APPLY_UPDATE);
			pkg.writeInt(id);
			sendPackage(pkg);
		}
		
		
		public function sendConsortiaRichOffer(num:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_RICHES_OFFER);
			pkg.writeInt(num);
			sendPackage(pkg);
		}
		
		/**
		 * 公会升级
		 */
		public function sendConsortiaLevelUp(bagType:int,place:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_LEVEL_UP);
			pkg.writeByte(bagType);
			pkg.writeInt(place);
			sendPackage(pkg);
		}
		/**公会银行升级**/
		public function sendConsortiaBankLevelUp() : void
		{
			var pkg :PackageOut = new PackageOut(ePackageType.CONSORTIA_STORE_UPGRADE);
			sendPackage(pkg);
		}
		/**公会商城升级**/
		public function sendConsortiaShopLevelUp() : void
		{
			var pkg :PackageOut = new PackageOut(ePackageType.CONSORTIA_SHOP_UPGRADE);
			sendPackage(pkg);
		}
		/**公会铁匠升级**/
		public function sendConsortiaSmithUp() : void
		{
			var pkg : PackageOut = new PackageOut(ePackageType.CONSORTIA_SMITH_UPGRADE);
			sendPackage(pkg);
		}
		
		
		
		/**
		 * 传送飞机 
		 * 
		 */		
		public function sendAirPlane():void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);	
			pkg.writeByte(CrazyTankPackageType.AIRPLANE);
			sendPackage(pkg);
		}
		/**
		 *加血枪 
		 * 
		 */		
//		public function sendAddBlood():void
//		{
//			var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);	
//			pkg.writeByte(CrazyTankPackageType.ADD_BLOOD);
//			sendPackage(pkg);
//		}
		/**
		 *使用副武器 
		 * 
		 */		
		public function useDeputyWeapon() : void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);	
			pkg.writeByte(CrazyTankPackageType.USE_DEPUTY_WEAPON);
			sendPackage(pkg);
		}
		
		public function sendGamePick(bombId:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
			pkg.writeByte(CrazyTankPackageType.PICK);
			pkg.writeInt(bombId);
			sendPackage(pkg);
		}
		
//		/*************************************************************************************************************/
		public  function sendPackage(pkg:PackageOut):void
		{
			//crazyTank.output.text += "发送数据:" + ByteUtils.ToHexDump("Receive Pkg:",pkg,0,pkg.length) + "\n"
			//Debug.trace("发送数据:" + ByteUtils.ToHexDump("Receive Pkg:",pkg,0,pkg.length) + "\n");
			_socket.send(pkg);
		}
		
		/**
		 * 
		 * negitive Value means delete;
		 */		
		public function sendMoveGoods(bagtype:int,place:int,tobagType:int,toplace:int,count:int = 1):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.CHANGE_PLACE_GOODS);
			pkg.writeByte(bagtype);
			pkg.writeInt(place);
			pkg.writeByte(tobagType);
			pkg.writeInt(toplace);
			pkg.writeInt(count);
			sendPackage(pkg);
		}
		
		/**
		 *系统回收物品(用户出售物品) 
		 * @param bagtype 背包类型
		 * @param place 当前位置
		 * @param itemID 物品ID
		 * @param count 出售物品总计
		 * 
		 */		
		public function reclaimGoods(bagtype:int,place:int,count:int = 1):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.REClAIM_GOODS);
			pkg.writeByte(bagtype);
			pkg.writeInt(place);
			pkg.writeInt(count);
			sendPackage(pkg);
		}
		
		/**
		 * 批量整理物品 
		 * @array 物品数组
		 * @startPlace 物品在物品栏中开始位置
		 */		
		public  function sendMoveGoodsAll(bagType:int, array:Array, startPlace:int):void
		{
			if(array.length<=0)
			{
				return;
			}
			
			var len:int=array.length;
			var pkg:PackageOut = new PackageOut(ePackageType.CHANGE_PLACE_GOODS_ALL);
			pkg.writeInt(len);
			pkg.writeInt(bagType);
			for(var i:int =0;i<len;i++)
			{
				pkg.writeInt(array[i].Place);
				pkg.writeInt(i+startPlace);
			}

			sendPackage(pkg);
		}
		
		/**
		 * 发送防沉迷开关请求 
		 * 
		 */	
		public function sendForSwitch():void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.ENTHRALL_SWITCH);
			sendPackage(pkg);
		}
		/**
		 * 发送身份证验证状态请求 
		 * 
		 */	
		public function sendCIDCheck():void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.CID_CHECK);
			sendPackage(pkg);
		}
		/**
		 * 发送身份证信息 
		 * 
		 */	
		public function sendCIDInfo(name:String,CID:String):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.CID_CHECK);
			pkg.writeBoolean(false);
			pkg.writeUTF(name);
			pkg.writeUTF(CID);
			sendPackage(pkg);
		}
		
		/**
		 * 发送变色信息
		 * */
		public function sendChangeColor(cardBagType:int,cardPlace:int,itemBagType:int,itemPlace:int,color:String,skin:String,templateID:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.USE_COLOR_CARD);
			pkg.writeInt(cardBagType);
			pkg.writeInt(cardPlace);
			pkg.writeInt(itemBagType);
			pkg.writeInt(itemPlace);
			pkg.writeUTF(color);
			pkg.writeUTF(skin);
			pkg.writeInt(templateID)
			sendPackage(pkg);
		}
		
		/**
		 * 发送使用卡片消息
		 * */
		public function sendUseCard(bagType:int, cardPlace:int, templateID:int, type:int, ignoreBagLock:Boolean = false):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.CARD_USE);
			pkg.writeInt(bagType);
			pkg.writeInt(cardPlace);
			pkg.writeInt(templateID);
			pkg.writeInt(type);
			pkg.writeBoolean(ignoreBagLock);
			sendPackage(pkg);
		}
		
		/**
		 * 打开轮盘宝箱
		 * @param bagType
		 * @param place
		 * 
		 */		
		public function sendRouletteBox(bagType:int , place:int):void
		{
		//	var pkg:PackageOut = new PackageOut(ePackageType.LOTTERY_OPEN_BOX);
		//	pkg.writeByte(bagType);
		//	pkg.writeInt(place);
		//	sendPackage(pkg);
		}
		/**
		 *轮盘宝箱开始抽奖 
		 * 
		 */		
		public function sendStartTurn():void
		{
	//		var pkg:PackageOut = new PackageOut(ePackageType.LOTTERY_RANDOM_SELECT);
	//		sendPackage(pkg);
		}
		/**
		 *轮盘宝箱抽奖结束 
		 * 
		 */		
		public function sendFinishRoulette():void
		{
	//		var pkg:PackageOut = new PackageOut(ePackageType.LOTTERY_FINISH);
	//		sendPackage(pkg);
		}
		
		/**
		 * 发送使用改名卡消息
		 */	
		 
		 public function sendUseReworkName(bagType:int ,place:int, newName:String):void
		 {
		 	var pkg:PackageOut = new PackageOut(ePackageType.USE_REWORK_NAME);
		 	pkg.writeByte(bagType);
		 	pkg.writeInt(place);
		 	pkg.writeUTF(newName);
		 	sendPackage(pkg);		 
		 }
		 
		/**
		 * 公会改名卡
		 */	
		 public function sendUseConsortiaReworkName(consortiaID:int,bagType:int ,place:int, newName:String):void
		 {
		 	var pkg:PackageOut = new PackageOut(ePackageType.USE_CONSORTIA_REWORK_NAME);
		 	pkg.writeInt(consortiaID);
		 	pkg.writeByte(bagType);
		 	pkg.writeInt(place);
		 	pkg.writeUTF(newName);
		 	sendPackage(pkg);		 
		 }	 	
		
		/****************************结婚系统************************************/		
		
		/**
		 * 验证是否已结婚 
		 * @param id
		 */		
		public function sendValidateMarry(id:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.MARRY_STATUS);
			pkg.writeInt(id);
			sendPackage(pkg);
		}
		
		/**
		 * 求婚 
		 * @param id
		 * @param useBugle
		 */		
		public function sendPropose(id:int,text:String,useBugle:Boolean):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.MARRY_APPLY);
			pkg.writeInt(id);
			pkg.writeUTF(text);
			pkg.writeBoolean(useBugle);
			sendPackage(pkg);
		}
		/**
		 * 响应求婚 
		 * @param result
		 * @param id
		 */		
		public function sendProposeRespose(result:Boolean,id:int,answerId:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.MARRY_APPLY_REPLY);
			pkg.writeBoolean(result);
			pkg.writeInt(id);
			pkg.writeInt(answerId);
			sendPackage(pkg);
		}
		
		/**
		 * 离婚 
		 */		
		public function sendUnmarry(isPlayMovie:Boolean = false):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.DIVORCE_APPLY);
			pkg.writeBoolean(isPlayMovie);
			sendPackage(pkg);
		}
		
		/**
		 * 进入结婚大厅 
		 */		
		public function sendMarryRoomLogin():void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.MARRY_SCENE_LOGIN);
			sendPackage(pkg);
		}
		/**
		 * 退出结婚大厅 
		 */		
		public function sendExitMarryRoom():void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.SCENE_REMOVE_USER);
			sendPackage(pkg);
		}
		/**
		 * 创建礼堂房间 
		 * @param info
		 */		
		public function sendCreateRoom(info:ChurchRoomInfo):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.MARRY_ROOM_CREATE);
			pkg.writeUTF(info.roomName);
			pkg.writeUTF(info.password);
			pkg.writeInt(info.mapID);
			pkg.writeInt(info.valideTimes);
			pkg.writeInt(100);
			pkg.writeBoolean(info.canInvite);
			pkg.writeUTF(info.discription);
			sendPackage(pkg);
		}
		/**
		 * 进入礼堂房间 
		 * @param id
		 * @param psw
		 */		
		public function sendEnterRoom(id:int,psw:String,sceneIndex:int =1):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.MARRY_ROOM_LOGIN);
			pkg.writeInt(id);
			pkg.writeUTF(psw);
			pkg.writeInt(sceneIndex);
			sendPackage(pkg);
		}
		
		/**
		 * 退出礼堂房间 
		 */		
		public function sendExitRoom():void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.PLAYER_EXIT_MARRY_ROOM);
			sendPackage(pkg);
		}
		/**
		 * 通知当前所在场景 
		 * @param index
		 * 0 礼堂场景
		 * 1 游戏广场
		 */		
		public function sendCurrentState(index:uint):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.SCENE_STATE);
			pkg.writeInt(index);
			sendPackage(pkg);
		}
		
		public function sendUpdateRoomList(hallType:int , updateType:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.ROOMLIST_UPDATE);
			pkg.writeInt(hallType);
			pkg.writeInt(updateType);
			sendPackage(pkg);
		}
		
		public function sendChurchMove(endX:int,endY:int,path:String):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
			pkg.writeByte(ChurchPackageType.MOVE);
			pkg.writeInt(endX);
			pkg.writeInt(endY);
			pkg.writeUTF(path);
			sendPackage(pkg);
		}
		/**
		 * 开始婚礼
		 */		
		public function sendStartWedding():void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
			pkg.writeByte(ChurchPackageType.HYMENEAL);
			sendPackage(pkg);
		}
		/**
		 * 礼堂续费 
		 * @param id
		 */		
		public function sendChurchContinuation(hours:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
			pkg.writeByte(ChurchPackageType.CONTINUATION);
			pkg.writeInt(hours);
			sendPackage(pkg);
		}
		/**
		 * 邀请进入礼堂 
		 */		
		public function sendChurchInvite(id:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
			pkg.writeByte(ChurchPackageType.INVITE);
			pkg.writeInt(id);
			sendPackage(pkg);
		}
		/**
		 * 赠送礼金 
		 */		
		public function sendChurchLargess(num:uint):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
			pkg.writeByte(ChurchPackageType.LARGESS);
			pkg.writeInt(num);
			sendPackage(pkg);
		}
		/**
		 * 燃放烟花 
		 */		
		public function sendUseFire(userID:int,fireID:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
			pkg.writeByte(ChurchPackageType.USEFIRECRACKERS);
			pkg.writeInt(userID);
			pkg.writeInt(fireID);
			sendPackage(pkg);
		}
		/**
		 * 踢出房间 
		 */		
		public function sendChurchKick(id:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
			pkg.writeByte(ChurchPackageType.KICK);
			pkg.writeInt(id);
			sendPackage(pkg);
		}
		/**	
		 * 结婚动画完成
		 */
		public function sendChurchMovieOver(ID:int, password:String):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.CHURCH_MOVIE_OVER);
			pkg.writeInt(ID);
			pkg.writeUTF(password)
			sendPackage(pkg);
		}		
		/**
		 * 阻止进入 
		 */		
		public function sendChurchForbid(id:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
			pkg.writeByte(ChurchPackageType.FORBID);
			pkg.writeInt(id);
			sendPackage(pkg);
		}
		/**
		 * 调整玩家坐标 
		 */		
		public function sendPosition(x:Number,y:Number):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
			pkg.writeByte(ChurchPackageType.POSITION);
			pkg.writeInt(x);
			pkg.writeInt(y);
			sendPackage(pkg);
		}
		
		/**
		 * 修改房间描述 
		 * @param discription
		 * 
		 */		
		public function sendModifyChurchDiscription(roomName:String,modifyPSW:Boolean,psw:String,discription:String):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.MARRY_ROOM_INFO_UPDATE);
			pkg.writeUTF(roomName);
			pkg.writeBoolean(modifyPSW);
			pkg.writeUTF(psw);
			pkg.writeUTF(discription);
			sendPackage(pkg);
		}
		/**
		 * 切换场景 
		 * @param sceneIndex  (1.礼堂  2.月光天台)
		 * 
		 */		
		public function sendSceneChange(sceneIndex:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.MARRY_SCENE_CHANGE);
			pkg.writeInt(sceneIndex);
			sendPackage(pkg);
		}
		
		public function sendGunSalute(userID:int,templeteID:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
			pkg.writeByte(ChurchPackageType.GUNSALUTE);
			pkg.writeInt(userID);
			pkg.writeInt(templeteID);
			sendPackage(pkg);
		}
		/****************************民政中心************************************/		
		
		/**
		 * 民政中心登记信息
		 */	
		public function sendRegisterInfo(UserID:int,IsPublishEquip:Boolean,introduction:String=null):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.MARRYINFO_ADD);
			pkg.writeBoolean(IsPublishEquip);
			pkg.writeUTF(introduction);
			pkg.writeInt(UserID);
			sendPackage(pkg);
		}
		/**
		 * 修改民政中心注册信息
		 */	
		public function sendModifyInfo(IsPublishEquip:Boolean,introduction:String=null):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.MARRYINFO_UPDATE);
			pkg.writeBoolean(IsPublishEquip);
			pkg.writeUTF(introduction);
			sendPackage(pkg);
		}
		
		/**
		 * 发送登记成功请求 
		 */	
		public function sendForMarryInfo(MarryInfoID:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.MARRYINFO_GET);
			pkg.writeInt(MarryInfoID);
			sendPackage(pkg);
		}
		
		/**
		 * 请求物品链接中的物品信息
		 * @param ItemID
		 * 
		 */		
		public function sendGetLinkGoodsInfo(type:int,ItemID:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.LINKREQUEST_GOODS);
			pkg.writeInt(type);
			pkg.writeInt(ItemID);
			sendPackage(pkg);
		}
		
		/**
		 * 将战利品放入背包
		 * @param place 战利品的位置，-1代表所有战利品
		 */
		 public function sendGetTropToBag(place:int):void{
		 	var pkg:PackageOut = new PackageOut(ePackageType.GAME_TAKE_TEMP);
		 	pkg.writeInt(place);
		 	sendPackage(pkg);
		 } 
		 public function sendUserGuideProgress(progress:int):void{
		 	var pkg:PackageOut = new PackageOut(ePackageType.USER_ANSWER);
			pkg.writeInt(progress);
			sendPackage(pkg);
		 }
		 /**
		 * 进入新手训练
		 */
		 public function createUserGuide(roomType:int = 10):void
		{
			var randomPass:String = String(Math.random());
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_ROOM_CREATE);
			pkg.writeByte(roomType);
			pkg.writeByte(3);
			pkg.writeUTF('');
			pkg.writeUTF(randomPass);
			sendPackage(pkg);
			//创建房间
		} 
		public function enterUserGuide():void{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_ROOM_SETUP_CHANGE);
			pkg.writeInt(101);
			pkg.writeByte(10);
			pkg.writeByte(3);
			pkg.writeByte(0);//难度
			pkg.writeInt(0);
			pkg.writeBoolean(false);
			sendPackage(pkg);
			//选择地图
		}
		public function userGuideStart():void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_START);
			sendPackage(pkg);
		}
		
		public function sendSaveDB():void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.SAVE_DB);
			sendPackage(pkg);
		}
		
		public function createMonster():void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
			pkg.writeByte(CrazyTankPackageType.GENERAL_COMMAND);
			pkg.writeInt(0);
			sendPackage(pkg);
		}
		
		public function deleteMonster():void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
			pkg.writeByte(CrazyTankPackageType.GENERAL_COMMAND);
			pkg.writeInt(1);
			sendPackage(pkg);
		}
		
		//*********温泉系统开始 *********
		/**
		 * 进入温泉模块 
		 */		
		public function sendHotSpringEnter():void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.HOTSPRING_ENTER);
			sendPackage(pkg);
		}
		
		/**
		 * 创建温泉房间 
		 */		
		public function sendHotSpringRoomCreate(roomVo:*):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.HOTSPRING_ROOM_CREATE);
			pkg.writeUTF(roomVo.roomName);
			pkg.writeUTF(roomVo.roomPassword);
			pkg.writeUTF(roomVo.roomIntroduction);
			pkg.writeInt(roomVo.maxCount);
			sendPackage(pkg);
		}
		
		/**
		 * 编辑温泉房间 
		 */		
		public function sendHotSpringRoomEdit(roomVo:*):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD);
			pkg.writeByte(HotSpringPackageType.HOTSPRING_ROOM_EDIT);
			pkg.writeUTF(roomVo.roomName);
			pkg.writeUTF(roomVo.roomPassword);
			pkg.writeUTF(roomVo.roomIntroduction);
			sendPackage(pkg);
		}
		
		/**
		 * 快速进入温泉房间
		 */
		public function sendHotSpringRoomQuickEnter():void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.HOTSPRING_ROOM_QUICK_ENTER);
			sendPackage(pkg);
		}
		
		/**
		 * 进入温泉房间
		 */
		public function sendHotSpringRoomEnterConfirm(roomID:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.HOTSPRING_ROOM_ENTER_CONFIRM);
			pkg.writeInt(roomID);
			sendPackage(pkg);
		}	
		
		/**
		 * 进入温泉房间
		 */
		public function sendHotSpringRoomEnter(roomID:int, roomPassword:String):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.HOTSPRING_ROOM_ENTER);
			pkg.writeInt(roomID);
			pkg.writeUTF(roomPassword);
			sendPackage(pkg);
		}
		
		/**
		 *进入温泉房间视图成功 
		 * @param state 0=成功，1=失败
		 */		
		public function sendHotSpringRoomEnterView(state:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.HOTSPRING_ROOM_ENTER_VIEW);
			pkg.writeInt(state);
			sendPackage(pkg);
		}
		
		/**
		 * 退出温泉房间
		 */
		public function sendHotSpringRoomPlayerRemove():void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.HOTSPRING_ROOM_PLAYER_REMOVE);
			sendPackage(pkg);
		}
		
		/**
		 * 玩家行动目标点发送
		 */
		public function sendHotSpringRoomPlayerTargetPoint(playerVO:*):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD);
			pkg.writeByte(HotSpringPackageType.TARGET_POINT);
			var souArr:Array=playerVO.walkPath.concat();
			var arr:Array = [];
			for(var i:uint;i<souArr.length;i++)
			{
				arr.push(int(souArr[i].x),int(souArr[i].y));
			}
			var pathStr:String = arr.toString();
			pkg.writeUTF(pathStr);
			pkg.writeInt(playerVO.playerInfo.ID);
			pkg.writeInt(playerVO.currentWalkStartPoint.x);
			pkg.writeInt(playerVO.currentWalkStartPoint.y);
			pkg.writeInt(1)
			pkg.writeInt(playerVO.playerDirection);
			
			sendPackage(pkg);
		}
		
		/**
		 * 房间续费
		 */
		public function sendHotSpringRoomRenewalFee(roomID:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD);
			pkg.writeByte(HotSpringPackageType.HOTSPRING_ROOM_RENEWAL_FEE);
			pkg.writeInt(roomID);
			sendPackage(pkg);
		}
		
		/**
		 * 邀请进入温泉房间
		 */		
		public function sendHotSpringRoomInvite(playerID:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD);
			pkg.writeByte(HotSpringPackageType.HOTSPRING_ROOM_INVITE);
			pkg.writeInt(playerID);
			sendPackage(pkg);
		}
		
		/**
		 * 房间踢人
		 */
		public function sendHotSpringRoomAdminRemovePlayer(playerID:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD);
			pkg.writeByte(HotSpringPackageType.HOTSPRING_ROOM_ADMIN_REMOVE_PLAYER);
			pkg.writeInt(playerID);
			sendPackage(pkg);
		}
		
		/**
		 * 系统房间刷新时，针对于玩家的继续(扣费)是否继续操作发送
		 */
		public function sendHotSpringRoomPlayerContinue(isContinue:Boolean):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD);
			pkg.writeByte(HotSpringPackageType.HOTSPRING_ROOM_PLAYER_CONTINUE);
			pkg.writeBoolean(isContinue);
			sendPackage(pkg);
		}
		//*********温泉系统结束 *********

		

		public function sendGetTimeBox(boxType:int, boxNumber:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.GET_TIME_BOX);
			pkg.writeInt(boxType);
			pkg.writeInt(boxNumber);
			sendPackage(pkg);
			//trace("sendGetTimeBox............",boxType,boxNumber);
		}

		

		//*********成就 ***************
		
		public function sendAchievementFinish(id:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.ACHIEVEMENT_FINISH);
			pkg.writeInt(id);
			sendPackage(pkg);
		}
		/**
		 * 修改称号USER_CHANGE_RANK = 0xbd,
		 */		
		public function  sendReworkRank(rank:String , id:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.USER_CHANGE_RANK);
			pkg.writeUTF(rank);
			pkg.writeInt(id);
			sendPackage(pkg);
		}
		/**
		 * 查看他人成就
		 */
		public function sendLookupEffort(id:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.LOOKUP_EFFORT);
			pkg.writeInt(id);
			sendPackage(pkg);
		}

		

		/** NPC遭遇战*/
		public function sendBeginFightNpc():void{
			var pkg:PackageOut = new PackageOut(ePackageType.FIGHT_NPC);
			sendPackage(pkg);
		}
		
		
		public function sendJoinWorldBoss():void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.WORLDBOSS_JOIN);
		}

	}
}