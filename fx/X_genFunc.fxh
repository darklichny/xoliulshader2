//XoliulShader General Functions Header file

float4x4 World 					: WORLD;
float4x4 View					: VIEW;
float4x4 Projection				: PROJECTION;
float4x4 WorldInvTrans			: WorldIT;
float4x4 ViewInv				: ViewInverse;
float4 cameraPos				: WORLDCAMERAPOSITION ;
float4x4 WorldViewProj;		

bool bUseLulz
<
    string gui = "slider";
    string UIName = "     For The Lulz?";
> = false;


//==============Custom Functions

void SetupMatrices()
{
	WorldViewProj = mul(mul(World, View), Projection); //just create WVP by multipying
}

//standard diffuse lighting by dot product
float diffuselight( float3 normal, float3 lightvec)
	{
		normal = normalize(normal);
		lightvec = normalize(lightvec);
		
		return saturate(dot(normal,lightvec)); //dot product between surface and light returns how lit the pixel is. clamp between 0 and 1 because intensity is multiplied later
	}

//Half Lambert lighting, function by Valve Software.
//see http://www.valvesoftware.com/publications/2007/NPAR07_IllustrativeRenderingInTeamFortress2.pdf for more info
float halflambert(float3 normal, float3 lightvec, float Power) 
{
	normal = normalize(normal);
	lightvec = normalize(lightvec);
	
	float NdotL = dot(lightvec,normal);		//dot product for base diffuse light
	float HalfLamb = (NdotL * 0.5f)+0.5f;	//magic formula!
	HalfLamb = pow(HalfLamb,Power);		//power halflambert 

	return  saturate(HalfLamb); 
}

//seperate specular calculation to make my life easier coding this thing
//color and masking is NOT done here; this is just for pure, raw specular calculation
//thanks to http://wiki.gamedev.net/index.php/D3DBook:(Lighting)_Blinn-Phong for the very clean and understandable explanation
float blinnspecular(float3 normal, float3 lightvec, float3 eyevec, float glossiness)
{
	normal = normalize(normal);
	lightvec = normalize(lightvec);
	eyevec = normalize(eyevec);
	
	float3 halfvector = normalize(eyevec+lightvec); //add eye and light together for half vector (Blinn)
	
	float specular;
	specular = dot(halfvector, normal); //dot between half and normal (Blinn)
	specular = pow(specular, glossiness); //power specular to glossiness to sharpen highlight
	specular *= saturate(dot(normal,lightvec) * 4); //fix for Specular through surface bug. what this does is just make sure no specular happens on unlit parts. the multiplier works as a bias
	
	return specular;
	
}

//Fresnel falloff function for all round application
float fresnel(float3 normal, float3 eyevec, float power, float bias)
{
	normal = normalize(normal);
	eyevec = normalize(eyevec);
	
	float fresnel = saturate(abs(dot(normal,eyevec))); //get fallof by dot product between normal and eye, absolute to prevent falloff to go negative on backside of object 
	fresnel = 1-fresnel; //invert falloff to get white instead of black on edges
	fresnel = pow(fresnel, power); //power falloff to sharpen effect
	fresnel+=bias; // add bias to falloff, this is mostly for cubemap reflections like in carpaint
	
	return saturate(fresnel);
}

//desaturate/luminance value function
float desaturate(float3 color)
{
	float luminance;
	luminance = dot(color,float3(0.299,0.587,0.114)); //desaturate by dot multiplying with luminance weights.
	return luminance;
}