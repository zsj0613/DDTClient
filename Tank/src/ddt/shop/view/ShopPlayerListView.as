package ddt.shop.view
{
	import flash.events.MouseEvent;
	
	import road.data.DictionaryData;
	import road.manager.SoundManager;
	import road.ui.controls.SimpleGrid;
	import road.utils.ComponentHelper;
	
	import ddt.data.player.ConsortiaPlayerInfo;
	import ddt.manager.PlayerManager;
	
	import webGame.crazyTank.view.shopII.ShopIIPlayerListBGAsset;

	public class ShopPlayerListView extends ShopIIPlayerListBGAsset
	{
		private var _playerlist:SimpleGrid;
		private var _doselected:Function;
		private var _currentType : int;
		
		public function ShopPlayerListView(doSelected:Function = null)
		{
			_doselected = doSelected;
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			bg.gotoAndStop(1);
			_currentType = 1;
			_playerlist = new SimpleGrid(190,22,1);
			_playerlist.horizontalScrollPolicy = "off";
			ComponentHelper.replaceChild(this,list_pos,_playerlist);
			setList(PlayerManager.Instance.friendList);
			btn_1.buttonMode = true;
		}
		
		private function initEvent():void
		{
			btn_0.addEventListener(MouseEvent.CLICK,__btnClick);
			btn_1.addEventListener(MouseEvent.CLICK,__btnClick);
		}
		
		private function __btnClick(evt:MouseEvent):void
		{
			evt.stopImmediatePropagation();
			
			var index:int = Number(evt.currentTarget.name.slice(4,5));
			bg.gotoAndStop(index + 1);
			if(_currentType == bg.currentFrame)return ;
			_currentType = bg.currentFrame;
			if(index == 0)
			{
				btn_1.buttonMode = true;
				btn_0.buttonMode = false;
				setList(PlayerManager.Instance.friendList);
			}
			else 
			{
				btn_0.buttonMode = true;
				btn_1.buttonMode = false;
				setList(PlayerManager.Instance.consortiaMemberList);
			}
			SoundManager.instance.play("008");
				
		}
		
		private function setList(list:DictionaryData):void
		{
			_playerlist.clearItems();
			for(var i:String in list)
			{
				var item:ShopPlayerListItem
				if(list[i] is ConsortiaPlayerInfo)
				{
					item = new ShopPlayerListItem(list[i].info,_doselected);
				}else
				{
					item = new ShopPlayerListItem(list[i],_doselected);
				}
				
				_playerlist.appendItem(item);
			}
		}
	}
}