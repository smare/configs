# configs
A collection of configuration files with defined aliases, color schemes, etc. for several applications.

Make the following hardlinks for Windows user's config files.

### bash
Ensure `.profile` and `.bash_profile` exist in `$HOME`.  Take care to update an existing `.bashrc` if
there is one.
```powershell
New-Item -ItemType Hardlink -Path "$HOME\.bashrc" -Target C:\dev\projects\configs\bash\.bashrc
New-Item -ItemType Hardlink -Path "$HOME\.bash_aliases" -Target C:\dev\projects\configs\bash\.bash_aliases
```

### cmd
```powershell
New-Item -ItemType Hardlink -Path "$HOME\doskey-macros.txt" -Target C:\dev\projects\configs\cmd\doskey-macros.txt
```
Then run the following command from a command prompt (not PowerShell):
```powershell
reg add "HKCU\Software\Microsoft\Command Processor" /v Autorun /d "doskey /macrofile=\"%HOME%\doskey-macros.txt\"" /f
```

### vim
```powershell
New-Item -ItemType Hardlink -Path "$ENV:ProgramFiles\Vim\_vimrc" -Target C:\dev\projects\configs\vim\_vimrc
```

### git
```powershell
New-Item -ItemType Hardlink -Path "$HOME\.gitconfig" -Target C:\dev\projects\configs\git\.gitconfig
```

### ripgrep
```powershell
New-Item -ItemType Hardlink -Path "$HOME\.rgconfig" -Target C:\dev\projects\configs\ripgrep\.rgconfig
```

### PowerShell
```powershell
New-Item -ItemType Hardlink -Path "$ENV:ProgramFiles\PowerShell\7\Microsoft.PowerShell_profile.ps1" -Target C:\dev\projects\configs\powershell\Microsoft.PowerShell_profile.ps1

New-Item -ItemType Hardlink -Path "$HOME\OneDrive\Documents\PowerShell\Microsoft.VSCode_profile.ps1" -Target C:\dev\projects\configs\powershell\Microsoft.VSCode_profile.ps1
```