-- Client (Computer2)
-- Assurez-vous d'avoir activé Rednet sur le client.

local modemSide = "top" -- Côté du modem
local serverID = nil -- ID de l'ordinateur serveur, initialisé à nil
local lumiereAllumee = false -- État actuel des lumières, initialisé à éteint

rednet.open(modemSide) -- Ouvrir le modem sur le côté spécifié

-- Afficher l'ID de l'ordinateur client
print("ID de l'ordinateur client : " .. os.getComputerID())

-- Demander à l'utilisateur de saisir l'ID du serveur
print("Entrez l'ID de l'ordinateur serveur : ")
serverID = tonumber(read())

-- Fonction pour envoyer une commande au serveur
local function envoyerCommande(commande, protocole)
  local success = rednet.send(serverID, commande, protocole)
  if not success then
    term.setTextColor(colors.red)
    print("Erreur lors de l'envoi de la commande.")
    term.setTextColor(colors.black)
  end
end

-- Options du menu
local menu = {
  { text = "Inverser l'etat des lumieres" },
  { text = "Quitter" }
}

local selectedOption = 1

-- Fonction pour afficher le menu de sélection
local function afficherMenu()
  term.setBackgroundColor(colors.white) -- Fond blanc
  term.clear()
  term.setCursorPos(1, 1)
  term.setTextColor(colors.black) -- Texte en noir
  print("            == Contrôle des lumières ==")
  term.setCursorPos(1, 3)

  for i, option in ipairs(menu) do
    if i == selectedOption then
      term.setTextColor(colors.black)
      print("> " .. option.text)
      term.setTextColor(colors.black)
    else
      print("  " .. option.text)
    end
  end

  -- Affichage du voyant
  term.setCursorPos(1, 6)
  term.setBackgroundColor(colors.gray)
  term.setTextColor(colors.white) -- Texte en blanc
  term.write(" Lumieres ")
  term.setTextColor(colors.white) -- Texte en blanc
  term.setBackgroundColor(lumiereAllumee and colors.lime or colors.red)
  term.write("  ") -- Voyant
  term.setBackgroundColor(colors.black)
end

-- Fonction pour gérer la sélection dans le menu
local function selectionMenu()
  while true do
    afficherMenu()
    local event, key = os.pullEvent("key")
    if key == keys.up and selectedOption > 1 then
      selectedOption = selectedOption - 1
    elseif key == keys.down and selectedOption < #menu then
      selectedOption = selectedOption + 1
    elseif key == keys.enter then
      if selectedOption == 1 then
        envoyerCommande("inverser", "inverser")
        -- Mettre à jour l'état des lumières en fonction de l'action
        lumiereAllumee = not lumiereAllumee
      elseif selectedOption == 2 then
        -- Option "Quitter" : redémarrage du système
        shell.run("reboot")
      end
    end
  end
end

-- Fonction pour recevoir et mettre à jour l'état des lumières
local function recevoirEtatLumieres()
  while true do
    local senderID, etat, protocol = rednet.receive("etatLumieres")
    if protocol == "etatLumieres" then
      lumiereAllumee = etat
    end
  end
end

local function main()
  selectionMenu()
end

parallel.waitForAny(recevoirEtatLumieres, main)
