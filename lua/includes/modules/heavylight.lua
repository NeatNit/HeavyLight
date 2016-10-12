if SERVER then
	-- what are you doing here?
	AddCSLuaFile()
	print("HEY!")
	return
end

module("heavylight", package.seeall)

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
-- As a table, it must be an array with two ITexture elements. The first element is the textured to be rendered into in tick_func, and the second is the texture to hold the blend of all rendered ticks thus far.
function StartPoster(poster_size, poster_split, new_section_func, tick_func, render_target, blend_mode, finish_func)
end