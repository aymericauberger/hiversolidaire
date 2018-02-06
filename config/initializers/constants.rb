module Constants
  PAROISSE = ENV['APP_NAME'] == 'Saint-Jacques du Haut-Pas' ? 'SJDHP' : 'SGP'
  DINER_PLATS = if ENV['PETIT_DINER'] == 'true'
                  ['Plat principal', 'Entrée + Dessert', 'Pain + Fromage']
                else
                  ['Entrée', 'Plat principal', 'Dessert', 'Pain + Fromage']
                end
  DINER_REQUIRED_NUMBER = ENV['PETIT_DINER'] == 'true' ? 2 : 4
  START_DATE = if PAROISSE == 'SJDHP'
                 Date.new(2018, 1, 5)
               else
                 Date.new(2017, 12, 17)
               end
  END_DATE = if PAROISSE == 'SJDHP'
               Date.new(2018, 3, 15)
             else
               Date.new(2018, 3, 18)
             end
end
