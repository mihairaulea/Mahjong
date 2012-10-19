package util 
{
	
	public class AssetsEmbedsSD 
	{
		// Particle textures
		
		[Embed(source = "/assets/particles/texture.png")]
		public static var VictoryParticleTexture:Class;
		
		[Embed(source = "/assets/particles/textureBurn.png")]
		public static var BurnParticleTexture:Class;
		
		// Texture Atlas
		
		[Embed(source = "/assets/textures/assetsSD.png")]
		public static const AtlasTextureAssets:Class;
		
		[Embed(source = "/assets/textures/assetsSD.xml", mimeType = "application/octet-stream")]
		public static const AtlasXmlAssets:Class;
		
		[Embed(source = "/assets/textures/levelsSD.png")]
		public static const AtlasTextureLevels:Class;
		
		[Embed(source = "/assets/textures/levelsSD.xml", mimeType = "application/octet-stream")]
		public static const AtlasXmlLevels:Class;
		
		// Bitmap Fonts
		
		
	}

}