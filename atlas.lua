SMODS.Atlas {
  key = 'Jokers',
  path = 'Jokers.png',
  px = 71,
  py = 95 
}

local JokerAtlasKeys = {
  'accountant',
  'atom',
  'balance',
  'bankaccount',
  'breakfast_cereal',
  
  'burdenofgreatness',
  'catalogue',
  'cleanslate',
  'cloverfield',
  'count_orlok',
  
  'delirium_alt0',
  'delirium_alt1',
  'delirium_alt2',
  'delirium_alt3',
  'equity',
  
  'fabergeegg',
  'fabergeegg_soul',
  'feather_marvelous',
  'feather_mystic',
  'feather_precious',
  
  'feather_silky',
  'feather_vibrant',
  'flipflop_even',
  'flipflop_odd',
  'golden_idol',
  
  'grapes',
  'hannysvoorwerp',
  'heirloom',
  'kudzu',
  'lady_in_waiting',
  
  'lady_of_the_lake',
  'lady_of_the_lake_soul',
  'legions',
  'lightning',
  'long_road',
  
  'lotteryticket',
  'overflow',
  'prehistory',
  'purple_card',
  'recycle',
  
  'roller_skates',
  'sextant',
  'skinner_box',  
  'slashed_joker',
  'slashed_joker_soul',
  
  'snow_shovel',
  'sputnik',
  'star_chart',
  'star_chart_soul',
  'theater',
  
  'truffle',
  'waveform',
  'waveform_soul',
  'windowsill'
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
  'ophiuchus',
  'undiscovered'
}

local ConstellationAtlasTable = {}
for i, key in ipairs(ConstellationAtlasKeys) do
  ConstellationAtlasTable[key] = i - 1
end
ConstellationAtlasKeys = nil

function GetConstellationAtlasTable(key)
  local pos = ConstellationAtlasTable[key]
  return { x = pos % 7, y = math.floor(pos / 7) }
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