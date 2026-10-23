SMODS.Joker {
  key = 'fruit_punch',
  atlas = 'Jokers',
  pools = { Food = true },
  rarity = 2,
  cost = 4,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = false,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('fruit_punch'),
  attributes = { 'on_sell', 'food', 'generation', 'tag' },
  
  config = {
    extra = {
      tag = 'tag_voucher',
      amount = 1
    }
  },
    
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = { set = 'Other', key = 'rainydays_' .. card.ability.extra.tag }
    
    return { 
      vars = {
        localize{ type = 'name_text', set = 'Tag', key = card.ability.extra.tag }
      } 
    }
  end,
  
  calculate = function(self, card, context)
    if context.selling_self then
      G.E_MANAGER:add_event(Event({
        func = (function()
          add_tag(Tag(card.ability.extra.tag))
          play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
          play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
          
          if G.shop and not G.shop.REMOVED and G.shop_vouchers then
            for i = 1, #G.GAME.tags do
              if G.GAME.tags[i].name == 'Voucher Tag' then
                G.GAME.tags[i]:apply_to_run({type = 'voucher_add'})
              end
            end
          end
          
          return true
        end)
      }))
      return {
        message = localize('rainydays_plus') .. card.ability.extra.amount .. ' ' .. localize{ type = 'name_text', set = 'Tag', key = card.ability.extra.tag },
        colour = G.C.FILTER
      }
    end
  end
}