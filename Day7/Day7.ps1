using namespace System.Collections.Generic

function Start-PartOne {
    [CmdletBinding()]
        param ([string]$fileName)

            $fileContent = (Get-Content $fileName) -split "`n"

            $fileSystem = [List[PSCustomObject]]::new()
            Add-Child -name "/" -type "d" -fileSystem ([ref]$fileSystem)

            foreach ($line in $fileContent) {

                switch -Regex ($line) {
# '\$\scd\s\/' {} # first line default
                    '\$\scd\s(?:\w|\/)' { 
                        Enter-Directory -name $(($_ -split " ")[2]) -fileSystem ([ref]$fileSystem.Children)
                    } # cd into a directory
                    '\$\scd\s\.\.' { Exit-Directory } # navigate up a directory
# '\$\sls' {Get-Message} # list contents
                        'dir\s\w' { Add-Child -name (($_ -split " ")[1]) -type "d" -filesystem ([ref]$fileSystem)} # add a sub directory
                        '\d' { Add-Child -name (($_ -split " ")[1]) -type "f" -size (($_ -split " ")[0]) -fileSystem ([ref]$fileSystem)} # add a file
                        default {} # default
                }

            }

    return $fileSystem

}

function Enter-Directory {
    param([string]$name,[ref]$fileSystem)
}

function Add-Child {
    param([string]$name,[string]$type,[int]$size,[ref]$fileSystem)

        $null = switch ($type) {
            "d" {
                $fileSystem.Value.Add(
                        [PSCustomObject]@{
                        Name = $name
                        Type = $type
                        Children = [List[PSCustomObject]]::new()
                        }
                        )
            }
            "f" {
                $fileSystem.Value.Add(
                        [PSCustomObject]@{
                        Name = $name
                        Type = $type
                        Size = $size
                        }
                        )
            }
        }

}

function Exit-Directory {
}
