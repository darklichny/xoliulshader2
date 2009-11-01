-----------------------------------------------------------
-- Xoliul shader 2 scripted material
--

-- bugs:
--	label LBL_version doesn't update

-- Reference:
-- http://www.cgcookie.com/articles/2008/11/22/custom-scripted-shader-in-3d-studio-max
-- http://tech-artists.org/wiki/MAXScript_DirectX_Scripted_Material_Plugin
-- http://www.gamasutra.com/features/20060524/puech_01.shtml
-----------------------------------------------------------
plugin material XoliulShader2
	name:"Xoliul Shader 2"
	classID:#(0x31ef8010, 0x24038596)
	extends:DirectX_9_Shader replaceUI:true version:1
(
-----------------------------------------------------------
-- Interface design params
-----------------------------------------------------------
	parameters MainParams rollout:MainParams
	(

	) 

	parameters LightParams rollout:LightParams
	(

	)  

-----------------------------------------------------------
-- Rollout and buttons definition
-----------------------------------------------------------	
	rollout MainParams "Load Parameters"
	(	
		bitmap bmp1 "Bitmap" width:306 height:44 fileName:"Xheader.tga"											
		label LBL_version "----" width:160 height:20			
		checkbox CHK_shadows "Shadows Enabled" width:137 height:20 enabled:true
		checkbox CHK_SoftShadows "Soft Shadows" width:137 height:20 enabled:false
		--button btnLoadVersion "Load"		
		
		on CHK_shadows changed false do
		(
			CHK_SoftShadows.checked = false
			CHK_SoftShadows.enabled = false
		)
		
		on CHK_shadows changed true do
		(
			CHK_SoftShadows.enabled = true
		)
  
		fn FN_VersionSet version =
		(
			if version<10 do
			(
				MainParams.CHK_shadows.enabled=false
				MainParams.CHK_SoftShadows.enabled=false				
				MainParams.LBL_version.text = "Max 9 detected"
				print "Max 9 detected"
			)
			if version==10 or version==11 do
			(
				MainParams.CHK_shadows.enabled=true
				MainParams.CHK_SoftShadows.enabled=false
				MainParams.LBL_version.text = "Max 2008-2009 detected"
				print "Max 2008-2009 detected"
			)
			if version>11 do
			(
				MainParams.CHK_shadows.enabled=true
				MainParams.CHK_SoftShadows.enabled=true
				MainParams.LBL_version.text = "Max 2010 detected"
				print "Max 2010 detected"
			)
		)

  
		on btnLoadVersion pressed do
		(
			if DDL_Version.selection==1 or (DDL_Version.selection>1 and CHK_shadows.state == false) do
			(
				delegate.effectfile = "P:\\3D\\Shaders\\Xoliulshader\\Xoliulshader_1.3_noshadows.fx"
			)
			if DDL_Version.selection>1 and CHK_shadows.state == true and CHK_SoftShadows.state == false do
			(
				delegate.effectfile = "P:\\3D\\Shaders\\Xoliulshader\\Xoliulshader_1.3.fx"
			)
			if DDL_Version.selection==3 and CHK_shadows.state == true and CHK_SoftShadows.state == true do
			(
				delegate.effectfile = "P:\\3D\\Shaders\\Xoliulshader\\Xoliulshader_1.3.fx"
			)
				MainParams.open = false
			)			
		)
  
  rollout LightParams "Light Parameters"
  (
  
  )

-----------------------------------------------------------	
-- Shader creation in the material editor
-----------------------------------------------------------	
	on create do
	(				
		print ""
		print "Creating scripted material"		
		global max_version = (substring(MaxVersion() as string) 3 2) as integer
		MainParams.FN_VersionSet max_version
	)  


) -- end plugin