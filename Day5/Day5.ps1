Add-Type -AssemblyName System.Collections

function Get-FinalCrates {
    param ( $file )

        $content = Get-Content $file -Raw

        $cratesLL = New-Object System.Collections.ArrayList
#$res = New-Object System.Collections.Generic.LinkedList[char]
        $sections = $content -split "`n`r"
        $topSection = $sections[0] -split "`n"
        $bottomSection = $sections[1]

        $colCount = 
        $topSection[-1].replace(" ","").replace("\n\r","") | 
        Select-String -Pattern '\d' -AllMatches | 
        Select-Object -ExpandProperty Matches | 
        Select-Object -ExpandProperty Value |
        Measure-Object -Maximum |
        Select-Object -ExpandProperty Maximum

        for ( $z = 0; $z -lt $colCount; $z++) {
            [void]$cratesLL.Add((New-Object System.Collections.Generic.LinkedList[char]))
        }

    for ( $y = 0; $y -lt ($topSection.length - 1); $y++) {
        $charArray = $topSection[$y].ToCharArray()
            $count = 0
            for ( $i = 1; $i -lt $charArray.length; $i += 4 ) {
                if ( ' ' -ne $charArray[$i]) {
                    [void]$cratesLL[$count].AddFirst($charArray[$i])
                }
                $count++
            }
    }

    $moves =
        $bottomSection | 
        Select-String -Pattern '(?:move\s)(\d)(?:\s)(?:from\s)(\d)(?:\s)(?:to\s)(\d)' -AllMatches

    $movesList = New-Object System.Collections.ArrayList

    foreach ( $move in $moves.Matches ) {
        $movesList.Add(($move.Groups | Select-Object -Skip 1 -ExpandProperty Value))
        }

    return $cratesLL

}

function Invoke-Main {
    param (
            [string]$file
          )

        $partOne = Get-FinalCrates -file $file

        $partwo = "" 

        return $partOne
        #return "PartOne: `n$partOne `n`n| PartTwo: `n$partwo"
}

Invoke-Main -file "testinput.txt"
