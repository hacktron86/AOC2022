using namespace System.Collections.Generic

function Start-PartOne {
    [CmdletBinding()]
        param ([string]$fileName)

            $fileContent = (Get-Content $fileName) -split "`n"

            $fileSystem = [List[PSCustomObject]]::new()

            $currentName = [List[char]]::new()

            $fileSystem.Add([PSCustomObject]@{Name="/";Type="d";Children=[List[PSCustomObject]]::new()})

            $currentNav = $fileSystem

            foreach ($line in $fileContent) {


                Write-Verbose $line

                    switch -Regex ($line) {
                        '\$\scd\s\/' { 
                            $currentName.Add(($_ -split " ")[2]) 
                        }
                        '\$\scd\s\w' { 
                            $currentName.Add(($_ -split " ")[2]) 
                                $currentNav = ($filesystem|Select-Object Children).Children | Where-Object { $_.Name -eq $currentName[-1]}
                        }
                        '\$\scd\s\.\.' { $currentName.Remove($currentName[-1]) } # navigate up a directory
                    'dir\s\w' { Add-Child -name (($_ -split " ")[1]) -type "d" -filesystem $currentNav } # add a sub directory
                    '\d' { Add-Child -name (($_ -split " ")[1]) -type "f" -size (($_ -split " ")[0]) -fileSystem $currentNav} # add a file
                    default {} # default
            }

    }

    return $fileSystem

}

function Enter-Directory {
    param([string]$name,[List[PSCustomObject]]$fileSystem)
}

function Add-Child {
    param([string]$name,[string]$type,[int]$size,[List[PSCustomObject]]$fileSystem)

        Write-Verbose $name
        Write-Verbose $name

        $fileSystemToEdit = ($fileSystem | Select-Object Children).Children
        $null = switch ($type) {
            "d" {
                $fileSystemToEdit.Add(
                        [PSCustomObject]@{
                        Name = $name
                        Type = $type
                        Children = [List[PSCustomObject]]::new()
                        }
                        )
            }
            "f" {
                $fileSystemToEdit.Add(
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

function Build-Directory {
    param([string]$line,[List[PSCustomObject]]$fileSystem)

        switch -Regex ($line) {
            '\$\scd\s(?:\w|\/)' { ($_ -split " ")[2] }
#     Build-Directory -fileSystem ($fileSystem | Where-Object { $_.Name -eq $(($_ -split " ")[2]) })
# } # cd into a directory
    '\$\scd\s\.\.' { Exit-Directory } # navigate up a directory
# '\$\sls' {Get-Message} # list contents
        'dir\s\w' { Add-Child -name (($_ -split " ")[1]) -type "d" -filesystem $fileSystem} # add a sub directory
        '\d' { Add-Child -name (($_ -split " ")[1]) -type "f" -size (($_ -split " ")[0]) -fileSystem $fileSystem} # add a file
        default {} # default
}

}
