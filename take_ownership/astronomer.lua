local set_cost_ref = Card.set_cost
function Card:set_cost()
  local ret = set_cost_ref(self)
  if RainyDays.config.constellations and self.ability.set == 'Constellation' and next(SMODS.find_card('j_astronomer')) then
    self.cost = 0
  end
  return ret
end