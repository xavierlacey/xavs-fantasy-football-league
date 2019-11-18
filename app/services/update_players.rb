class UpdatePlayers
    def self.call
      
      resp = HTTParty.get('https://fantasy.premierleague.com/api/bootstrap-static/'); nil
      api_players = JSON.parse(resp.body)['elements']; nil
      
  
      Player.all.each do |player|
        
        api_player = api_players.select{|x| x['id']==player['id']}
          
        status = api_player[0]['status']
        news = api_player[0]['news']
        if status == "a"
          chance_of_playing = "_100"
        elsif status == "i" || status =="u" || status == "s" || status == "n"
          chance_of_playing = "_0"
        else 
          chance_of_playing = "_" << news.gsub(/[^0-9]/, '')
        end
       
        player['status'] = status
        player['news'] = news
        player['chance_of_playing'] = chance_of_playing
  
        player.save!
      end
    end
  

  
  end