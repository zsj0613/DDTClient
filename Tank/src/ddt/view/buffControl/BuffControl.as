package ddt.view.buffControl
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Sprite;
	
	import road.data.DictionaryData;
	import road.data.DictionaryEvent;
	import road.ui.controls.SimpleGrid;
	
	import ddt.data.BuffInfo;
	import ddt.manager.PlayerManager;
	import ddt.view.bagII.TipGrid;
	import ddt.view.buffControl.buffButton.BuffButton;

	public class BuffControl extends Sprite
	{
		private var _buffData:DictionaryData;
		private var _buffList:TipGrid;
		private var _buffBtnArr:Array;
		
		public function BuffControl()
		{
			init();
			initEvents();
		}
		
		private function init():void
		{
			_buffData = PlayerManager.Instance.Self.buffInfo;
			
			_buffList = new TipGrid();
			_buffList.rowCount = 1;
            _buffList.paddingH = 6.1;
            _buffList.width = 200;
            addChild(_buffList);
            initBuffButtons();
		}
		
		private function initEvents():void
		{
			_buffData.addEventListener(DictionaryEvent.ADD,__addBuff);
			_buffData.addEventListener(DictionaryEvent.REMOVE,__removeBuff);
			_buffData.addEventListener(DictionaryEvent.UPDATE,__addBuff);
		}
		
		private function removeEvents():void
		{
			if(_buffData)
			{
				_buffData.removeEventListener(DictionaryEvent.ADD,__addBuff);
				_buffData.removeEventListener(DictionaryEvent.REMOVE,__removeBuff);
				_buffData.removeEventListener(DictionaryEvent.UPDATE,__addBuff);
			}
		}
		
		private function initBuffButtons():void
		{
			_buffBtnArr = []
			for(var i:int = 1; i<=4; i++)
			{
				var item:BuffButton = BuffButton.createBuffButton(i);
				item.setSize(26,30);
				_buffList.appendItem(item);
				_buffBtnArr.push(item);
			}
			_buffList.updataChildPosition();
			setInfo(_buffData);
		}
		
		public function setInfo(buffData:DictionaryData):void
		{
			for(var j:String in buffData)
			{
				if(buffData[j]!=null)
				{
			    	switch(buffData[j].Type)
			    	{
			    		case BuffInfo.FREE:
		    		    _buffBtnArr[0].info = buffData[j];
		 	    	    break;
		        		case BuffInfo.DOUBEL_EXP://经验
			    	    _buffBtnArr[1].info = buffData[j];
			    	    break;
		        		case BuffInfo.DOUBLE_GESTE://功勋
				        _buffBtnArr[2].info = buffData[j];
		 	    	    break;
		    	    	case BuffInfo.PREVENT_KICK://防踢卡
				        _buffBtnArr[3].info = buffData[j];
			    	    break;
			    	}
				}
			}
		}
		
		private function __addBuff(evt:DictionaryEvent):void
		{
			var buffInfo:BuffInfo = (evt.data as BuffInfo);
			switch(buffInfo.Type)
			{
				case BuffInfo.FREE:
				    setBuffButtonInfo(0,buffInfo);
				    break;
				case BuffInfo.DOUBEL_EXP://经验
				    setBuffButtonInfo(1,buffInfo);
				    break;
				case BuffInfo.DOUBLE_GESTE://功勋
				    setBuffButtonInfo(2,buffInfo);
				    break;
				case BuffInfo.PREVENT_KICK://防踢卡
				    setBuffButtonInfo(3,buffInfo);
				    break;
			}
		}
		
		private function setBuffButtonInfo(btnId:int,buffinfo:BuffInfo):void
		{
			if(buffinfo.IsExist)
		    {
		    	_buffBtnArr[btnId].info = buffinfo;
		    }else
		    {
		    	_buffBtnArr[btnId].isExist = false;
		    }
		}
		
		private function __removeBuff(evt:DictionaryEvent):void
		{
			switch((evt.data as BuffInfo).Type)
			{
				case BuffInfo.FREE:
				    _buffBtnArr[0].info = new BuffInfo(BuffInfo.FREE);
				    break;
				case BuffInfo.DOUBEL_EXP://经验
				    _buffBtnArr[1].info = new BuffInfo(BuffInfo.DOUBEL_EXP);
				    break;
				case BuffInfo.DOUBLE_GESTE://功勋
				    _buffBtnArr[2].info = new BuffInfo(BuffInfo.DOUBLE_GESTE);
				    break;
				case BuffInfo.PREVENT_KICK://防踢卡
				    _buffBtnArr[3].info = new BuffInfo(BuffInfo.PREVENT_KICK);
				    break;
			}
		}
		
		private function __updateBuff(evt:DictionaryEvent):void
		{
		}
		
		
		public function set CanClick(value:Boolean):void
		{
			for each(var i:BuffButton in _buffBtnArr)
			{
				i.CanClick = value;
			}
		}
		
		public function set ShowTip(value:Boolean):void
		{
			for each(var i:BuffButton in _buffBtnArr)
			{
				i.ShowTip = value;
			}
		}
		
		
		public function dispose():void
		{
			removeEvents();
			
//			if(_buffList)
//			{
//				for each(var item:BuffButton in _buffList.items)
//				{
//					item.dispose()
//				}
//				_buffList.clearItems();
//				
//				if(_buffList.parent)
//					_buffList.parent.removeChild(_buffList);
//				_buffList.clearItems();
//			}
			_buffList = null;
			
			_buffData = null;
			_buffBtnArr = null;
			
			if(parent)
				parent.removeChild(this);
		}
		
	}
}