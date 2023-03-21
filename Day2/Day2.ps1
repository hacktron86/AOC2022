function Get-Score {
    param($str)
        $res = switch ($str) {
            "A" {1}
            "B" {2}
            "C" {3}
            "X" {1}
            "Y" {2}
            "Z" {3}
        }
    return $res
}

function Get-Winner {
    param([Array]$arr)
        $them = Get-Score($arr[0])
        $me = Get-Score($arr[1])
        if ($them -eq $me) {
            return 3
        }
    if (
            ($them -eq 3 -and $me -eq 2) -or
            ($them -eq 2 -and $me -eq 1) -or
            ($them -eq 1 -and $me -eq 3)
       ) {
        return 0
    }
    return 6
}

function Get-RockPaperScissorsScore {
    param(
            $file
         )
        process {
            $match = [System.Collections.ArrayList]::new()
                $arr = $file -split "\r"
                foreach ($item in $arr) {
                    $subItem = $item -split " "
                        $match.Add($subItem) | Out-Null
                }
            $res = foreach ($round in $match) {
                $myChoice = Get-Score($round[1])
                    $result = Get-Winner($round)
                    $sum = $myChoice + $result
                    $sum
            }
            return $res | 
                Measure-Object -Sum | 
                Select-Object -ExpandProperty Sum

        }
}

Get-RockPaperScissorsScore -file (Get-Content "input.txt")
