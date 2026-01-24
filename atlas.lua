SMODS.Atlas {
  key = 'Jokers',
  path = 'Jokers.png',
  px = 71,
  py = 95 
}

local JokerAtlasKeys = {
  'burdenofgreatness',
  'slashed_joker',
  'slashed_joker_soul',
  'feather_precious',
  'feather_silky',
  
  'feather_vibrant',
  'sediment',
  'heirloom',
  'waveform',
  'lotteryticket',
  
  'burdenofgreatness_soul',
  'bankaccount',
  'truffle',
  'cleanslate',
  'recycle',
  
  'flipflop_odd',
  'flipflop_even',
  'fabergeegg',
  'sextant',
  'hannysvoorwerp',
  
  'sputnik',
  'breakfast_cereal',
  'atom',
  'lady_of_the_lake',
  'kudzu',
  
  'cloverfield',
  'feather_marvelous',
  'feather_energetic',
  'legions',
  'grapes',
  
  'fabergeegg_soul',
  'star_chart',
  'delirium_alt0',
  'skinner_box',
  'lady_of_the_lake_soul',
  
  'waveform_soul',
  'star_chart_soul',
  'delirium_alt1',
  'delirium_alt2',
  'delirium_alt3',
  
  'purple_card',
  'klondike',
  'klondike_soul',
  'long_road',
  'lady_in_waiting'
}

local JokerAtlasTable = {}
for i, key in ipairs(JokerAtlasKeys) do
  JokerAtlasTable[key] = i - 1
end
JokerAtlasKeys = nil

function GetJokersAtlasTable(key)
  local pos = JokerAtlasTable[key]
  return { x = pos % 5, y = math.floor(pos / 5) }
end

SMODS.Atlas {
  key = 'Constellations',
  path = 'Constellations.png',
  px = 65,
  py = 95
}

local ConstellationAtlasKeys = {
  'aries',
  'taurus',
  'gemini',
  'cancer',
  'leo',
  'virgo',
  
  'libra',
  'scorpio',
  'sagittarius',
  'capricorn',
  'aquarius',
  'pisces',
  
  'pegasus',
  'cetus',
  'ophiuchus',
  'orion',
  'vulpecula',
  'chamaeleon'
}

local ConstellationAtlasTable = {}
for i, key in ipairs(ConstellationAtlasKeys) do
  ConstellationAtlasTable[key] = i - 1
end
ConstellationAtlasKeys = nil

function GetConstellationAtlasTable(key)
  local pos = ConstellationAtlasTable[key]
  return { x = pos % 6, y = math.floor(pos / 6) }
end

SMODS.Atlas {
  key = 'Enhancements',
  path = 'Enhancements.png',
  px = 71,
  py = 95 
}

local EnhancementAtlasKeys = {
  'junk0',
  'junk1',
  'junk2',
  'junk3',
  
  'clay',
  'plastic',
  'wood',
}

local EnhancementAtlasTable = {}
for i, key in ipairs(EnhancementAtlasKeys) do
  EnhancementAtlasTable[key] = i - 1
end
EnhancementAtlasKeys = nil

function GetEnhancementAtlasTable(key)
  local pos = EnhancementAtlasTable[key]
  return { x = pos % 4, y = math.floor(pos / 4) }
end

SMODS.Atlas {
  key = 'Seals',
  path = 'Seals.png',
  px = 71,
  py = 95
}

SMODS.Atlas {
  key = 'Spectrals',
  path = 'Spectrals.png',
  px = 71,
  py = 95 
}