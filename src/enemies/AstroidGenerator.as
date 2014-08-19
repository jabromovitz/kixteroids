package enemies
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	import starling.textures.Texture;
	

	public class AstroidGenerator
	{
		
		
		private const BASE_ASTROID_COORDS:Vector.<Point> = new <Point>
														[new Point(0, 0.33),
														new Point(0.33, 0),
														new Point(0.67, 0),
														new Point(1, 0.33),
														new Point(1, 0.67),
														new Point(0.67, 1),
														new Point(0.33, 1),
														new Point(0, 0.67)
														];
		
		private const ASTROID_RANDOMNESS:Number = 0.18;
		
		public function AstroidGenerator()
		{
			
		}
		
		// Generate a random variant of the base astroid
		public function generateAstroid(diameter:Number):Texture
		{
			var randomVariance:Number = ASTROID_RANDOMNESS * diameter;
			var astroidVec:flash.display.Sprite = new flash.display.Sprite();
			var randomStartPoint:Point = new Point( randomVariance * (1 - 2 * Math.random()), randomVariance * (1 - 2 * Math.random()));
			
			astroidVec.graphics.lineStyle(1, 0xffffff);
			astroidVec.graphics.moveTo( diameter * BASE_ASTROID_COORDS[0].x + randomStartPoint.x, 
										diameter * BASE_ASTROID_COORDS[0].y + randomStartPoint.y);
			var someNum:int = 5;
			for(var i:int = 1; i < BASE_ASTROID_COORDS.length; i++)
			{
				
				astroidVec.graphics.lineTo( diameter * BASE_ASTROID_COORDS[i].x + randomVariance * (1 - 2 * Math.random()), 
											diameter * BASE_ASTROID_COORDS[i].y + randomVariance * (1 - 2 * Math.random()));
				
			}
			
			astroidVec.graphics.lineTo( diameter * BASE_ASTROID_COORDS[0].x + randomStartPoint.x, 
										diameter * BASE_ASTROID_COORDS[0].y + randomStartPoint.y);
			
			var bounds:Rectangle = astroidVec.getBounds(astroidVec);
			var nBMP_D:BitmapData = new BitmapData(int(bounds.width + 0.5), int(bounds.height + 0.5), true, 0x00000000);
			nBMP_D.draw(astroidVec, new Matrix(1,0,0,1,-bounds.x,-bounds.y));
			
			var nTxtr:Texture = Texture.fromBitmapData(nBMP_D, false, false);
			return nTxtr;
			
		}
		
	}
}