local jd_def = JokerDisplay.Definitions

jd_def["j_RainyDays_bankaccount"] = {
  text = {
    { text = "+" },
    { ref_table = "card.ability", ref_value = "plus_chips", retrigger_type = "mult" }
  },
  text_config = { colour = G.C.CHIPS }
}

jd_def["j_RainyDays_burdenofgreatness"] = {}

jd_def["j_RainyDays_cleanslate"] = {
  text = {
    { text = "+" },
    { ref_table = "card.ability", ref_value = "plus_mult", retrigger_type = "mult" }
  },
  text_config = { colour = G.C.MULT }
}

jd_def["j_RainyDays_cloverfield"] = {
  text = {
    { text = "+" },
    { ref_table = "card.ability", ref_value = "current_mult", retrigger_type = "mult" }
  },
  text_config = { colour = G.C.MULT },
  reminder_text = {
    { text = "(" },
    { ref_table = "card.ability", ref_value = "discarded_counter" },
    { text = "/" },
    { ref_table = "card.ability", ref_value = "per_discarded" },
    { text = ")" }
  }
}

jd_def["j_RainyDays_feather_precious"] = {
  text = {
    { text = "+$" },
    { ref_table = "card.joker_display_values", ref_value = "money" },
  },
  text_config = { colour = G.C.GOLD },
  calc_function = function(card)
    card.joker_display_values.money = card.ability.plus_money * GetFeatherCount()
  end
}

jd_def["j_RainyDays_feather_silky"] = {
  text = {
    { text = "+" },
    { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" },
  },
  text_config = { colour = G.C.MULT },
  calc_function = function(card)
    card.joker_display_values.mult = card.ability.plus_mult * GetFeatherCount()
  end
}

jd_def["j_RainyDays_feather_vibrant"] = {
  text = {
    { text = "+" },
    { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult" },
  },
  text_config = { colour = G.C.CHIPS },
  calc_function = function(card)
    card.joker_display_values.chips = card.ability.plus_chips * GetFeatherCount()
  end
}

jd_def["j_RainyDays_flipflop"] = {
  text = {
    {
      border_nodes = {
        { text = "X" },
        { ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp" }
      }
    },
    { text = " +", colour = G.C.CHIPS },
    { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult", colour = G.C.CHIPS }
  },
  calc_function = function(card)
    card.joker_display_values.xmult = (card.ability.state == 0) and card.ability.plus_xmult or 1
    card.joker_display_values.chips = (card.ability.state == 1) and card.ability.plus_chips or 0
  end
}

jd_def["j_RainyDays_heirloom"] = {}

jd_def["j_RainyDays_kintsugi"] = {}

jd_def["j_RainyDays_lotteryticket"] = {
  text = {
    { text = "+$" },
    { ref_table = "card.ability", ref_value = "reward_money", retrigger_type = "mult" }
  },
  text_config = { colour = G.C.GOLD },
  reminder_text = {
    { text = "(" },
    { ref_table = "G.GAME.current_round", ref_value = "RD_lotteryticket_string" },
    { text = ")" }
  }
}

jd_def["j_RainyDays_microwave"] = {
  text = {
    { text = "+" },
    { ref_table = "card.ability", ref_value = "plus_mult", retrigger_type = "mult" },
    { text = "/+" },
    { ref_table = "card.ability", ref_value = "plus_mult_border" }
  },
  text_config = { colour = G.C.MULT }
}

jd_def["j_RainyDays_sediment"] = {
  text = {
    {
      border_nodes = {
        { text = "X" },
        { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" }
      }
    }
  },
  calc_function = function(card)
    card.joker_display_values.Xmult = 1
    if #G.playing_cards - G.GAME.starting_deck_size >= card.ability.card_threshold then
      card.joker_display_values.Xmult = card.ability.plus_xmult
    end
  end
}

jd_def["j_RainyDays_truffle"] = {
  text = {
    { text = "(" },
    { ref_table = "card.ability", ref_value = "amount" },
    { text = "/" },
    { ref_table = "card.ability", ref_value = "amount_total" },
    { text = ")" }
  },
  text_config = { colour = G.C.FILTER }
}

jd_def["j_RainyDays_waste_not"] = {}