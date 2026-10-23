RainyDays.atlas_jokers = SMODS.Atlas {
  key = 'Jokers',
  path = 'Jokers.png',
  px = 71,
  py = 95 
}

local JokerAtlasKeys = {
  'abacus',
  'absent_heart',
  'accountant',
  'album_cover',
  'algebra',
  'atom',
  'avocado',
  'balance',
  'bankaccount',
  'bazaar',
  'beanstalk',
  'bingo_balls',
  'blood_moon',
  'bonsai',
  'breakdance',
  'breakfast_cereal',
  'bud',
  'bud_bloomed',
  'canine',
  'catalogue',
  'catwalk',
  'catwalk_soul',
  'ceremonial_bowl',
  'ceremonial_mask',
  'checklist',
  'cleanslate',
  'cloverfield',
  'collage',
  'conga_line',
  'count_orlok',
  'dancing_moves',
  'dealer',
  'delirium_alt0',
  'delirium_alt1',
  'delirium_alt2',
  'delirium_alt3',
  'desolate',
  'doubling_joker1',
  'doubling_joker2',
  'doubling_joker3',
  'doubling_joker4',
  'doubling_joker5',
  'doubling_joker6',
  'doubling_joker7',
  'doubling_joker8',
  'doubling_joker9',
  'duality',
  'duality_night',
  'early_birds',
  'early_birds_border',
  'equity',
  'fabergeegg',
  'fabergeegg_soul',
  'fan_mail',
  'feather_marvelous',
  'feather_precious',
  'feather_silky',
  'feather_vibrant',
  'five_and_dime',
  'flipflop_even',
  'flipflop_odd',
  'folding_chair',
  'frowny_face',
  'fruit_punch',
  'golden_idol',
  'goldfish',
  'goose',
  'grapes',
  'grey_joker',
  'grindstone',
  'hecate',
  'hecate_soul',
  'heirloom',
  'horseshoe',
  'hubris',
  'instructional',
  'joker_reject',
  'jungle_jack',
  'kimono',
  'kudzu',
  'lady_in_waiting',
  'lady_of_the_lake',
  'lady_of_the_lake_soul',
  'legions',
  'letter_board',
  'lightning',
  'long_road',
  'lotteryticket',
  'membership_card',
  'metropolis',
  'minimalist',
  'mirror_lake',
  'musketeers',
  'orange',
  'origami',
  'overflow',
  'parrot',
  'pigeon',
  'prairie',
  'prehistory',
  'primality',
  'purple_card',
  'quasar',
  'queue_ticket',
  'receipt',
  'recycle',
  'report_card',
  'return_to_sender',
  'roller_skates',
  'satellite',
  'secret_agent',
  'self_assembly',
  'serial',
  'sextant',
  'shooting_star',
  'simple_joker',
  'sketch_pad',
  'skinner_box',
  'slashed_joker',  
  'slashed_joker_soul',
  'snow_shovel',
  'spire',
  'spooky_joker',
  'sputnik',
  'squiggle_joker',
  'star_chart',
  'star_chart_soul',
  'starting_line',
  'tessen',
  'theater',
  'throne_active',
  'throne_inactive',
  'trading_stamps',
  'train_ticket',
  'truffle',
  'wanted',
  'waveform',
  'waveform_soul',
  'whirlpool',
  'windowsill',
  'wishbone',
  'wuxing',
  'xylophone'
}

local JokerAtlasTable = {}
for i, key in ipairs(JokerAtlasKeys) do
  JokerAtlasTable[key] = i - 1
end
JokerAtlasKeys = nil

function RainyDays.GetJokersAtlasTable(key)
  local pos = JokerAtlasTable[key] or 0
  return { x = pos % 10, y = math.floor(pos / 10) }
end

SMODS.Atlas {
  key = 'Wide',
  path = 'Wide.png',
  px = 80,
  py = 95 
}

SMODS.Atlas {
  key = 'Indicators',
  path = 'Indicators.png',
  px = 142,
  py = 190 
}

local IndicatorAtlasKeys = {
  'enhancements',
  'hands',
  'planets',
  'ranks'
}

local IndicatorAtlasTable = {}
for i, key in ipairs(IndicatorAtlasKeys) do
  IndicatorAtlasTable[key] = i - 1
end
IndicatorAtlasKeys = nil

function RainyDays.GetIndicatorsAtlasTable(key)
  local pos = IndicatorAtlasTable[key] or 0
  return { x = pos, y = 0 }
end