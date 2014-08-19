package enemies
{
	import flash.geom.Point;
	import flash.media.Sound;
	
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Astroid extends MovingObject
	{
		//Sizes
		public static const SMALL:uint = 20;
		public static const MEDIUM:uint = 35;
		public static const LARGE:uint = 50;
		
		
		private var _size:uint;
		
		private var _vx:Number;
		private var _vy:Number; 
		private var _radius:Number;
		private var _explosionSound:Sound;
	
		
		public function Astroid(texture:Texture, speed:Number, size:uint, direction:Point)
		{
			super(texture);
			_radius = size;
			_size = size;
			_direction = direction;
			_speed = speed
						
		}
		
		public function get initialAngle():Number
		{
			return Math.atan2(_direction.y, _direction.x);
		}

		public function get size():uint
		{
			return _size;
		}

		public function get speed():Number
		{
			return _speed;
		}

		public function set speed(value:Number):void
		{
			_speed = value;
		}

		override protected function init(e:Event):void
		{
			super.init(e);
			
			_vx = _speed * _direction.x;
			_vy = _speed * _direction.y;
			addEventListener(EnterFrameEvent.ENTER_FRAME, updateLoop);

		}
		
	}
}