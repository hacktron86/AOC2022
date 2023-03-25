function Start-PartOne {
    [CmdletBinding()]
        param ([string]$fileName)

            $rawDataStream = (Get-Content $fileName).ToCharArray()

            $dataStream = [System.Collections.Generic.List[char]]::new()

            foreach ($char in $rawDataStream) {

                [void]$dataStream.Add($char)

            }

    $index = 0

        foreach ($char in $dataStream) {

            $chunk = [System.Collections.Generic.List[char]]::new()

                foreach ($i in $dataStream[$index..($index + 3)]) {

                    $chunk.Add($i)

                }

                $check = [System.Collections.Generic.List[bool]]::new()

                foreach ($item in $chunk) {

                    Write-Verbose "Item: $item`nChunk: $chunk`n"

                        if (($chunk | Where-Object { $_ -eq $item}).Count -gt 1) {
                            $check.Add($false)
                        } else {
                            $check.Add($true)
                        }
                    Write-Verbose "Check: $($check)"
                }

            if (($check | Where-Object { $_ -eq $true }).Count -eq 4) {

                return $index + 4

            }

            $index ++

        }

    return "Error not found"

}

function Test-Message {
    param([System.Collections.Generic.List[char]]$message)

    foreach ($char in $message) {
        
        $charCount = ($message | Where-Object { $_ -eq $char}).Count
        if ($charCount -gt 1) {
            return $false
        }

    }

    return $true

}

function Start-PartTwo {
    [CmdletBinding()]
        param ([string]$fileName)

            $rawDataStream = (Get-Content $fileName).ToCharArray()

            $dataStream = [System.Collections.Generic.List[char]]::new()

            foreach ($char in $rawDataStream) {

                [void]$dataStream.Add($char)

            }

    $index = 0
    $messageSize = 14

        foreach ($char in $dataStream) {

            $message = [System.Collections.Generic.List[char]]::new()

                foreach ($i in $dataStream[$index..($index + ($messageSize - 1))]) {

                    $message.Add($i)

                }

                $found = Test-Message -message $message

            if ($found) {

                return $index + $messageSize

            }

            $index ++

        }

    return "Error not found"

}
