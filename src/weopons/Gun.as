package weopons
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.utils.Timer;
	
	import starling.display.Shape;
	import starling.events.Event;
	import starling.textures.Texture;
	import settings.Constants;
	import helpers.CollisionDetection;
	
	public class Gun extends Shape
	{
		private var _bullets:Vector.<Bullet>;
		private var _firingSpeedTimer:Timer;
		private var _numberOfBullets:int;
		private var _bulletSize:int;
		private var _bulletTexture:Texture;
		private var _parentsSize:Point; //For centering gun
		private var _shootSound:Sound;
		
		public function Gun(bulletSize:int, numberOfBullets:int, firingSpeed:Number)
		{
			super();
			
			_firingSpeedTimer = new Timer(firingSpeed, 1);
			_numberOfBullets = numberOfBullets;
			_bulletSize = bulletSize;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			_shootSound = new EmbeddedAssets.ShootSound() as Sound;
			_bulletTexture = createBulletTexture();
			createAndLoadBullets();
			_parentsSize = new Point(parent.width, parent.height);
			_firingSpeedTimer.addEventListener(TimerEvent.TIMER_COMPLETE, fireDelayComplete);
			
			
		}
		
		private function createBulletTexture():Texture
		{
			//Bullet Texture
			var bulletVec:flash.display.Sprite = new flash.display.Sprite();
			bulletVec.graphics.beginFill(0xffffff);
			bulletVec.graphics.drawCircle(0, 0, _bulletSize);
			bulletVec.graphics.endFill();
			
			var bounds:Rectangle = bulletVec.getBounds(bulletVec);
			var nBMP_D:BitmapData = new BitmapData(int(bounds.width + 0.5), int(bounds.height + 0.5), true, 0x00000000);
			nBMP_D.draw(bulletVec, new Matrix(1,0,0,1,-bounds.x,-bounds.y));
			
			return Texture.fromBitmapData(nBMP_D, false, false);
		}
		
		private function createAndLoadBullets():void
		{
			_bullets = new Vector.<Bullet>();
			var bullet:Bullet;
			
			for(var i:int = 0; i < _numberOfBullets; i++)
			{
				bullet = new Bullet(_bulletTexture);
				bullet.addEventListener(Constants.BULLET_LIFETIME_EXPIRED, removeAndResetBulletHandler);
				bullet.x = 0;
				bullet.y = 0;
				_bullets.push(bullet);
			}
			
		}
		
		public function removeAndResetBulletHandler(event:Event):void
		{
			
			var bullet:Bullet = event.target as Bullet;
			bullet.stopLifetimeTimer();
			bullet.x = 0;
			bullet.y = 0;
			CollisionDetection.deregisterBullet(bullet);
			stage.removeChild(bullet);
			_bullets.push(bullet);	
		}
		
		
		protected function fireDelayComplete(event:TimerEvent):void
		{
			_firingSpeedTimer.reset();
		}
		
		public function fireGun(direction:Point):void
		{
			//Make sure min shooting delay has passed
			if(!_firingSpeedTimer.running && (_bullets.length > 0))
			{
				//Fire bullet
				_firingSpeedTimer.start();
				_shootSound.play();
				var bullet:Bullet = _bullets.pop();
				stage.addChild(bullet);
				bullet.fire(localToGlobal(new Point(x+_parentsSize.x  , y+_parentsSize.y/2)), direction);
				CollisionDetection.registerBullet(bullet);
			}
				
		}
	}
}