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

-- Fonction pour supprimer un fichier avec gestion des erreurs
local function supprimerFichier(chemin)
    if fs.exists(chemin) then
        local success, err = pcall(fs.delete, chemin)
        if success then
            print("Suppression de l'ancien fichier " .. chemin)
        else
            print("Erreur lors de la suppression de " .. chemin .. ": " .. tostring(err))
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
    print("Téléchargement de " .. fichier.cheminGitHub .. "...")
    local contenu, erreur = http.get(cheminGitHub)

    if contenu then
        print("Téléchargement de " .. fichier.cheminGitHub .. " réussi.")

        -- Enregistre le contenu téléchargé localement
        local programme = fs.open(fichier.cheminLocal, "w")
        if programme then
            programme.write(contenu.readAll())
            programme.close()
            print("Mise à jour du fichier " .. fichier.cheminLocal)
        else
            print("Erreur lors de l'écriture du fichier " .. fichier.cheminLocal)
        end
    else
        print("Échec du téléchargement de " .. fichier.cheminGitHub .. ": " .. tostring(erreur))
    end
end

-- Affiche un message de mise à jour terminée
print("== Mise à jour terminée ==")
print("Redémarrage en cours...")
os.sleep(8)  -- Attendez un instant pour afficher le message
os.reboot()  -- Redémarre l'ordinateur de manière propre
