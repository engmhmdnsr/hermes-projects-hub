Set sh = CreateObject("WScript.Shell")
Set fs = CreateObject("Scripting.FileSystemObject")
url = WScript.Arguments(0)
' Scheme prefix is "mysessions://". Change both here and in register-protocol.ps1
' if you rename your scheme.
p = Replace(url, "mysessions://", "")
p = Replace(p, "/", "\")
p = Replace(p, """", "")
p = Trim(p)
Set log = fs.OpenTextFile(fs.GetParentFolderName(WScript.ScriptFullName) & "\session-launcher.log", 8, True)
log.WriteLine Now & " url=[" & url & "] dir=[" & p & "] exists=" & fs.FolderExists(p)
log.Close
If Not fs.FolderExists(p) Then
  MsgBox "Folder not found:" & vbCrLf & p & vbCrLf & vbCrLf & "Received: " & url, 16, "Project session"
Else
  sh.CurrentDirectory = p
  hermesExe = sh.ExpandEnvironmentStrings("%LOCALAPPDATA%") & "\hermes\hermes-agent\venv\Scripts\hermes.exe"
  sh.Run """" & hermesExe & """ chat", 1, False
End If
