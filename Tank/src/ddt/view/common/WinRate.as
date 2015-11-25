package ddt.view.common
{
	import game.crazyTank.view.common.WinRateAccect;
	public class WinRate extends WinRateAccect
	{
		private var _win:int;
		private var _total:int;
		public function WinRate($win:int,$total:int):void
		{
			_win = $win;
			_total = $total;
			setRate(_win,_total);
		}

		public function setRate($win:int,$total:int):void
		{
			_win = $win;
			_total = $total;
			var rate:Number = _total > 0 ? (_win / _total) * 100 : 0;
			rate_txt.text = rate.toFixed(2)+"%";
		}

	}
}