package player
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.textures.Texture;
	import weopons.Gun;
	import effects.ShipExplosion;
	import helpers.CollisionDetection;

	public class Ship extends MovingObject
	{
		// Put these somewhere else

		private const KEY_LEFT:uint = 37;
		private const KEY_UP:uint = 38;
		private const KEY_RIGHT:uint = 39;
		private const KEY_DOWN:uint = 40;
		
		private var keys:Object = new Object();
		
		private var speed:Number = 0.05;
		private var speedLimit:Number = 150;
		private var rotateSpeed:Number = 0.1;
		private var vx:Number = 0;
		private var vy:Number = 0;
		private var friction:Number = 0.99;
		
		//gun
		private var _gun:Gun;
		
		//Ship
		private var _shipImage:Image;
		private var _shootSound:Sound;
		private var _thrustSound:Sound;
		private var _shipExplosion:ShipExplosion;
		
		public function Ship(texture:Texture)
		{
			super(texture);
			_speed = 1.75;
		}
		
		override protected function init(e:Event):void
		{
			super.init(e);
			_direction = new Point(0,0);
			//Ship Sounds
			_thrustSound = new EmbeddedAssets.ThrustSound() as Sound;
			
			//Explosion animation
			_shipExplosion = new ShipExplosion(this);
			addChild(_shipExplosion);
			
			//Init gun
			_gun = new Gun(2, 7, 100);
			addChild(_gun);
			
			centerShipCoords();
			Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			Starling.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			addEventListener(EnterFrameEvent.ENTER_FRAME, updateLoop);
			
		}
		
		
		public function resetShip():void
		{
			this.visible = true;
			this.image.visible = true;
			//_shipImage.visible = true;
			x = stage.stageWidth/2;
			y = stage.stageHeight/2;
			CollisionDetection.registerShip(this);
		}
		
		private function centerShipCoords():void
		{
			//Center of ship
			this.pivotX = width  * 0.5;
			this.pivotY = height * 0.5;
		}
		
		override protected function updateLoop(e:EnterFrameEvent):void
		{
			
			if (keys[KEY_UP])
			{
				_direction.y += Math.sin(rotation) * _speed;
				_direction.x += Math.cos(rotation) * _speed;
				
				//Limit ship speed
				if(_direction.y > speedLimit)		_direction.y = speedLimit;
				if(_direction.y < -speedLimit)	_direction.y = -speedLimit;
				if(_direction.x > speedLimit)		_direction.x = speedLimit;
				if(_direction.x < -speedLimit)	_direction.x = -speedLimit;
				
				
			} else {
				_direction.y *= friction;
				_direction.x *= friction;
			}
			
			if (keys[KEY_RIGHT])
				rotation += rotateSpeed;
			else if (keys[KEY_LEFT])
				rotation -= rotateSpeed;
						
			super.updateLoop(e);
			/*
			y += _direction.y;
			x += _direction.x;
			
			//Wrap ship around the screen
			if (x > stage.stageWidth)
				x = 0;
			else if (x < 0)
				x = stage.stageWidth;
			
			if (y > stage.stageHeight)
				y = 0;
			else if (y < 0)
				y = stage.stageHeight;
			*/
			
		}
		
		//Arrow key up
		private function onKeyUp(e:KeyboardEvent):void
		{
			if(e.keyCode >= 37 && e.keyCode <= 40)
				keys[e.keyCode] = false;
			
		}
		
		//Arrow key down
		private function onKeyDown(e:KeyboardEvent):void
		{
			if(e.keyCode >= 37 && e.keyCode <= 40)
			{
				keys[e.keyCode] = true;
				if(e.keyCode == 38)
					_thrustSound.play();
			}
			else if(e.keyCode == 32)
			{
				//fire gun
				var directionVec:Point = new Point(Math.cos(this.rotation), Math.sin(this.rotation));
				_gun.fireGun(directionVec);
				
			}
		}
		
		
		
		private function degreesToRadians(degrees:Number) : Number
		{
			return degrees * Math.PI / 180;
		}
		
		public function shipDestroyed():void
		{
			this.image.visible = false;
			_shipExplosion.explode(new Point(this.x, this.y));
			
		}

		public function get gun():Gun
		{
			return _gun;
		}

	}
}