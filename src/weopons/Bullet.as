package weopons
{
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import starling.events.Event;
	import starling.textures.Texture;
	import settings.Constants;
	
	
	public class Bullet extends MovingObject
	{
		private var _lifetimeTimer:Timer = new Timer(1200,1);
		
		public function Bullet(texture:Texture)
		{
			super(texture);
			_speed = 200;
			_lifetimeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, lifetimeExpired);
		}
		
		private function lifetimeExpired(event:TimerEvent):void
		{
			//Bullet lifetime has expired
			_lifetimeTimer.reset();
			dispatchEventWith(Constants.BULLET_LIFETIME_EXPIRED, true, this);
		}
		
		override protected function init(e:Event):void
		{
			super.init(e);
		}
		

		public function stopLifetimeTimer():void
		{
			_lifetimeTimer.stop();
			
		}
		
		public function fire(origin:Point, direction:Point):void
		{
			//Move along direction for lifetime
			_direction = direction;
			x = origin.x;
			y = origin.y;
			_lifetimeTimer.start();	
		}
	}
}