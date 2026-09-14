function RainyDays.folder_get_filenames(folder)
  local filenames = SMODS.NFS.getDirectoryItems(RainyDays.path .. folder)
  for i = 1, #filenames do
    filenames[i] = string.gsub(filenames[i], '.lua', '')
  end
  return filenames
end

function RainyDays.unlock_all_in_folder(folder, prefix)
  local foldernames = RainyDays.folder_get_filenames(folder)
  for i = 1, #foldernames do
    local card = G.P_CENTERS[prefix .. 'RainyDays_' .. foldernames[i]]
    if card then
      card.unlocked = true
    end
  end
end

function RainyDays.discover_all_in_folder(folder, prefix)
  local foldernames = RainyDays.folder_get_filenames(folder)
  for i = 1, #foldernames do
    local card = G.P_CENTERS[prefix .. 'RainyDays_' .. foldernames[i]]
    if card and card.unlocked then
      discover_card(card)
    end
  end
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
    config = {
      align = 'cm',
      padding = 0.05,
      emboss = 0.05,
      r = 0.1,
      colour = G.C.CLEAR
    },
    nodes = {
      {
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
        config = { align = 'cm', padding = 0.2 },
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
        config = { align = 'cm', padding = 0.2 },
        nodes = {
          UIBox_button({
            label = { localize('rainydays_unlock_all') },
            button = 'rainydays_unlock_all'
          })
        }
      }, {
        n = G.UIT.R,
        config = { align = 'cm', padding = 0.2 },
        nodes = {
          UIBox_button({
            label = { localize('rainydays_discover_all') },
            button = 'rainydays_discover_all'
          })
        }
      }
    }
  }
end