RainyDays = SMODS.current_mod

function load_folder(folder)
  local filenames = NFS.getDirectoryItems(RainyDays.path .. folder)
  for i = 1, #filenames do
    assert(SMODS.load_file(folder .. '/' .. filenames[i]))()
  end
end

--load mod files
assert(SMODS.load_file('config_menu.lua'))()
load_folder('functions')
assert(SMODS.load_file('atlas.lua'))()
assert(SMODS.load_file('canvas_sprite.lua'))()
assert(SMODS.load_file('drawstep.lua'))()
assert(SMODS.load_file('shaders.lua'))()

if RainyDays.config.feathers then
  assert(SMODS.load_file('objecttype_feather.lua'))()
end

load_folder('jokers')
load_folder('jokers_unlockable')
load_folder('seals')
load_folder('spectrals')
load_folder('take_ownership')

if RainyDays.config.constellations then
  assert(SMODS.load_file('constellation_type.lua'))()
  load_folder('constellations')
end

RainyDays_lottery_font = love.graphics.newFont('resources/fonts/GoNotoCurrent-Bold.ttf', 0.5 * G.TILESIZE)
RainyDays_lottery_font:setFilter('nearest', 'nearest')
RainyDays_skinner_box_font = love.graphics.newFont('resources/fonts/m6x11plus.ttf', 16)
RainyDays_skinner_box_font:setFilter('nearest', 'nearest')

--jokerdisplay support
if JokerDisplay then
  assert(SMODS.load_file('jokerdisplay.lua'))()
end

--override and adds new vars to initalization
local old_func_init_game_object = Game.init_game_object
function Game:init_game_object()
	local ret = old_func_init_game_object(self)
	ret.current_round.RD_lotteryticket = { 'Ace', 'King', 'Queen', 'Jack', '10' } --used for lottery ticket
  ret.current_round.RD_skip_interest = false --used for piggybank
	return ret
end

--calls here in case we add more cards that need the same function
function SMODS.current_mod.reset_game_globals(run_start)
  reset_game_globals_lotteryticket()
end