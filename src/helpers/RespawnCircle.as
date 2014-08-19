package helpers
{
	public class RespawnCircle
	{
		private var _x:Number;
		private var _y:Number;
		private var _radius:Number;
		
		public function RespawnCircle(x:Number, y:Number, radius:Number)
		{
			_x = x;
			_y = y;
			_radius = radius;
		}

		public function get x():Number
		{
			return _x;
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function get radius():Number
		{
			return _radius;
		}

	}
}