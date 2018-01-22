'+++++++++++++++++++++++++++++++++++++++++++++++++++++
'Date de Création: Vendredi 09 Janvier 2009          +
'Date de Modification: Lundi 12 Janvier 2009         +
'Objet: Afficher l'etat des Disques sur S2           +
'Préparé par: Rova TSIRINIAINA et Haja RAKOTOMALALA  +
'version: 2.0                                        +
'+++++++++++++++++++++++++++++++++++++++++++++++++++++

'Variable date separé
CurrentDate = Date
jour = Cstr(Day(CurrentDate))
mois = Cstr(Month(CurrentDate))
annee = Cstr(Year(CurrentDate))
dt = jour + "-" + mois + "-" + annee
Set objNetwork = Wscript.CreateObject("Wscript.Network") 'instance objet network
nompc = objNetwork.ComputerName
Fname = dt + "-" + nompc + ".txt"

'Recherche fichier dans le dossier
Set FSO = CreateObject("Scripting.FileSystemObject")
Set Folder = FSO.GetFolder("E:\log\audit")
rep = "E:\log\audit\" + Fname
if  FSO.FileExists(rep) then
   Const CONVERSION_FACTOR = 1048576
   Computer = "s2_us02_b"              '-----------------------Nom de l'ordinateur
   Set objWMIService = GetObject("winmgmts://" & Computer)
   Set colLogicalDisk = objWMIService.InstancesOf("Win32_LogicalDisk")
   

   Set f1 = CreateObject("Scripting.FileSystemObject")   
   Set f = f1.OpenTextFile(rep, 8,true)                   '----------------------ouverture du fichier
   f.writeLine("")
   f.writeLine("")
   f.writeLine("----------------------" + Computer + "----------------------") 
   
   For Each objLogicalDisk In colLogicalDisk '-----------------------------audit des disques
    
    FreeMegaBytes = (objLogicalDisk.FreeSpace / CONVERSION_FACTOR) 'Calcul d'espace libre
    if IsNull(FreeMegaBytes) = true then 'Tester si la variable renvoie quelque chose
       FreeMegaBytes = 0
    end if
    SizeMegaBytes = (objLogicalDisk.Size / CONVERSION_FACTOR) 'Calcul du capacite total du Disque
    SizeTotalOctets = objLogicalDisk.Size 'Convertion de Mega en Octet
    if IsNull(SizeTotalOctets) = true then
       SizeTotalOctets = 0
    end if
    SizeFreeOctets = objLogicalDisk.FreeSpace
    if IsNull(SizeFreeOctets) = true then
       SizeFreeOctets = 0
    end if
    prcent = (FreeMegaBytes * 100) / SizeMegaBytes
    if IsNull(prcent) = true then
       prcent = 0
    end if
    
    tt = "Espace Disque Total sur  " & objLogicalDisk.DeviceID & " " & Int(SizeMegaBytes) & " Mo   ("  &  SizeTotalOctets & " Octets)"
    lib = "Espace Libre             " & objLogicalDisk.DeviceID & " " & Int(FreeMegaBytes) & "Mo   ("  &  SizeFreeOctets & " Octets)  " &_
    FormatNumber(prcent,2) & "%"
    

    'Affiches les informations des tous les disques sauf le CD
    if objLogicalDisk.DriveType <> 5 then
                f.writeLine("")
                f.writeLine("")
                f.writeLine(tt)
                f.writeLine(lib)
                f.writeLine("-------------------------------------------------------------")
    end if

next   
f.close
else
   'wscript.Echo "Fichier inexistant"
end if
