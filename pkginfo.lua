return {
	--[[
	-- Defines the name of the mod directory to be used inside the zip archive.
	-- (it doesn't need to match the actual directory name being used)
	--
	-- The name of the zip will be that appended with ".zip".
	--]]
	moddir = "UpAndAway_test",

	--[[
	-- Names of the files returning asset tables.
	--]]
	asset_files = {
		"assets.lua",
		"prefabassets.lua",
	},

	--[[
	-- File extensions to never include.
	--
	-- Only the image extensions really have a reason to be listed, the others
	-- shouldn't be included anyway.
	--]]
	exclude_extensions = {
		"png",
		"psd",
		"xcf",
		"svg",

		"bin",

		"scml",
	},

	--[[
	-- Extra files/directories to include.
	--]]
	extra = {
		"modinfo.lua",
		"modmain.lua",
		"modworldgenmain.lua",

		"favicon",

		"assets.lua",
		"asset_utils.lua",
		"prefabfiles.lua",

		"credits.lua",
		"LICENSE",
		"NEWS.md",
		"README.md",

		"rc.defaults.lua",
		"tuning.lua",
		"tuning",

		"scripts",
		"levels",
	},

	--[[
	-- Directories to include as empty directories.
	--
	-- They are not required to exist (being placed anyway in the zip).
	--]]
	empty_directories = {
		"log",
	},
}