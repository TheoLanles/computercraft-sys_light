-- Fonction pour afficher une séquence de démarrage de style Windows sans logo 
function displayWindowsStartup()
    local screenWidth, screenHeight = term.getSize()

    -- Barre de progression (non modifiée)
    term.setBackgroundColor(colors.blue)
    term.setTextColor(colors.white)
    local progressBarWidth = 40
    local progressBarX = math.floor((screenWidth - progressBarWidth) / 2)
    local progressBarY = math.floor(screenHeight / 2)

    for i = 1, progressBarWidth do
        term.setCursorPos(progressBarX + i - 1, progressBarY)
        term.write(" ")
        sleep(0.05)
    end

    -- Effacer l'écran
    term.setBackgroundColor(colors.black)
    term.clear()
end

-- Appel de la séquence de démarrage de style Windows sans logo
displayWindowsStartup()
shell.run("boot.lua")

-- Vous pouvez ajouter ici le code pour exécuter votre système d'exploitation après la séquence de démarrage.
