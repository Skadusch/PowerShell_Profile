# posh-git
Import-Module posh-git

# Disable Highlight for Directorys
$PSStyle.FileInfo.Directory = ""

# oh-my-posh
oh-my-posh init pwsh --config 'https://raw.githubusercontent.com/maxstolly/rose-pine.omp/main/rose-pine.omp.json' | Invoke-Expression

# Reload Profile
function reload-profile {
    . $profile
}

# edit profile with nvim
function ep { nvim $PROFILE }

# touch to create file
function touch($file) { "" | Out-File $file -Encoding ASCII }

# better listing
function la { Get-ChildItem -Path . -Force | Format-Table -AutoSize }
function lh { Get-ChildItem -Path . -Force -Hidden | Format-Table -AutoSize }

# grep
Set-Alias grep findstr

# find file
function find-file($name) {
    Get-ChildItem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | ForEach {
        Write-Output "$($_.directory)\$($_)"
    }
}

# Unzip to current directory
function unzip ($file) {
    Write-Output("Extracting", $file, "to", $pwd)
    $fullFile = Get-ChildItem -Path $pwd -Filter $file | ForEach-Object { $_.FullName }
    Expand-Archive -Path $fullFile -DestinationPath $pwd
}

# git shortcuts
function gs { git status }
function ga { git add * }
function gcom { 
    git add .
    git commit -m "$args" }
function gpu { git push -u origin main }
function lazyg {
    git add .
    git commit -m "$args"
    git push
}

function sed($file, $find, $replace) {
    (Get-Content $file).replace("$find", $replace) | Set-Content $file
}

function which($name) {
    Get-Command $name | Select-Object -ExpandProperty Definition
}

function export($name, $value) {
    set-item -force -path "env:$name" -value $value;
}
# Kill Process
function pkill($name) {
    Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
}
# Get Process
function pgrep($name) {
    Get-Process $name
}

function head {
  param($Path, $n = 10)
  Get-Content $Path -Head $n
}

function tail {
  param($Path, $n = 10)
  Get-Content $Path -Tail $n
}

# sh256 and 512 for downloads
function sha256 { Get-FileHash -Algorithm SHA256 $args }
function sha512 { Get-FileHash -Algorithm SHA512 $args }

# creates a new admin powershell instance
function admin
{
    if ($args.Count -gt 0)
    {   
        $argList = "& '" + $args + "'"
            Start-Process pwsh -Verb runAs -ArgumentList $argList
    }
    else
    {
        Start-Process pwsh -Verb runAs
    }
}

# Unix like Alias "sudo"
Set-Alias -Name su -Value admin
Set-Alias -Name sudo -Value admin



