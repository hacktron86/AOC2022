Add-Type -AssemblyName System.Collections

function Get-MoveList {
    param ( $content )

        $movesList = New-Object System.Collections.ArrayList

        $moves =
        $content | 
        Select-String -Pattern '(?:move\s)(\d+)(?:\s)(?:from\s)(\d+)(?:\s)(?:to\s)(\d+)' -AllMatches

        foreach ( $move in $moves.Matches ) {
            [void]$movesList.Add(($move.Groups | Select-Object -Skip 1 -ExpandProperty Value))
        }

    return $movesList

}

function Get-CrateList {
    param ( $content,$colCount )

        $content = $content -split "`n"

        $crateList = New-Object System.Collections.ArrayList

        for ( $z = 0; $z -lt $colCount; $z++) {
            [void]$crateList.Add((New-Object System.Collections.Generic.LinkedList[char]))
        }
    for ( $y = 0; $y -lt ($content.length - 1); $y++) {
        $charArray = $content[$y].ToCharArray()
            $count = 0
            for ( $i = 1; $i -lt $charArray.length; $i += 4 ) {
                if ( ' ' -ne $charArray[$i]) {
                    [void]$crateList[$count].AddFirst($charArray[$i])
                }
                $count++
            }
    }
    return $crateList
}

function Get-ColumnCount {
    param ( $content )

        $content = $content -split "`n"

        $res =
        ($content -split "`n")[-1] |
        ForEach-Object {
            $_.replace(" ","").replace("\n\r","") |
                Select-String -Pattern '\d' -AllMatches |
                Select-Object -ExpandProperty Matches |
                Select-Object -ExpandProperty Value |
                Measure-Object -Maximum |
                Select-Object -ExpandProperty Maximum
        }

    return $res

}

function Move-CratesPartOne {
    param ( $movesList, [ref]$crateList )

        foreach ( $move in $movesList ) {

            $count = $move[0]
                $firstCol = $move[1] - 1
                $secondCol = $move[2] - 1

                for ($i = 0; $i -lt $count; $i ++) {

                    [void]$crateList.Value[$secondCol].Add(
                            $crateList.Value[$firstCol].last.value
                            )
                        [void]$crateList.Value[$firstCol].RemoveLast()

                }

        }

}

function Move-CratesPartTwo {
    param ( $movesList, [ref]$crateList )

        foreach ( $move in $movesList ) {

            $count = $move[0]
                $firstCol = $move[1] - 1
                $secondCol = $move[2] - 1

                $cratesToMove = $crateList.Value[$firstCol] | Select-Object -Last $count
                foreach ($crate in $cratesToMove) {
                    [void]$crateList.Value[$secondCol].Add(
                            $crate
                            )
                }
            for ($i = 0; $i -lt $count; $i ++) {

                [void]$crateList.Value[$firstCol].RemoveLast()

            }

        }

}

function Get-FinalCratesPartOne {
    param ( $file )

        $content = Get-Content $file -Raw
        $sections = $content -split "`n`r"

        $colCount = Get-ColumnCount -content $sections[0]

        $movesList = Get-MoveList -content $sections[1]

        $crateList = Get-CrateList -content $sections[0] -colCount $colCount

        Move-CratesPartOne -movesList $movesList -crateList ([ref]$crateList)

        $finalCrates = $crateList | ForEach-Object { $_.last.value } | Join-String
 
        return $finalCrates

}

function Get-FinalCratesPartTwo {
    param ( $file )

        $content = Get-Content $file -Raw
        $sections = $content -split "`n`r"

        $colCount = Get-ColumnCount -content $sections[0]

        $movesList = Get-MoveList -content $sections[1]

        $crateList = Get-CrateList -content $sections[0] -colCount $colCount

        Move-CratesPartTwo -movesList $movesList -crateList ([ref]$crateList)

        $finalCrates = $crateList | ForEach-Object { $_.last.value } | Join-String
 
        return $finalCrates

}

function Invoke-Main {
    param (
            [string]$file
          )

        $partOne = Get-FinalCratesPartOne -file $file

        $partTwo = Get-FinalCratesPartTwo -file $file

        return "PartOne: $partOne`n`nPartTwo: $partTwo"
}

Invoke-Main -file "input.txt"
