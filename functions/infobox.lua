function RainyDays.create_infobox_list(box_name, contents, key)
  key = key or 'rd_list_infobox'
  G.localization.descriptions['Other'][key] = G.localization.descriptions['Other'][key] or {}
  G.localization.descriptions['Other'][key].name = box_name
  G.localization.descriptions['Other'][key].text = {}
  G.localization.descriptions['Other'][key].name_parsed = {{{}}}
  G.localization.descriptions['Other'][key].name_parsed[1][1].strings = { box_name }
  G.localization.descriptions['Other'][key].name_parsed[1][1].control = {}
  G.localization.descriptions['Other'][key].text_parsed = {}
  
  if #contents <= 0 then
    contents[1] = localize('k_none')
  end
  
  for i = 1, #contents do
    G.localization.descriptions['Other'][key].text[i] = contents[i]
    G.localization.descriptions['Other'][key].text_parsed[i] = {{ strings = { contents[i] }, control = {} }}
  end
  
  return key
end