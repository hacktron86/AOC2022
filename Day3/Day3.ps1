# bit operation for finding index in alphabet

function Get-BitWiseValue {
    param( [char]$str )
        $num = 31
        Write-Host (( $str -band $num ) + " " )
}

function Invoke-Main {
        Get-BitWiseValue -str "a"
}

Invoke-Main
