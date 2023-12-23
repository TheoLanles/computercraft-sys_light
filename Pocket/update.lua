local backgroundColor = colors.white
local textColor = colors.black


  term.setBackgroundColor(backgroundColor) -- Fond modifier
  term.clear()
  term.setCursorPos(1, 1)
  term.setTextColor(textColor)

-- Spécifiez l'utilisateur, le référentiel et la liste des fichiers sur GitHub
local utilisateur = "TheoLanles"
local repo = "computercraft-sys_light"
local fichiers = {
    { cheminGitHub = "Pocket/boot.lua", cheminLocal = "/boot.lua" },
    { cheminGitHub = "Pocket/startup.lua.lua", cheminLocal = "/startup.lua" },
    { cheminGitHub = "Pocket/client.lua", cheminLocal = "/client.lua" },
    { cheminGitHub = "Pocket/config.lua", cheminLocal = "/config.lua" },
    --{ cheminGitHub = "Pocket/update.lua", cheminLocal = "/update.lua" },
    -- Ajoutez autant de fichiers que nécessaire
}

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

        -- Exécute le code du programme
        --local success, err = pcall(dofile, fichier.cheminLocal)
       -- if not success then
        --    print("Erreur lors de l'exécution de " .. fichier.cheminLocal .. ": " .. err)
        --end
    else
  --      print("Échec du téléchargement de " .. fichier.cheminGitHub .. ": " .. (erreur or "Erreur inconnue"))
   -- end
end

print("== Mise a jour terminée ==")
print("Redémarrage en cours...")
os.sleep(5)  -- Attendez un instant pour afficher le message
shell.run("reboot")
