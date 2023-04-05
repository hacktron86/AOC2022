using namespace System.Collections.Generic

function Invoke-Main {

    [List[Int[]]]$list = Build-List -filename "testinput.txt"

    return $list

}

function Build-List([string]$filename) {
    [OutputType([List[Int[]]])]

    $list = [List[int[]]]::new()

    $lineInput = (Get-Content $filename) -split "`n"

    foreach ($line in $lineInput) {

        $lineArray = $line.ToCharArray() | ForEach-Object { [convert]::ToInt32($_, 10) }

        $list.Add($lineArray)

    }

    $visibleTrees = New-Object 'object[,]' $list.Count,$list[0].Count

    Invoke-TreeVisibilityFunction -list $list -visible $visibleTrees

    return $null

}

function Invoke-TreeVisibilityFunction ([List[Int[]]]$list,$visibleTrees) {

    for ( $y = 1; $y -lt ( $list.Count - 1 ); $y++ ) {

        for ( $x = 1; $x -lt ( $list[$y].Count - 1 ); $x++) {

            Write-Information $list[$y][$x] -InformationAction Continue

            Search-AllDirections -y $y -x $x -list $list -visible $visibleTrees

        }

    }

    return $null
}

function Search-AllDirections ($y, $x, $list, $visibleTrees) {

    # check up
    if ( $list[$y][$x] -gt $list[$y-1][$x] ) {
        Search-Direction -y $y -x $x -list $list -visible $visibleTrees -direction "up"
    }
    # check down
    if ( $list[$y][$x] -gt $list[$y+1][$x] ) {
        $true
    }
    # check left    
    if ( $list[$y][$x] -gt $list[$y][$x-1] ) {
        $true
    }
    # check right
    if ( $list[$y][$x] -gt $list[$y][$x+1] ) {
        $true
    }
    return

}

function Search-Direction ($y, $x, $list, $visibleTrees, $direction) {

    switch ($direction) {
        "up" {  }
        Default {}
    }

}

Invoke-Main
