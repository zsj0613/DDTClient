package ddt.data.game
{
	import flash.utils.Dictionary;
	
	import ddt.events.LivingEvent;
	
	[Event(name="attackingChanged",type="ddt.events.LivingEvent")]
	public class TurnedLiving extends Living
	{
		public function TurnedLiving(id:int,team:int,maxBlood:int)
		{
			super(id,team,maxBlood);
		}

		private var _isAttacking:Boolean = false;
		public function get isAttacking():Boolean
		{
			return _isAttacking;
		}
		public function set isAttacking(value:Boolean):void
		{
			if(_isAttacking == value) return;
			_isAttacking = value;
			dispatchEvent(new LivingEvent(LivingEvent.ATTACKING_CHANGED));
		}
		
		override public function beginNewTurn():void
		{
			super.beginNewTurn();
			isAttacking = false;   // jsion edit at 2009年11月10日
			_fightBuffs = new Dictionary();
		}
		
		override public function die(widthAction:Boolean = true):void
		{
			if(isLiving)
			{
				if(_isAttacking)
				{
					stopAttacking();
				}
				super.die(widthAction);
//				dispatchEvent(new LivingEvent(LivingEvent.DIE));
			}
		}
		
		/**
		 * 添加状态
		 * SP： -1 ，道具为道具的id。 
		 */
		private var _fightBuffs:Dictionary;
		public function hasState(stateId:int):Boolean
		{
			return _fightBuffs[stateId] != null;
		}		
		public function addState(stateId:int,pic:String = ""):void
		{
			if(stateId != 0)_fightBuffs[stateId] = true;
			dispatchEvent(new LivingEvent(LivingEvent.ADD_STATE,stateId,0,pic));
		}
		
		public function startAttacking():void
		{
			isAttacking = true;
		}
		
		public function stopAttacking():void
		{
			isAttacking = false;
		}
		
		override public function dispose():void
		{
			_fightBuffs = null;
			super.dispose();
		}
	}
}