SMODS.Joker {
  key = 'wuxing',
  atlas = 'Jokers',
  rarity = 1,
  cost = 5,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('wuxing'),
  attributes = { 'tag', 'generation', 'rank', 'chance', 'five' },
  
  config = {
    extra = {
      rank = '5',
      amount = 1,
      numerator_in = 1,
      denominator_in = 5,      
    }
  },
  
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = { set = 'Other', key = 'rainydays_tag_edition' }
    
    local editions = { 'e_foil', 'e_holo', 'e_polychrome', 'e_negative' }
    for _, edition in ipairs(editions) do
      if not (card.edition and card.edition.key == edition) then
        info_queue[#info_queue + 1] = G.P_CENTERS[edition]
      end
    end
    
    local numerator_out, denominator_out = SMODS.get_probability_vars(card, card.ability.extra.numerator_in, card.ability.extra.denominator_in) 
    return {
      vars = {
        localize(card.ability.extra.rank, 'ranks'),
        numerator_out,
        denominator_out,
        localize{ type = 'name_text', set = 'Other', key = 'rainydays_tag_edition' }
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and context.other_card:get_id() == RainyDays.balatro_ranks_to_id[card.ability.extra.rank] then
      if not context.other_card.debuff and SMODS.pseudorandom_probability(card, 'wuxing', card.ability.extra.numerator_in, card.ability.extra.denominator_in) then
        local edition = SMODS.poll_edition { key = 'wuxing', guaranteed = true, no_negative = false, options = { 'e_foil', 'e_holo', 'e_polychrome', 'e_negative' }}
        local tag = string.gsub(edition, 'e_', 'tag_')
        return {
          message = localize('rainydays_plus') .. card.ability.extra.amount .. ' ' .. localize{ type = 'name_text', set = 'Tag', key = tag },
          colour = G.C.DARK_EDITION,
          func = function()
            G.E_MANAGER:add_event(Event({
              func = function()
                add_tag(Tag(tag))
                play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                if edition == 'e_foil' then
                  play_sound('foil1', 1.2, 0.4)
                elseif edition == 'e_holo' then
                  play_sound('holo1', 1.896, 0.4)
                elseif edition == 'e_polychrome' then
                  play_sound('polychrome1', 1.2, 0.7)
                elseif edition == 'e_negative' then
                  play_sound('negative', 1.5, 0.4)
                end
                return true
              end
            }))
          end
        }
      end
    end
  end
}