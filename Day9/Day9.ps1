using namespace System.Collections.Generic

class Coords {
    [int] $x
    [int] $y

    Coords($x, $y) {
        $this.x = $x
        $this.y = $y
    }
}

class RopeEnd {
    [string] $name
    [int] $x
    [int] $y
    [Coords[]] $history

    RopeEnd($name) {
        $this.name = $name
        $this.x = 0
        $this.y = 0
        $this.Update()
    }

    [void] Move([string]$direction, [int]$count) {
        switch ($direction) {
            "R" { $this.x = $this.x + $count }
            "L" { $this.x = $this.x - $count }
            "U" { $this.y = $this.y + $count }
            "D" { $this.y = $this.y - $count }
        }
    }

    [void] Update() {
        $temp = [Coords]::new($this.x, $this.y)
        $this.history += $temp
    }

}

function Invoke-Main {

    [CmdletBinding()]
    param()

    $list = Build-List -filename "input.txt"

    $head = [RopeEnd]::new("head")

    $tail = [RopeEnd]::new("tail")
            
    # Write-Verbose "Head - x: $($head.x); y: $($head.y);" 
    # Write-Verbose "Tail - x: $($tail.x); y: $($tail.y);" 
    # Write-Verbose "End"

    $count = 0
    Write-Verbose "Total Lines: $($list.count)"

    foreach ($line in $list) {
        Write-Verbose "Line: $count" 
        $count++
        for ($i = 0; $i -lt $line.Count; $i++) {
            $head.Move($line.Move, 1)

            $xDiff = $head.x - $tail.x
            $xDiffAbs = [Math]::Abs($xDiff)
            $yDiff = $head.y - $tail.y
            $yDiffAbs = [Math]::Abs($yDiff)

            if ($xDiffAbs -eq 2) {
                if ($head.x -lt $tail.x) {
                    $tail.Move("L", 1)
                }
                else {
                    $tail.Move("R", 1)
                }
                $tail.y = $head.y
            }
            if ($yDiffAbs -eq 2) {
                if ($head.y -lt $tail.y) {
                    $tail.Move("D", 1)
                }
                else {
                    $tail.Move("U", 1)
                }
                $tail.x = $head.x
            }
            $tail.Update()
            
            # Write-Verbose "Head - x: $($head.x); y: $($head.y);" 
            # Write-Verbose "Tail - x: $($tail.x); y: $($tail.y);" 
            # Write-Verbose "End"

            # Write-Verbose ""

        }
    }

    $tailCount = $tail.history | Select-Object -Property x, y -Unique | Measure-Object | Select-Object -ExpandProperty Count

    Write-Verbose "DayOne: $tailCount"

    return $tail

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