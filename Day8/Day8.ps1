using namespace System.Collections.Generic

function Invoke-Main
{

    [List[Int[]]]$list = Build-List -filename "testinput.txt"

    return $list

}

function Build-List([string]$filename)
{
    [OutputType([List[Int[]]])]

    $data = [List[int[]]]::new()

    $lineInput = (Get-Content $filename) -split "`n"

    foreach ($line in $lineInput)
    {

        $lineArray = $line.ToCharArray() | ForEach-Object { [convert]::ToInt32($_, 10) }

        $list.Add($lineArray)

    }

    return $list

}

Invoke-Main
