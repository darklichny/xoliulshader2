//----------------------------------------------------------------------------------------------------------------------
// Shader material parameters
//

//----------------------------------------------------------------------------------------------------------------------
// General
//----------------------------------------------------------------------------------------------------------------------
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

//----------------------------------------------------------------------------------------------------------------------
// Diffuse
//----------------------------------------------------------------------------------------------------------------------
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


bool bColorDiffuse
<
    string gui = "slider";
    string UIName = "     Color Diffuse Map";
> = false;

//----------------------------------------------------------------------------------------------------------------------
// Opacity 
//----------------------------------------------------------------------------------------------------------------------
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

//----------------------------------------------------------------------------------------------------------------------
// Specular
//----------------------------------------------------------------------------------------------------------------------
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

//----------------------------------------------------------------------------------------------------------------------
// Gloss
//----------------------------------------------------------------------------------------------------------------------
bool bUseGlossMap
<
    string gui = "slider";
    string UIName = "Gloss Map";
> = false;

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
//----------------------------------------------------------------------------------------------------------------------
// Normal
//----------------------------------------------------------------------------------------------------------------------
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

bool bFlipGreenChannel
<
    string gui = "slider";
    string UIName = "     Flip Green";
> = false;
//----------------------------------------------------------------------------------------------------------------------
// Self illumination
//----------------------------------------------------------------------------------------------------------------------


bool bUseSIMap
<
    string gui = "slider";
    string UIName = "Self Illumination Map";
> = false;

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

//----------------------------------------------------------------------------------------------------------------------
// Reflection
//----------------------------------------------------------------------------------------------------------------------
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

bool bUseCubeMap
<
    string gui = "slider";
    string UIName = "     Reflect Cubemap";
> = false;


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
//----------------------------------------------------------------------------------------------------------------------
// Ambient
//----------------------------------------------------------------------------------------------------------------------
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

//----------------------------------------------------------------------------------------------------------------------
// Shadows
//----------------------------------------------------------------------------------------------------------------------
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



//----------------------------------------------------------------------------------------------------------------------
// Lights
//----------------------------------------------------------------------------------------------------------------------
int numberOfActiveLights
<
string UIName = "     Active Lights";
string UIType = "FloatSpinner";
float UIMin = 0.0f;
float UIMax = 3.0f;
float UIStep = 1.0;
> = 1;

float4 light1_Position : POSITION
<
	string UIName = "Light 1 Position";
	string Object = "PointLight";
	string Space = "World";
	int refID = 1; 								//refID for automatic lightcolor input
>;// = {100.0f, 100.0f, 100.0f, 0.0f};

//lightcolor = lightrgb x lightmultiplier, done by Max
float4 light1Color : LIGHTCOLOR <int LightRef = 1; string UIWidget = "None"; > = { 1.0f, 1.0f, 1.0f, 1.0f}; 	//lightref ID makes sure that max fills in this value automatically

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

