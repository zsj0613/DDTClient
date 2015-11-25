package ddt.data.store
{
	public class StoreState
	{
		public static const BASESTORE      : String = "baseStore";
		public static const CONSORTIASTORE : String = "consortiaStore";
		public static const CONSORTIAIISTORE : String = "consortiaIIStore";  //背包中的公会铁匠铺
		public static const BAGSTORE       : String = "bagStore";
		public static const BAGBASESTORE :String = "bagBaseStore";  //背包中的基础铁匠铺
		public static var   storeState     : String;
		public static var   ConsortiaSmithLevel : int ;//公会铁匠铺的等级

	}
}