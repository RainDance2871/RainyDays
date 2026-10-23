local old_func_create_card = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)  
  local ret = old_func_create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
  local rd_effects = {}
  SMODS.calculate_context({ rd_transform_encountered_card = true, created_card = ret }, rd_effects)
  SMODS.trigger_effects(rd_effects)
  
  if not ret.rd_transformed and ret.ability.set == 'Joker' and RainyDays.config.feathers and RainyDays.FeatherOwned() then
    local absent_feathers = RainyDays.GetAbsentFeathers(ret.config.center.rarity)
    if absent_feathers and #absent_feathers > 0 and pseudorandom('feathers') <= #absent_feathers / RainyDays.feather_rate then
      local feather_key = pseudorandom_element(absent_feathers, pseudoseed('Feathers' .. G.GAME.round_resets.ante))
      ret:set_ability(feather_key, true)
      ret:set_cost()
    end
  end
  
  ret.rd_transformed = nil
  return ret
end