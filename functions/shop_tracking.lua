--see also lua injects

local toggle_shop_ref = G.FUNCS.toggle_shop
function G.FUNCS.toggle_shop(e)
  toggle_shop_ref(e)
  if not G.GAME.rd_money_spent_this_shop or G.GAME.rd_money_spent_this_shop <= 0 then
    G.GAME.rd_no_spend_shop = (G.GAME.rd_no_spend_shop or 0) + 1
  end
  G.GAME.rd_money_spent_this_shop = nil
end

local inc_career_stat_ref = inc_career_stat
function inc_career_stat(stat, mod)
  if stat == 'c_shop_dollars_spent' and mod > 0 then
    G.GAME.rd_money_spent_shops = (G.GAME.rd_money_spent_shops or 0) + mod
    G.GAME.rd_money_spent_this_shop = (G.GAME.rd_money_spent_this_shop or 0) + mod
  end
  return inc_career_stat_ref(stat, mod)
end