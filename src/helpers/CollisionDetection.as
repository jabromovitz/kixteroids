package helpers
{
	import flash.geom.Point;

	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import weopons.Bullet;
	import enemies.Astroid;
	import settings.Constants;
	import player.Ship;

	public class CollisionDetection extends Sprite
	{
		
		//Types of things that can collide
		private const SHIP:uint = 			0x1;
		private const ENEMY:uint = 			0x2;
		private const BULLET:uint = 		0x4;
		private const RESPAWN_HALO:uint = 	0x8;
		
		static private var _ship:Ship;
		static private var _enemies:Array = new Array();
		static private var _bullets:Array = new Array();
		
		public function CollisionDetection()
		{
			this.addEventListener(EnterFrameEvent.ENTER_FRAME, updateLoop);
		}
		
		private function updateLoop():void
		{
			
			//Check for collision between ship and enemies
			//if the ship is on stage
			if(_ship != null && _ship.stage != null)
			{
				var shipCenter:Point = new Point(_ship.x + _ship.width/2, _ship.y + _ship.height/2);
				var shipRadius:Number = _ship.width / 2;
				var enemyCenter:Point;
				var enemyRadius:Number;
				var distance:Number;

				
				for each(var enemy:Astroid in _enemies)
				{
					enemyCenter = new Point(enemy.x + enemy.width/2, enemy.y + enemy.height/2);
					//enemyRadius = Math.max(enemy.getBounds(enemy).width, enemy.getBounds(enemy).height) / 2;
					enemyRadius = enemy.getBounds(enemy).width / 2;
					distance = Point.distance(shipCenter, enemyCenter);
					
					if (distance < shipRadius + enemyRadius)
					{
						dispatchEventWith("SHIP_DESTROYED");
					}
					else
					{
						//Check for collision between bullets and enemies
						var bulletCenter:Point;
						var bulletRadius:Number;
						for each(var bullet:Bullet in _bullets)
						{
							bulletCenter = new Point(bullet.x + bullet.width/2, bullet.y + bullet.height/2);
							bulletRadius = bullet.width / 2;
							
							distance = Point.distance(bulletCenter, enemyCenter);
							
							//trace("D:", distance, "br:", bulletRadius, "em", enemyRadius); 
							if (distance < enemyRadius)
							{
								_enemies.splice(_enemies.indexOf(enemy), 1);
	  							dispatchEventWith(Constants.ENEMY_DESTROYED, false, enemy);
								deregisterBullet(bullet);
							}
						}
					}
				}
				
			}
			
		}
		
		static public function registerShip(ship:Ship):void
		{
			_ship = ship;
		}
		
		static public function deRegisterShip():void
		{
			_ship = null;
		}
		
		static public function registerEnemy(enemy:Astroid):void
		{
			_enemies.push(enemy);
		}
		
		static public function registerBullet(bullet:Bullet):void
		{
			_bullets.push(bullet);
		}
		
		public static function deregisterBullet(bullet:Object):void
		{
			if(_bullets.indexOf(bullet) >= 0)
				_bullets.splice(_bullets.indexOf(bullet), 1);
			
		}
		
		public static function deregisterAllAsteroids():void
		{
			_enemies.length = 0;
		}
		
		//Check if two objects are currently colliding
		public static function quickRepawnSafeCheck(halo:RespawnCircle):Boolean
		{
			var haloCenter:Point = new Point(halo.x, halo.y);
			var halo2Radius:Number = halo.radius;
			var enemyCenter:Point;
			var enemyRadius:Number;
			var distance:Number;
			
			for each(var enemy:Astroid in _enemies)
			{
				enemyCenter = new Point(enemy.x + enemy.width/2, enemy.y + enemy.height/2);
				enemyRadius = enemy.getBounds(enemy).width / 2;
				distance = Point.distance(haloCenter, enemyCenter);
				
				if (distance < halo2Radius + enemyRadius)
					return true;

			}
			
			return false;
		}
	}
}