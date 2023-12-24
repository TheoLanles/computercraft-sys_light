local nbServeurs = 0
local serverIDs = {}
local lumieresAllumees = {}
local selectedServer = 1
local maxServeurs = 5  -- Définissez le nombre maximal de serveurs à afficher
peripheral.find("modem", rednet.open)

term.clear()
term.setCursorPos(1, 1)

local function demanderNombreServeurs()
  while nbServeurs < 1 or nbServeurs > maxServeurs do
    print("Serveurs a gerer ? (1 a " .. maxServeurs .. ") ")
    nbServeurs = tonumber(read())
  end
end

local function demanderIDsServeurs()
  for i = 1, nbServeurs do
    print("Entrez l'ID du serveur " .. i .. " : ")
    local serverID = tonumber(read())
    table.insert(serverIDs, serverID)
    table.insert(lumieresAllumees, false)
  end
end

local function envoyerCommande(commande, protocole, serverID)
  local success = rednet.send(serverID, commande, protocole)
  if not success then
    term.setTextColor(colors.red)
    print("Erreur lors de l'envoi de la commande au serveur " .. serverID)
    term.setTextColor(colors.black)
  end
end

local menu = {
  { text = "Inverser l'etat lumieres" },
  { text = "Serveur Suivant" },
  { text = "Quitter" }
}

local selectedOption = 1

-- Définir les coordonnées x et y pour les voyants
local voyants = {
  { x = 1, y = 11 },
  { x = 1, y = 13 },
  { x = 1, y = 15 },
  { x = 1, y = 17 },
  { x = 1, y = 19 },
}

local function afficherMenu()
  term.setBackgroundColor(colors.white)
  term.clear()
  term.setCursorPos(1, 1)
  term.setTextColor(colors.black)
  print("  == Controle lumiere ==")
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

  term.setCursorPos(1, 9)
  term.setTextColor(colors.black)
  print("Serveur actuel : " .. selectedServer)
  term.setTextColor(colors.black)
  term.setCursorPos(1, 7)
  print("ID client : " .. os.getComputerID())

  -- Affichage des voyants pour les serveurs actuellement gérés
  for i, voyant in ipairs(voyants) do
    if i <= nbServeurs then
      term.setCursorPos(voyant.x, voyant.y)
      term.setBackgroundColor(colors.gray)
      term.setTextColor(serverIDs[selectedServer] == i and colors.yellow or colors.white)
      term.write(" Serveur " .. i .. " ")
      term.setTextColor(colors.white)
      term.setBackgroundColor(lumieresAllumees[i] and colors.lime or colors.red)
      term.write("  ")
      term.setBackgroundColor(colors.white)
    else
      -- Pour les serveurs inutilisés, placez le voyant en dehors de l'écran
      term.setCursorPos(voyant.x, voyant.y)
      term.write("  ") -- Espace vide pour masquer le voyant
      term.setBackgroundColor(colors.white)
    end
  end
end

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
        envoyerCommande("inverser", "inverser", serverIDs[selectedServer])
        lumieresAllumees[selectedServer] = not lumieresAllumees[selectedServer]
      elseif selectedOption == 2 then
        selectedServer = (selectedServer % nbServeurs) + 1
      elseif selectedOption == 3 then
        shell.run("boot.lua")
      end
    end
  end
end

local function main()
  demanderNombreServeurs()
  demanderIDsServeurs()
  selectionMenu()
end

parallel.waitForAny(main)