local backgroundColor = colors.white
local textColor = colors.black


  term.setBackgroundColor(backgroundColor) -- Fond modifier
  term.clear()
  term.setCursorPos(1, 1)
  term.setTextColor(textColor)



local filesToDownload = {
    {pastebin = "VQjpEnAa", path = "/boot.lua"},
    {pastebin = "Cwwjbdu4", path = "/startup.lua"},
    {pastebin = "R0Cq6TYQ", path = "/client.lua"},
    {pastebin = "eedPz59Z", path = "/config.lua"},
    {pastebin = "u3S85kCk", path = "/update.lua"},
    -- Ajoutez d'autres fichiers si nécessaire
}
 
-- Fonction pour télécharger un fichier depuis Pastebin
local function downloadFromPastebin(pastebinId, destinationPath)
    local url = "https://pastebin.com/raw/" .. pastebinId
    local response = http.get(url)
 
    if response then
        local content = response.readAll()
        response.close()
 
        local file = fs.open(destinationPath, "w")
        file.write(content)
        file.close()
        return true  -- Téléchargement réussi
    else
        return false  -- Échec du téléchargement
    end
end
 
print("== Début de l'installation ==")
 
for _, file in pairs(filesToDownload) do
    print("Téléchargement depuis Pastebin : " .. file.pastebin)
    if downloadFromPastebin(file.pastebin, file.path) then
        print("Téléchargement terminé : " .. file.path)
    else
        print("Échec du téléchargement depuis Pastebin : " .. file.pastebin)
        return  -- Arrête l'installation en cas d'échec
    end
end
 
print("== Mise a jour terminée ==")
print("Redémarrage en cours...")
os.sleep(1)  -- Attendez un instant pour afficher le message
shell.run("reboot")
