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
    }

    [void] Move([string]$direction, [int]$count) {
        $temp = [Coords]::new($this.x,$this.y)
        $dup = $false
        foreach ($coord in $this.history) {
            if ( -not (Compare-Object $coord $temp -Property {$_.x},{$_.y})) {
                $dup = $true
            }
        }
        if (-not $dup) {
            $this.history += $temp
        }
        switch ($direction) {
            "R" { $this.x = $this.x + $count }
            "L" { $this.x = $this.x - $count }
            "U" { $this.y = $this.y + $count }
            "D" { $this.y = $this.y - $count }
        }
    }

}

function Invoke-Main {

    [CmdletBinding()]
    param()

    $list = Build-List -filename "testinput.txt"

    $head = [RopeEnd]::new("head")

    $tail = [RopeEnd]::new("tail")

    foreach ($line in $list) {
        for ($i = 0; $i -lt $line.Count; $i++) {
            Write-Verbose "Head - x: $($head.x); y: $($head.y);" 
            Write-Verbose "Tail - x: $($tail.x); y: $($tail.y);" 
            $head.Move($line.Move, 1)

            $xDiff = $head.x - $tail.x
            $xDiffAbs = [Math]::Abs($xDiff)
            $yDiff = $head.y - $tail.y
            $yDiffAbs = [Math]::Abs($yDiff)

            if ($xDiffAbs -eq 2) {
                if($xDiff -lt 0) {
                    $tail.Move("L",1)
                } else {
                    $tail.Move("R",1)
                }
                $tail.y = $head.y
            }
            if ($yDiffAbs -eq 2) {
                if($xDiff -lt 0) {
                    $tail.Move("D",1)
                } else {
                    $tail.Move("U",1)
                }
                $tail.x = $head.x
            }
            
            Write-Verbose ""
        }
    }

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

Invoke-Main -verbose