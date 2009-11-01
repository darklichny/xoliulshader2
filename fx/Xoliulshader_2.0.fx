
//3DS Max viewport shader by Laurens Corijn, http://www.laurenscorijn.com
//Big thanks to Ben Cloward for always being the guy to ask shader questions to; http://www.bencloward.com
//thanks to Jeroen Maton and Lumonix ShaderFX, http://www.jeroenmaton.net, http://www.lumonix.net
//thanks to Brice Vandemoortele for informing me about texCUBElod, made IBL easier and reflection gloss possible! http://www.mentalwarp.com

string ParamID = "0x003"; //use DXSAS compiler

#include <X_genFunc.fxh>

//***************************************************************** DATAMEMBERS
//motherload of stuff here, most is straightforward so uncommented


struct LightStruct  //struct with lightinfo, easier to work with.
{
	float4 LightVec;
	float4 LightColor; //this value is 32 bit: it is NOT clamped by Max to 8bit per channel, so light color also includes the intensity, since they are mutliplied before Max hads them over
};
			
LightStruct lightsarray[3]; //3-light array


// these elements are required for projected shadows 
//SHADOWCODE
#include <shadowMap.fxh> 

float  ShadowFloats[3];
float  ShadowStrengths[3];


//===========LIGHTS

float4 light1_Position : POSITION
<
	string UIName = "Light 1 Position";
	string Object = "PointLight";
	string Space = "World";
	int refID = 1; 								//refID for automatic lightcolor input
>;// = {100.0f, 100.0f, 100.0f, 0.0f};

//lightcolor = lightrgb x lightmultiplier, done by Max
float4 light1Color : LIGHTCOLOR <int LightRef = 1; string UIWidget = "None"; > = { 1.0f, 1.0f, 1.0f, 1.0f}; 	//lightref ID makes sure that max fills in this value automatically



//SHADOWCODE
SHADOW_FUNCTOR(shadowTerm1); //Only 1 shadow supported, more is just not necessary and not worth the effort and trouble. the shader would also become too slow and messy because of it
//SOFTSHADOW
//SOFT_SHADOW_FUNCTOR(SoftShadowTerm1, 000, float4(10,5,0.01,0), false); // NOTE: '000' represents for omni light, '001' is spot, and '002' is direct.

bool bUseShadow1
<
    string gui = "slider";
    string UIName = "     Use Shadow 1";
> = false;

float Shadow1Soft
<
	string UIName = "     Shadow1 Blur";
	string UIWidget = "FloatSpinner";
	float UIMin = 0.0f;
	float UIMax = 50.0f;
> = {0.0f};

float Shadow1Strength
<
	string UIName = "     Shadow1 Intensity";
	string UIWidget = "FloatSpinner";
	float UIMin = 0.0f;
	float UIMax = 1.0f;
> = {1.0f};

float DistanceBlur
<
	string UIName = "     Distance Shadow Blur";
	string UIWidget = "FloatSpinner";
> = {3.0f};



float4 light2_Position : POSITION
<
	string UIName = "Light 2 Position";
	string Object = "PointLight";
	string Space = "World";
	int refID = 2;
>;// = {100.0f, 100.0f, 100.0f, 1.0f};

float4 light2Color : LIGHTCOLOR <int LightRef = 2; string UIWidget = "None"; > = { 1.0f, 1.0f, 1.0f, 1.0f}; 

float4 light3_Position : POSITION
<
	string UIName = "Light 3 Position";
	string Object = "PointLight";
	string Space = "World";
	int refID = 3;
>;// = {100.0f, 100.0f, 100.0f, 1.0f};

float4 light3Color : LIGHTCOLOR <int LightRef = 3; string UIWidget = "None"; > = { 1.0f, 1.0f, 1.0f, 1.0f}; 

bool bUseHalfLambert
<
    string gui = "slider";
    string UIName = "     Half Lambert Shading";
> = false;

float HalfLambertPower
<
string UIName = "         Half Lambert Power";
string UIType = "FloatSpinner";
float UIMin = 0.0f;
float UIMax = 10.0f;
float UIStep = 0.1;
> = 2;

float3 ambientcolor
<
	string UIName = "     Ambient Color";
	string UIWidget = "Color";
> = {0.0f, 0.0f, 0.0f};

bool bUseIBL
<
    string gui = "slider";
    string UIName = "         Use IBL cubemap for Ambient";
> = false;


bool bUseIBLCubeMap
<
    string gui = "slider";
    string UIName = "         Share Reflection Cubemap for IBL";
> = false;

texture IBLcubemap
<
	string ResourceName = "";
	string UIName = "     IBL Cubemap";
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

float IBLBlur
<
string UIName = "         Ambient Cube Blur";
string UIType = "FloatSpinner";
float UIMin = 0.0f;
float UIMax = 10.0f;
float UIStep = 0.1f;
> = 6.0f;

float IBLmultiplier
<
string UIName = "         Ambient Cube Strength";
string UIType = "FloatSpinner";
float UIMin = 0.0f;
float UIMax = 2.0f;
float UIStep = 0.05;
> = 0.5;

int numberOfActiveLights
<
string UIName = "     Active Lights";
string UIType = "FloatSpinner";
float UIMin = 0.0f;
float UIMax = 3.0f;
float UIStep = 1.0;
> = 1;

//==========DIFFUSEMAP

bool bUseDiffuseMap
<
    string gui = "slider";
    string UIName = "Diffuse Map";
> = false;

half4 diffuseColor : DIFFUSECOLOR
<
	string UIWidget = "Color";
    string UIName = "     Diffuse Color";
> = {0.5f, 0.5f, 0.5f, 1.0f};

texture diffuseMap : DIFFUSEMAP
<
	string name ="";
	string UIName = "     Diffuse Map";	
	int Texcoord = 0;

>;


bool bColorDiffuse
<
    string gui = "slider";
    string UIName = "     Color Diffuse Map";
> = false;


sampler2D diffuseSampler = sampler_state
{
	Texture = <diffuseMap>;
	MinFilter = ANISOTROPIC;
	MagFilter = ANISOTROPIC;
	MipFilter = ANISOTROPIC;
	AddressU = WRAP;
	AddressV = WRAP;
};

//==========OPACITYMAP

bool bUseAlpha
<
    string gui = "slider";
    string UIName = "     Enable alpha channel";
	int Texcoord = 0;
	int MapChannel = 1;	
> = false;

float GlobalOpacity
<
string UIName = "         Global Opacity Level";
string UIType = "FloatSpinner";
float UIMin = 0.0f;
float UIMax = 1.0f;
float UIStep = 0.05;
> = 1;


//==========SPECULARMAP

bool bUseSpecMap
<
    string gui = "slider";
    string UIName = "Spec Map";
> = false;

half4 specularColor : SPECULARCOLOR
<
	string UIWidget = "Color";
    string UIName = "     Specular Color";
> = {1.0f, 1.0f, 1.0f, 1.0f};

float speclevel
<
string UIName = "     Specular Global Level";
string UIType = "FloatSpinner";
float UIMin = 0.0f;
float UIMax = 10.0f;
float UIStep = 0.05;
> = 1.0f;

texture specularMap : SPECULARMAP
<
	string name ="";
	string UIName = "     Specular Map";
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

//==========GLOSSMAP

bool bUseGlossMap
<
    string gui = "slider";
    string UIName = "Gloss Map";
> = false;

texture glossMap : GLOSSINESS
<
	string name ="";
	string UIName = "     Gloss Map";
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

float glossiness
<
	string UIName = "     Glossiness Level";
	string UIType = "FloatSpinner";
	float UIMin = 0.0f;
	float UIMax = 100.0f;
	float UIStep = 0.05;
> = 25.0f;

float glossoffset
<
	string UIName = "     Glossmap Offset";
	string UIType = "FloatSpinner";
	float UIMin = 0.0f;
	float UIMax = 100.0f;
	float UIStep = 0.05;
> = 10.0f;
 
//==========NORMALMAP
 
bool bUseNormalMap
<
    string gui = "slider";
    string UIName = "Normal Map";
> = false;

bool bUseObjectNormals
<
    string gui = "slider";
    string UIName = "     Object Space";
> = false;


texture normalMap : NORMALMAP
<
	string name ="";
	string UIName = "     Normal Map";
	string ResourceType = "2D";
>;

bool bFlipGreenChannel
<
    string gui = "slider";
    string UIName = "     Flip Green";
> = false;

sampler2D normalSampler = sampler_state
{
	Texture = <normalMap>;
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
	AddressU = WRAP;
	AddressV = WRAP;
};

//==========GLOWMAP

bool bUseSIMap
<
    string gui = "slider";
    string UIName = "Self Illumination Map";
> = false;

texture siMap : SIMAP
<
	string name ="";
	string UIName = "     SI Map";
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

float siMapMult<
	string UIName = "     SI Map Multiply";
	string UIType = "FloatSpinner";
	float UIMin = 1.0f;
	float UIMax = 10.0f;
> = 1.0f;

float siLevel<
	string UIName = "     Global SI Level";
	string UIType = "FloatSpinner";
	float UIMin = 0.0f;
	float UIMax = 100.0f;
	float UIStep = 1.0f;
> = 0;

//==========Reflections

bool bUseFresnel
<
    string gui = "slider";
    string UIName = "Use Fresnel Reflections";
> = false;

bool bAlphaMasksFresnel
<
    string gui = "slider";
    string UIName = "     Alpha Affects Reflections";
> = false;

float FresnelPower
<
	string UIWidget = "Spinner";
	float UIMin = 0.0;
	float UIMax = 100.0;
	float UIStep = 0.1;
	string UIName = "     Fresnel Power";
> = 3.0;
 
 
float FresnelBias
<
	string UIWidget = "Spinner";
	float UIMin = 0.0;
	float UIMax = 1.0;
	float UIStep = 0.01;
	string UIName = "     Fresnel Bias";
> = 0.0;

float FresnelMult
<
	string UIWidget = "Spinner";
	float UIMin = 0.0;
	float UIMax = 100.0;
	float UIStep = 0.1;
	string UIName = "     Fresnel Multiplier";
> = 2.0;

float3 FresnelColor 
<
	string UIWidget = "Color";
    string UIName = "     Rim Color";
> = {1.0f, 1.0f, 1.0f};

float FresnelMaskHardness
<
	string UIWidget = "Spinner";
	float UIMin = 0.0;
	float UIMax = 100.0;
	float UIStep = 0.1;
	string UIName = "     Fresnel Mask Hardness";
> = 4.0;

bool bUseWorldMask
<
    string gui = "slider";
    string UIName = "     Use Hard-Type World Masking";
> = true;

bool bUseReflMap
<
    string gui = "slider";
    string UIName = "     Reflection Map";
> = false;

texture ReflMap 
<
	string name ="";
	string UIName = "     Reflect Map";
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

bool bUseCubeMap
<
    string gui = "slider";
    string UIName = "     Reflect Cubemap";
> = false;

texture reflcubemap : environment
<
	string ResourceName = "";
	string UIName = "     Cubemap";
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

float CubeMapBlur
<
	string UIWidget = "Spinner";
	float UIMin = 0.0;
	float UIMax = 10.0;
	float UIStep = 0.1;
	string UIName = "     Cubemap Blur";
> = 0.0;
bool bUseReflGloss
<
    string gui = "slider";
    string UIName = "         Use Glossmap for blur";
> = false;



//----------------------------------VS & PS structs 


// input from application for Vertex Shader
struct VS_InputStruct {
	float4 position		: POSITION;
	float2 texCoord		: TEXCOORD0;
	float2 texCoord2		: TEXCOORD1;
	float3 tangent		: TANGENT;
	float3 binormal		: BINORMAL;
	float3 normal		: NORMAL;
};

// Vertex Shader output for Pixel Shader
struct VS_To_PS_Struct {
        float4 position   	: POSITION;
		float2 texCoord    	: TEXCOORD0;
		float3 eyeVec		: TEXCOORD1;
		float3 worldNormal	: TEXCOORD2;
		float3 worldTangent	: TEXCOORD3;
		float3 worldBinormal	: TEXCOORD4;
		//half2 texCoordShadow	: TEXCOORD7; //unused, for lightmaps
		float4 worldSpacePos	: TEXCOORD5;
};



//Fill light array function
void CreateLights( float4 worldspacepos )
{
	
		lightsarray[0].LightVec = light1_Position - worldspacepos; // transform light position to world space position, put into array
		lightsarray[0].LightColor = light1Color; // set light color to array. light color is automatically updated by Max because we use RefId's.
		
		lightsarray[1].LightVec = light2_Position - worldspacepos;
		lightsarray[1].LightColor = light2Color;
		
		lightsarray[2].LightVec = light3_Position - worldspacepos;
		lightsarray[2].LightColor = light3Color;
	
}

//SHADOWCODE
//shadow blur lookup function
//special multisample function made by Laurens
//HEAVY ON PERFORMANCE due to crappy 3DS max shadow API
float ShadowLookUp(float4 position, float3 tangent, float3 binormal, float blur)
{
	float blurscale = sqrt(blur);
	float shadowleftup = shadowTerm1(position + float4((tangent*blurscale).xyz,0)+ float4((binormal*blurscale).xyz,0)); // sample shadows around pixel location, sampling depth determined by blur scale
	float shadowleftdown = shadowTerm1(position + float4((tangent*blurscale).xyz,0)- float4((binormal*blurscale).xyz,0));
	float shadowrightup = shadowTerm1(position - float4((tangent*blurscale).xyz,0)+ float4((binormal*blurscale).xyz,0));
	float shadowrightdown = shadowTerm1(position - float4((tangent*blurscale).xyz,0)- float4((binormal*blurscale).xyz,0));
	float shadowtotal = (shadowleftup+shadowleftdown+shadowrightup+shadowrightdown)/4; //average 4 samples
	return shadowtotal;
}


//Vertex And Pixel Shaders

//VERTEX SHADER
VS_To_PS_Struct vs_main(VS_InputStruct In) //vertexshader gets input struct from application, all automatically
{
	SetupMatrices(); //create WVP
	
	VS_To_PS_Struct Out; //define output struct
	
    Out.worldNormal = mul(In.normal, (float3x3)World).xyz; //transform normal to worldspace
	Out.worldTangent = mul(In.tangent, (float3x3)World).xyz; //transform tangent to worldspace
	Out.worldBinormal = mul(In.binormal, (float3x3)World).xyz; //transform binormal to worldspace
    
	Out.worldSpacePos = mul(In.position, World);	 //transform position to worldspace
  
	Out.texCoord.xy = In.texCoord; //pass texcoord to output
    Out.eyeVec = ViewInv[3].xyz -  Out.worldSpacePos; //calculate eyevector
    Out.position = mul(In.position, WorldViewProj); //special worldspacepos in texcoord slot for shadow code, will error otherwise

    return Out;
}

//PIXEL SHADER
float4 ps_main(VS_To_PS_Struct In) : COLOR 
{ 
	//Map Checks
	//these just check if a map is used to overwrite the default value.
	
	//diffuse
	float4 color = float4(diffuseColor); //default diffusecolor
	if(bUseDiffuseMap)
	{
		color = tex2D(diffuseSampler, In.texCoord.xy);
		
		
		if(bColorDiffuse) color*=diffuseColor; //multiply diffuse texturesample with color, useful for recoloring grayscale diffusemaps
	} 
	
	//opacity
	float opacity = GlobalOpacity; //default is global opacity
	if(bUseAlpha)
	{
		opacity = color.a; //sampled alpha from diffuse map
	}
	
	
	//specular
	float4 speccolor = specularColor; //default is solid specular color
	if(bUseSpecMap)
	{
		speccolor = tex2D(specularSampler, In.texCoord.xy);
	}
	
	//glossiness
	if(bUseGlossMap)
	{
		glossiness = tex2D(glossinessSampler, In.texCoord.xy) * (glossiness - glossoffset); //overwrite glossiness global with texsample, multiplied with level
		glossiness += glossoffset; //offset gloss to prevent zero glossiness, allows for better control over glossiness map range
	}
	
	//normal
	float3 normal = In.worldNormal; //default worldspace vertex normal
	if(bUseNormalMap)
	{
		normal = tex2D(normalSampler, In.texCoord.xy).rgb;
		normal = (2*normal)-1; //expand into -1 to 1 range, since a normalmap is always returned in 0 to 1 space
		if (bFlipGreenChannel) normal.g =-normal.g; //flip green for texture instead of flipping tangent, works for object space normals also
	}
	
	//self illumination
	float4 selfillumination = (0.0f,0.0f,0.0f,0.0f); //default no self illum
	if(bUseSIMap)
	{
		selfillumination = tex2D(siMapSampler, In.texCoord.xy);
	}
	
	
	
	//Create Light Calculations
	CreateLights( In.worldSpacePos ); // fill lightstruct array DOES NOT WORK IN VERTEX SHADER, MUST HAPPEN IN PIXEL SHADER! ~0_o>
	
	//normal application
	if(!bUseObjectNormals && bUseNormalMap) //tangentspace normalmap
	{
		normal = (In.worldNormal * normal.z) + (normal.x * In.worldBinormal + normal.y * -In.worldTangent); //transform every vertex normal component by the tangentspace normalmap
	}
	if(bUseObjectNormals && bUseNormalMap) //if object space, pure sampling equals the normal
	{
		normal = mul(normal, WorldInvTrans).xyz; // put objectspace normal in worldspace
	}
	
	normal = normalize( normal );
	
	//SHADOWCODE
	//Shadow calculations
	ShadowFloats[0]=ShadowStrengths[0]=ShadowFloats[1]=ShadowStrengths[1]=ShadowFloats[2]=ShadowStrengths[2]=1.0f; //set all shadow values to 1, fully lit no shadow as default
	
	if(bUseShadow1) //if shadow 1 is on, only shadow 1 will be filled, the rest just stay at one
	{
		if(Shadow1Soft !=0.0f) //if blurring is not turned off
		{
			float diffuse = saturate(dot(normal,lightsarray[0].LightVec)); //calculate diffuse for area light effect
			float blurscale = (Shadow1Soft* (1/(diffuse*diffuse*(1/(DistanceBlur)*5)))); // calculate blur scale based on diffuse term and global blur
			ShadowFloats[0] = ShadowLookUp(float4(In.worldSpacePos.xyz,1),In.worldTangent,In.worldBinormal,blurscale); // lookup shadows with special function
		}
		else
			ShadowFloats[0] = shadowTerm1(float4(In.worldSpacePos.xyz,1)); //if no blur, just do simple hard shadow lookup
			
		ShadowStrengths[0] = ShadowFloats[0] + ((1-Shadow1Strength) * (1-ShadowFloats[0])); //calculate final shadow strength based on user settings
	
	}
	
	
	//Light Loop
	float4 ambient;
	
		if(bUseIBLCubeMap && bUseIBL)
			ambient = texCUBElod(reflcubemapSampler, float4(normal.x,normal.z,normal.y,IBLBlur)) * IBLmultiplier;
		else if(bUseIBL && !bUseIBLCubeMap)
			ambient = texCUBElod(IBLcubemapSampler, float4(normal.x,normal.z,normal.y,IBLBlur)) * IBLmultiplier;
		else ambient = float4(ambientcolor,1.0f);
	
	float4 totaldiffuse =  ambient; //start off with ambient color
	float4 totalspecular = (0.0f,0.0f,0.0f,0.0f); //if the alpha value is not zero, messed up specular happens
	
	for(int i = 0; i < numberOfActiveLights; ++i) //for loop to iterate over our 3 lights
	{
		//diffuse term
		float diffuse;
		if(bUseHalfLambert) 
		{
			diffuse = halflambert(normal,lightsarray[i].LightVec, HalfLambertPower);
			diffuse *= ShadowStrengths[i]; // apply shadow into diffuse, this is done for each light to prevent performance slowdown with IF statements due to varying instructioncount
		}
		else //regular blinn/phong diffuse
		{
			diffuse = diffuselight(normal,lightsarray[i].LightVec);
			diffuse *= ShadowStrengths[i]; // apply shadow into diffuse
		}
		
		totaldiffuse += (diffuse*lightsarray[i].LightColor); //add every light to the total diffuse sum (lights are additive towards each other), multiplied with light color 

		
		//specular term
		float4 specular = (1.0,1.0,1.0,1.0);
		specular *= blinnspecular(normal,lightsarray[i].LightVec, In.eyeVec, glossiness);
		specular *= speccolor; //apply specular color map
		
		specular *= ShadowFloats[i]; // reduce specular by shadow, since you don't want specular where light can't go. we use raw specular value because this effect is absolute
		
		specular *= lightsarray[i].LightColor; //multiply by light color
		totalspecular += specular; //add every light specular to total specular level
	}
	totalspecular *= speclevel; // apply global specular multiplier to increase global strength
	
	
	//Apply Lighting
	
	float4 ret = color; // our final returned color starts as unlit diffuse color
	
	ret.rgb*=totaldiffuse; //multiply diffuse with color
	ret+=totalspecular; // ADD specular to colored diffuse
	
	
	//Self Illumination
	
	if(bUseSIMap)
	{
		//get total SI amount by adding (desaturated) map contribution to global level and the clamping between 0 and 1
		float SItotal = saturate(desaturate(selfillumination.rgb) + (siLevel/100)); 
		
		ret = lerp( ret, color * siMapMult,  SItotal); //lerp blend between normal shaded model and unlit multiplied by SImapmultiplier. no color contribution of glowmap yet....
	}
	
	ret.a = opacity; // finally set opacity
	
	
	return ret; //all done, return result :)
} 


//Fresnel effects PS pass function. Main reason for split is to avoid hitting the dynamic branching limit
float4 ps_fresnel(VS_To_PS_Struct In) : COLOR 
{ 
	float4 ret =(0,0,0,0);
	
	//alpha
	float opacity = GlobalOpacity; //default is global opacity
	if(bUseAlpha)
	{
		opacity = tex2D(diffuseSampler, In.texCoord.xy).a; //sampled alpha from diffuse map
	}
	
	//specular
	float4 speccolor = specularColor; //default is solid specular color
	if(bUseSpecMap)
	{
		speccolor = tex2D(specularSampler, In.texCoord.xy);
	}
	
	//glossiness
	float glossiness = 0.0f;
	if(bUseGlossMap && bUseReflGloss)
	{
		glossiness = desaturate(tex2D(glossinessSampler, In.texCoord.xy)); //overwrite glossiness global with texsample
	}
	
	//normal
	float3 normal = In.worldNormal; //default worldspace vertex normal
	if(bUseNormalMap)
	{
		normal = tex2D(normalSampler, In.texCoord.xy).rgb;
		normal = (2*normal)-1; //expand into -1 to 1 range, since a normalmap is always returned in 0 to 1 space
		if (bFlipGreenChannel) normal.g =-normal.g; //flip green for texture instead of flipping tangent, works for object space normals also
	}
	
	//reflection
	float3 reflectmap = desaturate(speccolor.rgb); //use desaturated specmap for reflections if reflectmap is not enabled
	if(bUseReflMap)
	{
		reflectmap = tex2D(ReflMapSampler, In.texCoord.xy); //use colored reflectmap to enable metal-like colored reflections
	}
	
	//normal application
	if(!bUseObjectNormals && bUseNormalMap) //tangentspace normalmap
	{
		normal = (In.worldNormal * normal.z) + (normal.x * In.worldBinormal + normal.y * -In.worldTangent); //transform every vertex normal component by the tangentspace normalmap
	}
	if(bUseObjectNormals && bUseNormalMap) //if object space, pure sampling equals the normal
	{
		normal = mul(normal, WorldInvTrans).xyz; // put objectspace normal in worldspace
	}
	
	if(bUseFresnel)
	{
		float reflectionamount = fresnel(normal, In.eyeVec, FresnelPower, FresnelBias); //start off by getting fresnel falloff
		reflectionamount *= reflectmap; //mask fresnelrim by reflectmap, if no reflectmap is used, the value will be the specmap.
		
		float3 ReflectVector = reflect(In.eyeVec, normal); //compute reflection vector
		ReflectVector.xyz = ReflectVector.xzy;  //swizzle required for Max 
	
		float worldmask =1.0f;
		if(!bUseWorldMask)
		{
			worldmask = 1 - saturate(dot(float3(0.0,1.0,0.0),-normal.xzy)); // invert, clamped dot product of normal and upward vector => only normals pointing upward will work
			worldmask = pow(worldmask, FresnelMaskHardness); // power to hardness factor to control effect. 0 equals no control
		}
		else
		{
			//hard type masking activated for reflection faking
			worldmask = 1 - saturate(dot(float3(0.0,1.0,0.0),ReflectVector)); // invert, clamped dot product of reflection and upward vector => only reflections tracing upward will work
		}
		
		//final lerps, to blend between fresnel effect and lit color
		if(!bUseCubeMap) //if no cubemap, fake fresnel rim used
			ret = float4(FresnelColor,0.0f)*FresnelMult * reflectionamount * worldmask; //lerp alpha is fresnel masked by specmap, masked by worldmask
		if(bUseCubeMap)
		{
			ReflectVector.yz = -ReflectVector.yz; //invert reflectionvector for cubemap sampling
			float reflectiongloss = (1-glossiness)*CubeMapBlur; //calculate final reflection blur factor by rescaling gloss to max blur range
			float3 reflcubemap = texCUBElod(reflcubemapSampler, float4(ReflectVector.x,ReflectVector.y,ReflectVector.z,reflectiongloss)); //sample from cubemap with reflection vector, LOD forced by reflection blur factor
																		//NOTE: using texCUBElod with ( ReflectVector.xyz, LODlevel) DOES NOT WORK AS IT SHOULD, split in components to fix ~0_o>
				ret = float4(FresnelMult*reflcubemap*reflectionamount,0); //add cubemap, multiplied with fresnel multiplier, masked by fresnel
		}
	}
	
	if(bAlphaMasksFresnel) ret.rgb *= opacity; //if opacity is used, you can reduce the fresnel effects strength to match the opacity. The is off by default since glass effects are better like this

	return ret;
}


technique SM3  
{  
	pass  P0
    {		 
		ZEnable = true; 
		ZWriteEnable = true; 
		CullMode = cw; //clockwise culling
		AlphaBlendEnable = true; //alphablend allows for full range, smooth opacity masking
		AlphaTestEnable = false;
		VertexShader = compile vs_3_0 vs_main( );
		PixelShader = compile ps_3_0 ps_main( );
	}  
	pass P1
	{		 
		ZEnable = true; 
		ZWriteEnable = true; 
		CullMode = cw; //clockwise culling
		AlphaBlendEnable = true; //alphablend allows for full range, smooth opacity masking
		AlphaTestEnable = false; 
		SrcBlend = One; // additive blening of fresnel stuff
		DestBlend = One;
		VertexShader = compile vs_3_0 vs_main( );
		PixelShader = compile ps_3_0 ps_fresnel( );
	}

} 

technique SM3Masked 
{  
	pass  P0
    {		 
		ZEnable = true; 
		ZWriteEnable = true; 
		CullMode = cw; //clockwise culling 
		AlphaBlendEnable = false; 
		AlphaTestEnable = true; //alphatest is for hard, 1bit opacity masking. might work better in max with draw ordering.
		AlphaRef = 0.333; //Alpha Reference for masked testing
		VertexShader = compile vs_3_0 vs_main( );
		PixelShader = compile ps_3_0 ps_main( );
	}  
	pass P1
	{		 
		ZEnable = true; 
		ZWriteEnable = true; 
		CullMode = cw; //clockwise culling
		AlphaBlendEnable = false; //alphablend allows for full range, smooth opacity masking
		AlphaTestEnable = true; 
		SrcBlend = One; // additive blening of fresnel stuff
		DestBlend = One;
		VertexShader = compile vs_3_0 vs_main( );
		PixelShader = compile ps_3_0 ps_fresnel( );
	}

} 


