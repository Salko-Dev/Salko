param(
    [string]$TeamKey
)

$ErrorActionPreference = "Stop"

function Write-Header([string]$Message) {
    Write-Host $Message -ForegroundColor Cyan
}

function Write-Step([string]$Message) {
    Write-Host "-> $Message" -ForegroundColor Yellow
}

function Write-Success([string]$Message) {
    Write-Host "OK $Message" -ForegroundColor Green
}

function Test-IsWindows {
    if (Get-Variable IsWindows -ErrorAction SilentlyContinue) {
        return [bool]$IsWindows
    }

    return $env:OS -eq 'Windows_NT'
}

function Get-NpmBin {
    try {
        $npmBin = (& npm bin -g).Trim()
        if ($npmBin) {
            return $npmBin
        }
    }
    catch {
    }

    $prefix = (& npm prefix -g).Trim()
    if (Test-IsWindows) {
        return $prefix
    }

    return (Join-Path $prefix 'bin')
}

function Get-SalkoExecutableName {
    if (Test-IsWindows) {
        return 'salko.cmd'
    }

    return 'salko'
}

function Resolve-SalkoCommand {
    $command = Get-Command salko -ErrorAction SilentlyContinue
    if ($command) {
        return $command.Source
    }

    $npmBin = Get-NpmBin
    $candidate = Join-Path $npmBin (Get-SalkoExecutableName)
    if (Test-Path $candidate) {
        return $candidate
    }

    throw 'Unable to find salko after installation. Open a new terminal and try again.'
}

if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    throw 'npm is required but was not found. Install Node.js from https://nodejs.org and run again.'
}

Write-Header 'Salko CLI installer (PowerShell)'
Write-Step 'Installing or updating salko'
& npm install -g @salko-dev/cli | Out-Host

$npmBin = Get-NpmBin
$pathSeparator = [System.IO.Path]::PathSeparator
$pathEntries = $env:Path -split [System.Text.RegularExpressions.Regex]::Escape([string]$pathSeparator)
if (-not ($pathEntries | Where-Object { $_ -eq $npmBin })) {
    $env:Path = "$npmBin$pathSeparator$env:Path"
}

$salko = Resolve-SalkoCommand
$version = (& $salko --version).Trim()
Write-Success "Salko CLI ready ($version)"

if ($TeamKey) {
    Write-Step 'Authenticating with team key'
    & $salko auth team-key --key $TeamKey | Out-Host
    Write-Success 'Authenticated successfully'
}

Write-Step 'Installing bundled Salko skills into detected agent roots'
& $salko skills install | Out-Host
Write-Success 'Bundled skills installed'
