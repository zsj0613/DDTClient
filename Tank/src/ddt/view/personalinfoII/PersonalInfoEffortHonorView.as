package ddt.view.personalinfoII
{
	import fl.controls.BaseButton;
	import fl.controls.ScrollPolicy;
	
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.personalinfoII.EffortHonorAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.SimpleGrid;
	
	import ddt.events.EffortEvent;
	import ddt.manager.EffortManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;

	public class PersonalInfoEffortHonorView extends EffortHonorAsset
	{
		private var _honorList:SimpleGrid;
		private var _honorArray:Array;
		public function PersonalInfoEffortHonorView(honorArray:Array = null)
		{
			super();
			_honorArray = honorArray;
			var arr:Array = [0,LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.null")];
			_honorArray.push(arr);
			init();
			initEvent();
		}
		
		private function init():void
		{
			this.honor_txt.text = PlayerManager.Instance.Self.honor ? PlayerManager.Instance.Self.honor : "";
			this.bottomII.buttonMode = true;
			this.bg.visible     = false;
			update();
			if(_honorList)_honorList.visible = false;
		}
		
		private function initEvent():void
		{
			addEventListener(MouseEvent.CLICK , __viewClick);
			EffortManager.Instance.addEventListener(EffortEvent.FINISH , __upadte);
		}
		
		private function __upadte(evt:EffortEvent):void
		{
			clearList();
			setlist(EffortManager.Instance.getHonorArray());
		}
		
		public function setlist(honorArray:Array):void
		{
			_honorArray = [];
			_honorArray = honorArray;
			var arr:Array = [0,LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.null")];
			_honorArray.push(arr);
		}
		
		private function update():void
		{
			clearList();
			_honorList = new SimpleGrid();
			_honorList.x = bg.x;
			_honorList.y = bg.y;
			_honorList.verticalScrollPolicy   = ScrollPolicy.AUTO;
			_honorList.horizontalScrollPolicy = ScrollPolicy.OFF;
			_honorList.setSize(86,82);
			addChild(_honorList);
			for each( var arr:Array in _honorArray )
			{
				var item:PersonalInfoEffortHonorItemView = new PersonalInfoEffortHonorItemView(arr);
				item.addEventListener(MouseEvent.CLICK , __itemClick);
				_honorList.appendItem(item);
			}
		}
		
		private function __itemClick(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			var honor:String = (evt.currentTarget as PersonalInfoEffortHonorItemView).honor;
			var id:int = (evt.currentTarget as PersonalInfoEffortHonorItemView).id;
			this.honor_txt.text = honor;
			if(this.honor_txt.text != LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.null") )
			{
				SocketManager.Instance.out.sendReworkRank(honor,id);
			}else
			{
				SocketManager.Instance.out.sendReworkRank("",id);
				this.honor_txt.text = "";
			}
			
		}
		
		private function __viewClick(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			if(evt.target is BaseButton)return;
			if(!bg.visible)
			{
				this.bg.visible     = true;
				if(_honorList)_honorList.visible = true;
				update();
				if(stage)
				{
					stage.addEventListener(MouseEvent.CLICK , __closeView);
				}
			}else
			{
				if(stage)
				{
					stage.removeEventListener(MouseEvent.CLICK , __closeView);
				}
				this.bg.visible     = false;
				if(_honorList)_honorList.visible = false;
				clearList();
			}
		}
		
		private function __closeView(evt:MouseEvent):void
		{
			if(evt.target.name != "bottomII" && !(evt.target is BaseButton))
			{
				this.bg.visible     = false;
				if(_honorList)_honorList.visible = false;
				clearList();
				if(stage)stage.removeEventListener(MouseEvent.CLICK , __closeView);
			}
		}
		
		private function clearList():void
		{
			if(_honorList)
			{
				for(var i:int = 0;i<_honorList.itemCount;i++)
				{
					_honorList.items[i].removeEventListener(MouseEvent.CLICK,__itemClick);
					_honorList.items[i].dispose();
				}
				_honorList.clearItems();
			}
			if(_honorList && _honorList.parent)
				_honorList.parent.removeChild(_honorList);
			_honorList = null;
		}
		
		public function dispose():void
		{
			if(stage)
			{
				stage.removeEventListener(MouseEvent.CLICK , __closeView);
			}
			clearList();
			removeEventListener(MouseEvent.CLICK , __viewClick);
			EffortManager.Instance.removeEventListener(EffortEvent.FINISH , __upadte);
		}
	}
}