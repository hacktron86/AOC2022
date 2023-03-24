# if a0 -le b0 -and a1 -ge b1 then 1
# if b0 -le a0 -and b1 -ge a1 then 1
# else 0



function Convert-List {
    param ( $file )

        Get-ChildItem $file | 
        Select-String -Pattern "((\d{1,2})-(\d{1,2})),((\d{1,2})-(\d{1,2}))" |
        ForEach-Object {
            $first, $second, $third, $fourth = $_.Matches[0].Groups[2,3,5,6].Value
                [PSCustomObject] @{
                    first = [int]$first
                        second = [int]$second
                        third = [int]$third
                        fourth = [int]$fourth
                }
        }
}

function Compare-Pairs {
    param ( $pair )


        if ( 
                ($pair.first -le $pair.third) -and
                ($pair.second -ge $pair.fourth)
           ){
            return 1
        }

    if ( 
            ($pair.third -le $pair.first) -and
            ($pair.fourth -ge $pair.second)
       ){
        return 1
    }

    return 0 

}

function Compare-OverLappingPairs {
    param ( $pair )

        for ( $x = $pair.first; $x -le $pair.second; $x++) {
            
            for ( $y = $pair.third; $y -le $pair.fourth; $y++) {

                if ( $x -eq $y ) {

                    return 1

                }

            }

        }

       return 0

}

function Get-SumOfContainedPairs {
    param ( $parsed )

        foreach ( $pair in $parsed ) {

            Compare-Pairs -pair $pair

        }
}

function Get-SumOfOverlappingPairs {
    param ( $parsed )

        foreach ( $pair in $parsed ) {
            Compare-OverLappingPairs -pair $pair
        }
}

function Get-AssignmentPairCount {
    param( $file )

        $parsed = Convert-List -file $file

        $res = Get-SumOfContainedPairs -parsed $parsed

        foreach ($r in $res) {
            $sum = $sum + $r 
        }

    return $sum
}

function Get-OverlapCount {
    param ( $file )

        $parsed = Convert-List -file $file

        $res = Get-SumOfOverlappingPairs -parsed $parsed

        foreach ($r in $res) {
            $sum = $sum + $r
        }

    return $sum
}

function Invoke-Main {
    param (
            [string]$file
          )

        $partOne = Get-AssignmentPairCount -file $file

        $partwo = Get-OverlapCount -file $file

        return "PartOne: $partOne | PartTwo: $partwo"
}

Invoke-Main -file "input.txt"
