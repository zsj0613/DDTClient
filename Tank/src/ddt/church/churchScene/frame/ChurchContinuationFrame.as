package ddt.church.churchScene.frame
{
	import ddt.church.churchScene.SceneControler;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.controls.hframe.HConfirmFrame;
	
	import tank.church.ContinuationAsset;
	import ddt.manager.ChurchRoomManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.utils.DisposeUtils;
	import ddt.utils.LeavePage; 
	
	public class ChurchContinuationFrame extends HConfirmFrame
	{
		private var _bg:ContinuationAsset;
		private var _controler:SceneControler;

		private var _secondType:uint = 2;
		private static var PRICE:Array = [2000,2700,3400];
		
		public function ChurchContinuationFrame(controler:SceneControler)
		{
			this._controler = controler;
			
			this.buttonGape = 100;
			this.setContentSize(290,160);
			
			this.cancelFunction =__cancel;
			this.okFunction =__confirm ;
			
			init();
			addEvent();
		}
		
		private function init():void
		{
			moveEnable = false;
			_bg = new ContinuationAsset();
			addContent(_bg,true);
			
			for(var i:uint = 0;i<3;i++)
			{
				var m:MovieClip = (_bg["time"+i+"_mc"] as MovieClip);
				m.buttonMode = true;
			}
			
			resetSecondBtn();
			
			_bg.time0_mc.gotoAndStop(2);
			
			_bg.hourLight_mc.mouseEnabled = false;
		}
		
		private function addEvent():void
		{
			for(var i:uint = 0;i<3;i++)
			{
				var m:MovieClip = (_bg["time"+i+"_mc"] as MovieClip);
				m.addEventListener(MouseEvent.CLICK,__secondClick);
			}
		}
		
		private function __secondClick(event:MouseEvent):void
		{
			SoundManager.instance.play("043");
			var index:Number = Number(event.currentTarget.name.slice(4,5));
			
			resetSecondBtn();
			
			(_bg["time"+index+"_mc"] as MovieClip).gotoAndStop(2);
			
			_secondType = index+2;
			
			_bg.hourLight_mc.x = (event.currentTarget as MovieClip).x -4;
		}
		
		private function resetSecondBtn():void
		{
			for(var i:uint = 0;i<3;i++)
			{
				var m:MovieClip = (_bg["time"+i+"_mc"] as MovieClip);
				m.gotoAndStop(1);
			}
		}
		
		private function __confirm():void
		{
			if(checkMoney()&&ChurchRoomManager.instance.currentRoom)
			{
				SocketManager.Instance.out.sendChurchContinuation(_secondType);
			}
			
			dispose();
		}
		
		private function checkMoney():Boolean
		{
			if(PlayerManager.Instance.Self.Money<PRICE[_secondType-2])
			{
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.comon.lack"),true,LeavePage.leaveToFill,null);
				
				dispose();
				return false;
			}
			
			return true;
		}
		
		private function __cancel():void
		{
			dispose();
		}
		override public function dispose():void
		{
			super.dispose();
			DisposeUtils.disposeDisplayObject(_bg);
			if(this.parent)this.parent.removeChild(this);
		}
	}
}