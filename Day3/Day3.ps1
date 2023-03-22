function Get-BitWiseValue {
    param( [char]$str )
        $num = 31
        $strNum = (( $str -band $num ) + " " )
        if ($str -cmatch "[A-Z]") {
            $res = $strNum + 26
        } else {
            $res = $strNum
        }
    return $res
}

function Convert-BadgeList {
    param ( $list )

        $res = [System.Collections.ArrayList]::new()
        $arr = $list -split "\r\n"

        for ( $i = 0; $i -lt $arr.length; $i += 3 ) {
            $a = @("","","")
                if ($arr[0+$i]) {$a[0] = $arr[0+$i]}      
            if ($arr[1+$i]) {$a[1] = $arr[1+$i]} 
            if ($arr[2+$i]) {$a[2] = $arr[2+$i]} 
            $res.Add(
                    [System.Tuple]::Create($a[0],$a[1],$a[2])
                    ) | Out-Null
        }

    return $res

}

function Get-CommonBadgeLetter {
    param( $tuple )

        $chrArray = $tuple.item1.ToCharArray()

        foreach ($chr in $chrArray) {
            if (
                    $tuple.item2.contains($chr) -and 
                    $tuple.item3.contains($chr)
               ) {
                return $chr
            }
        }
}

function Convert-List {
    param ( $list )

        $res = [System.Collections.ArrayList]::new()
        $arr = $list -split "\r\n"

        foreach ($a in $arr) {
            $res.Add(
                    [System.Tuple]::Create(
                        $a.SubString(0,$a.length/2),
                        $a.SubString($a.length/2,$a.length/2)
                        )
                    ) | Out-Null
        }

    return $res

}

function Get-CommonLetter {
    param( $tuple )

        $chrArray = $tuple.item1.ToCharArray()

        foreach ($chr in $chrArray) {
            if ($tuple.item2.contains($chr)) {
                return $chr
            }
        }


}

function Get-SumOfPriorities {
    param (
            [string]$file
          )

        $list = Get-Content $file -Raw

        $listArray = Convert-List -list $list

        $commonLetters = @()
        foreach ($tuple in $listArray) {
            $commonLetters += Get-CommonLetter -tuple $tuple
        }

    $priorities = @()
        foreach ($letter in $commonLetters) {
            $priorities += Get-BitWiseValue -str $letter

        }

    foreach ($priority in $priorities) {
        $sum = $sum + $priority
    }

    Return $sum
}

function Get-SumOfBadgePriorities {
    param (
            [string]$file
          )

        $list = Get-Content $file -Raw

        $listArray = Convert-BadgeList -list $list

        $commonLetters = @()
        foreach ($tuple in $listArray) {
            $commonLetters += Get-CommonBadgeLetter -tuple $tuple
        }

    $priorities = @()
        foreach ($letter in $commonLetters) {
            $priorities += Get-BitWiseValue -str $letter

        }

    foreach ($priority in $priorities) {
        $sum = $sum + $priority
    }

    Return $sum
}   

function Invoke-Main {
    param (
            [string]$file
          )

        $partOne = Get-SumOfPriorities -file $file

        $partTwo = Get-SumOfBadgePriorities -file $file

        Write-Host "P1:$partOne | P2:$partTwo"
}

Invoke-Main -file "input.txt"
