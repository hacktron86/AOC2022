$textinput = @"
Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi
"@

$buffer = (($textinput -split "`n") |  Where-Object { $null -ne $_ }) | ForEach-Object { $_.ToCharArray() }
$intBuffer = @()

foreach ($char in $buffer) {
    switch -regex -casesensitive ($char) {
        '[S]' { $intBuffer += 0 }
        '[E]' { $intBuffer += 27 }
        default { $intBuffer += [int][char]$char - 96 }
    }
}

# create two dimensional grid array then loop through intbuffer putting every 8 items into a new line of the grid
$grid = New-Object 'int[,]' 8, 5
$charGrid = New-Object 'char[,]' 8, 5
for ($j = 0; $j -lt 5; $j++) {
    for ($i = 0; $i -lt 8; $i++) {
        $grid[$i, $j] = $intBuffer[$j * 8 + $i]
        $charGrid[$i, $j] = $buffer[$j * 8 + $i]
    }
}

for ($j = 0; $j -lt 5; $j++) {
    for ($i = 0; $i -lt 8; $i++) {
        switch ($grid[$i, $j]) {
            0 { $start = @($i, $j) }
            27 { $end = @($i, $j) }
        }
    }
}

class coords:ICloneable {
    
    [Object] Clone () {
        $newCoords = [coords]::new($this.x, $this.y)
        return $newCoords
    }

    [int]$x
    [int]$y

    coords([int]$x, [int]$y) {
        $this.x = $x
        $this.y = $y
    }
}

function checkHistory {
    param (
        [object]$pathHistory,
        [coords[]]$curPath,
        [coords]$coords
    )
    if ($pathHistory.count -gt 0) {
        foreach ($path in $pathHistory[0..($pathHistory.count - 2)]) {
            $ref = $path[$curPath.count]
            if ($ref.x -eq $coords.x -and $ref.y -eq $coords.y) {
                return $true
                break
            }
        }
    }
    foreach ($path in $curPath) {
        if ($path.x -eq $coords.x -and $path.y -eq $coords.y) {
            return $true
            break
        }
    }
    return $false
}

function checkLegalMoves {
    param (
        [int[, ]]$grid,
        [coords]$coords,
        [object]$pathHistory,
        [coords[]]$curPath
    )
    $legalMoves = [pscustomobject]@{
        U = $false
        D = $false
        L = $false
        R = $false
    }
    $moves = [pscustomobject]@{
        U = [coords]::new($coords.x, $coords.y - 1)
        D = [coords]::new($coords.x, $coords.y + 1)
        L = [coords]::new($coords.x - 1, $coords.y)
        R = [coords]::new($coords.x + 1, $coords.y)
    }
    if (
        $coords.x - 1 -ge 0 -and 
        $grid[$moves.L.x, $moves.L.y] - $grid[$coords.x, $coords.y] -le 1
    ) {
        if (!(checkHistory -pathHistory $pathHistory -curPath $curPath -coords $moves.L)) {
            $legalMoves.L = $true
        }
    }
    if (
        $coords.x + 1 -le 8 -and 
        $grid[$moves.R.x, $moves.R.y] - $grid[$coords.x, $coords.y] -le 1
    ) {
        if (!(checkHistory -pathHistory $pathHistory -curPath $curPath -coords $moves.R)) {
            $legalMoves.R = $true
        }
    }
    if (
        $coords.y - 1 -ge 0 -and 
        $grid[$moves.U.x, $moves.U.y] - $grid[$coords.x, $coords.y] -le 1
    ) {
        if (!(checkHistory -pathHistory $pathHistory -curPath $curPath -coords $moves.U)) {
            $legalMoves.U = $true
        }
    }
    if (
        $coords.y + 1 -le 4 -and 
        $grid[$moves.D.x, $moves.D.y] - $grid[$coords.x, $coords.y] -le 1 
    ) {
        if (!(checkHistory -pathHistory $pathHistory -curPath $curPath -coords $moves.D)) {
            $legalMoves.D = $true
        }
    }
    return $legalMoves
}

function moveCoords {
    param (
        [coords]$coords,
        [pscustomobject]$legalMoves
    )
    if ($legalMoves.U -eq $true) {
        $coords.y -= 1
        return $coords
        break
    }
    if ($legalMoves.D -eq $true) {
        $coords.y += 1
        return $coords
        break
    }
    if ($legalMoves.L -eq $true) {
        $coords.x -= 1
        return $coords
        break
    }
    if ($legalMoves.R -eq $true) {
        $coords.x += 1
        return $coords
        break
    }
    throw "No legal moves"
}


$pathHistory = @()
$noMorePaths = $false 
while ($noMorePaths -eq $false) {
    $end = $false
    $curPath = @()
    $coords = [coords]::new($start[0], $start[1])
    Write-Host "Path Count: $($pathHistory.count)"
    while ($end -eq $false) {
        Write-Host "Current Path Coords: $($coords.x), $($coords.y)"
        if ($grid[$coords.x, $coords.y] -eq 27) {
            $end = $true
        }
        $curPath += $coords.Clone()
        $legalMoves = checkLegalMoves -grid $grid -coords $coords -pathHistory $pathHistory -curPath $curPath
        try {
            $coords = moveCoords -coords $coords -legalMoves $legalMoves
        }
        catch {
            $end = $true
        }
    }
    if ($curPath.count -eq 1) {
        $noMorePaths = $true
    }
    $pathHistory += ,$curPath
}

Write-Host "break"