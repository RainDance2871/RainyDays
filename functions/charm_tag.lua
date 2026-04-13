--meteor tags now open the moment you enter the shop after a blind, no need to open another pack or exit the shop first
local old_update_shop_ref = Game.update_shop
function Game:update_shop(dt)
  local ret = old_update_shop_ref(self, dt)
  for i = 1, #G.GAME.tags do
    local lock = G.GAME.tags[i].ID
    if G.CONTROLLER.locks[lock] then
      return ret
    end
  end    
    
  for i = 1, #G.GAME.tags do
    if G.GAME.tags[i].name == 'Charm Tag' and G.GAME.tags[i]:apply_to_run({type = 'new_blind_choice'}) then
      break;
    end
  end
  
  return ret
end