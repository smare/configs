
#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module

Import-Module -Name Microsoft.WinGet.CommandNotFound
#f45873b3-b655-43a6-b217-97c00aa0db58

# Importing large modules in the profile incurs a significant startup cost, so
# only do so for frequently used modules.
# Import-Module AWSPowerShell.NetCore

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

function Get-PSVersion { $PSVersionTable.PSVersion }
Set-Alias psver Get-PSVersion

#------------------------------------------------------------------------------

function Get-PSVersion { $PSVersionTable.PSVersion }
Set-Alias -Name psver Get-PSVersion

#------------------------------------------------------------------------------

function Get-PSProfiles { $PROFILE | Select-Object * }
Set-Alias -Name psprof Get-PSProfiles

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

    foreach ($profile_filename in $profiles) {
        if (Test-Path $profile_filename) {
            Write-Output "Searching in profile: $profile_filename"
            Select-String -Path $profile_filename -Pattern 'Set-Alias|New-Alias' | ForEach-Object {
                [PSCustomObject]@{
                    Profile = $profile_filename
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

# ALIAS: irg
# FUNCTION: Invoke-RipGrep (rg)
Set-Alias -Name irg Invoke-RipGrep

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
Set-Alias -Name npp Invoke-NotepadPlusPlus

#------------------------------------------------------------------------------

# Searches  $env:path for any file (incl. .lnk)
function Find-Whence {
    @(where.exe $args 2>$null)[0]
}

# ALIAS: whence
# FUNCTION: Find-Whence
Set-Alias -Name whence Find-Whence

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
Set-Alias -Name dir-sysint Get-ExeFilesWith64

#------------------------------------------------------------------------------

# Queries ifconfig.me/ip for external IP address
function Get-ExternalIPAddress {
	(Invoke-WebRequest -UseBasicParsing https://ifconfig.me/ip).Content.Trim()
}

# ALIAS: extip
# FUNCTION: Get-ExternalIPAddress
Set-Alias -Name extip Get-ExternalIPAddress

#------------------------------------------------------------------------------

# Change to downloads directory
function Set-DownloadsDirectory {
    Set-Location -Path $env:USERPROFILE\Downloads
}

# ALIAS: dld
# FUNCTION: Set-DownloadsDirectory
Set-Alias -Name dld Set-DownloadsDirectory

#------------------------------------------------------------------------------

# Pushes to Git
function Invoke-GitPush {
    & git push $args
}

# ALIAS: igps
# FUNCTION: pushes to remote git repository
Set-Alias -Name igps Invoke-GitPush

#------------------------------------------------------------------------------

# Pulls from Git
function Invoke-GitPull {
    & git pull $args
}

# ALIAS: igp
# FUNCTION: Invoke-GitPull
Set-Alias -Name igpl Invoke-GitPull

#------------------------------------------------------------------------------

function Invoke-GitClone {
    $currentDir = Get-Location
    $targetDir = 'C:\dev\projects'

    # Construct the target clone directory based on the current directory and provided repo URL
    $repoName = $args[0].Split('/')[-1].Replace('.git', '')
    $cloneDir = if ($currentDir.Path -ne $targetDir) { Join-Path $targetDir $repoName } else { $repoName }

    # Clone the repository into the determined directory
    & git clone $args[0] $cloneDir
}

# Correctly setting the alias for Invoke-GitClone
Set-Alias -Name igc Invoke-GitClone

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