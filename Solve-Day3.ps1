function Solve-Day3Part1 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $Current
    )
    begin {
        $all = [System.Collections.Generic.List[string]]::new()
    }
    process {
        $all.Add($Current)
    }
    end {
        $size = $all[0].Length
        $ones = [int[]]::new($size)
        foreach ($current in $all) {
            for ($i = 0; $i -lt $size; $i++) {
                if ($current[$i] -eq "1") {
                    $ones[$i]++
                }
            }
        }

        $gamma = 0
        for ($i = 0; $i -lt $size; $i++) {
            if ($ones[$i] -ge $all.Count / 2) {
                $gamma = $gamma -bor (1 -shl ($size - 1 - $i))
            }
        }
        $epsilon = -bnot $gamma -band ((1 -shl $size) - 1)

        $gamma * $epsilon
    }
}

function Solve-Day3Part2 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $Current
    )
    begin {
        $all = [System.Collections.Generic.List[string]]::new()

        function Get-MostCommonBit($Sequence, $Position) {
            $ones = ($Sequence | Where-Object { $_[$Position] -eq "1" }).Count

            if ($ones -ge $Sequence.Count / 2) { "1" } else { "0" }
        }
    }
    process {
        $all.Add($Current)
    }
    end {
        $size = $all[0].Length

        $filtered = $all
        for ($i = 0; $filtered.Count -gt 1 -and $i -lt $size; $i++) {
            $mostCommon = Get-MostCommonBit $filtered $i
            $filtered = $filtered | Where-Object { $_[$i] -eq $mostCommon }
        }
        $generatorRating = [Convert]::ToInt32($filtered, 2)

        $filtered = $all
        for ($i = 0; $filtered.Count -gt 1 -and $i -lt $size; $i++) {
            $mostCommon = Get-MostCommonBit $filtered $i
            $filtered = $filtered | Where-Object { $_[$i] -ne $mostCommon }
        }
        $scrubberRating = [Convert]::ToInt32($filtered, 2)

        $generatorRating * $scrubberRating
    }
}
