--load mod files
assert(SMODS.load_file("atlas.lua"))()
assert(SMODS.load_file("function.lua"))()
assert(SMODS.load_file("objecttype_feather.lua"))()
local filenames = NFS.getDirectoryItems(SMODS.current_mod.path .. 'jokers')
for i = 1, #filenames do
    local file, exception = SMODS.load_file('jokers/' .. filenames[i])
    if exception then
        error(exception)
    end
    file()
end

--jokerdisplay support
if JokerDisplay then
    SMODS.load_file('jokerdisplay.lua')()
end

--override and adds new vars to initalization
local old_func_init_game_object = Game.init_game_object
function Game:init_game_object()
	local ret = old_func_init_game_object(self)
  
	ret.current_round.RD_lotteryticket = { 'Ace', 'King', 'Queen', 'Jack', '10' }
  ret.current_round.RD_lotteryticket_string = "A K Q J 10"
  ret.current_round.RD_skip_interest = false --used for piggybank
  
	return ret
end

--calls here in case we add more cards that need the same function
function SMODS.current_mod.reset_game_globals(run_start)
  reset_game_globals_lotteryticket(run_start)
end