-- Serveur (Computer1)
-- Assurez-vous d'avoir activé Rednet sur le serveur.

local modemSide = "top" -- Cote du modem
local serverID = os.getComputerID() -- ID de l'ordinateur serveur
local redstoneSide = "back" -- Cote de la sortie Redstone
local isLightOn = false -- Etat actuel des lumieres

-- Afficher l'ID de l'ordinateur serveur
print("ID de l'ordinateur serveur : " .. serverID)

-- Ouvrir le modem sur le cote specifie
rednet.open(modemSide)

-- Demander à l'utilisateur de saisir l'ID du client
print("Entrez l'ID de l'ordinateur client : ")
local clientID = tonumber(read())

-- Fonction pour inverser l'etat des lumieres
local function inverserEtat()
  isLightOn = not isLightOn
  redstone.setOutput(redstoneSide, isLightOn)

  -- Envoyer un message au client pour informer de la modification
  rednet.send(clientID, isLightOn, "etatLumieres")
end

-- Fonction pour afficher l'etat actuel des lumieres
local function afficherVoyant()
  term.setBackgroundColor(colors.white) -- Fond blanc
  term.setTextColor(colors.black) -- Texte en noir
  term.clear()
  term.setCursorPos(1, 1)
  print("                  == Serveur ==")
  term.setCursorPos(1, 3)
  print("Attente des commandes...")

  -- Affichage du voyant
  local voyantTexte = isLightOn and "  Allume  " or "  Eteint  "
  local voyantCouleur = isLightOn and colors.lime or colors.red
  term.setCursorPos((term.getSize() - #voyantTexte) / 2, 6)
  term.setBackgroundColor(voyantCouleur)
  term.setTextColor(colors.white)
  print(voyantTexte)
  term.setBackgroundColor(colors.black)
  term.setTextColor(colors.white)
end

-- Afficher le voyant initial
afficherVoyant()

while true do
  local senderID, message, protocol = rednet.receive(serverID)

  if protocol == "inverser" then
    inverserEtat()
    afficherVoyant() -- Mettre a jour l'affichage du voyant

    -- Envoyer l'etat actuel des lumieres au client
    rednet.send(clientID, isLightOn, "etatLumieres")
  end
end
