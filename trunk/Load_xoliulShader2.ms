-- XoliulShader2
-- this file goes in #maxroot#\Scripts\Startup

-- tries to load xoliulShader2 scripted material
(
	local rootPath = getDir #maxRoot				
	global xoliulShader2Dir = (rootPath + "\\xoliulshader2")		
	fileIn (xoliulShader2Dir + "\\xoliulShader2.ms") -- start the script
)