function folder_get_filenames(folder, remove_start_code)
  local filenames = NFS.getDirectoryItems(RainyDays.path .. folder)
  for i = 1, #filenames do
    filenames[i] = string.gsub(filenames[i], '.lua', '')
    if remove_start_code then
      filenames[i] = string.sub(filenames[i], 4, -1)
    end
  end
  return filenames
end

function discover_all_in_folder(folder, prefix, remove_start_code)
  local foldernames = folder_get_filenames(folder, remove_start_code)
  for i = 1, #foldernames do
    local card = G.P_CENTERS[prefix .. 'RainyDays_' .. foldernames[i]]
    if card then
      discover_card(card)
    end
  end
end

function G.FUNCS.rainydays_discover_all()
  discover_all_in_folder('jokers', 'j_')
  discover_all_in_folder('jokers_unlockable', 'j_')
  discover_all_in_folder('spectrals', 'c_')
  discover_all_in_folder('constellations', 'c_', true)
end

function G.FUNCS.rainydays_unlock_all()
  local foldernames = folder_get_filenames('jokers_unlockable')
  for i = 1, #foldernames do
    local card = G.P_CENTERS['j_RainyDays_' .. foldernames[i]]
    if card then
      unlock_card(card)
    end
  end
end

RainyDays.config_tab = function()
  return {
    n = G.UIT.ROOT, 
    config = {
      align = 'cm', 
      padding = 0.1, 
      colour = G.C.CLEAR
    },
    
    nodes = {
      create_toggle({
        label = localize('rainydays_include_feathers'),
        info = { localize('rainydays_requires_restart') },
        ref_table = RainyDays.config,
        ref_value = 'feathers'
      }),
      create_toggle({
        label = localize('rainydays_include_constellations'),
        info = { localize('rainydays_requires_restart') },
        ref_table = RainyDays.config,
        ref_value = 'constellations'
      }),
      UIBox_button({
        label = { localize('rainydays_unlock_all') },
        button = 'rainydays_unlock_all'
      }),
      UIBox_button({
        label = { localize('rainydays_discover_all') },
        button = 'rainydays_discover_all'
      })
    }
  }
end