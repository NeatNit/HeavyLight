module("heavylight", package.seeall) -- package.seeall actually sucks, but whatever

assert(CLIENT, "Tried to include a client module (heavylight) in a server file!")
 -- change!
 -- change 2!
do
	local RTs = {}

	function GetRT(rttype, index, width, height)
		local w, h = width or ScrW(), height or ScrH()
		RTs[rttype]       = RTs[rttype] or {}
		RTs[rttype][w]    = RTs[rttype][w] or {}
		RTs[rttype][w][h] = RTs[rttype][w][h] or {}

		if not RTs[rttype][w][h][index] then
			RTs[rttype][w][h][index] = GetRenderTargetEx(
				"HeavyLight" .. w .. "_" .. h .. "_" .. rttype .. tostring(index),	-- Name
				w,	-- Width
				h,	-- Height
				RT_SIZE_DEFAULT,	-- Size Mode, does this even affect anything?
				MATERIAL_RT_DEPTH_SHARED,	-- Depth Mode, what is this?
				nil,	-- Texture Flags, shit documentation, does jack shit
				0,	-- RT flags
				_G["IMAGE_FORMAT_" .. rttype])	-- Image Format
		end

		return RTs[rttype][w][h][index]
	end
end

--[[
renderdef structure:
{
	Start = function to be called at the beginning of each section of the poster.
		For example, if PosterSize is 3, Start will be called 9 times.
		The appropriate render target will be set prior to this function being called.
		This function will receive these arguments - PosterSize, x coordinate, and y coordinate.
		Optional.
	Tick = function to be called immediately after Start, and repeatedly (with blends in between) as long as it returns true.
		The appropriate render target will be set prior to this function being called.
		This function will receive these arguments - tick number (running count per section), PosterSize, x coordinate, y coordinate
		This function must return a boolean value. Optionally, it can additionally return extra data used to display progress bars:
																																		-- FILL THIS IN
	Finish = A function called after Tick returns false. When this function is finished, the blend texture is expected to hold the final image.
		This function receives these arguments: RenderTexture, BlendTexture, final tick count, PosterSize, x coordinate, y coordinate
		If BlendMode is a function and Finish is missing, BlendMode will be called instead.
	Textures = The type of render targets to use. Can be one of these strings (case-insensitive):
		* "basic" - The default RGB888 render target. This is the default value, and is the only type to support anti-aliasing (see this GitHub issue: https://github.com/Facepunch/garrysmod-issues/issues/2106)
		* "int" - RGBA16161616 render target.
		* "float" - RGBA16161616F render target.
		Alternatively, it can be a table with two ITexture elements:
			* Render = The texture rendered into in Tick
			* Blend = The texture to hold the blend of all rendered ticks thus far.
		It is not recommended to use the table method though, as it disables many of HeavyLight's tricks. If there is another type of render target that you need, you should make a request so I add it.
	BlendMode = The method used to blend all Ticks together. Can be one of these strings (case-insensitive):
		* "blend" = (Default) An average blend of all the ticks will be computed, with all ticks receiving equal weights. On the technical side, this is implemented by additive blending and finalized by dividing the values by the number of ticks.
		* "blend2" = Same as blend, but implemented differently - instead of additive and division, a 'running average' is used.
		* "add" / "additive" = Additive blending of all ticks.
		Alternatively, it can be a function that receives these arguments: RenderTexture, BlendTexture, tick number, is this the last tick (boolean), PosterSize, x coordinate, y coordinate
		The function will be called after every Tick that returns true, and after Tick returns false if Finish is missing, and is expected to blend into BlendTexture the ticks which are rendered into RenderTexture.
}
--]]
local function CheckValidity(renderdef, errorlevel)
	if type(renderdef.Tick) ~= "function" then
		error("Missing Tick function for HeavyLight", (errorlevel or 2) + 1)
	end
end


local function GetAddRT(rttype, index, width, height)
	rttype = rttype or "basic"
	if isstring(rttype) then
		if		rttype == "basic" then
			index = math.floor((index or 0) / 257)
			return render.GetRenderTarget()
		elseif	rttype == "int" then
			-- RGBA16161616
		elseif	rttype == "float" then
			-- RGBA16161616F
		end
	elseif index >= 0 then
		return rttype.Render
	else
		return rttype.Blend
	end
end

function Render(renderdef, drawprogress)
	CheckValidity(renderdef)

	if renderdef.Start then
		reunderdef.Start()
	end

	GetRT()
end

--[[-------------------------------------------------------------------------
 Poster
 ---------------------------------------------------------------------------]]
do
	local posterdata = {}
	--- Starts a HeavyLight poster render.
	-- @param renderdef A table of the structure defined someplace else. Give me a break okay?
	-- @param int postersize The first parameter of the 'poster' console command.
	-- @param[opt] int postersplit The second parameter of the 'poster' console command.
	function StartPoster(renderdef, postersize, postersplit)
		CheckValidity(renderdef)
		assert(tonumber(postersize), "bad argument #2 to StartPoster (number expected, got " .. type(postersize) .. ")")
	end

	hook.Add("RenderScene","HeavyLightPoster",function()
		if not posterdata.active then return end

		Render(posterdata.renderdef, true)
		return true
	end)
end