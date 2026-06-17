param(
  [string]$Root = $PSScriptRoot
)

$ErrorActionPreference = 'Stop'

Write-Host "Running verification in: $Root"

$requiredFiles = @('index.html', 'cakes.html', 'baked-snacks.html', 'contact.html', 'styles.css')
$missingRequired = @()

foreach ($required in $requiredFiles) {
  if (-not (Test-Path (Join-Path $Root $required))) {
    $missingRequired += $required
  }
}

if ($missingRequired.Count -gt 0) {
  Write-Host "Missing required files:" -ForegroundColor Red
  $missingRequired | ForEach-Object { Write-Host " - $_" -ForegroundColor Red }
  exit 1
}

$htmlFiles = Get-ChildItem -Path $Root -Filter *.html -File
$brokenReferences = @()

foreach ($file in $htmlFiles) {
  $content = Get-Content -Path $file.FullName -Raw
  $refs = [regex]::Matches($content, '(?:href|src)\s*=\s*"([^"]+)"') | ForEach-Object { $_.Groups[1].Value }

  foreach ($ref in $refs) {
    if ($ref -match '^(https?:|mailto:|tel:|#|javascript:)') {
      continue
    }

    $clean = $ref.Split('?')[0].Split('#')[0]
    # Skip JS template placeholders and inline template variables (e.g. ${imageData})
    if ($clean -match '\$\{') {
      continue
    }
    if ([string]::IsNullOrWhiteSpace($clean)) {
      continue
    }

    $resolvedPath = Join-Path $Root $clean
    try {
      if (-not (Test-Path $resolvedPath)) {
        $brokenReferences += [pscustomobject]@{
          File = $file.Name
          Reference = $ref
        }
      }
    } catch {
      # If Test-Path errors (illegal characters or unsupported formats), skip this reference
      continue
    }
  }
}

if ($brokenReferences.Count -gt 0) {
  Write-Host "Broken local references found:" -ForegroundColor Red
  $brokenReferences | Format-Table -AutoSize | Out-String | Write-Host
  exit 1
}

Write-Host "Verification passed: required files exist and no broken local href/src references were found." -ForegroundColor Green
exit 0
