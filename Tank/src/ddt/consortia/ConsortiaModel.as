package ddt.consortia
{
	import flash.events.EventDispatcher;
	
	import road.data.DictionaryData;
	
	import ddt.consortia.data.ConsortiaApplyInfo;
	import ddt.consortia.data.ConsortiaDiplomatismInfo;
	import ddt.consortia.data.ConsortiaDutyInfo;
	import ddt.consortia.event.ConsortiaDataEvent;
	import ddt.data.ConsortiaInfo;
	import ddt.data.player.ConsortiaPlayerInfo;
	import ddt.manager.PlayerManager;
	
	public class ConsortiaModel extends EventDispatcher
	{
		
		private var _consortiaList:Array = [];
		private var _consortiaInventList:Array = [];
		private var _consortiaApplyList:Array = [];
		private var _consortiaMemberList:Array = [];
		private var _consortiaDisplayBoard:String = "";
		private var _myConsortiaData:ConsortiaInfo = new ConsortiaInfo();
		private var _consortiaEventList:Array = [];
		private var _myConsortiaAuditingApplyList : Array = [];
		private var _consortiaAllyList:Array = [];
		private var _dutyList:Array = [];
		private var _consortiaAssetLevelOffer : Array;
		
		private var _allyApplyList:Array;
		
		
		public function ConsortiaModel()
		{
		}
		
		public function clearData() : void
		{
			_consortiaList = null;
			_consortiaInventList = null;
			_consortiaApplyList = null;
			_consortiaMemberList = null;
			_myConsortiaData = null;
			_consortiaEventList = null;
			_myConsortiaAuditingApplyList = null;
			_consortiaAllyList = null;
			_consortiaAllyList = null;
			_dutyList = null;
			_allyApplyList = null;
		}
		public function get consortiaList():Array
		{
			return _consortiaList;
		}
		
		private var _consortiaListTotalPage : int;
		public function get consortiaListTotalPage() : int
		{
			return _consortiaListTotalPage;
		}
		public function set consortiaListTotalPage(i : int) : void
		{
			_consortiaListTotalPage = i;
		} 
		public function set consortiaList($list:Array):void
		{
			/* 发出改变的事件 更新视图 */
			if($list)
			{
				_consortiaList = $list;
			}else
			{
				_consortiaList = [];
			}
			this.dispatchEvent(new ConsortiaDataEvent(ConsortiaDataEvent.CONSORTIA_LIST_CHANGE));
		}
		/***使用公会的商城,铁匠铺需要贡献的财富****/
		public function set consortiaAssetLevelOffer($info : Array) :void
		{
			if(!$info)return;
			_consortiaAssetLevelOffer = $info;
			dispatchEvent(new ConsortiaDataEvent(ConsortiaDataEvent.CONSORTIA_ASSET_LEVEL_OFFER));
		}
		public function get consortiaAssetLevelOffer() : Array
		{
			return _consortiaAssetLevelOffer;
		}
		
		public function get consortiaInventList():Array
		{
			return _consortiaInventList;
		}
		
		public function set consortiaInventList($list:Array):void		
		{
			/* 发出改变的事件 更新视图 */
//			_consortiaInventList = $list;
			if($list)
			{
				_consortiaInventList = $list;
			}else
			{
				_consortiaInventList = [];
			}
			this.dispatchEvent(new ConsortiaDataEvent(ConsortiaDataEvent.CONSORTIA_INVITE_RECORD_CHANGE));
		}
		
		/**
		 * 中立公会
		 */
		 public function get neutralConsortiaList() : Array
		 {
		 	var temp : Array = new Array();
		 	for(var i:int=0;i<this._consortiaList.length;i++)
		 	{
//		 		if(是否中立)temp.push(_consortiaList[i]);
		 	}
		 	return temp;
		 }
		 
		/**
		 * 敌对公会
		 */
		 
		 public function get antagonizeConsortiaList() : Array
		 {
		 	var temp : Array = new Array();
		 	for(var i:int=0;i<this._consortiaList.length;i++)
		 	{
//		 		if(是否敌对)temp.push(_consortiaList[i]);
		 	}
		 	return temp;
		 }
		
		
		
		public function get consortiaApplyList():Array
		{
			return _consortiaApplyList
		}
		
		public function set consortiaApplyList($list:Array):void
		{
			/* 发出改变的事件 更新视图 */
//			_consortiaApplyList = $list;
			if($list)
			{
				_consortiaApplyList = $list;
			}else
			{
				_consortiaApplyList = [];
			}
			this.dispatchEvent(new ConsortiaDataEvent(ConsortiaDataEvent.CONSORTIA_APPLY_RECORD_CHANGE));
		}
		
		public function get consortiaMemberList():Array
		{
			return _consortiaMemberList;
		}
		
		public function set consortiaMemberList($list:Array):void
		{
			///* 发出改变的事件 更新视图 */
			_consortiaMemberList = $list
			dispatchEvent(new ConsortiaDataEvent(ConsortiaDataEvent.CONSORTIA_MEMBER_LIST_CHANGE,$list));
		}
		
		public function setConsortiaMemberList($list:Array, item:ConsortiaPlayerInfo):void
		{
			_consortiaMemberList=$list;
			
			/* 发出改变的事件 更新视图 */
			dispatchEvent(new ConsortiaDataEvent(ConsortiaDataEvent.CONSORTIA_MEMBER_LIST_CHANGE,item));
		}		
		
		public function get consortiaDisplayBoard():String
		{
			return _consortiaDisplayBoard;
		}
		
		public function set consortiaDisplayBoard(msg:String):void
		{
			_consortiaDisplayBoard = msg
		}
		
		/**更新公会财富*/
		public function upMyConsortiaRiches(m : int) : void
		{
			_myConsortiaData.Riches += m;
			if(PlayerManager.Instance.Self.ConsortiaRiches != _myConsortiaData.Riches)
			PlayerManager.Instance.Self.ConsortiaRiches = _myConsortiaData.Riches;
			var info  : ConsortiaPlayerInfo;
			for(var i:int=0;i<this._consortiaMemberList.length;i++)
			{
			    info = _consortiaMemberList[i] as ConsortiaPlayerInfo;
				if(PlayerManager.Instance.Self.ID == info.info.ID)
				{
//					info.RichesOffer += m;
//					info.info.RichesOffer = info.RichesOffer;
					break;
				}
			}
			dispatchEvent(new ConsortiaDataEvent(ConsortiaDataEvent.UP_MY_CONSORTIA_DATA_CHANGE,info));
			
			
		}
		/*更新公会宣言*/
		public function upMyConsortiaDescription(msg : String) : void
		{
			_myConsortiaData.Description = msg;
			dispatchEvent(new ConsortiaDataEvent(ConsortiaDataEvent.UP_MY_CONSORTIA_Description));
			
		}
		public function get myConsortiaData():ConsortiaInfo
		{
			return _myConsortiaData;
		}
		
		public function set myConsortiaData(c:ConsortiaInfo):void
		{
			_myConsortiaData = c;
			if(_myConsortiaData)
			{
				if(PlayerManager.Instance.Self.StoreLevel != c.StoreLevel)
				PlayerManager.Instance.Self.StoreLevel = c.StoreLevel;
				if(PlayerManager.Instance.Self.SmithLevel != c.SmithLevel)
				PlayerManager.Instance.Self.SmithLevel = c.SmithLevel;
				if(PlayerManager.Instance.Self.ShopLevel != c.ShopLevel)
				PlayerManager.Instance.Self.ShopLevel  = c.ShopLevel;
				if(PlayerManager.Instance.Self.ConsortiaRiches != c.Riches)
				PlayerManager.Instance.Self.ConsortiaRiches = c.Riches;
				dispatchEvent(new ConsortiaDataEvent(ConsortiaDataEvent.MY_CONSORTIA_DATA_CHANGE,c));
			}
			else
			{
				PlayerManager.Instance.Self.StoreLevel = 0;
				PlayerManager.Instance.Self.SmithLevel = 0;
				PlayerManager.Instance.Self.ShopLevel  = 0;
				PlayerManager.Instance.Self.ConsortiaRiches = 0;
			}
		}
		public function myConsortiaDataEvent() : void
		{
			dispatchEvent(new ConsortiaDataEvent(ConsortiaDataEvent.MY_CONSORTIA_DATA_CHANGE,_myConsortiaData));
		}
		
		public function set consortiaEventList($list:Array):void
		{
//			_consortiaEventList = $list;
			if($list)
			{
				_consortiaEventList = $list;
			}else
			{
				_consortiaEventList = [];
			}
			
			this.dispatchEvent(new ConsortiaDataEvent(ConsortiaDataEvent.CONSORTIA_EVENT_LIST_CHANGE,$list));

			
		}
		
		public function get consortiaEventList():Array
		{
			return _consortiaEventList
		}
		
		private var _consortiaAllyCount : int;
		public function set consortiaAllyCount(i : int) : void
		{
			this._consortiaAllyCount = i;
		}
		public function get consortiaAllyCount() : int
		{
			return this._consortiaAllyCount;
		}
		/*公会外交*/
		public function set consortiaAllyList($list:Array):void
		{
//			_consortiaAllyList = $list;
			if($list)
			{
				_consortiaAllyList = $list;
			}else
			{
				_consortiaAllyList = [];
			}
			
//			updateSelfConsortiaAllyList();
			dispatchEvent(new ConsortiaDataEvent(ConsortiaDataEvent.CONSORTIA_ALLY_LIST_CHANGE,$list));
		}
		
		private function updateSelfConsortiaAllyList():void
		{
//			var aList:DictionaryData = PlayerManager.Instance.Self.ConsortiaAllyList;
//			for(var j:uint = 0;j< _consortiaAllyList.length;j++)
//			{
//				aList.add(_consortiaAllyList[j].ConsortiaID,_consortiaAllyList[j]);
//			}
		}
		
		public function updateSelfConsortiaAllyListByID(id:int,isFright:Boolean):void
		{
//			var aList:DictionaryData = PlayerManager.Instance.Self.ConsortiaAllyList;
//			for(var j:uint = 0;j< aList.length;j++)
//			{
//				if(id == aList[j])
//				{
//					var info:ConsortiaInfo = aList[j]
//					info.State = isFright ? 2 : 0;
//					aList.add(info.ConsortiaID,info);
//					return
//				}
//			}
//			var tempInfo:ConsortiaInfo = new ConsortiaInfo();
//			tempInfo.ConsortiaID = id;
//			tempInfo.State = isFright ? 2 : 0;
//			aList.add(tempInfo.ConsortiaID,tempInfo);
		}
		
		public function get consortiaAllyList():Array
		{
			return _consortiaAllyList;
		}
		/*删去公会外交中的一个公会*/
		public function removeConsortiaAllyItem(consortiaID : int) : void
		{
			for(var i:int=0;i<_consortiaAllyList.length;i++)
			{
				var info : ConsortiaInfo = _consortiaAllyList[i] as ConsortiaInfo;
				if(consortiaID == info.ConsortiaID)
				{
					_consortiaAllyList.splice(i,1);
					dispatchEvent(new ConsortiaDataEvent(ConsortiaDataEvent.CONSORTIA_ALLY_ITEM_REMOVE,consortiaID));
					break;
				}
			}
		}
		
		
		

		/*申请审核的*/
		public function set myConsortiaAuditingApplyData($list : Array) : void
		{
//			this._myConsortiaAuditingApplyList = $list;
			if($list)
			{
				_myConsortiaAuditingApplyList = $list;
			}else
			{
				_myConsortiaAuditingApplyList = [];
			}
			
			this.dispatchEvent(new ConsortiaDataEvent(ConsortiaDataEvent.MY_CONSORTIA_AUDITING_APPLY_DATA_CHAGE,$list));
		}
		/*删除申请列表中的一条记录*/
		public function deleteMyConsortiaAuditingData(id : int) : void
		{
			for(var i:int=0;i<this._myConsortiaAuditingApplyList.length;i++)
			{
				var CAI : ConsortiaApplyInfo = _myConsortiaAuditingApplyList[i];
				if(CAI.ID == id)
				{
					_myConsortiaAuditingApplyList.splice(i,1);
					this.dispatchEvent(new ConsortiaDataEvent(ConsortiaDataEvent.DELETE_CONSORTIA_APPLY,id));
					break;
				}
			}
		}
		public function get myConsortiaAuditingApplyData() : Array
		{
			return this._myConsortiaAuditingApplyList;
		}
		
		/*更新职位*/
		public function upDutyName(id:int,name:String) : void
		{
			for(var i:int=0;i<_dutyList.length;i++)
			{
				var info : ConsortiaDutyInfo = _dutyList[i];
				if(info.DutyID == id)
				{
					info.DutyName = name;
					dispatchEvent(new ConsortiaDataEvent(ConsortiaDataEvent.DUTY_LIST_CHANGE));
					break;
				}
			}
		}
		/*职位列表*/
		public function get dutyList():Array
		{
			return _dutyList;
		}
		
		public function set dutyList($list:Array):void
		{
//			_dutyList = $list;
			
			if($list)
			{
				_dutyList = $list;
			}else
			{
				_dutyList = [];
			}
			dispatchEvent(new ConsortiaDataEvent(ConsortiaDataEvent.DUTY_LIST_CHANGE,$list));
		}
		
		/*通过/拒绝议和审批*/
		public function deleteAllyApplyItem(id : int) : void
		{
			for(var i:int=0;i<_allyApplyList.length;i++)
			{
				var info : ConsortiaDiplomatismInfo = _allyApplyList[i] as ConsortiaDiplomatismInfo;
				if(info.ID == id)
				{
					_allyApplyList.splice(i,1);
					dispatchEvent(new ConsortiaDataEvent(ConsortiaDataEvent.DELETE_ALLY_APPLY_ITEM,id));
					break;
				}
			}
		}
		/*议和审批*/
		public function set allyApplyList($list:Array):void
		{
//			_allyApplyList = $list;
			if($list)
			{
				_allyApplyList = $list;
			}else
			{
				_allyApplyList = [];
			}
			dispatchEvent(new ConsortiaDataEvent(ConsortiaDataEvent.ALLY_APPLY_LIST_CHANGE,$list));
		}
		public function get allyApplyList ():Array
		{
			return _allyApplyList;
		}
		
		
		
		
		
		

	}
}