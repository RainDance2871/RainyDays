function RainyDays.folder_get_filenames(folder)
  local filenames = SMODS.NFS.getDirectoryItems(RainyDays.path .. folder)
  for i = 1, #filenames do
    filenames[i] = string.gsub(filenames[i], '.lua', '')
  end
  return filenames
end

function RainyDays.unlock_all_in_folder(folder, prefix)
  for key, value in pairs(G.P_CENTERS) do
    local key_part = prefix .. 'RainyDays_'
    local len = string.len(key_part)
    if string.sub(key, 1, len) == key_part and value then
      value.unlocked = true
    end
  end
  
  play_sound('highlight1', nil, 0.5)
  play_sound('foil2', 0.5, 0.4)
end

function RainyDays.discover_all_in_folder(folder, prefix)
  for key, value in pairs(G.P_CENTERS) do
    local key_part = prefix .. 'RainyDays_'
    local len = string.len(key_part)
    if string.sub(key, 1, len) == key_part and value and value.unlocked then
      value.discovered = true
    end
  end
  
  play_sound('highlight1', nil, 0.5)
  play_sound('foil2', 0.5, 0.4)
end

function G.FUNCS.rainydays_unlock_all()
  RainyDays.unlock_all_in_folder('jokers_unlockable', 'j_')
end

function G.FUNCS.rainydays_discover_all()
  RainyDays.discover_all_in_folder('jokers', 'j_')
  RainyDays.discover_all_in_folder('jokers_unlockable', 'j_')
end

function G.FUNCS.cycle_options(args)
    args = args or {}
    if args.cycle_config and args.cycle_config.ref_table and args.cycle_config.ref_value then
      args.cycle_config.ref_table[args.cycle_config.ref_value] = args.to_key
    end
end

RainyDays.config_tab = function()
  return {
    n = G.UIT.ROOT,
    config = { align = 'cm', padding = 0.05, emboss = 0.05, r = 0.1, colour = G.C.CLEAR },
    nodes = {{
      n = G.UIT.R,
      config = { align = 'cm', padding = 0.2 },
      nodes = {
        create_toggle({
          label = localize('rainydays_include_feathers'),
          info = { localize('rainydays_requires_restart') },
          ref_table = RainyDays.config,
          ref_value = 'feathers'
        })
      }
    }, {
      n = G.UIT.R,
      config = { align = 'cm', padding = 0 },
      nodes = {
        create_option_cycle({ -- 1 both, 2 icons, 3 lists, 4 neither
          w = 7,
          info = localize('rainydays_clarifiers_info'),
          options = localize('rainydays_clarifiers_options'),
          current_option = RainyDays.config.clarifiers,
          colour = G.C.RED,
          text_scale = 0.5,
          ref_table = RainyDays.config,
          ref_value = 'clarifiers',
          opt_callback = 'cycle_options'
        }),
        create_toggle({
          label = localize('rainydays_include_satellite'),
          info = { localize('rainydays_requires_restart') },
          ref_table = RainyDays.config,
          ref_value = 'satellite'
        })
      }
    }, {
      n = G.UIT.R,
      config = { align = 'cm', padding = 0.2 },
      nodes = {
        create_toggle({
          label = localize('rainydays_show_metallic_highlights'),
          info = localize('rainydays_metallic_highlight_info'),
          ref_table = RainyDays.config,
          ref_value = 'metallic_hightlights'
        })
      }
    }, {
      n = G.UIT.R,
      config = { align = 'cm', padding = 0 },
      nodes = {{
        n = G.UIT.C,
        config = { align = 'cm', padding = 0.2 },
        nodes = {
          UIBox_button({
            label = { localize('rainydays_unlock_all') },
            button = 'rainydays_unlock_all',
            col = true
          }),
          UIBox_button({
            label = { localize('rainydays_discover_all') },
            button = 'rainydays_discover_all',
            col = true,
            colour = G.C.BLUE
          })
        }
      }}
    }}
  }
end