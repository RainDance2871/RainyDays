SMODS.Joker {
  key = 'breakfast_cereal',
  atlas = 'Jokers',
  pools = { Food = true },
  rarity = 2,
  cost = 5,
  unlocked = true, 
  discovered = true,
  blueprint_compat = true,
  eternal_compat = false,
  perishable_compat = true,
  pos = GetJokersAtlasTable('breakfast_cereal'),
  config = {
    extra = {
      cards_amount = 12,
      repetitions = 1
    }
  },
  
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_TAGS.tag_charm
    return {
      vars = {
        math.max(0, card.ability.extra.cards_amount)
      }
    } 
  end,
  
  calculate = function (self, card, context)
    if context.repetition and context.cardarea == G.play and next(SMODS.get_enhancements(context.other_card)) and card.ability.extra.cards_amount > 0 then
      if not context.blueprint then
        card.ability.extra.cards_amount = card.ability.extra.cards_amount - 1
      end
      
      return {
        repetitions = card.ability.extra.repetitions
      }
    end
    
    if context.after and not context.blueprint then
      if card.ability.extra.cards_amount <= 0 then
        SMODS.destroy_cards(card, nil, nil, true)
        card_eval_status_text(card, 'jokers', nil, nil, nil, { message = localize('k_eaten_ex'), colour = G.C.RED })
        G.E_MANAGER:add_event(Event({
          func = (function()
            add_tag(Tag('tag_charm'))
            play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
            play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
            return true
          end)
        }))
        return {
          message = localize('rainydays_plus_charm_tag'),
          colour = G.C.PURPLE
        }
      end
    end
  end
}

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