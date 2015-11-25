package ddt.consortia
{
	
	import flash.events.Event;
	
	import road.data.DictionaryEvent;
	
	import ddt.consortia.data.ConsortiaAssetLevelOffer;
	import ddt.consortia.data.ConsortiaDutyInfo;
	import ddt.consortia.request.LoadConsortiaApplayAllyList;
	import ddt.consortia.request.LoadConsortiaApplyUsersList;
	import ddt.consortia.request.LoadConsortiaDutyList;
	import ddt.consortia.request.LoadConsortiaInventList;
	import ddt.consortia.request.LoadConsortiaMemberList;
	import ddt.data.player.ConsortiaPlayerInfo;
	import ddt.data.player.PlayerPropertyEvent;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.manager.ChatManager;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.request.LoadConsortiaAllyList;
	import ddt.request.LoadConsortiaAssetRight;
	import ddt.request.LoadConsortias;
	import ddt.request.LoadSelfConsortiaMemberList;
	import ddt.states.BaseStateView;
	import ddt.states.StateType;
	import ddt.view.chatsystem.ChatInputView;
	import ddt.view.common.BellowStripViewII;
	
	public class ConsortiaControl extends BaseStateView
	{
		private var _view  : ConsortiaView;
		private var _model : ConsortiaModel;
		
		public static const CLUBE_STATE:String = "clubState";
		public static const MYCONSORTIA_STATE:String = "myConsortiaState";
		public static const DIPLOMATISM_STATE:String = "displomatismState";
		public static const CONSORTIASHOP_STATE : String = "consortiashopState";
		public static const CONSORTIABANK_STATE : String = "consortiabankState";
		public static const CONSORTIASTORE_STATE : String = "consortiastoreState";
		
		private var currentState:String = "";
		
		public function ConsortiaControl()
		{
		}
		override public function prepare():void
		{
			super.prepare();
		}
		
		override public function enter(prev:BaseStateView, data:Object=null):void
		{
			super.enter(prev,data);
			
			SocketManager.Instance.out.sendCurrentState(1);
			
			if(PlayerManager.Instance.Self.ConsortiaID != 0) {
				new LoadSelfConsortiaMemberList(PlayerManager.Instance.Self.ConsortiaID).loadSync();
			}
			
			_model = new ConsortiaModel();
			_view = new ConsortiaView(_model,this);
			addChild(_view);
			BellowStripViewII.Instance.show();
			BellowStripViewII.Instance.enabled = true;
			initEvent();
			changeSateByCurrent();
			
//			ChatManager.Instance.input.setCursorToLast();
		}
		
		
		private function changeSateByCurrent():void
		{
			if(PlayerManager.Instance.Self.ConsortiaID != 0)
			{
				viewState = MYCONSORTIA_STATE;
				_model.consortiaMemberList = PlayerManager.Instance.consortiaMemberList.list;
			}else
			{
				viewState = CLUBE_STATE;
			}
		}
		
		private function initEvent():void
		{
			PlayerManager.Instance.addEventListener(PlayerManager.CONSORTIA_CHANNGE,__consortiaChannge);
			PlayerManager.Instance.Self.addEventListener(PlayerManager.FRIEND_STATE_CHANGED,_updateConsortiaMemberList);
			PlayerManager.Instance.addEventListener(PlayerManager.SELF_CONSORTIA_COMPLETE,_updateConsortiaMemberList);
			
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_TRYIN,__consortiaTryIn);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_TRYIN_DEL,__tryInDel);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_TRYIN_PASS,__consortiaTryInPass);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_RENEGADE,__renegadeUser);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_CHAIRMAN_CHAHGE,__oncharmanChange);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_ALLY_UPDATE,__onAllyUpdate);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_RICHES_OFFER,__givceOffer);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_DUTY_UPDATE,__dutyUpdate);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_LEVEL_UP,__onConsortiaLevelUp);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_ALLY_APPLY_ADD,__onAddAllyBack);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_DESCRIPTION_UPDATE,__consortiaDescriptionUpdate);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_ALLY_APPLY_UPDATE, __consortiaAllyApplyUpdate);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_ALLY_APPLY_DELETE, __consortiaAllyApplyDelete);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_STORE_UPGRADE, __onConsortiaLevelUpII);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_SMITH_UPGRADE, __onConsortiaLevelUpII);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_SHOP_UPGRADE,  __onConsortiaLevelUpII);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_EQUIP_CONTROL, __onConsortiaEquipControl);
			
			PlayerManager.Instance.consortiaMemberList.addEventListener(DictionaryEvent.UPDATE,_updateConsortiaMemberList);
			PlayerManager.Instance.consortiaMemberList.addEventListener(DictionaryEvent.ADD,_updateConsortiaMemberList);
			PlayerManager.Instance.consortiaMemberList.addEventListener(DictionaryEvent.REMOVE,_updateConsortiaMemberList);
			
			PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__onPopChange);
		}
		private function removeEvent():void
		{
			PlayerManager.Instance.removeEventListener(PlayerManager.CONSORTIA_CHANNGE,__consortiaChannge);
			PlayerManager.Instance.Self.removeEventListener(PlayerManager.FRIEND_STATE_CHANGED,_updateConsortiaMemberList);
			PlayerManager.Instance.removeEventListener(PlayerManager.SELF_CONSORTIA_COMPLETE,_updateConsortiaMemberList);
			
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONSORTIA_TRYIN,__consortiaTryIn);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_TRYIN_DEL,__tryInDel);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONSORTIA_TRYIN_PASS,__consortiaTryInPass);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONSORTIA_RENEGADE,__renegadeUser);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONSORTIA_CHAIRMAN_CHAHGE,__oncharmanChange);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONSORTIA_ALLY_UPDATE,__onAllyUpdate);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONSORTIA_RICHES_OFFER,__givceOffer);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONSORTIA_DUTY_UPDATE,__dutyUpdate);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONSORTIA_LEVEL_UP,__onConsortiaLevelUp);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONSORTIA_ALLY_APPLY_ADD,__onAddAllyBack);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONSORTIA_DESCRIPTION_UPDATE,__consortiaDescriptionUpdate);
			
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONSORTIA_ALLY_APPLY_UPDATE, __consortiaAllyApplyUpdate);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONSORTIA_ALLY_APPLY_DELETE, __consortiaAllyApplyDelete);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONSORTIA_STORE_UPGRADE, __onConsortiaLevelUpII);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONSORTIA_SMITH_UPGRADE, __onConsortiaLevelUpII);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONSORTIA_SHOP_UPGRADE,  __onConsortiaLevelUpII);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONSORTIA_EQUIP_CONTROL, __onConsortiaEquipControl);
			
			PlayerManager.Instance.consortiaMemberList.removeEventListener(DictionaryEvent.UPDATE,_updateConsortiaMemberList);
			PlayerManager.Instance.consortiaMemberList.removeEventListener(DictionaryEvent.ADD,_updateConsortiaMemberList);
			PlayerManager.Instance.consortiaMemberList.removeEventListener(DictionaryEvent.REMOVE,_updateConsortiaMemberList);
			PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__onPopChange);
			
		}
		private function __consortiaStoreLevelUp(evt : CrazyTankSocketEvent) : void
		{
			
		}
		private function __consortiaSmithLevelUp(evt : CrazyTankSocketEvent) : void
		{
			
		}
		private function __consortiaShopLevelUp(evt : CrazyTankSocketEvent) : void
		{
			
		}
		public function loadConsortiaEquipContrl() : void
		{
			var consortiaId : int = PlayerManager.Instance.Self.ConsortiaID;
			new LoadConsortiaAssetRight(consortiaId).loadSync(__resultConsortiaEquipContro);
		}
		private function __resultConsortiaEquipContro(action : LoadConsortiaAssetRight) : void
		{
			if(_model)_model.consortiaAssetLevelOffer = action.list;
		}
		
		override public function leaving(next:BaseStateView):void
		{
			super.leaving(next);
			BellowStripViewII.Instance.backFunction = null;
			BellowStripViewII.Instance.hide();
			_view.getViewBySate(currentState).leaveView();
			_view.leaving();
			_view.dispose();
			removeEvent();
			_view = null;
			if(_model)_model.clearData();
			_model = null;
			currentState = "";
			
//			ChatManager.Instance.outputChannel = ChatInputView.CURRENT;
//			ChatManager.Instance.inputChannel = ChatInputView.CURRENT;
		}
		override public function getBackType():String
		{
			return StateType.MAIN;
		}
		
		override public function getType():String
		{
			return StateType.CONSORTIA;
		}
		
		public function gotoConsortiaDiplomatism() : void
		{
//			this._view.gotoConsortiaDiplomatism();
		}
		
		
		
		
		/**
		 * 加载公会列表
		 */
		public function searchConsortiaClubList(page : int=1,count : int=6,order:int=-1,name:String = "",openApply:int=-1) : void
		{
			new LoadConsortias(page,count,order,name,-1,-1,openApply).loadSync(__consortiaClubSearchResult);
		}
		private function __consortiaClubSearchResult(action : LoadConsortias) : void
		{
			if(_model)_model.consortiaList = action.list;
			if(_model)_model.consortiaListTotalPage = Math.floor(action.totalCount/6);
		}
		
		/**
		 * 加载申请记录
		 */
		public function searchConsortiaApplyRecordList() : void
		{
			new LoadConsortiaApplyUsersList(1,1000,-1,-1,-1,PlayerManager.Instance.Self.ID).loadSync(__consortiaApplyRecordResult);
		}
		private function __consortiaApplyRecordResult(action : LoadConsortiaApplyUsersList) : void
		{
			if(_model)_model.myConsortiaAuditingApplyData = action.list;
		}
		
		/**
		 * 加载邀请记录
		 */
		 
		public function searchConsortiaInviteRecordList() : void
		{
			new LoadConsortiaInventList(PlayerManager.Instance.Self.ID).loadSync(__consortiaInviteRecordResult);
		}
		private function __consortiaInviteRecordResult(action : LoadConsortiaInventList) : void
		{
			if(_model)_model.consortiaInventList = action.list;
		}
		
		public function searchMyConsortiaMember() : void
		{
			new LoadConsortias(1,6).loadSync(__myConsortiaMemberResult);
		}
		private function __myConsortiaMemberResult(action : LoadConsortias) : void
		{
			if(_model)_model.consortiaMemberList = action.list;
		}
		public function loadMyConsortiaEventList(page:int,size:int,order:int = -1,consortiaID:int = -1) : void
		{
			PlayerManager.Instance.Self.loadMyConsortiaEventList(page,size,order,consortiaID);
		}
		
		private function __onPopChange(e:PlayerPropertyEvent) : void
		{
			if(e.changedProperties["myConsortiaEventList"])
			{
				if(_model)_model.consortiaEventList = PlayerManager.Instance.Self.myConsortiaEventList;
			}
			
		}
		
		public function searchMyConsortiaAuditingApply() : void
		{
			new LoadConsortias(1,6).loadSync(__myConsortiaAudingApplyResult);
		}
		private function __myConsortiaAudingApplyResult(action : LoadConsortias) : void
		{
			if(_model)_model.myConsortiaAuditingApplyData = action.list;
		}
		public function searchConsortiaApplyList() : void
		{
			new LoadConsortias(1,6).loadSync(__consortiaApplyResult);
		}
		private function __consortiaApplyResult(action :  LoadConsortias) : void
		{
			if(_model)_model.consortiaApplyList = action.list;
		}
		public function loadConsoritaDutyList(consortiaID:int=-1,dutyID:int=-1) : void
		{
			new LoadConsortiaDutyList(consortiaID,dutyID).loadSync(__consortiaDutyListResult);
		}
		private function __consortiaDutyListResult(evt : LoadConsortiaDutyList) : void
		{
			if(_model)_model.dutyList = evt.list;
		}
		/*公会外交中立与敌对*/
		public function loadAllyList(page:int = 1,state:int = 0,name:String =""):void
		{
			new LoadConsortiaAllyList(PlayerManager.Instance.Self.ConsortiaID,state,-1,page,6,name).loadSync(__onLoadAllyListBack);
		}
		private function __onLoadAllyListBack(loader: LoadConsortiaAllyList):void
		{
//			_currentpage = loader.page;
//			_total = loader.totalCount;
//			_totalPage = Math.ceil(_total / _countperpage);
//			_nextPageBtnAsset.enable = !((_totalPage <= 1) || (_currentpage == _totalPage));
//			_prePageAsset.enable = !(_currentpage == 1);
//			
//			this.pageTxt.text = String(_currentpage);
////			this.pageTxt.text = String((_currentpage - 1) * _countperpage + 1) + "-" + String(_currentpage * _countperpage) + "(总数" + String(_total) + ")";
//			
//			_model
//			this._consortiaList.infoList(loader.list);
            if(_model)_model.consortiaAllyCount = loader.totalCount;
           if(_model)_model.consortiaAllyList = loader.list;
		}
		
		
		private function __consortiaChannge(e:Event):void
		{
			sendGetMyConsortiaData();
			_updateConsortiaMemberList(null);
			viewState = CLUBE_STATE;
		}
		
		public function set viewState(state:String):void
		{
			if(state== currentState || !_view) return;
			if(_view.getViewBySate(currentState))
			{
				_view.getViewBySate(currentState).leaveView();
			}
			currentState = state;
			_view.getViewBySate(currentState).enterView();
			_view.viewState = currentState
			if(state == CLUBE_STATE)
			{
				BellowStripViewII.Instance.backFunction = null;
			}else if(state == MYCONSORTIA_STATE)
			{
				BellowStripViewII.Instance.backFunction = null;
			}
			else if(state == DIPLOMATISM_STATE)
			{
				BellowStripViewII.Instance.backFunction = addbacktoMyConsortia;
			}
			
		}
		
		private function addbacktoMyConsortia():void
		{
			viewState = MYCONSORTIA_STATE;
		}
		
		
		public function get viewState():String
		{
			return currentState
		}
		
		public function sendGetMyConsortiaData():void
		{
			new LoadConsortias(1,1,-1,"",-1,PlayerManager.Instance.Self.ConsortiaID).loadSync(__setMyConsortiaData);
		}
		
		private function __setMyConsortiaData(loader:LoadConsortias):void
		{
			if(_model)_model.myConsortiaData = loader.list[0];
		}
		
		public function loadSelfConsortiaMemberList (oder:int):void
		{
//			new LoadConsortiaMemberList(1,10000,oder,PlayerManager.Instance.Self.ConsortiaID,-1,-1).loadSync(__onMemberListBack);
		}
		
		private function __onMemberListBack(loader:LoadConsortiaMemberList):void
		{
			if(_model)_model.consortiaMemberList = loader.list;
		}
		
		
		/* 成功退出公会 */
		private function __renegadeUser(e:CrazyTankSocketEvent):void
		{
			var id:int = e.pkg.readInt();
			var isSuccess:Boolean = e.pkg.readBoolean();
			var msg:String = e.pkg.readUTF();
			if(isSuccess)
			{
				
			}
			MessageTipManager.getInstance().show(msg);
		}
		/*拒绝议和审批*/
		private function __consortiaAllyApplyDelete(evt : CrazyTankSocketEvent) : void
		{
			var id : int = evt.pkg.readInt();
			var isSuccess : Boolean = evt.pkg.readBoolean();
			var msg : String = evt.pkg.readUTF();
			if(isSuccess)_model.deleteAllyApplyItem(id);
			MessageTipManager.getInstance().show(msg);
		}
		/*同意议和审批*/
		private function __consortiaAllyApplyUpdate(evt : CrazyTankSocketEvent) : void
		{
			var id : int = evt.pkg.readInt();
			var isSuccess : Boolean = evt.pkg.readBoolean();
			var msg : String = evt.pkg.readUTF();
			if(isSuccess)_model.deleteAllyApplyItem(id);
			MessageTipManager.getInstance().show(msg);
		}
		
		private function __consortiaTryIn(evt:CrazyTankSocketEvent):void
		{
			var id:int = evt.pkg.readInt();
			 var isScuess:Boolean = evt.pkg.readBoolean();
			 var msg:String = evt.pkg.readUTF()
			 MessageTipManager.getInstance().show(msg);
			 if(isScuess)
			 {
			 	searchConsortiaApplyRecordList();//更新申请列表
			 }
		}
		
		private function _updateConsortiaMemberList(e:Event):void
		{
			if(e is DictionaryEvent && e.type==DictionaryEvent.UPDATE)
			{
				if(_model)_model.setConsortiaMemberList(PlayerManager.Instance.consortiaMemberList.list, (e as DictionaryEvent).data as ConsortiaPlayerInfo);
			}
			else
			{
				if(_model)_model.consortiaMemberList = PlayerManager.Instance.consortiaMemberList.list;
			}
		}
		
		/* 删除申请记录 */
		public function sendDeleteTryinRecord(id:int):void
		{
			SocketManager.Instance.out.sendConsortiaTryinDelete(id);
		}
		
		/* 删除申请记录返回 */
		private function __tryInDel(evt:CrazyTankSocketEvent):void
		{
			var id:int = evt.pkg.readInt();
			var isScuss:Boolean = evt.pkg.readBoolean();
			var msg:String = evt.pkg.readUTF();
			MessageTipManager.getInstance().show(msg);
			if(isScuss)_model.deleteMyConsortiaAuditingData(id);
		}
		
		/* 本公会的申请记录 */
		
		public function sendGetSelfConsortiaApplyList(id:int):void
		{
			new LoadConsortiaApplyUsersList(1,1000,-1,id).loadSync(__getSelfConsortiaApplyListBack);
		}
		
		private function __getSelfConsortiaApplyListBack(loader:LoadConsortiaApplyUsersList):void
		{
			if(_model)_model.myConsortiaAuditingApplyData = loader.list;
		}
		
		/* 通过申请 */
		public function sendTryinPass(id:int):void
		{
			SocketManager.Instance.out.sendConsortiaTryinPass(id);
		}
		
		/* 接受邀请 */
		public function sendInventPass(id:int):void
		{
			SocketManager.Instance.out.sendConsortiaInvatePass(id);
		}
		/*会长通过你的申请*/
		private function __consortiaTryInPass(e:CrazyTankSocketEvent):void
		{
			var id:int = e.pkg.readInt();
			var isSuccess:Boolean = e.pkg.readBoolean();
			var msg:String = e.pkg.readUTF();
			MessageTipManager.getInstance().show(msg);
			if(_model)_model.deleteMyConsortiaAuditingData(id);
		}
		
		
		/* 审批列表 */
		public function getApplyAllyList():void
		{
			
		}
		
		
		private function __oncharmanChange(e:CrazyTankSocketEvent):void
		{
			var nick:String = e.pkg.readUTF();
			var isSuccess:Boolean = e.pkg.readBoolean();
			var msg:String = e.pkg.readUTF();
			MessageTipManager.getInstance().show(msg);
		}
		
		/*上缴会费的返回*/
		private function __givceOffer(e:CrazyTankSocketEvent):void
		{
			var num:int = e.pkg.readInt();
			var isSuccess:Boolean = e.pkg.readBoolean();
			var msg:String = e.pkg.readUTF();
			MessageTipManager.getInstance().show(msg);
			if(isSuccess)
			{
				if(_model)_model.upMyConsortiaRiches(Math.floor(Number(num*100)));
			}
			
		}
		
		/* 公会升级 */
		private function __onConsortiaLevelUp (e:CrazyTankSocketEvent):void
		{
			var bagType:int = e.pkg.readByte();
			var place:int = e.pkg.readInt();
			var isSuccess:Boolean = e.pkg.readBoolean();
			var msg:String = e.pkg.readUTF();
			
			
			MessageTipManager.getInstance().show(msg);
			if(isSuccess)sendGetMyConsortiaData();
		}
		
		private function __onConsortiaEquipControl(evt : CrazyTankSocketEvent) : void
		{
			var levelOffer : ConsortiaAssetLevelOffer = new ConsortiaAssetLevelOffer();
			var offer : int = evt.pkg.readInt();
			offer = evt.pkg.readInt();
			offer = evt.pkg.readInt();
			offer = evt.pkg.readInt();
			offer = evt.pkg.readInt();
			offer     = evt.pkg.readInt();
			var isSuccess       : Boolean = evt.pkg.readBoolean();
			var msg             : String = evt.pkg.readUTF();
			MessageTipManager.getInstance().show(msg);
//			if(isSuccess)_model.consortiaAssetLevelOffer = levelOffer;
		}
		/**公会商城,铁匠铺,保管箱的升级***/
		private function __onConsortiaLevelUpII (e:CrazyTankSocketEvent):void
		{
			var isSuccess:Boolean = e.pkg.readBoolean();
			var msg:String = e.pkg.readUTF();
			
			
			MessageTipManager.getInstance().show(msg);
			if(isSuccess)sendGetMyConsortiaData();
		}
		
		/*  职务更新返回*/
		private function __dutyUpdate(evt:CrazyTankSocketEvent):void
		{
			var t:ConsortiaDutyInfo = new ConsortiaDutyInfo();
			t.DutyID = evt.pkg.readInt();
			var type:int = evt.pkg.readByte();
			var name:String = evt.pkg.readUTF();
            var right:int = evt.pkg.readInt();
			var isScuess:Boolean = evt.pkg.readBoolean();
			var id:int = evt.pkg.readInt();
			if(right == PlayerManager.Instance.Self.DutyLevel)
			{
				PlayerManager.Instance.Self.beginChanges();
				PlayerManager.Instance.Self.DutyName = name;
				PlayerManager.Instance.Self.commitChanges();
			}
			if(isScuess)
			{
				if(_model)_model.upDutyName(id,name);
//				添加更新
				if(type ==1 || type == 2)
				{
					
//					t.DutyID = id;
//					ConsortiaModel.getInstance().addDuty(t);
				}else if(type ==3 || type == 4)
				{
//				升级降级
//					ConsortiaModel.getInstance().setDutyLevel(t.DutyID,type == 3);
				}
			}
			var msg : String = evt.pkg.readUTF();
			MessageTipManager.getInstance().show(msg);
		}
		
		public function sendLoadDutyInfo(consortiaID:int):void
		{
			new LoadConsortiaDutyList(consortiaID).loadSync(__onDutyBack);;
		}
		
		private function __onDutyBack(loader:LoadConsortiaDutyList):void
		{
			if(_model)_model.dutyList = loader.list;
		}
		
		/*  中立地对审批列表*/
		public function loadAllyApplyList(state:int,consortiaID:int = -1):void
		{
			new LoadConsortiaApplayAllyList(state,1,1000,-1,consortiaID,-1).loadSync(__loadAllyApplyListBack);
		}
		
		private function __loadAllyApplyListBack(loader:LoadConsortiaApplayAllyList):void
		{
			if(_model)_model.allyApplyList = loader.list;
		}
		/*议和*/
		private function __onAddAllyBack(e:CrazyTankSocketEvent):void
		{
			var consortiaID:int = e.pkg.readInt();
			var isAlly:Boolean = e.pkg.readBoolean();
			var isSuccess:Boolean = e.pkg.readBoolean();
			var msg:String = e.pkg.readUTF();
			MessageTipManager.getInstance().show(msg);
		}
		/*宣战*/
		private function __onAllyUpdate(e:CrazyTankSocketEvent):void
		{
			var id:int = e.pkg.readInt();
			var isFright:Boolean = e.pkg.readBoolean();
			var isSuccess:Boolean = e.pkg.readBoolean();
			
			var msg:String = e.pkg.readUTF();
			MessageTipManager.getInstance().show(msg);
			if(isSuccess)_model.removeConsortiaAllyItem(id);
		}
		
		/*修改公会宣言*/
		private function __consortiaDescriptionUpdate(evt:CrazyTankSocketEvent):void
		{
			var description : String = evt.pkg.readUTF();
			var isSuccess:Boolean = evt.pkg.readBoolean();
			var msg:String = evt.pkg.readUTF();
			MessageTipManager.getInstance().show(msg);
			if(isSuccess)
			_model.upMyConsortiaDescription(description);
			
		}
		
//		private function __disClareUpdate(e:CrazyTankSocketEvent):void
//		{
//			var dis:String = e.pkg.readUTF();
//			var isSuccess:Boolean = e.pkg.readBoolean();
//			var msg:String = e.pkg.readUTF();
//			MessageTipManager.getInstance().show(msg);
//		}
		
		public function getConsortia():void
		{
			
		}
		
		
		
		
		

	}
}