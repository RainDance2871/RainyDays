local old_func_evaluate_round = G.FUNCS.evaluate_round
function G.FUNCS.evaluate_round()
	local rd_effects = {}
  SMODS.calculate_context({ rd_before_payout = true }, rd_effects)
	SMODS.trigger_effects(rd_effects)
  
  if G.GAME.rd_skip_interest then
    local interest_setting = G.GAME.modifiers.no_interest
    G.GAME.modifiers.no_interest = true
    old_func_evaluate_round()
    G.GAME.modifiers.no_interest = interest_setting
    G.GAME.rd_skip_interest = false
  else 
    old_func_evaluate_round()
  end
  
	rd_effects = {}
  SMODS.calculate_context({ rd_after_payout = true }, rd_effects)
	SMODS.trigger_effects(rd_effects)
end