SMODS.Atlas {
    key = 'RainyDays',
    path = 'RainyDays.png',
    px = 71, --width of one card
    py = 95 -- height of one card
}

local RainyDaysAtlasKeys = {
  'burdenofgreatness',
  'cloverfield',
  'flipflop_even',
  'feather_precious',
  'feather_silky',
  
  'feather_vibrant',
  'sediment',
  'heirloom',
  'kintsugi',
  'lotteryticket',
  
  'microwave',
  'bankaccount',
  'truffle',
  'cleanslate',
  'waste_not',
  
  'flipflop_odd',
  'kintsugi_vase',
  'fabergeegg',
  'junkdrawer'
}

local RainyDaysAtlasTable = {}
for i, key in ipairs(RainyDaysAtlasKeys) do
    RainyDaysAtlasTable[key] = i - 1
end
RainyDaysAtlasKeys = nil

function GetRainyDaysAtlasTable(key)
  local pos = RainyDaysAtlasTable[key]
  return { x = pos % 5, y = math.floor(pos / 5) }
end