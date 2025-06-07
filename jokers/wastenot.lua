SMODS.Joker {
  key = 'waste_not',
  name = 'Waste Not',
  atlas = 'RainyDays',
  rarity = 2,
  cost = 4,
  unlocked = true, 
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetRainyDaysAtlasTable('waste_not'),
  config = {
    minus_chips = 4
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = { card.ability.minus_chips }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.discard and not context.other_card.debuff then
      --find the maximum amount of chips when can remove without cards scoring negative chips.
      local amount_to_take = math.min(card.ability.minus_chips, context.other_card:get_chip_bonus())
      
      if amount_to_take > 0 and #G.hand.cards > #G.hand.highlighted then --check if chips can be taken and if there are cards remaining in hand to give them to
        --create the perma_bonus var in the card if it doesn't have it yet, then substract the amount of chips
        
        --find all cards remaing in hand and pick one at random, then give the taken chips to it
        local remaining_cards = {}
        for i = 1, #G.hand.cards do
          if not check_card_in_hand(G.hand.cards[i], G.hand.highlighted) then
            remaining_cards[#remaining_cards + 1] = G.hand.cards[i] 
          end
        end
        
        if #remaining_cards > 0 then
          context.other_card.ability.perma_bonus = (context.other_card.ability.perma_bonus or 0) - amount_to_take
          local recieving_card = pseudorandom_element(remaining_cards, pseudoseed('WasteNot' .. G.GAME.round_scores.cards_discarded.amt))
          recieving_card.ability.perma_bonus = (recieving_card.ability.perma_bonus or 0) + amount_to_take
        
          return {
            card = context.other_card,
            message = localize{ type = 'variable', key = 'a_chips_minus', vars = { amount_to_take }},
            colour = G.C.CHIPS,
            extra = {
              card = recieving_card,
              message = localize { type = 'variable', key = 'a_chips', vars = { amount_to_take }},
              colour = G.C.CHIPS
            }
          }
        end
      end
    end
  end
}

--lets make it so that if stone or bonus cards transform into something else, their score doesn't become negative.
local old_func_set_ability = Card.set_ability
function Card:set_ability(center, initial, delay_sprites)
  --run the old function
  local ret = old_func_set_ability(self, center, initial, delay_sprites)
  
  --so that we don't target non-playing cards
  if not self.base then
    return ret
  end
  
  --disable debuffs so we can use get_chip_bonus properly
  local card_debuffed = self.debuff
  self.debuff = false;
  
  --prevent the chip_score from being negative
  local after_chip_score = self:get_chip_bonus()
  if after_chip_score < 0 then
    self.ability.perma_bonus = (self.ability.perma_bonus or 0) - after_chip_score
  end
  
  --set debuff back to previous state
  self.debuff = card_debuffed;

  --old function doesn't have a return value, put lets make sure for other mods/future changes.
  return ret
end