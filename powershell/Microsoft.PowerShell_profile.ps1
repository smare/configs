
#34de4b3d-13a8-4540-b76d-b9e8d3851756 PowerToys CommandNotFound module

Import-Module "C:\Program Files\PowerToys\WinUI3Apps\..\WinGetCommandNotFound.psd1"
Import-Module AWSPowerShell.NetCore

#34de4b3d-13a8-4540-b76d-b9e8d3851756

# Windows Powershell

# TODO: Customize command prompt
# function Prompt {
# 	$env:COMPUTERNAME + "\" + (Get-Location) + "> "
# }


# Change to working directory
Set-Location -Path C:\dev\projects
Set-PSReadLineOption -BellStyle None # Remove the annoying bell sound  # not sure it actually works


# Set UTF-8 encoding
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# *****************************************************************************
# ALIASES

#------------------------------------------------------------------------------

# Source this profile
function Set-ProfileSource {
    . $PSHOME\Microsoft.PowerShell_profile.ps1
#    & $profile
}
Set-Alias source Set-ProfileSource

#------------------------------------------------------------------------------

function Get-PSVersion { $PSVersionTable.PSVersion }
Set-Alias psver Get-PSVersion

#------------------------------------------------------------------------------

function Get-PSProfiles { $PROFILE | Select-Object * }
Set-Alias psprof Get-PSProfiles

#------------------------------------------------------------------------------

function Get-CmdletAliases {
    param (
        [string]$CmdletName
    )

    if ([string]::IsNullOrEmpty($CmdletName)) {
        # List all aliases if no cmdlet name is provided
        Get-Alias | Format-Table Name, Definition
    }
    else {
        # Filter aliases based on the provided cmdlet name
        Get-Alias | Where-Object { $_.Definition -eq $CmdletName } | Format-Table Name, Definition
    }
}

Set-Alias -Name gca -Value Get-CmdletAliases

#------------------------------------------------------------------------------

function Get-AliasResolvedCommand {
    param (
        [Parameter(Mandatory=$true)]
        [string]$AliasName
    )

    $alias = Get-Alias -Name $AliasName -ErrorAction SilentlyContinue
    if ($alias) {
        $obj = [PSCustomObject]@{
            Alias = $AliasName
            ResolvedCommand = $alias.ResolvedCommandName
        }
        $obj | Format-Table -AutoSize
    } else {
        Write-Output "No alias found for '$AliasName'."
    }
}

Set-Alias -Name garc -Value Get-AliasResolvedCommand

#------------------------------------------------------------------------------

function Get-ProfileAliases {
    $profiles = @(
        $PROFILE.AllUsersAllHosts,
        $PROFILE.AllUsersCurrentHost,
        $PROFILE.CurrentUserAllHosts,
        $PROFILE.CurrentUserCurrentHost
    )

    foreach ($profile in $profiles) {
        if (Test-Path $profile) {
            Write-Output "Searching in profile: $profile"
            Select-String -Path $profile -Pattern 'Set-Alias|New-Alias' | ForEach-Object {
                [PSCustomObject]@{
                    Profile = $profile
                    LineNumber = $_.LineNumber
                    Text = $_.Line
                }
            } | Format-Table -AutoSize
        }
    }
}

Set-Alias -Name gpa -Value Get-ProfileAliases

#------------------------------------------------------------------------------

# Looks for the environment variable $env:RIPGREP_CONFIG_PATH to determine the
# location of the ripgrep configuration file. If it does not exist, it will use
# any parameters passed as parameters.
function Invoke-RipGrep {
    & C:\dev\tools\ripgrep-14.1.0\rg.exe $args
}

# ALIAS: igl
# FUNCTION: Invoke-RipGrep (rg)
Set-Alias irg Invoke-RipGrep

#------------------------------------------------------------------------------

# Passes arguments to the where.exe command
function Get-Which {
    param (
        [Parameter(Mandatory)]
        [string]$Name
    )

    Get-Command $Name | Select-Object -ExpandProperty Source
}

Set-Alias -Name which -Value Get-Which

#------------------------------------------------------------------------------

# Runs Notepad++ and opens the specified file
function Invoke-NotepadPlusPlus {
    & 'C:\Program Files\Notepad++\notepad++.exe' $args
}

# ALIAS: npp
# FUNCTION: Invoke-NotepadPlusPlus
Set-Alias npp Invoke-NotepadPlusPlus

#------------------------------------------------------------------------------

# Searches  $env:path for any file (incl. .lnk)
function Find-Whence {
    @(where.exe $args 2>$null)[0]
}

# ALIAS: whence
# FUNCTION: Find-Whence
Set-Alias whence Find-Whence

#------------------------------------------------------------------------------

# Lists all the executables in the SysInternals directory
function Get-ExeFilesWith64 {
    param(
        [string]$Path = 'C:\dev\tools\SysInternals'
    )
    Get-ChildItem -Path $Path -Filter *64*.exe -Recurse |
    Where-Object { $_.Name -like '*64*.exe' } |
    ForEach-Object { $_.BaseName } | more
}

# ALIAS: dir-sysint
# FUNCTION: Get-ExeFilesWith64
Set-Alias dir-sysint Get-ExeFilesWith64

#------------------------------------------------------------------------------

# Queries ifconfig.me/ip for external IP address
function Get-External-IP-Address {
	(Invoke-WebRequest -UseBasicParsing https://ifconfig.me/ip).Content.Trim()
}

# ALIAS: extip
# FUNCTION: Get-External-IP-Address
Set-Alias extip Get-External-IP-Address

#------------------------------------------------------------------------------

function Get-Wttr {
    (Invoke-WebRequest wttr.in).Content
}

Set-Alias -Name wttr -Value Get-Wttr -Description "Displays the local weather from wttr.in"

#------------------------------------------------------------------------------

# Change to downloads directory
function Set-DownloadsDirectory {
    Set-Location -Path $env:USERPROFILE\Downloads
}

# ALIAS: dld
# FUNCTION: Set-DownloadsDirectory
Set-Alias dld Set-DownloadsDirectory

#------------------------------------------------------------------------------

# Pushes to Git
function Get-GitPush {
    & git push $args
}

# ALIAS: gpush
# FUNCTION: pushes to remote git repository
Set-Alias gpush Get-GitPush

#------------------------------------------------------------------------------

# Pulls from Git
function Get-GitPull {
    & git pull $args
}

# ALIAS: gpull
# FUNCTION: Get-GitPull
Set-Alias gpull Get-GitPull

#------------------------------------------------------------------------------

function Get-GitClone {
    $currentDir = Get-Location
    $targetDir = 'C:\dev\projects'

    # Construct the target clone directory based on the current directory and provided repo URL
    $repoName = $args[0].Split('/')[-1].Replace('.git', '')
    $cloneDir = if ($currentDir.Path -ne $targetDir) { Join-Path $targetDir $repoName } else { $repoName }

    # Clone the repository into the determined directory
    & git clone $args[0] $cloneDir
}

# Correctly setting the alias for Get-GitClone
Set-Alias gcl Get-GitClone

#------------------------------------------------------------------------------

# ALIASES
# *****************************************************************************

#
# TODO: Add a function Get-PowerShellCommands that displays available commands
#   and aliases and their descriptions. Input parameters should be things like:
#   No arguments - display all commands (cmdlets, functions, aliases)
#   -Type <cmdlet|function|alias> - display only the specified type
#   -Name <name> - display only the specified command
#   -Module <module> - display only commands from the specified module


# TODO: Add a function Get-Variables that display variables and their values
#       Input parameters should be things like:
#       No arguments - display all variables (preference, environment, user-defined)
#       -Preference <preference> - display only the specified preference variable. If no preference is specified, display all preference variables
#       -Environment <environment> - display only the specified environment variable. If no environment variable is specified, display all environment variables
#       -UserDefined <user-defined> - display only the specified user-defined variable. If no user-defined variable is specified, display all user-defined variables

# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_environment_variables?view=powershell-7.4
# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/?view=powershell-7.4
# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/?view=powershell-7.4
# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/?view=powershell-7.4
# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.security/?view=powershell-7.4
# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables?view=powershell-7.4#confirmpreference
# https://theitbros.com/how-to-get-list-of-installed-programs-in-windows-10/
# https://blog.ironmansoftware.com/daily-powershell/powershell-read-registry/
# https://learn.microsoft.com/en-us/windows/deployment/usmt/usmt-recognized-environment-variables
# https://4sysops.com/archives/using-powershell-with-psstyle/
# https://book.hacktricks.xyz/windows-hardening/basic-cmd-for-pentesters
# gci env:* | sort-object name | Foreach {"[System.Environment]::SetEnvironmentVariable('$($_.Name)', '$($_.Value)', 'Machine')"}
#