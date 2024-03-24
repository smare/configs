# configs
A collection of configuration files with defined aliases, color schemes, etc. for several applications.

Make the following hardlinks to Windows user's config files.

### git
```powershell
PS C:\dev> New-Item -ItemType Hardlink -Path "$HOME\.gitconfig" -Target C:\dev\projects\configs\git\.gitconfig
```

### ripgrep
```powershell
PS C:\dev> New-Item -ItemType Hardlink -Path "$HOME\.rgconfig" -Target C:\dev\projects\configs\ripgrep\.rgconfig
```

### PowerShell
```powershell
PS C:\dev> New-Item -ItemType Hardlink -Path "C:\Program Files\PowerShell\7\Microsoft.PowerShell_profile.ps1" -Target C:\dev\projects\configs\powershell\Microsoft.PowerShell_profile.ps1
PS C:\dev> New-Item -ItemType Hardlink -Path "$HOME\OneDrive\Documents\PowerShell\Microsoft.VSCode_profile.ps1" -Target C:\dev\projects\configs\powershell\Microsoft.VSCode_profile.ps1
```