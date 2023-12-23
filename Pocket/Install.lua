-- Charge le système de fichiers virtuel (VFS) pour GitHub
local githubPath = "/lib/vfs/github.lua"
if not fs.exists(githubPath) then
    print("Téléchargement de la bibliothèque GitHub VFS...")
    local githubVfsCode = http.get("https://raw.githubusercontent.com/someuser/someproject/master/lib/vfs/github.lua")
    if githubVfsCode then
        local githubVfsFile = fs.open(githubPath, "w")
        githubVfsFile.write(githubVfsCode.readAll())
        githubVfsFile.close()
        githubVfsCode.close()
    else
        error("Impossible de télécharger la bibliothèque GitHub VFS.")
    end
end

-- Charge la bibliothèque GitHub VFS
local github = require("/lib/vfs/github")

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
    local cheminLocal = fichier.cheminLocal
    if github.downloadFile(utilisateur, repo, fichier.cheminGitHub, cheminLocal) then
        print("Téléchargement de " .. fichier.cheminGitHub .. " réussi.")
        -- Charge le fichier téléchargé en tant que programme Lua
        local programme = fs.open(cheminLocal, "r")
        local code = programme.readAll()
        programme.close()
        -- Exécute le code du programme
        local success, err = pcall(load(code))
        if not success then
            print("Erreur lors de l'exécution de " .. fichier.cheminGitHub .. ": " .. err)
        end
    else
        print("Échec du téléchargement de " .. fichier.cheminGitHub)
    end
end
