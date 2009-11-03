-----------------------------------------------------------
-- Xoliul shader 2 scripted material
--

-- Bugs:
-- ( minor ) Texture names don't update when material editor is open when loading file.

-- Todo:

-- Reference:
-- http://www.cgcookie.com/articles/2008/11/22/custom-scripted-shader-in-3d-studio-max
-- http://tech-artists.org/wiki/MAXScript_DirectX_Scripted_Material_Plugin
-- http://www.gamasutra.com/features/20060524/puech_01.shtml
-----------------------------------------------------------

-- This stuff will be moved to startup script --
global bmp_diffuseIcon = openBitMap(xoliulShader2Dir + "\\gui\\test.bmp")

global max_version = (substring(MaxVersion() as string) 3 2) as integer		
global max_version_flag = 0 -- 1=max9, 2=max2008-2009, 3=max2010				
if max_version<10 do max_version_flag = 1			
if max_version==10 or max_version==11 do max_version_flag = 2			
if max_version>11 do max_version_flag = 3
-- This stuff will be moved to startup script --


plugin material XoliulShader2
	name:"Xoliul Shader 2"
	classID:#(0x31ef8010, 0x24038596)
	extends:DirectX_9_Shader replaceUI:true version:1
(	

-----------------------------------------------------------
-- Interface design params
-----------------------------------------------------------
	parameters param_main rollout:roll_main
	(
		technique type:#integer default:1 ui:dd_technique
		on technique set val do -- this works !
		(
			delegate.Technique = val - 1						
		)
	)
	
	parameters param_textures rollout:roll_textures
	(		
		diffuseTex type:#bitmap
		on diffuseTex set val do
		(
			if(val != undefined) then
			(
				delegate.diffuseMap = val							
			)
		)
		
		useDiffuse type:#boolean default:false ui:chb_useDiffuseTex
		on useDiffuse set val do
		(			
			delegate.bUseDiffuseMap = val			
		)
	)

-----------------------------------------------------------
-- Rollout and buttons definition
-----------------------------------------------------------	
	rollout roll_about "About" category:1
	(
		bitmap bmp_logo "Bitmap" fileName:(xoliulShader2Dir + "\\gui\\header.bmp") align:#center
		label lbl_version align:#center
		hyperlink hp_link "url test" address:"http://code.google.com/p/xoliulshader2/" align:#center
		
		on roll_about open do
		(										
			if max_version_flag==1 do lbl_version.text = "3ds Max 9 version"
			if max_version_flag==2 do lbl_version.text = "3ds Max 2008-2009 version"					
			if max_version_flag==3 do lbl_version.text = "3ds Max 2010 version"						
		)
	) -- roll_about
	
	rollout roll_main "Basic Parameters" category:3
	(					
		group "Material technique"
		(	
			dropdownlist dd_technique items:#("SM3 Default","SM3 Masked")
		)
				
		group "Diffuse"
		(						
			colorpicker cp_diffuseColor "Color" color:[128,128,128] modal:false across:3
			checkbox chk_colorizeDiffuse "Colorize diffuse texture" enabled:true
			imgtag bmp_diffuse bitmap:bmp_diffuseIcon transparent:(color 255 0 255) align:#right offset:[0,-5]
		)		
		
		group "Specular"
		(
			colorpicker cp_specularColor "Color" color:[255,255,255] modal:false across:3
			spinner sp_globalSpecular "Level" range:[0,10,0.05] type:#float			
			imgtag bmp_specular bitmap:bmp_diffuseIcon transparent:(color 255 0 255) align:#right offset:[0,-5]
		)
		--on frab_amt changed val do frabulate selection val
		
		group "Normals"
		(
			checkbox chk_objectSpaceNormals "Object Space Normals" enabled:true
			checkbox chk_flipGreen "Flip Green Channel" enabled:true
			imgtag bmp_normal bitmap:bmp_diffuseIcon transparent:(color 255 0 255) align:#right offset:[0,-40]
		)
		
		group "Reflection"
		(
		)		
		
		group "Opacity"
		(
		)			
				
		/*
		on CHK_shadows changed state do
		(
			--CHK_SoftShadows.checked = state
			--if max_version_flag == 3 do
			--(
			--	CHK_SoftShadows.enabled = state
			--)
			
			--MainParams.FN_LoadFxFile()					
		)
		
		on CHK_SoftShadows changed state do
		(
			--CHK_SoftShadows.enabled = state
			--MainParams.FN_LoadFxFile()
		)		
		*/		
	) -- roll_main

	rollout roll_textures "Textures" category:2
	(	
		checkbox chb_useDiffuseTex "Diffuse" align:#left across:2
		button btn_diffuseTex "None" width:230 align:#right		
		
		on roll_textures open do
		(		
			if delegate != undefined then
			(
				if delegate.diffuseMap != undefined then
				(
					btn_diffuseTex.text = delegate.diffuseMap.filename
					btn_diffuseTex.tooltip = btn_diffuseTex.caption					
				)
			)
		)		
		
		-- When pressing btn DiffuseMap button
		on btn_diffuseTex pressed do
		(
			  bmp = selectbitmap caption: "Diffuse Texture"
			  if(bmp != undefined) do
			  (					
					btn_diffuseTex.text = bmp.filename
					btn_diffuseTex.tooltip = btn_diffuseTex.caption
					diffuseTex = bmp                   -- Set Paramblock value
			  )
		) 
		
		--here we want to open an explorer window for the user to find his diffuse texture
		/*
		on btn_diffuseBrowse pressed do
		(			
			try (
				texPath = selectbitmap caption: "Diffuse Texture"
				if texPath != undefined then
				(
					et_diffuseTex.text = texPath.filename
					--delegate.diffuseMap = texPath					 
					--btn_diffuseTex.caption  = delegate.diffuseMap.filename
					--btn_diffuseTex.tooltip = btn_diffuseTex.caption
				)							
			) catch ()
		)
		*/
	) -- roll_textures
	
	rollout roll_shading "Shading" category:4
	(
		group "Shadows"
		(	
			checkbox chk_shadows "Shadows Enabled" enabled:true across:2
			checkbox chk_softShadows "Soft Shadows" enabled:false	
		)
		
		on roll_shading open do
		(										
			if max_version_flag==1 do
			(			
				chk_shadows.enabled=false
				chk_softShadows.enabled=false								
			)
			if max_version_flag==2 do
			(
				chk_shadows.enabled=true
				chk_softShadows.enabled=false				
			)
			if max_version_flag==3 do
			(
				chk_shadows.enabled=true
				chk_softShadows.enabled=true				
			)			
		)
	) -- roll_shading
	
	-----------------------------------------------------------	
-- Shader creation in the material editor
-----------------------------------------------------------	
	fn LoadFxFile =
	(						
		-- max9 or no shadows
		--if max_version_flag==1 do
		--(
			print "Loading no shadows shader"
			print (xoliulShader2Dir + "\\fx\\Xoliulshader_2.0.fx")
			delegate.effectfile = xoliulShader2Dir + "\\fx\\Xoliulshader_2.0.fx"
		--)
		
		/*
		-- max 2008-2009 shadows			
		if max_version_flag>1 and CHK_shadows.state == true and CHK_SoftShadows.state == false do
		(
			print "Loading shadows shader"
			delegate.effectfile = xoliulShader2Dir + "\\fx\\Xoliulshader_2.0.fx"
		)
		
		-- max2010 softshadows
		if max_version_flag==3 and CHK_shadows.state == true and CHK_SoftShadows.state == true do
		(
			print "Loading soft shadows shader"
			delegate.effectfile = xoliulShader2Dir + "\\fx\\Xoliulshader_2.0.fx"
		)
		*/			
			--MainParams.open = false
	)						

	on create do
	(				
		print ""
		print "Creating scripted material"
		LoadFxFile()
	)  
	
) -- end plugin