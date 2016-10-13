module("heavylight", package.seeall) -- package.seeall actually sucks, but whatever

if SERVER then
	-- what are you doing here?
	AddCSLuaFile() -- I guess?
	return
end

--[[
renderdef structure:
{
	NewSection = function to be called at the beginning of each section of the poster. Can be nil if this isn't needed.
		For example, if poster_size is 3, new_section_func will be called 9 times.
		The appropriate render target will be set prior to this function being called.
		This function will receive 3 parameters - poster_size, x coordinate, and y coordinate.
	Tick = function to be called immediately after new_section_func, and repeatedly (with blends in between) as long as it returns true.
		The appropriate render target will be set prior to this function being called.
		This function will receive 4 parameters - poster_size, x coordinate, y coordinate, and tick count (per section).
}
--]]

--- Starts a HeavyLight poster render.
-- @param poster_size The first parameter of the 'poster' console command.
-- @param poster_split The second parameter of the 'poster' console command.
-- @param new_section_func A function to be called at the beginning of each section of the poster. Can be nil if this isn't needed.
--	For example, if poster_size is 3, new_section_func will be called 9 times.
--	This function will receive 3 parameters - poster_size, x coordinate, and y coordinate.
-- @param tick_func The function to be called immediately after new_section_func, and repeatedly as long as it returns true.
--	This function will receive 4 parameters - poster_size, x coordinate, y coordinate, and tick count (per section).
-- @param render_target The render target type to use. Can either be a string or a table.
--	As a string it can be one of these (case-insensitive):
--	* "basic" - RGB888 render target. This is the only type to support anti-aliasing (https://github.com/Facepunch/garrysmod-issues/issues/2106)
--	* "int" - RGBA16161616 render target.
--	* "float" - RGBA16161616F render target. This is the default value.
--	As a table, it must be an array with two ITexture elements. The first element is the texture to be rendered into in tick_func, and the second is the texture to hold the blend of all rendered ticks thus far.
-- @param blend_mode The blend mode to use.
--	Can be one of the following (strings are case-insensitive):
--	* "blend" - Blend all rendered ticks together with 
function StartPoster(poster_size, poster_split, renderdef)
	if type(tick_func) ~= "function" then
		error("",number errorLevel=1)
	end
end