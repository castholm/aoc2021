function Solve-Day14Part1 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $Current
    )
    begin {
        $polymer = $null
        $allRules = @{}
    }
    process {
        if ($null -eq $polymer) {
            $polymer = [System.Collections.ArrayList]::new($Current.ToCharArray())
        } elseif ($Current -cmatch '^([A-Z])([A-Z]) -> ([A-Z])$') {
            $a, $b, $c = [char[]]$Matches[1..3]
            $rules = $allRules[$a]
            if ($null -eq $rules) {
                $rules = @{}
                $allRules[$a] = $rules
            }
            $rules[$b] = $c
        }
    }
    end {
        for ($i = 0; $i -lt 10; $i++) {
            $next = [System.Collections.ArrayList]::new(2 * $polymer.Count)

            for ($j = 0; $j -lt $polymer.Count - 1; $j++) {
                $null = $next.Add($polymer[$j])
                $rules = $allRules[$polymer[$j]]
                if ($null -ne $rules) {
                    $charToInsert = $rules[$polymer[$j + 1]]
                    if ($null -ne $charToInsert) {
                        $null = $next.Add($charToInsert)
                    }
                }
            }
            $null = $next.Add($polymer[-1])

            $polymer = $next
        }

        $sortedCounts = $polymer | Group-Object | ForEach-Object { $_.Count } | Sort-Object -Descending

        $sortedCounts[0] - $sortedCounts[-1]
    }
}

function Solve-Day14Part2 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $Current
    )
    begin {
        $polymer = $null
        $allRules = @{}
    }
    process {
        if ($null -eq $polymer) {
            $polymer = [System.Collections.ArrayList]::new($Current.ToCharArray())
        } elseif ($Current -cmatch '^([A-Z])([A-Z]) -> ([A-Z])$') {
            $a, $b, $c = [char[]]$Matches[1..3]
            $rules = $allRules[$a]
            if ($null -eq $rules) {
                $rules = @{}
                $allRules[$a] = $rules
            }
            $rules[$b] = $c
        }
    }
    end {
        function Apply($first, $second) {
            foreach ($entry in $second.GetEnumerator()) {
                if ($null -eq $first[$entry.Name]) {
                    $first[$entry.Name] = [long]0
                }
                $first[$entry.Name] += $entry.Value
            }
        }

        $countsLookup = @{}
        function GetCounts($a, $b, $iterations) {
            $lookupKey = "$a$b$iterations"
            $counts = $countsLookup[$lookupKey]
            if ($null -ne $counts) {
                $counts
                return
            }

            $counts = @{}
            $countsLookup[$lookupKey] = $counts
            $rules = $allRules[$a]
            if ($iterations -gt 0 -and $null -ne $rules) {
                $c = $rules[$b]
                if ($null -ne $c) {
                    Apply $counts (GetCounts $a $c ($iterations - 1))
                    Apply $counts (GetCounts $c $b ($iterations - 1))
                }
            }
            if ($counts.Count -eq 0) {
                $counts[$a] = [long]1
            }

            $counts
        }

        $counts = @{ $polymer[-1] = [long]1 }
        for ($i = 0; $i -lt $polymer.Count - 1; $i++) {
            Apply $counts (GetCounts $polymer[$i] $polymer[$i + 1] 40)
        }
        $sortedCounts = $counts.Values | Sort-Object -Descending

        $sortedCounts[0] - $sortedCounts[-1]
    }
}
