package
{
	public class EmbeddedAssets
	{
		
		// Textures
		[Embed(source="../assets/img/ufo.png")]
		public static const Ufo:Class;
		
		// Sounds
		[Embed(source="../assets/audio/saucer.mp3")]
		public static const SaucerSound:Class;
		
		[Embed(source="../assets/audio/shoot.mp3")]
		public static const ShootSound:Class;
		
		[Embed(source="../assets/audio/thrust.mp3")]
		public static const ThrustSound:Class;
		
		[Embed(source="../assets/audio/tonehi.mp3")]
		public static const ToneHigh:Class;
		
		[Embed(source="../assets/audio/tonelo.mp3")]
		public static const ToneLow:Class;
		
		[Embed(source="../assets/audio/banglarge.mp3")]
		public static const BangLarge:Class;
		
		//Fonts
		[Embed(source="../assets/fonts/Hyperspace.ttf", embedAsCFF="false", fontFamily="Hyperspace")]
		private static const Hyperspace:Class;
		
		
		public function EmbeddedAssets()
		{
		}
	}
}