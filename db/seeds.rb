require 'rubygems'
require 'httparty'
require 'csv'

resp = HTTParty.get('https://fantasy.premierleague.com/api/bootstrap-static/'); nil
teams = JSON.parse(resp.body)['teams']; nil
players = JSON.parse(resp.body)['elements']; nil

# league
League.create!(
  :season => '2019/2020',
  :name => 'FLONX',
)

# admin user
# User.create!(
#   :name => 'Xavier Lacey',
#   :email => 'xavlacey@gmail.com',
#   :initials => 'XL',
#   :password => 'cookie123',
#   :password_confirmation => 'cookie123',
#   :admin => true,
#   :activated => true,
#   :activated_at => Time.zone.now,
# )

# premier league teams
teams.each do |team|
  name = team['name']
  short_name = team['short_name']
  PremierLeagueTeam.create!(
    :name => name,
    :short_name => short_name,
  )
end

def position(type)
  # 40 GK, 220 DEF, 220 MID, 120 STR
  if type == 1
    'GK'
  elsif type == 2
    'DEF'
  elsif type == 3
    'MID'
  else
    'FWD'
  end
end

# users
names = [
  'Alex Dyzenhaus',
  'Adam Davies',
  'Arnaud Lacey',
  'Chris Taylor',
  'Darrelle Wood',
  'Graeme M',
  'Hannah Taylor',
  'Joe Kelly',
  'James Thornton',
  'Kate Wyatt',
  'Nathaniel Melman',
  'Phil Buckingham',
  'Philippe Lacey',
  'Xavier Lacey',
]
initials = %w[AD AD2 AL CT DW GM HT JK JT KW NM PB PL XL]
emails = %w[
  dyzenhaus@gmail.com
  adamd@xx.com
  arnaudlacey@gmail.com
  christr08@gmail.com
  Darrellewood@outlook.com
  gm@xx.com
  htaylor6406@gmail.com
  joe1kelly37@hotmail.co.uk
  Jamesthornton1@live.co.uk
  k.wyatt@live.com
  nathanielmelman@gmail.com
  Philip.buckingham@hotmail.com
  philippe.lacey@ad-esse.com
  xavlacey@gmail.com
]
teams = [
  'Your Sessegnon Fire',
  'F.C. Lloris Academy 4',
  'Chamakh My Pitch Up United',
  'Real Joeissobad',
  'Aaaaaaaa FC',
  'Hakuna JuanMata FC',
  'Knowing Mee, Knowing Giroud (Zaha) FC',
  'Pun Basedonmyinitials FC',
  'Lupus Non Mordet Lupum AFC',
  'Borussalah VfL 1992 Mönchenxavbach e.V.',
]

teams = [
  'The Season is Cancelloed',
  'Emerson, Ake and Palmer FC',
  'Expected Tolouse',
  'Sterling Albion',
  "Ndombele's Going to Get Ya",
  'Hakuna JuanMata FC',
  'aubaNMe-wang',
  "Uh Oh! Look Out! It's Team PB! FC",
  'Neves Say Dijk',
  'Borussegnon 1992 Mönchenxavbach',
  'Police El Mohamady',
  'AL Team',
  'Lost Leroy y las Cebollas',
  'Names of the Game',
]

emails.count.times do |n|
  email = "#{initials[n].downcase}@xfl.com"
  password = 'password'
  User.create!(
    :name => names[n],
    :email => email,
    :initials => initials[n],
    :password => password,
    :password_confirmation => password,
    :activated => true,
    :activated_at => Time.zone.now,
    :admin => initials[n] == 'XL',
  )
end

# teams
emails.count.times do |n|
  Team.create!(
    :name => teams[n],
    :league_id => 1,
    :user_id => n + 1,
    :properties => {:wins => 0, :losses => 0, :draws => 0, :matches_within_five_points => 0, :top_weekly => 0, :bottom_weekly => 0, :over_sixty => 0},
    :gameweek_scores => {1 => 0 },
  )
end

# matches for a ten-league team
# every team plays every other team four times
# then the final two weeks are 1v2, 3v4, etc. with two legs

csv_text = File.read(Rails.root.join('lib', 'seeds', 'fixtures.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')

csv.each do |fixture|
  Match.create!(
    :league_id => 1,
    :gameweek => fixture['gameweek'],
    :home_team_id => fixture['home_team_id'],
    :away_team_id => fixture['away_team_id'],
  )
end

def playing_chancer(status, news)
  if status == "a"
    return "_100"
  elsif status == "i" || status =="u" || status == "s" || status == "n"
    return "_0"
  else 
    return "_" << news.gsub(/[^0-9]/, '')
  end
end

# players
players.each do |player|
  flonx_player = Player.where(id: player['id'])
  next unless flonx_player.empty?

  surname = player['web_name']
  full_name = "#{player['first_name']} #{player['second_name']}"
  position = position(player['element_type'])
  picture = player['photo'].tr('.jpg','')
  status = player['status']
  news = player['news']
  chance_of_playing = playing_chancer(status, news)

  # Get specific player url
  url = "https://fantasy.premierleague.com/api/element-summary/#{player['id'].to_s}/"
  response = HTTParty.get(url)
  next unless response.ok?

  player_match_history = JSON.parse(response.body)['history']
  gameweek_history = {}

  player_match_history.each do |m|
    current_score = gameweek_history[m['round']] || 0
    gameweek_history[m['round']] = m['total_points'] += current_score
  end

  Player.create!(
    :id => player['id'],
    :full_name => full_name,
    :common_name => surname,
    :position => position,
    :premier_league_team_id => player['team'],
    :picture => picture,
    :gameweek_points => { 1 => 0 },
    :status => status,
    :news => news,
    :chance_of_playing => chance_of_playing
  )

  puts "done #{full_name}" if (player['id'].to_i % 50).zero?
end

# player team relationships
starting_team_relationships = {
  '1' => [93, 141, 401, 182, 518, 192, 431, 151, 217, 67, 409], # AD1
  '2' => [111, 122, 274, 309, 358, 321, 463, 119, 154, 210, 363], # CT
  '3' => [212, 123, 104, 486, 343, 171, 138, 369, 31, 12, 91], # DW
  '4' => [388, 161, 108, 459, 143, 214, 354, 399, 17, 523, 496], # JK
  '5' => [235, 185, 181, 103, 184, 207, 113, 29, 346, 114, 166], # JT
  '6' => [262, 206, 337, 144, 28, 265, 390, 292, 187, 36, 68], # KW
  '7' => [14, 202, 203, 515, 226, 193, 15, 215, 239, 457, 11], # NM
  '8' => [189, 252, 3, 159, 191, 266, 320, 368, 90, 466, 460], # PB
  '9' => [366, 183, 332, 186, 218, 116, 220, 414, 415, 487, 167], # PL
  '10' => [198, 331, 106, 405, 344, 176, 199, 219, 278, 211, 437], # XL
  '11' => [94, 182, 381, 258, 325, 442, 488, 525,283, 338, 428], # AD2
  '12' => [340, 105, 2, 160, 150, 238, 342, 134, 133, 188, 313], # AL
  '13' => [411, 330, 179, 59, 75, 448, 392, 469, 50, 233, 44], # GM
  '14' => [168, 42, 163, 39, 10, 24, 393, 244, 347, 365, 175], # HT
}

captains = [192, 210, 31, 214, 181, 187, 11, 191, 183, 219, 338, 342, 233, 393]

starting_team_relationships.each do |team_id, player_ids|
  player_ids.each do |player_id|
    puts "team_id #{team_id}, player_id #{player_id}"
    PlayerTeamRelationship.create!(
      :player_id => player_id,
      :team_id => team_id,
      :gameweek_in => 1,
      :gameweek_out => nil,
      :captain => captains.include?(player_id),
    )
  end
end
