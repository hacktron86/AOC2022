using namespace System.Collections.Generic

function Invoke-Main
{

    $data = [List[int[]]]::new()

    $list = Build-List -filename "testinput.txt" -list $data

    return $list

}

function Build-List([string]$filename,[List[Int[]]]$data)
{
    $lineInput = (Get-Content $filename) -split "`n"
    $rowCount = 0
    foreach ($line in $lineInput)
    {
        $lineArray = [int[]][string[]]$line.ToCharArray()
        $data.Add($lineArray)
        $rowCount++
    }
    return $data
}

Invoke-Main
