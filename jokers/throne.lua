SMODS.Joker {
  key = 'throne',
  atlas = 'Jokers',
  rarity = 3,
  cost = 8,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('throne_inactive'),
  config = {
    extra = {
      xmult = 4,
      active = false,
      in_deck = false,
      string = 'throne_inactive'
    }
  },
  
  add_to_deck = function(self, card, from_debuff)
    card.ability.extra.in_deck = true
    card.ability.extra.active = G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards]:is_face()
    card.ability.extra.string = card.ability.extra.active and 'throne_active' or 'throne_inactive'
    card.children.center:set_sprite_pos(RainyDays.GetJokersAtlasTable(card.ability.extra.string))
  end,
  
  set_sprites = function(self, card, front)
    if card.ability and card.ability.extra.in_deck and (card.config.center.discovered or card.bypass_discovery_center) then
      if G.deck and G.deck.cards[1] then
        card.ability.extra.active = G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards]:is_face()
        card.ability.extra.string = card.ability.extra.active and 'throne_active' or 'throne_inactive'
        card.children.center:set_sprite_pos(RainyDays.GetJokersAtlasTable(card.ability.extra.string))
      end
    end
  end,
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        colours = {
          (card.ability.extra.in_deck and card.ability.extra.active) and G.C.FILTER or G.C.UI.TEXT_INACTIVE
        },
        card.ability.extra.xmult,
        card.ability.extra.in_deck and (card.ability.extra.active and localize('rainydays_active') or localize('rainydays_inactive')) or localize('rainydays_hidden')
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.joker_main and card.ability.extra.active then
      return {
        xmult = card.ability.extra.xmult
      }
    end
    
    if (context.hand_drawn or context.other_drawn or context.playing_card_added) and not context.blueprint then
      card.ability.extra.active = G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards]:is_face()
      card.ability.extra.string = card.ability.extra.active and 'throne_active' or 'throne_inactive'
      card.children.center:set_sprite_pos(RainyDays.GetJokersAtlasTable(card.ability.extra.string))
    end
  end
}