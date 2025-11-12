#Requires AutoHotkey v2.0
Persistent

; ===============================
; ======== CONFIG SETUP =========
; ===============================
configFile := A_ScriptDir "\autopaste_config.ini"

; Default values
settings := Map(
    "interval", 60,
    "showUI", 1,
    "toggleKey", "F8",
    "exitKey", "F9",
    "configKey", "F10",
    "useSendInput", 1,
    "maxPastes", 0,
    "chatButton", "/",
    "pasteText", "",
    "useClipboard", 0,
    "showCountdown", 1,
    "showPasteCount", 0
)

; Load existing config
if FileExist(configFile) {
    for key, val in settings {
        readVal := IniRead(configFile, "AutoPaste", key, "ERROR_NOT_FOUND")
        if (readVal != "ERROR_NOT_FOUND")
            settings[key] := (key = "interval" or key = "showUI" or key = "useSendInput" or key = "maxPastes" or key = "useClipboard" or key = "showCountdown" or key = "showPasteCount") ? Integer(readVal) : readVal
    }
}

; Save config function
SaveConfig() {
    global configFile, settings
    for key, val in settings
        IniWrite(val, configFile, "AutoPaste", key)
}

; ===============================
; ======= MAIN VARIABLES ========
; ===============================
global isRunning := false
global timeLeft := settings["interval"]
global pasteCount := 0
global ui := ""
global txtStatus := ""
global txtCountdown := settings["showCountdown"] ? "" : "disabled"
global txtPasteCount := settings["showPasteCount"] ? "" : "disabled"

; ===============================
; ======== CREATE STATUS UI =====
; ===============================
CreateStatusUI() {
    global ui, txtStatus, txtCountdown, txtPasteCount, settings
    
    if !settings["showUI"] {
        if IsObject(ui)
            ui.Destroy()
        return
    }
    
    if IsObject(ui)
        return  ; already exists
    
    ui := Gui("+AlwaysOnTop -Caption +ToolWindow", "AutoPaste Status")
    ui.BackColor := "1C1C1C"
    ui.SetFont("s10", "Segoe UI")
    
    txtStatus := ui.AddText("cWhite w120 Center", "Status: OFF")
    
    if settings["showCountdown"]
        txtCountdown := ui.AddText("cGray w120 Center", "Next in: --s")
    
    if settings["showPasteCount"]
        txtPasteCount := ui.AddText("cYellow w120 Center", "Pastes: 0")
    
    ui.Show("x10 y10 NoActivate")
}

UpdateStatusUI() {
    global txtStatus, txtCountdown, txtPasteCount, isRunning, timeLeft, pasteCount, settings
    
    if !IsObject(txtStatus)
        return
    
    txtStatus.Value := "Status: " (isRunning ? "ON" : "OFF")
    txtStatus.SetFont("c" (isRunning ? "Lime" : "Red"))
    
    if settings["showCountdown"] and IsObject(txtCountdown) and txtCountdown != "disabled" {
        txtCountdown.Value := isRunning ? "Next in: " timeLeft "s" : "Next in: --s"
    }
    
    if settings["showPasteCount"] and IsObject(txtPasteCount) and txtPasteCount != "disabled" {
        maxText := settings["maxPastes"] > 0 ? "/" settings["maxPastes"] : ""
        txtPasteCount.Value := "Pastes: " pasteCount maxText
    }
}

CreateStatusUI()

; ===============================
; ========== MAIN TASK ==========
; ===============================
DoPaste(*) {
    global settings, pasteCount, isRunning
    
    ; Execute paste sequence
    if settings["useSendInput"] {
        if settings["chatButton"]
            SendInput(settings["chatButton"])
        Sleep(80)
        
        ; Either use Ctrl+V or type custom text
        if settings["useClipboard"]
            SendInput("^v")
        else if settings["pasteText"]
            SendInput(settings["pasteText"])
            
        Sleep(80)
        SendInput("{Enter}")
    } else {
        if settings["chatButton"]
            Send(settings["chatButton"])
        Sleep(80)
        
        ; Either use Ctrl+V or type custom text
        if settings["useClipboard"]
            Send("^v")
        else if settings["pasteText"]
            Send(settings["pasteText"])
            
        Sleep(80)
        Send("{Enter}")
    }
    
    ; Increment paste count
    pasteCount += 1
    UpdateStatusUI()
    
    ; Check if max pastes reached
    if settings["maxPastes"] > 0 and pasteCount >= settings["maxPastes"] {
        isRunning := false
        UpdateStatusUI()
        TrayTip("AutoPaste", "Max pastes (" settings["maxPastes"] ") reached! Stopped.", 2000)
    }
}

; Countdown updater
CountdownTick() {
    global isRunning, timeLeft, settings
    
    if (isRunning) {
        timeLeft -= 1
        if (timeLeft <= 0) {
            DoPaste()
            timeLeft := settings["interval"]
        }
    }
    UpdateStatusUI()
}

SetTimer(CountdownTick, 1000)

; ===============================
; ========= HOTKEY LOGIC ========
; ===============================
Hotkey(settings["toggleKey"], ToggleTimer)
Hotkey(settings["exitKey"], (*) => ExitApp())
Hotkey(settings["configKey"], OpenConfig)

ToggleTimer(*) {
    global isRunning, timeLeft, pasteCount, settings
    
    isRunning := !isRunning
    
    if isRunning {
        pasteCount := 0  ; Reset counter on start
        DoPaste()  ; Execute immediately on first toggle
        timeLeft := settings["interval"]
        TrayTip("AutoPaste", "Timer ON", 1000)
    } else {
        TrayTip("AutoPaste", "Timer OFF", 1000)
    }
    
    UpdateStatusUI()
}

; ===============================
; ========= CONFIG WINDOW =======
; ===============================
OpenConfig(*) {
    global settings, ui
    
    cfg := Gui("+AlwaysOnTop", "AutoPaste Config")
    cfg.SetFont("s10", "Segoe UI")
    
    cfg.AddText(, "Interval (seconds):")
    inputInterval := cfg.AddEdit("w200", settings["interval"])
    
    cfg.AddText(, "Max Pastes (0 = unlimited):")
    inputMaxPastes := cfg.AddEdit("w200", settings["maxPastes"])
    
    cfg.AddText(, "Show UI (1 = yes, 0 = no):")
    inputShowUI := cfg.AddEdit("w200", settings["showUI"])
    
    cfg.AddText(, "Show Countdown Timer (1 = yes, 0 = no):")
    inputShowCountdown := cfg.AddEdit("w200", settings["showCountdown"])
    
    cfg.AddText(, "Show Paste Counter (1 = yes, 0 = no):")
    inputShowPasteCount := cfg.AddEdit("w200", settings["showPasteCount"])
    
    cfg.AddText(, "Chat Button (e.g., / for Roblox, leave empty for none):")
    inputChatButton := cfg.AddEdit("w200", settings["chatButton"])
    
    cfg.AddText(, "Use Clipboard Ctrl+V (1 = yes, 0 = no):")
    inputUseClipboard := cfg.AddEdit("w200", settings["useClipboard"])
    
    cfg.AddText(, "OR Text to Type (ignored if clipboard enabled):")
    inputPasteText := cfg.AddEdit("w200", settings["pasteText"])
    
    cfg.AddText(, "Use SendInput (1 = yes, 0 = no):")
    inputUseSendInput := cfg.AddEdit("w200", settings["useSendInput"])
    
    cfg.AddText(, "Toggle Key:")
    inputToggle := cfg.AddEdit("w200", settings["toggleKey"])
    
    cfg.AddText(, "Exit Key:")
    inputExit := cfg.AddEdit("w200", settings["exitKey"])
    
    cfg.AddText(, "Config Key:")
    inputConfig := cfg.AddEdit("w200", settings["configKey"])
    
    btnSave := cfg.AddButton("w100 Default", "Save")
    btnCancel := cfg.AddButton("w100 x+10", "Cancel")
    
    btnSave.OnEvent("Click", (*) => (
        settings["interval"] := Integer(inputInterval.Value),
        settings["maxPastes"] := Integer(inputMaxPastes.Value),
        settings["showUI"] := Integer(inputShowUI.Value),
        settings["showCountdown"] := Integer(inputShowCountdown.Value),
        settings["showPasteCount"] := Integer(inputShowPasteCount.Value),
        settings["chatButton"] := inputChatButton.Value,
        settings["useClipboard"] := Integer(inputUseClipboard.Value),
        settings["pasteText"] := inputPasteText.Value,
        settings["useSendInput"] := Integer(inputUseSendInput.Value),
        settings["toggleKey"] := inputToggle.Value,
        settings["exitKey"] := inputExit.Value,
        settings["configKey"] := inputConfig.Value,
        SaveConfig(),
        (IsObject(ui) ? ui.Destroy() : ""),
        (ui := ""),
        (txtStatus := ""),
        (txtCountdown := ""),
        (txtPasteCount := ""),
        Reload()
    ))
    
    btnCancel.OnEvent("Click", (*) => cfg.Destroy())
    
    cfg.Show()
}

; ===============================
; ========= END SCRIPT ==========
; ===============================
OnExit(*) => SaveConfig()