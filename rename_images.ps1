$root = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
Set-Location $root
Get-ChildItem -Path 'assets\optimized' -File | Where-Object { $_.Name -match ' ' } | ForEach-Object {
    $old = $_.FullName
    $newName = ($_.Name -replace ' ', '-')
    Rename-Item -LiteralPath $old -NewName $newName -Verbose
}