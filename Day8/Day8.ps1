function Invoke-Main {

    $lineInput = Convert-InputToArray -filename "input.txt"

    return $lineInput

}

function Convert-InputToArray([string]$filename) {
    $lineInput = (Get-Content $filename) -split "`n"
    return $lineInput[1..($lineInput.count - 1)]
}

Invoke-Main