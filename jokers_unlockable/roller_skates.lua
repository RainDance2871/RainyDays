SMODS.Joker {
  key = 'roller_skates',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = false,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetJokersAtlasTable('roller_skates'),
  
  config = {
    extra = {
      xmult = 3,
      border_hand = 'Two Pair'
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        colours = {
          card.ability.extra.active and G.C.FILTER or G.C.UI.TEXT_INACTIVE
        },
        card.ability.extra.xmult,
        localize(card.ability.extra.border_hand, 'poker_hands'),
        card.ability.extra.active and  localize('rainydays_active') or localize('rainydays_inactive')
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.joker_main and card.ability.extra.active then
      return {
        xmult = card.ability.extra.xmult
      }
    end
    
    if context.pre_discard and not card.ability.extra.active and not context.blueprint then
      for _, value in ipairs(G.handlist) do
        if value == G.FUNCS.get_poker_hand_info(G.hand.highlighted) then
          card.ability.extra.active = true
          return {
            message = localize('rainydays_activated'),
            colour = G.C.RED
          }
        elseif value == card.ability.extra.border_hand then
          return
        end
      end
    end
    
    if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint and card.ability.extra.active then
      card.ability.extra.active = nil
      return {
        message = localize('k_reset'),
        colour = G.C.RED
      }
    end
  end,
  
  locked_loc_vars = function(self, info_queue, card)
    return { vars = { 6 }}
  end,
  
  check_for_unlock = function(self, args)
    if args.type == 'discard_custom' then
      local count = 0
      for _, value in ipairs(G.handlist) do
        if G.GAME.hands[value].rainydays_discarded and G.GAME.hands[value].rainydays_discarded > 0 then
          count = count + 1
          if count >= 6 then
            return true
          end
        end
      end
    return false
    end
  end
}

local discard_cards_from_highlighted_ref = G.FUNCS.discard_cards_from_highlighted
G.FUNCS.discard_cards_from_highlighted = function(e, hook)
  local highlighted_count = math.min(#G.hand.highlighted, G.discard.config.card_limit - #G.play.cards)
  if highlighted_count > 0 then 
    local text, _ = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
     G.GAME.hands[text].rainydays_discarded = (G.GAME.hands[text].rainydays_discarded or 0) + 1
  end
  return discard_cards_from_highlighted_ref(e, hook)
end