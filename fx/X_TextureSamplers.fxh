//----------------------------------------------------------------------------------------------------------------------
// Texture samplers
//

// Notes:
//	Those tags like DIFFUSEMAP don't seem to follow any rules. eg: in an other shader file it was DIFFUSE.

//----------------------------------------------------------------------------------------------------------------------
// Diffuse
//----------------------------------------------------------------------------------------------------------------------
texture diffuseMap : DIFFUSEMAP
<
	string Name ="";
	string UIName = "Diffuse Map";	
	int Texcoord = 0;
	string TextureType = "2D";
>;

sampler2D diffuseSampler = sampler_state
{
	Texture = <diffuseMap>;
	MinFilter = ANISOTROPIC;
	MagFilter = ANISOTROPIC;
	MipFilter = ANISOTROPIC;
	AddressU = WRAP;
	AddressV = WRAP;
};

//----------------------------------------------------------------------------------------------------------------------
// Opacity 
//	Opacity map is inside diffuse's alpha channel.
//----------------------------------------------------------------------------------------------------------------------


//----------------------------------------------------------------------------------------------------------------------
// Specular
//----------------------------------------------------------------------------------------------------------------------
texture specularMap : SPECULARMAP
<
	string Name ="";
	string UIName = "Specular Map";
	string ResourceType = "2D";
>;

sampler2D specularSampler = sampler_state
{
	Texture = <specularMap>;
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
	AddressU = WRAP;
	AddressV = WRAP;
};

//----------------------------------------------------------------------------------------------------------------------
// Gloss
//----------------------------------------------------------------------------------------------------------------------
texture glossMap : GLOSSINESS
<
	string Name ="";
	string UIName = "Gloss Map";
	string ResourceType = "2D";
>;

sampler2D glossinessSampler = sampler_state
{
Texture = <glossMap>;
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
	AddressU = WRAP;
	AddressV = WRAP;
};
 
//----------------------------------------------------------------------------------------------------------------------
// Normal
//----------------------------------------------------------------------------------------------------------------------
texture normalMap : NORMALMAP
<
	string Name ="";
	string UIName = "Normal Map";
	string ResourceType = "2D";
>;

sampler2D normalSampler = sampler_state
{
	Texture = <normalMap>;
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
	AddressU = WRAP;
	AddressV = WRAP;
};

//----------------------------------------------------------------------------------------------------------------------
// Self illumination
//----------------------------------------------------------------------------------------------------------------------
texture siMap : SIMAP
<
	string Name ="";
	string UIName = "SI Map";
>;

sampler2D siMapSampler = sampler_state
{
	Texture = <siMap>;
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
	AddressU = WRAP;
	AddressV = WRAP;
};

//----------------------------------------------------------------------------------------------------------------------
// Reflection strength
//----------------------------------------------------------------------------------------------------------------------
texture ReflMap 
<
	string Name ="";
	string UIName = "Reflect Map";
	string ResourceType = "2D";
>;

sampler2D ReflMapSampler = sampler_state
{
	Texture = <ReflMap>;
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
	AddressU = WRAP;
	AddressV = WRAP;
};

//----------------------------------------------------------------------------------------------------------------------
// Reflection environment cubemap
//----------------------------------------------------------------------------------------------------------------------
texture reflcubemap : environment
<
	string ResourceName = "";
	string UIName = "Cubemap";
	string ResourceType = "Cube";
>;
 
samplerCUBE reflcubemapSampler = sampler_state
{
	Texture = <reflcubemap>;
	MinFilter = LINEAR;
	MagFilter = LINEAR;
	MipFilter = LINEAR;
	AddressU = WRAP;
	AddressV = WRAP;
};

//----------------------------------------------------------------------------------------------------------------------
// Ambient reflection environment cubmap
//----------------------------------------------------------------------------------------------------------------------
texture IBLcubemap
<
	string ResourceName = "";
	string UIName = "IBL Cubemap";
	string ResourceType = "Cube";
>;

samplerCUBE IBLcubemapSampler = sampler_state
{
	Texture = <IBLcubemap>;
	MinFilter = LINEAR;
	MagFilter = LINEAR;
	MipFilter = LINEAR;
	AddressU = WRAP;
	AddressV = WRAP;
};


