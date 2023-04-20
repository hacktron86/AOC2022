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
    [RopeEnd] $child

    RopeEnd($name) {
        $this.name = $name
        $this.x = 0
        $this.y = 0
        $this.Update()
    }

    [void] Move([string]$direction, [int]$count, [int]$adjust) {
        switch ($direction) {
            "R" { $this.x = $this.x + $count; if ($this.name -ne "head") { $this.y = $adjust } }
            "L" { $this.x = $this.x - $count; if ($this.name -ne "head") { $this.y = $adjust } }
            "U" { $this.y = $this.y + $count; if ($this.name -ne "head") { $this.x = $adjust } }
            "D" { $this.y = $this.y - $count; if ($this.name -ne "head") { $this.x = $adjust } }
        }
        $this.Update()
        if ($null -ne $this.child) {
            $xDiff = $this.x - $this.child.x
            $xDiffAbs = [Math]::Abs($xDiff)
            $yDiff = $this.y - $this.child.y
            $yDiffAbs = [Math]::Abs($yDiff)

            if (($xDiffAbs -eq 2) -and ($yDiffAbs -ne 2)) {
                if ($this.x -lt $this.child.x) {
                    $this.child.Move("L", 1, $this.y)
                }
                else {
                    $this.child.Move("R", 1, $this.y)
                }
            }
            if (($yDiffAbs -eq 2) -and ($xDiffAbs -ne 2)) {
                if ($this.y -lt $this.child.y) {
                    $this.child.Move("D", 1, $this.x)
                }
                else {
                    $this.child.Move("U", 1, $this.x)
                }
            }
            if (($yDiffAbs -eq 2) -and ($xDiffAbs -eq 2)) {
                if ($this.y -lt $this.child.y) {
                    $this.child.Move("D", 2, $this.x)
                }
                else {
                    $this.child.Move("U", 2, $this.x)
                }
            }
        }
    }

    [void] Update() {
        $this.history += [Coords]::new($this.x, $this.y)
    }

}

function Invoke-Main {

    [CmdletBinding()]
    param()

    $list = Build-List -filename "testinput.txt"

    $head = [RopeEnd]::new("head")

    $head.child = [RopeEnd]::new("2")

    $cur = $head.child

    for ( $i = 3; $i -lt 10; $i++ ) {

        $cur.child = [RopeEnd]::new("$i")

        $cur = $cur.child

    }

    $tail = [RopeEnd]::new("tail")

    $cur.child = $tail

    $cur = $head

    $exit = $false

    Do {
        Write-Verbose "$($cur.name); $($cur.x); $($cur.y);"
        if ($null -eq $cur.child) { $exit = $true }
        $cur = $cur.child
    } While ($exit -eq $false)
            
    # Write-Verbose "Head - x: $($head.x); y: $($head.y);" 
    # Write-Verbose "Tail - x: $($tail.x); y: $($tail.y);" 
    # Write-Verbose "End"

    $count = 0
    Write-Verbose "Total Lines: $($list.count)"

    foreach ($line in $list) {
        Write-Verbose "Line: $count" 
        $count++
        for ($i = 0; $i -lt $line.Count; $i++) {
            $head.Move($line.Move, 1, $null)
            # $xDiff = $head.x - $tail.x
            # $xDiffAbs = [Math]::Abs($xDiff)
            # $yDiff = $head.y - $tail.y
            # $yDiffAbs = [Math]::Abs($yDiff)

            # if ($xDiffAbs -eq 2) {
            #     if ($head.x -lt $tail.x) {
            #         $tail.Move("L", 1)
            #     }
            #     else {
            #         $tail.Move("R", 1)
            #     }
            #     $tail.y = $head.y
            # }
            # if ($yDiffAbs -eq 2) {
            #     if ($head.y -lt $tail.y) {
            #         $tail.Move("D", 1)
            #     }
            #     else {
            #         $tail.Move("U", 1)
            #     }
            #     $tail.x = $head.x
            # }
            # $tail.Update()
            $cur = $head
            $exit = $false
            Do {
                Write-Verbose "$($cur.name); $($cur.x); $($cur.y);"
                if ($null -eq $cur.child) { $exit = $true }
                $cur = $cur.child
            } While ($exit -eq $false)
            
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