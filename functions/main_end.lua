function generate_main_end(text, colour)
  return {{
    n = G.UIT.C,
    config = { align = "bm", minh =  0.02 },
    nodes = {{
      n = G.UIT.C,
      config = {
        ref_table = card, 
        align = "m", 
        colour = colour,
        r = 0.05, 
        padding = 0.05 
      },
      nodes = {{ 
        n = G.UIT.T, 
        config = { 
          text = ' ' .. text .. ' ',
          colour = G.C.UI.TEXT_LIGHT, 
          scale = 0.3, 
          shadow = true 
        }
      }}
    }}
  }}
end

function main_end_string(string, length)
  local string_parts = splitString(string, length)
  local nodes = {}
  for i = 1, #string_parts do
    nodes[#nodes + 1] = {
      n = G.UIT.R, 
      config = { align = "cm" },
      nodes = {{
        n = G.UIT.T,
        config = {
          text = string_parts[i],
          colour = G.C.UI.TEXT_INACTIVE,
          scale = 0.3,
          shadow = false
        }
      }}
    }
  end
  
  return {{
    n = G.UIT.C,
    config = { align = "bm", minh =  0.02 },
    nodes = nodes
  }}
end