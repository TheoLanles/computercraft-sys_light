local backgroundColor = colors.white
local textColor = colors.black

term.setBackgroundColor(backgroundColor)
term.clear()
term.setCursorPos(1, 1)
term.setTextColor(textColor)

local utilisateur = "TheoLanles"
local repo = "computercraft-sys_light"
local fichiers = {
    { cheminGitHub = "Pocket/boot.lua", cheminLocal = "/boot.lua" },
    { cheminGitHub = "Pocket/startup.lua", cheminLocal = "/startup.lua" },
    { cheminGitHub = "Pocket/client.lua", cheminLocal = "/client.lua" },
    { cheminGitHub = "Pocket/config.lua", cheminLocal = "/config.lua" },
    -- Ajoutez autant de fichiers que nécessaire
}

local function supprimerFichier(fichier)
  if fs.exists(fichier) then
      local success, err = pcall(fs.delete, fichier)
      if success then
          print("Suppression de l'ancien fichier " .. fichier)
      else
          print("Erreur lors de la suppression de " .. fichier .. ": " .. err)
      end
  end
end

-- Supprime chaque fichier local s'il existe
for _, fichier in ipairs(fichiers) do
  supprimerFichier(fichier.cheminLocal)
end


-- Télécharge chaque fichier depuis GitHub
for _, fichier in ipairs(fichiers) do
    local cheminGitHub = "https://raw.githubusercontent.com/" .. utilisateur .. "/" .. repo .. "/main/" .. fichier.cheminGitHub
    local contenu, erreur = http.get(cheminGitHub)

    if contenu then
        print("Téléchargement de " .. fichier.cheminGitHub .. " réussi.")

        -- Enregistre le contenu téléchargé localement
        local programme = fs.open(fichier.cheminLocal, "w")
        programme.write(contenu.readAll())
        programme.close()
    else
        print("Échec du téléchargement de " .. fichier.cheminGitHub .. ": " .. (erreur or "Erreur inconnue"))
    end
end

-- Affiche un message de mise à jour terminée
print("== Mise à jour terminée ==")
print("Redémarrage en cours...")
os.sleep(3)  -- Attendez un instant pour afficher le message
os.reboot()  -- Redémarre l'ordinateur de manière propre
