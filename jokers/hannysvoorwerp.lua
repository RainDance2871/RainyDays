SMODS.Joker {
  key = 'hannysvoorwerp',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  pos = RainyDays.GetJokersAtlasTable('hannysvoorwerp'),
  attributes = { 'mult', 'scaling', 'planet', 'space' },
  config = {
    extra = {
      current_mult = 0,
      plus_mult = 7
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.plus_mult,
        card.ability.extra.current_mult
      }
    }
  end,

  
  calculate = function(self, card, context)
    if context.joker_main and card.ability.extra.current_mult > 0 then
      return {
        mult = card.ability.extra.current_mult
      }
    end
    
    if context.before and not context.blueprint then
      for _, planet in ipairs(G.consumeables.cards) do
        if planet.ability.set == 'Planet'and planet.ability.hand_type == context.scoring_name and not planet.getting_sliced then
          planet.getting_sliced = true
          G.GAME.consumeable_buffer = G.GAME.consumeable_buffer - 1
          G.E_MANAGER:add_event(Event({
            trigger = 'before',
            delay = 1,
            func = function()
              G.GAME.consumeable_buffer = 0
              card:juice_up(0.8, 0.8)
              planet:start_dissolve({ HEX('57ecab') }, nil, 1.6)
              play_sound('slice1', 0.96 + math.random() * 0.08)
              return true
            end
          }))
          
          SMODS.scale_card(card, {
            ref_table = card.ability.extra,
            ref_value = 'current_mult',
            scalar_value = 'plus_mult',
            scaling_message = { message = localize('k_upgrade_ex'), message_card = card, colour = G.C.MULT }
          })
        end
      end
    end
  end
}