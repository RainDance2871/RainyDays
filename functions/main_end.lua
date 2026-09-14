function RainyDays.generate_main_end_counter(text)
  return {
    { n = G.UIT.T, config = { text = '[', colour = G.C.UI.TEXT_INACTIVE, scale = 0.32 }},
    { n = G.UIT.T, config = { text = text, colour = G.C.UI.TEXT_INACTIVE, scale = 0.32 }},
    { n = G.UIT.T, config = { text = ']', colour = G.C.UI.TEXT_INACTIVE, scale = 0.32 }}
  }
end