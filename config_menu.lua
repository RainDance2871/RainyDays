local start_constellations

RainyDays.config_tab = function()
  start_constellations = RainyDays.config.constellations
  
  return {
    n = G.UIT.ROOT, 
    config = {
      align = "cm", 
      padding = 0.05, 
      colour = G.C.CLEAR
    },
    
    nodes = {
      create_toggle({
        label = localize('rainydays_include_constellations'),
        info = { localize('rainydays_requires_restart') },
        ref_table = RainyDays.config,
        ref_value = 'constellations'
      })
    }
  }
end

local old_func_exit = G.FUNCS.exit_mods
G.FUNCS.exit_mods = function(e)
  if start_constellations ~= RainyDays.config.constellations then
    SMODS.full_restart = 1
  end
  return old_func_exit(e)
end