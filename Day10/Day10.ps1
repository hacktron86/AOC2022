using namespace System.Collections.Generic

$data = ((Get-Content -Path .\input.txt) -split [System.Environment]::NewLine) -split " "

$x = 1
$y = 0
$cycle = 0
$signalStrengthSum = 0

for ($i = 0; $i -lt $data.count; $i++) {
    $cycle++
    if (($cycle + 20) % 40 -eq 0) {
        # Write-Host "Cycle $($cycle): $($x * $cycle)"
        # Write-Host "X: $($x)"
        $signalStrengthSum = $signalStrengthSum + ($x * $cycle)
    }
    if ([int]::TryParse($data[$i], [ref]$y)) {
        $x = $x + $y
    }
}

Write-Host "PartOne: $($signalStrengthSum)"

$x = 1
$y = 0
$cycle = 0
$crtPos = 0
$pixels = @()

Write-Host "PartTwo:"

for ($i = 0; $i -lt $data.count; $i++) {
    $cycle++
    $crtPos++
    # Write-Host "Cycle: $($cycle); X: $($x)"
    if ($crtPos -ge ($x) -and $crtPos -le ($x + 2)) {
        $pixels += '#'
    }
    else {
        $pixels += '.'
    }
    if ([int]::TryParse($data[$i], [ref]$y)) {
        $x = $x + $y
    }
    if ($crtPos -eq 40) {
        $crtPos = 0
    }
}

for ($z = 0; $z -lt $pixels.count; $z++) {
    Write-Host $pixels[$z] -NoNewline
    if (($z + 1) % 40 -eq 0) {
        Write-Host 
    }
}

Write-Host