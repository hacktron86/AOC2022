using namespace System.Collections.Generic

function Invoke-Main {

    $list = Build-List -filename "input.txt"

    return $list

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

Invoke-Main
