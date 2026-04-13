SMODS.Joker {
  key = 'cleanslate',
  atlas = 'Jokers',
  rarity = 1,
  cost = 6,
  unlocked = true, 
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('cleanslate'),
  config = {
    extra = {
      plus_mult = 15
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = { card.ability.extra.plus_mult }
    } 
  end,
  
  add_to_deck = function(self, card, from_debuff)
    G.GAME.rd_full_discard = (G.GAME.rd_full_discard or 0) + 1
  end,
  
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.rd_full_discard = (G.GAME.rd_full_discard or 0) - 1
  end,
  
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.joker_main then
      return {
        mult = card.ability.extra.plus_mult
      }
    end
  end
}

--override function, changes discard behaviour to discard all cards
local old_func_discard = G.FUNCS.discard_cards_from_highlighted
function G.FUNCS.discard_cards_from_highlighted(e, hook)
  if G.GAME.rd_full_discard and G.GAME.rd_full_discard > 0 then
    local card_limit = G.hand.config.highlighted_limit;
    G.hand.config.highlighted_limit = #G.hand.cards
    G.hand:unhighlight_all()
    for i = 1, #G.hand.cards do
      G.hand.cards[i].ability.forced_selection = true
      G.hand:add_to_highlighted(G.hand.cards[i], true)
    end
    play_sound('cardSlide1')
    local ret = old_func_discard(e, hook)
    G.hand.config.highlighted_limit = card_limit
    return ret
  else
    return old_func_discard(e, hook)
  end
end

--override function that changes button behaviour - now active when no cards selected if you have cleanslate
local old_func_can_discard = G.FUNCS.can_discard
function G.FUNCS.can_discard(e)
  local ret = old_func_can_discard(e)
  if not e.config.button and G.GAME.rd_full_discard and G.GAME.rd_full_discard > 0 and G.GAME.current_round.discards_left > 0 then
    e.config.colour = G.C.RED
    e.config.button = 'discard_cards_from_highlighted'
  end
  return ret
end