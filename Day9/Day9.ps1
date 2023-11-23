using namespace System.Collections.Generic

class Coords {
    [int] $x
    [int] $y

    Coords($x, $y) {
        $this.x = $x
        $this.y = $y
    }
}

function Set-Coordinates([RopeEnd]$ropeEnd, [char[, ]]$grid, [int]$minX, [int]$minY) {
    #set coordinates for current rope end
    $coord = $ropeEnd.history[-1]  # Get the last coordinate only
    $a = $coord.y - $minY
    $b = $coord.x - $minX
    $grid[$a, $b] = $ropeEnd.name

    if ($ropeEnd.child) {
        Set-Coordinates $ropeEnd.child $grid $minX $minY
    }
}

function ConvertTo-AsciiGrid([RopeEnd]$ropeEnd) {
    $minX = [int]::MaxValue
    $maxX = [int]::MinValue
    $minY = [int]::MaxValue
    $maxY = [int]::MinValue

    # set min x and y to -12 and max x and y to 12
    $minX = -15
    $maxX = 15
    $minY = -15
    $maxY = 15

    # Create the ASCII grid
    $grid = New-Object 'char[,]' ($maxY - $minY + 1), ($maxX - $minX + 1)

    # fill the grid with .
    for ($y = 0; $y -lt $grid.GetLength(0); $y++) {
        for ($x = 0; $x -lt $grid.GetLength(1); $x++) {
            $grid[$y, $x] = '.'
        }
    }

    # Set the coordinates onto the grid
    Set-Coordinates $ropeEnd $grid $minX $minY

    # reset grid position 15,15 to S
    $grid[15, 15] = 's'

    # Print the ASCII grid
    for ($y = $grid.GetLength(0); $y -gt 0; $y--) {
        for ($x = 0; $x -lt $grid.GetLength(1); $x++) {
            if ($null -eq $grid[$y, $x]) {
                Write-Host ' ' -NoNewline
            }
            else {
                Write-Host $grid[$y, $x] -NoNewline
            }
        }
        Write-Host
    }
}


class RopeEnd {
    [string] $name
    [int] $x
    [int] $y
    [Coords[]] $history
    [RopeEnd] $child

    RopeEnd($name) {
        $this.name = $name
        $this.x = 0
        $this.y = 0
        $this.Update()
    }

    [string] getState() {
        if ($null -ne $this.child) {
            return "$($this.name): $($this.x), $($this.y) -> $($this.child.getState())"
        }
        return "$($this.name): $($this.x), $($this.y)"
    }

    [void] Drag([string]$coord, [int]$value) {
        switch ($coord) {
            "x" { $this.x = $value; }
            "y" { $this.y = $value; }
        }
    }

    # method to move the rope end diagnoally
    [void] MoveDiagonal([string]$direction, [int]$count) {
        switch ($direction) {
            "RU" { $this.x = $this.x + $count; $this.y = $this.y + $count; }
            "RD" { $this.x = $this.x + $count; $this.y = $this.y - $count; }
            "LU" { $this.x = $this.x - $count; $this.y = $this.y + $count; }
            "LD" { $this.x = $this.x - $count; $this.y = $this.y - $count; }
        }
        # Write-Verbose "$($this.name): $($this.x), $($this.y)"
        if ($null -ne $this.child) {
            if ([Math]::Abs($this.child.x - $this.x) -eq 2 -and [Math]::Abs($this.child.y - $this.y) -eq 2) {
                if ($this.x -gt $this.child.x) {
                    if ($this.y -gt $this.child.y) {
                        $this.child.MoveDiagonal("RU", $count)
                    }
                    else {
                        $this.child.MoveDiagonal("RD", $count)
                    }
                }
                else {
                    if ($this.y -gt $this.child.y) {
                        $this.child.MoveDiagonal("LU", $count)
                    }
                    else {
                        $this.child.MoveDiagonal("LD", $count)
                    }
                }
            }
            else {
                if ([Math]::Abs($this.child.x - $this.x) -gt 1) {
                    if ([Math]::Abs($this.child.y - $this.y) -gt 0) {
                        $this.child.Drag("y", $this.y)
                        if ($this.x -gt $this.child.x) {
                            $this.child.Move("R", $count)
                        }
                        else {
                            $this.child.Move("L", $count)
                        }
                    }
                    else {
                        if ($this.x -gt $this.child.x) {
                            $this.child.Move("R", $count)
                        }
                        else {
                            $this.child.Move("L", $count)
                        }
                    }
                }
                if (
                    [Math]::Abs($this.child.y - $this.y) -gt 1
                ) {
                    if ([Math]::Abs($this.child.x - $this.x) -gt 0) {
                        $this.child.Drag("x", $this.x)
                        if ($this.y -gt $this.child.y) {
                            $this.child.Move("U", $count)
                        }
                        else {
                            $this.child.Move("D", $count)
                        }
                    }
                    else {
                        if ($this.y -gt $this.child.y) {
                            $this.child.Move("U", $count)
                        }
                        else {
                            $this.child.Move("D", $count)
                        }
                    }
                }
            }
        }
        $this.Update()
    }


    [void] Move([string]$direction, [int]$count) {
        switch ($direction) {
            "R" { $this.x = $this.x + $count; }
            "L" { $this.x = $this.x - $count; }
            "U" { $this.y = $this.y + $count; }
            "D" { $this.y = $this.y - $count; }
        }
        # Write-Verbose "$($this.name): $($this.x), $($this.y)"
        if ($null -ne $this.child) {
            if ([Math]::Abs($this.child.x - $this.x) -eq 2 -and [Math]::Abs($this.child.y - $this.y) -eq 2) {
                if ($this.x -gt $this.child.x) {
                    if ($this.y -gt $this.child.y) {
                        $this.child.MoveDiagonal("RU", $count)
                    }
                    else {
                        $this.child.MoveDiagonal("RD", $count)
                    }
                }
                else {
                    if ($this.y -gt $this.child.y) {
                        $this.child.MoveDiagonal("LU", $count)
                    }
                    else {
                        $this.child.MoveDiagonal("LD", $count)
                    }
                }
            }
            else {
                if ([Math]::Abs($this.child.x - $this.x) -gt 1) {
                    if ([Math]::Abs($this.child.y - $this.y) -gt 0) {
                        $this.child.Drag("y", $this.y)
                        if ($this.x -gt $this.child.x) {
                            $this.child.Move("R", $count)
                        }
                        else {
                            $this.child.Move("L", $count)
                        }
                    }
                    else {
                        if ($this.x -gt $this.child.x) {
                            $this.child.Move("R", $count)
                        }
                        else {
                            $this.child.Move("L", $count)
                        }
                    }
                }
                if (
                    [Math]::Abs($this.child.y - $this.y) -gt 1
                ) {
                    if ([Math]::Abs($this.child.x - $this.x) -gt 0) {
                        $this.child.Drag("x", $this.x)
                        if ($this.y -gt $this.child.y) {
                            $this.child.Move("U", $count)
                        }
                        else {
                            $this.child.Move("D", $count)
                        }
                    }
                    else {
                        if ($this.y -gt $this.child.y) {
                            $this.child.Move("U", $count)
                        }
                        else {
                            $this.child.Move("D", $count)
                        }
                    }
                }
            }
        }
        $this.Update()
    }

    [void] Update() {
        $this.history += [Coords]::new($this.x, $this.y)
    }

}

function Invoke-Main {

    [CmdletBinding()]
    param()

    $list = Build-List -filename "input.txt"

    #
    # Part 1
    #

    $head = [RopeEnd]::new("head")

    $head.child = [RopeEnd]::new("tail")

    $tail = $head.child

    $cur = $head

    $count = 0

    foreach ($line in $list) {
        # Write-Verbose "Line: $count" 
        $count++
        for ($i = 0; $i -lt $line.Count; $i++) {
            $head.Move($line.Move, 1)
        }
    }

    $tailCount = $tail.history | Select-Object -Property x, y -Unique | Measure-Object | Select-Object -ExpandProperty Count

    Write-Verbose "DayOne: $tailCount"

    #
    # Part 2
    #

    $head = $tail = $cur = $null

    $head = [RopeEnd]::new("h")

    $cur = $head

    for ( $i = 1; $i -le 9; $i++ ) {

        $cur.child = [RopeEnd]::new("$i")

        $cur = $cur.child

    }

    $tail = $cur

    $cur = $head

    $count = 0

    foreach ($line in $list) {
        # Write-Verbose "Line: $count" 
        $count++
        for ($i = 0; $i -lt $line.Count; $i++) {
            # Write-Verbose "Move: $i" 
            $head.Move($line.Move, 1)
            # if ($count -eq 5) {
            #     ConvertTo-AsciiGrid -ropeEnd $head
            # }
            # Write-Host "$($head.getState())"
            # Write-Host ""
        }
        # ConvertTo-AsciiGrid -ropeEnd $head
    }

    $tailCount = $tail.history | Select-Object -Property x, y -Unique | Measure-Object | Select-Object -ExpandProperty Count

    Write-Verbose "DayTwo: $tailCount"

    return $null

}


function Build-List {
    param (
        $filename
    )

    $string = Select-String -Path $filename -Pattern '(?<Move>[A-Z])\s(?<Count>\d+)'

    $res = @()

    foreach ($line in $string) {

        $res += [PSCustomObject]@{
            Move  = $line.Matches.Captures.Groups[1].Value
            Count = $line.Matches.Captures.Groups[2].Value
        }

    }

    return $res

}

Invoke-Main -Verbose