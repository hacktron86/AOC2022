function Get-Score {
    param($str)
        $retr = switch ($str) {
            "A" {1}
            "B" {2}
            "C" {3}
            "X" {0}
            "Y" {3}
            "Z" {6}
        }
    return $retr
}

function Get-Winner {
    param(
            $tC, $rR
         )
        if ($rR -eq 3) {
            $ret = $tC
        }
    if ($rR -eq 6) {
        $ret = switch ($tC) {
            1 {2}
            2 {3}
            3 {1}
        }
    }
    if ($rR -eq 0) {
        $ret = switch ($tC) {
            1 {3}
            2 {1}
            3 {2}
        }
    }
    return $ret
}

function Get-RockPaperScissorsScoreB {
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
            $res = 0
                $res = foreach ($round in $match) {
                    $theirChoice = Get-Score -str $round[0]
                        $roundResult = Get-Score -str $round[1]
                        $myChoice = Get-Winner -tC $theirChoice -rR $roundResult
                        $sum = $myChoice + $roundResult
                        $sum
                }
            return $res | 
                Measure-Object -Sum | 
                Select-Object -ExpandProperty Sum

        }
}

Get-RockPaperScissorsScoreB -file (Get-Content "input.txt")
