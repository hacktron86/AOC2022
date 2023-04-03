$script:data = [System.Collections.Generic.List[PSCustomObject]]::new()
$script:bounds = @{}
#$script:dataArr = New-Object 'object[,]' 100,100

function Invoke-Main {

    Build-List -filename "input.txt"
    #Build-Array -filename "testinput.txt"

    Update-EdgesToVisible

    Update-VisibleTreeCount

    return $script:data.Visible | Where-Object { $_ -eq $true } | Measure-Object | Select-Object -ExpandProperty Count

}

function Build-Array([string]$filename) {
    $lineInput = (Get-Content $filename) -split "`n"
    $rowCount = 0
    foreach ($line in $lineInput) {
        $lineArray = $line.ToCharArray()
        $columnCount = 0
        foreach ($char in $lineArray) {
            $script:dataArr[$rowCount, $columnCount] = [PSCustomObject]@{
                treeHeight = [System.Int32]::Parse($char)
                visible    = $false
            }
            $columnCount++
        }
        $rowCount++
    }
    $script:bounds.Add("rowMin", 0)
    $script:bounds.Add("rowMax", $rowCount)
    $script:bounds.Add("colMin", 0)
    $script:bounds.Add("colMax", $rowCount)
    return $null
}

function Update-EdgesToVisible {
    foreach ( $tree in $script:data ) {
        if ( 
            $tree.column -eq $script:bounds["colMin"] -or
            $tree.column -eq $script:bounds["colMax"] -or
            $tree.row -eq $script:bounds["rowMin"] -or
            $tree.row -eq $script:bounds["rowMax"]
        ) {
            $tree.visible = $true
        }
    } 
}

function Update-VisibleTreeCount() {
    for ( $y = 1; $y -lt $script:bounds["rowMax"]; $y++ ) {
        Write-Information "Row $y" -InformationAction Continue
        for ( $x = 1; $x -lt $script:bounds["colMax"]; $x++ ) {
            Write-Information "Column $x" -InformationAction Continue
            $cur = $script:data | Where-Object { $_.column -eq $x -and $_.row -eq $y } 
            if ( $cur.visible -eq $false ) {
                $left = $script:data | Where-Object { $_.column -eq $x - 1 -and $_.row -eq $y } 
                $right = $script:data | Where-Object { $_.column -eq $x + 1 -and $_.row -eq $y } 
                $up = $script:data | Where-Object { $_.column -eq $x -and $_.row -eq $y - 1 } 
                $down = $script:data | Where-Object { $_.column -eq $x -and $_.row -eq $y + 1 } 
                #check from left
                if ( $cur.treeHeight -gt $left.treeHeight ) {
                    $maxLeft = $script:data | Where-Object { $_.row -eq $y -and $_.column -lt $x } | Measure-Object -Maximum -Property treeHeight | Select-Object -ExpandProperty Maximum
                    if ( $cur.treeHeight -gt $maxLeft) {
                        $cur.visible = $true
                    }
                }
                #check from right
                if ( $cur.treeHeight -gt $right.treeHeight -and $cur.visible -eq $false) {
                    $maxRight = $script:data | Where-Object { $_.row -eq $y -and $_.column -gt $x } | Measure-Object -Maximum -Property treeHeight | Select-Object -ExpandProperty Maximum
                    if ( $cur.treeHeight -gt $maxRight) {
                        $cur.visible = $true
                    }
                }
                #check from top
                if ( $cur.treeHeight -gt $up.treeHeight -and $cur.visible -eq $false ) {
                    $maxUp = $script:data | Where-Object { $_.column -eq $x -and $_.row -lt $y } | Measure-Object -Maximum -Property treeHeight | Select-Object -ExpandProperty Maximum
                    if ( $cur.treeHeight -gt $maxUp) {
                        $cur.visible = $true
                    }
                }
                #check from bottom
                if ( $cur.treeHeight -gt $down.treeHeight -and $cur.visible -eq $false ) {
                    $maxDown = $script:data | Where-Object { $_.column -eq $x -and $_.row -lt $y } | Measure-Object -Maximum -Property treeHeight | Select-Object -ExpandProperty Maximum
                    if ( $cur.treeHeight -gt $maxDown) {
                        $cur.visible = $true
                    }
                }
            }
        }
    }
}

function Build-List([string]$filename) {
    $lineInput = (Get-Content $filename) -split "`n"
    $rowCount = 0
    foreach ($line in $lineInput) {
        $lineArray = $line.ToCharArray()
        $columnCount = 0
        foreach ($char in $lineArray) {
            $script:data.Add(
                [PSCustomObject]@{
                    treeHeight = [System.Int32]::Parse($char)
                    row        = $rowCount
                    column     = $columnCount
                    visible    = $false
                }
            )
            $columnCount++
        }
        $rowCount++
    }
    $script:bounds.Add("rowMin", 0)
    $script:bounds.Add("rowMax", $rowCount)
    $script:bounds.Add("colMin", 0)
    $script:bounds.Add("colMax", $rowCount)
    return $null
}

Invoke-Main