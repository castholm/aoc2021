function Solve-Day15Part1 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $Current
    )
    begin {
        $width = 0
        $height = 0
        $risks = [System.Collections.Generic.List[byte]]::new()
    }
    process {
        $width = $Current.Length
        $height++
        $risks.AddRange([byte[]][string[]]$Current.ToCharArray())
    }
    end {
        FoolsDijkstra $risks $width $height 10
    }
}

function Solve-Day15Part2 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $Current
    )
    begin {
        $width = 0
        $height = 0
        $risks = [System.Collections.Generic.List[byte]]::new()
    }
    process {
        $width = $Current.Length * 5
        $height++
        $bytes = [byte[]][string[]]$Current.ToCharArray()
        $risks.AddRange($bytes)
        $risks.AddRange([byte[]]($bytes | ForEach-Object { ($_) % 9 + 1 }))
        $risks.AddRange([byte[]]($bytes | ForEach-Object { ($_ + 1) % 9 + 1 }))
        $risks.AddRange([byte[]]($bytes | ForEach-Object { ($_ + 2) % 9 + 1 }))
        $risks.AddRange([byte[]]($bytes | ForEach-Object { ($_ + 3) % 9 + 1 }))
    }
    end {
        $risks.AddRange([byte[]]($risks[0..($width * $height - 1)] | ForEach-Object { ($_) % 9 + 1 }))
        $risks.AddRange([byte[]]($risks[0..($width * $height - 1)] | ForEach-Object { ($_ + 1) % 9 + 1 }))
        $risks.AddRange([byte[]]($risks[0..($width * $height - 1)] | ForEach-Object { ($_ + 2) % 9 + 1 }))
        $risks.AddRange([byte[]]($risks[0..($width * $height - 1)] | ForEach-Object { ($_ + 3) % 9 + 1 }))
        $height *= 5

        FoolsDijkstra $risks $width $height 10
    }
}

function FoolsDijkstra ($risks, $width, $height, $iterations) {
    $minRiskSums = [uint16[]][uint16]::MaxValue * $risks.Count
    $minRiskSums[0] = 0

    # This will not work out-of-the-box for all inputs. Increase the iteration count to improve the accuracy.
    for ($iteration = 0; $iteration -lt $iterations; $iteration++) {
        for ($y = 0; $y -lt $height; $y++) {
            for ($x = 0; $x -lt $width; $x++) {
                $i = $y * $width + $x
                $iSum = $minRiskSums[$i]
                if ($x -lt $width - 1) {
                    $j = $i + 1
                    $minRiskSums[$j] = [System.Math]::Min($minRiskSums[$j], $iSum + $risks[$j])
                }
                if ($y -lt $height - 1) {
                    $j = $i + $width
                    $minRiskSums[$j] = [System.Math]::Min($minRiskSums[$j], $iSum + $risks[$j])
                }
                if ($x -gt 0) {
                    $j = $i - 1
                    $minRiskSums[$j] = [System.Math]::Min($minRiskSums[$j], $iSum + $risks[$j])
                }
                if ($y -gt 0) {
                    $j = $i - $width
                    $minRiskSums[$j] = [System.Math]::Min($minRiskSums[$j], $iSum + $risks[$j])
                }
            }
        }
    }

    $minRiskSums[-1]
}
