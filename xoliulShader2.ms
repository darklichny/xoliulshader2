-----------------------------------------------------------
-- Xoliul shader 2 scripted material
--

-- Bugs:

-- Reference:
-- http://www.cgcookie.com/articles/2008/11/22/custom-scripted-shader-in-3d-studio-max
-- http://tech-artists.org/wiki/MAXScript_DirectX_Scripted_Material_Plugin
-- http://www.gamasutra.com/features/20060524/puech_01.shtml
-----------------------------------------------------------
--fileIn (xoliulShader2Dir + "\\common.ms") -- include common maxscript functions

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
		g_technique type:#integer default:1 ui:dd_technique
		on g_technique set val do (
			delegate.Technique = val - 1			
		)
	)	
	

-----------------------------------------------------------
-- Rollout and buttons definition
-----------------------------------------------------------	
	rollout roll_main "Basic Parameters"
	(	
		bitmap bmp_logo "Bitmap" fileName:(xoliulShader2Dir + "\\gui\\header.bmp")
		label lbl_version	
		
		group "Material technique"
		(	
			dropdownlist dd_technique items:#("SM3 Default","SM3 Masked")
		)
		
		group "Shadows"
		(	
			checkbox chk_shadows "Shadows Enabled" enabled:true across:2
			checkbox chk_softShadows "Soft Shadows" enabled:false	
		)
		
		on roll_main open do
		(					
			local max_version = (substring(MaxVersion() as string) 3 2) as integer		
			global max_version_flag = 0 -- 1=max9, 2=max2008-2009, 3=max2010				
			if max_version<10 do max_version_flag = 1			
			if max_version==10 or max_version==11 do max_version_flag = 2			
			if max_version>11 do max_version_flag = 3
		
			if max_version_flag==1 do
			(			
				chk_shadows.enabled=false
				chk_softShadows.enabled=false				
				lbl_version.text = "3ds Max 9 version"					
			)
			if max_version_flag==2 do
			(
				chk_shadows.enabled=true
				chk_softShadows.enabled=false
				lbl_version.text = "3ds Max 2008-2009 version"		
			)
			if max_version_flag==3 do
			(
				chk_shadows.enabled=true
				chk_softShadows.enabled=true
				lbl_version.text = "3ds Max 2010 version"				
			)			
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
		
		fn LoadFxFile =
		(						
			-- max9 or no shadows
			if max_version_flag==1 or chk_shadows.state == false do
			(
				print "Loading no shadows shader"
				print (xoliulShader2Dir + "\\fx\\Xoliulshader_2.0.fx")
				delegate.effectfile = xoliulShader2Dir + "\\fx\\Xoliulshader_2.0.fx"
			)
			
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
	)

-----------------------------------------------------------	
-- Shader creation in the material editor
-----------------------------------------------------------	
	on create do
	(				
		print ""
		print "Creating scripted material"
		roll_main.LoadFxFile()
	)  


) -- end plugin