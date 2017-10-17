module Constants
  DINER_PLATS = if ENV['PETIT_DINER'] == 'true'
                  ['Plat principal', 'Entrée + Dessert', 'Pain + Fromage']
                else
                  ['Entrée', 'Plat principal', 'Dessert', 'Pain + Fromage']
                end
  DINER_REQUIRED_NUMBER = ENV['PETIT_DINER'] == 'true' ? 2 : 4
end
