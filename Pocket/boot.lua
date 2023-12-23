-- Tableau de couleurs disponibles
local colorsTable = {
    { name = "Blanc", code = colors.white },
    { name = "Orange", code = colors.orange },
    { name = "Magenta", code = colors.magenta },
    { name = "Leger bleu", code = colors.lightBlue },
    { name = "Jaune", code = colors.yellow },
    { name = "Vert", code = colors.lime },
    { name = "Rose", code = colors.pink },
    { name = "Gris clair", code = colors.lightGray },
    { name = "Gris", code = colors.gray },
    { name = "Cyan", code = colors.cyan },
    { name = "Leger pourpre", code = colors.purple },
    { name = "Bleu", code = colors.blue },
    { name = "Marron", code = colors.brown },
    { name = "Vert fonce", code = colors.green },
    { name = "Rouge", code = colors.red }
}

local colorNames = {
    [colors.white] = "Blanc",
    [colors.orange] = "Orange",
    [colors.magenta] = "Magenta",
    [colors.lightBlue] = "Léger bleu"
    -- Ajoutez d'autres correspondances pour les couleurs ici
}

-- Couleurs par défaut
local backgroundColor = colors.white
local textColor = colors.black
local highlightColor = colors.blue

-- Fonction pour centrer le texte sur l'écran
function centerText(text)
    local screenWidth, screenHeight = term.getSize()
    local xPos = math.floor((screenWidth - #text) / 2)
    return xPos
end

-- Fonction principale
function main()
    local selectedOption = 1

    while true do
        clearScreen()
        term.setTextColor(textColor)
        local menuTitle = "  == Mon OS == V.1.3"
        term.setCursorPos(centerText(menuTitle), 1)
        print(menuTitle)
        print(string.rep("-", 26)) -- Ligne horizontale

        local menuOptions = {
            "1. Lancer un programme",
            "2. Explorer",
            "3. Changer la couleur",
            "4. Lumieres",
            "5. Quitter",
            "6. Mise a jour"
        }

        for i, option in ipairs(menuOptions) do
            term.setCursorPos(centerText(option), i + 2)

            if i == selectedOption then
                term.setBackgroundColor(highlightColor) -- Couleur de surbrillance
            else
                term.setBackgroundColor(backgroundColor)
            end

            term.write(option)
        end

        local event, key = os.pullEvent("key")

        if key == keys.up and selectedOption > 1 then
            selectedOption = selectedOption - 1
        elseif key == keys.down and selectedOption < #menuOptions then
            selectedOption = selectedOption + 1
        elseif key == keys.enter then
            if selectedOption == 1 then
                runProgram()
            elseif selectedOption == 2 then
                exploreFilesystem()
            elseif selectedOption == 3 then
                changeBackgroundColor()
            elseif selectedOption == 4 then
                shell.run("client.lua")
            elseif selectedOption == 5 then
                clearScreen()
                print("Redémarrage en cours...")
                sleep(2)
                shell.run("reboot")
            elseif selectedOption == 6 then
                shell.run("update.lua")
                return
                -- Ajoutez ici le code pour la fonction "Faites un choix"
            end
        end
    end
end

-- Efface l'écran
function clearScreen()
    term.setBackgroundColor(backgroundColor)
    term.clear()
    term.setCursorPos(1, 1)
end

-- Exécute un programme
function runProgram()
    clearScreen()
    term.setTextColor(textColor)
    local headerText = " == Programme =="
    local separator = string.rep("-", 28)

    term.setCursorPos(centerText(headerText), 1)
    print(headerText)
    term.setCursorPos(centerText(separator), 2)
    print(separator)

    term.setCursorPos(2, 4)
    write("Entrez le nom du programme : ")
    local programName = read()

    local programPath = shell.resolve(programName)
    local program = fs.open(programPath, "r")
    
    if program then
        local programCode = program.readAll()
        program.close()

        clearScreen()
        term.setTextColor(textColor)

        term.setCursorPos(centerText(headerText), 1)
        print(headerText)
        term.setCursorPos(centerText(separator), 2)
        print(separator)

        term.setTextColor(textColor)
        term.setCursorPos(2, 3)
        print("Nom du programme: " .. programName)

        term.setCursorPos(centerText(separator), 4)
        print(separator)

        term.setCursorPos(centerText("Appuyez sur une touche pour continuer..."), 5)
        os.pullEvent("key") -- Attendre que l'utilisateur appuie sur une touche

        -- Exécute le code du programme en utilisant load
        local success, err = load(programCode, "=" .. programName, "t", _G)
        if success then
            success()  -- Exécute le code
        else
            print("Erreur lors de l'exécution de " .. programName .. ": " .. err)
        end
    else
        clearScreen()
        term.setTextColor(textColor)

        term.setCursorPos(centerText(headerText), 1)
        print(headerText)
        term.setCursorPos(centerText(separator), 2)
        print(separator)

        term.setCursorPos(centerText(separator), 6)
        print(separator)

        term.setCursorPos(centerText("Appuyez sur une toouche pour continuer..."), 7)
        os.pullEvent("key") -- Attendre que l'utilisateur appuie sur une touche
    end
end




-- Fonction pour centrer le texte
function centerText(text)
    local screenWidth, _ = term.getSize()
    return math.floor((screenWidth - #text) / 2)
end

-- Explore le système de fichiers
function exploreFilesystem()
    clearScreen()
    term.setTextColor(textColor)
    local headerText = "== Explorer =="
    local separator = string.rep("-", 28)

    term.setCursorPos(centerText(headerText), 1)
    print(headerText)
    term.setCursorPos(centerText(separator), 2)
    print(separator)

    local files = fs.list("/")
    if #files > 0 then
        print("Liste des fichiers:")
        print(string.rep("-", 26)) -- Ligne horizontale

        for i, file in pairs(files) do
            term.setCursorPos(1, i + 4)
            print("- " .. file)
        end
    else
        term.setCursorPos(centerText("Le répertoire est vide."), 4)
        print("Le répertoire est vide.")
    end

    term.setCursorPos(centerText("Appuyez pour continuer.."), 15)
    print("Appuyez pour continuer...")
    os.pullEvent("key") -- Attendez que l'utilisateur appuie sur une touche
end

-- Change la couleur de fond et de surbrillance
function changeBackgroundColor()
    clearScreen()
    term.setTextColor(textColor)
    print(" == Changer la Couleur ==")
    print(string.rep("-", 26)) -- Ligne horizontale

    -- Affiche les options de couleur de fond
    for i, color in pairs(colorsTable) do
        term.setCursorPos(2, i + 2)
        term.setBackgroundColor(color.code)
        term.write("  ")
        term.setBackgroundColor(backgroundColor)
        term.setTextColor(textColor)
        term.write(" " .. i .. ". " .. color.name)
    end

    -- Affiche les options de couleur de surbrillance
    local highlightOption = #colorsTable + 1
    term.setCursorPos(2, highlightOption + 2)
    term.setBackgroundColor(highlightColor)
    term.write("  ")
    term.setBackgroundColor(backgroundColor)
    term.setTextColor(textColor)
    term.write(" " .. highlightOption .. ". surbrillance ")

    local choice = tonumber(read())

    if choice and choice >= 1 and choice <= #colorsTable then
        backgroundColor = colorsTable[choice].code
    elseif choice == highlightOption then
        -- Change la couleur de surbrillance
        highlightColor = selectHighlightColor()
    else
        term.setTextColor(textColor)
        print("Choix invalide. Réessayez")
        sleep(2) -- Attend quelques secondes pour que l'utilisateur puisse lire le message d'erreur
    end
end

-- Fonction pour sélectionner la couleur de surbrillance
function selectHighlightColor()
    clearScreen()
    term.setTextColor(textColor)
    print("    == Surbrillance ==")
    print(string.rep("-", 26)) -- Ligne horizontale

    -- Affiche les options de couleur de surbrillance
    for i, color in pairs(colorsTable) do
        term.setCursorPos(2, i + 2)
        if color.code == highlightColor then
            term.setBackgroundColor(highlightColor) -- Utilisez une couleur de fond grise pour mettre en évidence la sélection
        else
            term.setBackgroundColor(colors.black)
        end
        term.write("  ")
        term.setBackgroundColor(backgroundColor)
        term.setTextColor(textColor)
        term.write(" " .. i .. ". " .. color.name)
    end

    term.setCursorPos(2, #colorsTable + 4)
    term.setTextColor(textColor)
    write("Faites un choix: ")

    local choice = tonumber(read())

    if choice and choice >= 1 and choice <= #colorsTable then
        return colorsTable[choice].code
    else
        term.setTextColor(textColor)
        print("Choix invalide. Réessayez")
        sleep(2) -- Attend quelques secondes pour que l'utilisateur puisse lire le message d'erreur
    end
end

-- Programme principal
main()
