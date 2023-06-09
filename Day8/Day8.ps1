using namespace System.Collections.Generic

function Invoke-Main {

    $list = Build-List -filename "input.txt"

    Invoke-TreeVisibilityFunction -list $list

    $dayOne = Get-VisibleTreeCount -list $list[2]

    Write-Information "DayOne Answer: $dayOne" -InformationAction Continue

    $dayTwo = Get-MaxScenicScore -list $list[3]

    Write-Information "DayTwo Answer: $dayTwo" -InformationAction Continue
    
    return $list

}

function Get-MaxScenicScore($list) {

    $res = foreach ($row in $list) {
        $row
    } 

    return $res | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum

}

function Get-VisibleTreeCount($list) {

    $res = foreach ($row in $list) {
        $row | Where-Object { $_ -eq $true }
    }

    return $res | Measure-Object | Select-Object -ExpandProperty Count

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

    $visibleList = [List[bool[]]]::new()

    for ( $y = 0; $y -lt $lineInput.Length; $y++ ) {

        $temp = for ( $x = 0; $x -lt $lineInput[0].Length; $x++ ) {

            if (
                    (($y -eq 0) -or ($y -eq $lineInput.Length - 1)) -or
                    (($x -eq 0) -or ($x -eq $lineInput[0].Length - 1))
            ) {
                $true
            }
            else {
                $false
            }
        }

        $visibleList.Add($temp)

    }

    $scenicScore = [List[int[]]]::new()

    for ( $y = 0; $y -lt $lineInput.Length; $y++ ) {

        $temp = for ( $x = 0; $x -lt $lineInput[0].Length; $x++ ) {

            0

        }

        $scenicScore.Add($temp)

    }

    return @($hList, $vList, $visibleList, $scenicScore)

}

function Invoke-TreeVisibilityFunction ($list) {

    for ( $y = 1; $y -lt ( $list[0].Count - 1 ); $y++ ) {

        for ( $x = 1; $x -lt ( $list[0][$y].Count - 1 ); $x++) {

            $list[2][$y][$x] = Search-AllDirections -y $y -x $x -list $list

            $list[3][$y][$x] = Get-ScenicScore -y $y -x $x -list $list

            Write-Information "Scenic Score: $($list[3][$y][$x])"

        }

    }

    return $null

}

function Get-ScenicScore ($y, $x, $list) {

    # check up
    $up = Get-SSOneDirection -y $y -x $x -list $list[1][$x][0..$y]

    # check down
    $temp = ($list[1][$x][$y..($list[1][$x].length - 1)]).clone()
    [array]::Reverse($temp)
    $down = Get-SSOneDirection -y $y -x $x -list $temp 

    # check left    
    $left = Get-SSOneDirection -y $y -x $x -list $list[0][$y][0..$x]

    # check right
    $temp = ($list[0][$y][$x..($list[0][$y].length - 1)]).clone()
    [array]::Reverse($temp)
    $right = Get-SSOneDirection -y $y -x $x -list $temp

    return $up * $down * $left * $right

}

function Get-SSOneDirection ($y, $x, $list) {

    $max = 0

    $count = 0

    for ( $i = ($list.count - 2); $i -ge 0; $i-- ) {

        $count++

        if ( $max -lt $list[$i]) {

            $max = $list[$i]

        }

        if ( $max -ge $list[-1] ) {

            return $count

        }

    }

    return $count

}

function Search-AllDirections ($y, $x, $list) {

    # check up
    if ( $list[0][$y][$x] -gt $list[0][$y - 1][$x] ) {
        if ( Search-Direction -y $y -x $x -list $list[1][$x][0..$y] ) {
            return $true
        }
    }
    # check down
    if ( $list[0][$y][$x] -gt $list[0][$y + 1][$x] ) {
        $temp = ($list[1][$x][$y..($list[1][$x].length-1)]).clone()
        [array]::Reverse($temp)
        if ( Search-Direction -y $y -x $x -list $temp ) {
            return $true
        }
    }
    # check left    
    if ( $list[0][$y][$x] -gt $list[0][$y][$x - 1] ) {
        if ( Search-Direction -y $y -x $x -list $list[0][$y][0..$x] ) {
            return $true
        }
    }
    # check right
    if ( $list[0][$y][$x] -gt $list[0][$y][$x + 1] ) {
        $temp = ($list[0][$y][$x..($list[0][$y].length-1)]).clone()
        [array]::Reverse($temp)
        if ( Search-Direction -y $y -x $x -list $temp ) {
            return $true
        }
    }
    return $false

}

function Search-Direction ($y, $x, $list) {

    $max = 0

    for ( $i = 0; $i -lt ($list.count - 1); $i++ ) {

        if ( $list[-1] -lt $list[$i] ) {

            return $false

        }

        if ( $max -lt $list[$i]) {

            $max = $list[$i]

        }

    }

    if ( $max -ge $list[-1] ) {

        return $false

    } else {

    return $true    

    }

}

Invoke-Main
