package road.loader
{
	public class DataAnalyzer
	{
		protected var _onCompleteCall:Function;
		public function DataAnalyzer(onCompleteCall:Function)
		{
			_onCompleteCall = onCompleteCall;
		}
		
		public function analyze(data:*):void
		{
		}
		public var message:String;
		public var analyzeCompleteCall:Function;
		protected function onAnalyzeComplete():void
		{
			_onCompleteCall(this);
			if(analyzeCompleteCall != null)analyzeCompleteCall();
		}
	}
}