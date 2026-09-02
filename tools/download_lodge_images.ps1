# Download lodge images from Unsplash into assets/optimized/
$dest = Join-Path $PSScriptRoot "..\assets\optimized"
if (-not (Test-Path $dest)) { New-Item -ItemType Directory -Path $dest | Out-Null }

$images = @(
    @{ url = 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=1600&auto=format&fit=crop&q=80'; out = 'lodge-3bed-1600.jpg' },
    @{ url = 'https://images.unsplash.com/photo-1595576508898-0ad5c879a061?w=1600&auto=format&fit=crop&q=80'; out = 'lodge-2bed-1600.jpg' },
    @{ url = 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=1600&auto=format&fit=crop&q=80'; out = 'standard-room-1600.jpg' },
    @{ url = 'https://images.unsplash.com/photo-1493666438817-866a91353ca9?w=1600&auto=format&fit=crop&q=80'; out = 'dorm-6bed-1600.jpg' }
)

foreach ($img in $images) {
    $outPath = Join-Path $dest $img.out
    Write-Host "Downloading $($img.url) -> $outPath"
    try {
        Invoke-WebRequest -Uri $img.url -OutFile $outPath -UseBasicParsing -ErrorAction Stop
    } catch {
        Write-Host "Failed to download $($img.url): $_" -ForegroundColor Red
    }
}

Write-Host "Done. Images saved to $dest"