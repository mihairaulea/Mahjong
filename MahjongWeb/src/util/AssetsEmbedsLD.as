package util 
{
	
	
	public class AssetsEmbedsLD 
	{
		// Particle textures
		
		[Embed(source = "/assets/particles/texture.png")]
		public static var VictoryParticleTexture:Class;
		
		[Embed(source = "/assets/particles/textureBurn.png")]
		public static var BurnParticleTexture:Class;
		
		// Texture Atlas
		
		[Embed(source = "/assets/textures/assetsLD.png")]
		public static const AtlasTextureAssets:Class;
		
		[Embed(source = "/assets/textures/assetsLD.xml", mimeType = "application/octet-stream")]
		public static const AtlasXmlAssets:Class;
		
		[Embed(source = "/assets/textures/levelsLD.png")]
		public static const AtlasTextureLevels:Class;
		
		[Embed(source = "/assets/textures/levelsLD.xml", mimeType = "application/octet-stream")]
		public static const AtlasXmlLevels:Class;
		
		// Bitmap Fonts
		
		
	}

}