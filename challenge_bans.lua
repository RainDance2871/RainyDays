function RainyDays.challenge_add_bans(challenge, bans)
  for i = 1, #bans do
    G.CHALLENGES[challenge].restrictions.banned_cards[#G.CHALLENGES[challenge].restrictions.banned_cards + 1] = { id = 'j_RainyDays_' .. bans[i] }
  end
end

if RainyDays.config.feathers then 
  RainyDays.challenge_add_bans(1, { 'feather_precious' }) --Jokers with payout
end

RainyDays.challenge_add_bans(8, { 'avocado', 'breakfast_cereal', 'dealer', 'grapes', 'orange', 'truffle', 'wishbone' }) --Jokers that can't be eternal
RainyDays.challenge_add_bans(14, { 'lady_in_waiting', 'lady_of_the_lake', 'primality' }) --jokers that add non-glass cards or can turn glass cards into non-glass
RainyDays.challenge_add_bans(16, { 'dealer' }) --Jokers that give extra hands
RainyDays.challenge_add_bans(17, { 'bazaar', 'folding_chair', 'overflow' }) --Joker that increase hand size
RainyDays.challenge_add_bans(18, { 'dealer' }) --Jokers that give extra hands