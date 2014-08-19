package
{
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class MovingObject extends Sprite
	{
		
		protected var _direction:Point;
		protected var _speed:Number;
		protected var _image:Image;
		private var _collisionShape:Shape;
		private const _showCollisionShape:Boolean = false;
		
		public function MovingObject(texture:Texture)
		{
			super();
			_image = new Image(texture);
			addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(EnterFrameEvent.ENTER_FRAME, updateLoop);
		}
		
		protected function init(e:Event):void
		{
			addChild(_image);
			if(_showCollisionShape)
				showCollisionShape();
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function updateLoop(e:EnterFrameEvent):void
		{
			x += _speed * _direction.x * e.passedTime;
			y += _speed * _direction.y * e.passedTime;
			
			//Wrap astroid around the screen
			if (x > stage.stageWidth)
				x = 0;
			else if (x < 0)
				x = stage.stageWidth;
			
			if (y > stage.stageHeight)
				y = 0;
			else if (y < 0)
				y = stage.stageHeight;
		}
		
		private function showCollisionShape():void
		{
			_collisionShape = new Shape();
			_collisionShape.graphics.lineStyle(1, 0xff0000);
			_collisionShape.graphics.drawCircle(width/2, height/2, width/2);
			addChild(_collisionShape);
		}

		public function get image():Image
		{
			return _image;
		}

	}
}