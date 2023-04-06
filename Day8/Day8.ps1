using namespace System.Collections.Generic

function Invoke-Main {

    $list = Build-List -filename "testinput.txt"

    $visibleTrees = New-Object 'object[,]' $list[0].Count, $list[0][0].Count

    Invoke-TreeVisibilityFunction -list $list -visible $visibleTrees
    
    return $null

}

function Build-List([string]$filename) {

    $hList = [List[int[]]]::new()

    $lineInput = (Get-Content $filename) -split "`n"

    $null = foreach ($line in $lineInput) {

        $lineArray = $line.ToCharArray() | ForEach-Object { [convert]::ToInt32($_, 10) }

        $hList.Add($lineArray)

    }

    $vList = [List[int[]]]::new()

    for ( $x = 0; $x -lt $hList[0].Count; $x++) {

        $arr = @()

        for ( $y = 0; $y -lt $hList.Count; $y++ ) {
            
            $arr += $hList[$y][$x]    

        }

        $vList.Add($arr)

    }

    return @($hList, $vList)

}

function Invoke-TreeVisibilityFunction ($list, $visibleTrees) {

    for ( $y = 1; $y -lt ( $list[0].Count - 1 ); $y++ ) {

        for ( $x = 1; $x -lt ( $list[0][$y].Count - 1 ); $x++) {

            #Write-Information $list[0][$y][$x] -InformationAction Continue

            Search-AllDirections -y $y -x $x -list $list -visible $visibleTrees

        }

    }

    return $null
}

function Search-AllDirections ($y, $x, $list, $visibleTrees) {

    # check up
    if ( $list[0][$y][$x] -gt $list[0][$y - 1][$x] ) {
        Search-Direction -y $y -x $x -list $list[1][$x] -visible $visibleTrees
    }
    # check down
    if ( $list[0][$y][$x] -gt $list[0][$y + 1][$x] ) {
        Search-Direction -y $y -x $x -list [array]::Reverse($list[1][$x]) -visible $visibleTrees
    }
    # check left    
    if ( $list[0][$y][$x] -gt $list[0][$y][$x - 1] ) {
        Search-Direction -y $y -x $x -list $list[0][$y] -visible $visibleTrees
    }
    # check right
    if ( $list[0][$y][$x] -gt $list[0][$y][$x + 1] ) {
        Search-Direction -y $y -x $x -list [array]::Reverse($list[0][$y]) -visible $visibleTrees
    }
    return

}

function Search-Direction ($y, $x, $list, $visibleTrees) {

    for ( $i = 1; $i -lt ($list.count - 1); $i++) {

    }

    return $true    

}

Invoke-Main
