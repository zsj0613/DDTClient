package ddt.game.actions
{
	import flash.display.MovieClip;
	
	import game.crazyTank.view.LoseAsset;
	import game.crazyTank.view.MissionOverContextAsset;
	import game.crazyTank.view.WinAsset;
	
	import road.display.MovieClipWrapper;
	import road.manager.SoundManager;
	
	import ddt.actions.BaseAction;
	import ddt.data.MissionInfo;
	import ddt.data.gameover.BaseSettleInfo;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.game.map.MapView;
	import ddt.gameover.settlement.item.PlayerSettleItem;
	import ddt.manager.GameManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;

	public class MissionOverAction extends BaseAction
	{
		private var _event:CrazyTankSocketEvent;
		private var _executed:Boolean;
		private var _count:int;
		private var _map:MapView;
		public function MissionOverAction(map:MapView,event:CrazyTankSocketEvent,waitTime:Number = 3000)
		{
			_event = event;
			_map = map;
			_count = waitTime / 40;
		}
		
		override public function cancel():void
		{
			_event.executed = true;
		}
		
		
		
		override public function execute():void
		{
			if(!_executed)
			{
				if(_map.hasSomethingMoving() == false && (_map.currentPlayer == null || _map.currentPlayer.actionCount == 0 ))
				{
					_executed = true;
					_event.executed = true;
					if(_map.currentPlayer) _map.currentPlayer.beginNewTurn();
					var movie:MovieClipWrapper;
					var infoPane : MissionOverContextAsset = new MissionOverContextAsset();
					upContextView(infoPane);
					var mc:MovieClip;
					if(GameManager.Instance.Current.selfGamePlayer.isWin)
					{
						 mc = new WinAsset();
					}
					else
					{
						mc = new LoseAsset();
					}
					mc.addChild(infoPane);
					movie = new MovieClipWrapper(mc,true,true);
					SoundManager.instance.play("040");
					movie.x = 500;
					movie.y = 360;
					_map.gameView.addChild(movie);
					_map.gameView.gameOver();
				}
			}
			else
			{
				_count --;
				if(_count <=0)
				{
					_isFinished = true;
					if(GameManager.Instance.Current.hasNextMission)
					{
						_map.gameView.gotoMissionOverState();
					}
				}
			}
		}
		
		private function initContextView(mc : MissionOverContextAsset) : void
		{
			mc.stateTxt.mouseEnabled = mc.stateTxt.selectable = false;
			mc.titleTxt1.mouseEnabled = mc.titleTxt1.selectable = false;
			mc.titleTxt2.mouseEnabled = mc.titleTxt2.selectable = false;
			mc.titleTxt3.mouseEnabled = mc.titleTxt3.selectable = false;
			mc.valueTxt1.mouseEnabled = mc.valueTxt1.selectable = false;
			mc.valueTxt2.mouseEnabled = mc.valueTxt2.selectable = false;
			mc.valueTxt3.mouseEnabled = mc.valueTxt3.selectable = false;
		}
		
		private function upContextView(mc : MissionOverContextAsset) : void
		{
			initContextView(mc);
			var info : MissionInfo = GameManager.Instance.Current.missionInfo;
			var gameOverInfo:BaseSettleInfo = GameManager.Instance.Current.missionInfo.findMissionOverInfo(PlayerManager.Instance.Self.ID);
			mc.titleTxt1.text = LanguageMgr.GetTranslation("ddt.game.actions.kill");
			mc.valueTxt1.text = String(info.currentValue2);
			
			mc.titleTxt2.text = LanguageMgr.GetTranslation("ddt.game.actions.turn");
			mc.valueTxt2.text = String(info.currentValue1);
			
			mc.titleTxt3.text = LanguageMgr.GetTranslation("ddt.game.BloodStrip.HP");
			mc.valueTxt3.text = String(gameOverInfo.treatment);
			
			var missionInfo : MissionInfo = GameManager.Instance.Current.missionInfo;
			var graded : int = missionInfo.findMissionOverInfo(PlayerManager.Instance.Self.ID).graded;
			
			mc.stateTxt.text = PlayerSettleItem.getGradedStr(graded);
		}
		
	}
}