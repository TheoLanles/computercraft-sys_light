-- Spécifiez l'utilisateur, le référentiel et la liste des fichiers sur GitHub
local utilisateur = "TheoLanles"
local repo = "computercraft-sys_light"
local fichiers = {
    { cheminGitHub = "/computercraft-sys_light/blob/main/Pocket/boot.lua", cheminLocal = "/boot.lua" },
    { cheminGitHub = "/computercraft-sys_light/blob/main/Pocket/startup.lua.lua", cheminLocal = "/startup.lua" },
    { cheminGitHub = "/computercraft-sys_light/blob/main/Pocket/client.lua", cheminLocal = "/client.lua" },
    { cheminGitHub = "/computercraft-sys_light/blob/main/Pocket/config.lua", cheminLocal = "/config.lua" },
    { cheminGitHub = "/computercraft-sys_light/blob/main/Pocket/update.lua", cheminLocal = "/update.lua" },
    -- Ajoutez autant de fichiers que nécessaire
}

-- Télécharge chaque fichier depuis GitHub
for _, fichier in ipairs(fichiers) do
    if github.downloadFile(utilisateur, repo, fichier.cheminGitHub, fichier.cheminLocal) then
        print("Téléchargement de " .. fichier.cheminGitHub .. " réussi.")
        -- Charge le fichier téléchargé en tant que programme Lua
        local programme = fs.open(fichier.cheminLocal, "r")
        local code = programme.readAll()
        programme.close()
        -- Exécute le code du programme
        load(code)()
    else
        print("Échec du téléchargement de " .. fichier.cheminGitHub)
    end
end