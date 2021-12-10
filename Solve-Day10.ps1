$Pairs = @{
    "(" = ")"
    "[" = "]"
    "{" = "}"
    "<" = ">"
}

function Solve-Day10Part1 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $Current
    )
    begin {
        $pointValues = @{
            ")" = 3
            "]" = 57
            "}" = 1197
            ">" = 25137
        }
        $score = 0
    }
    process {
        $stack = [System.Collections.Generic.Stack[string]]::new()
        foreach ($char in [string[]]$Current.ToCharArray()) {
            if ($char -in $Pairs.Keys) {
                $stack.Push($Pairs[$char])
            } elseif (-not ($stack.Count -gt 0 -and $char -eq $stack.Pop())) {
                $score += $pointValues[$char]

                break
            }
        }
    }
    end {
        $score
    }
}

function Solve-Day10Part2 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $Current
    )
    begin {
        $pointValues = @{
            ")" = 1
            "]" = 2
            "}" = 3
            ">" = 4
        }
        $scores = [System.Collections.Generic.List[long]]::new()
    }
    process {
        $stack = [System.Collections.Generic.Stack[string]]::new()
        $corrupted = $false
        foreach ($char in [string[]]$Current.ToCharArray()) {
            if ($char -in $Pairs.Keys) {
                $stack.Push($Pairs[$char])
            } elseif (-not ($stack.Count -gt 0 -and $char -eq $stack.Pop())) {
                $corrupted = $true

                break
            }
        }

        if (-not $corrupted) {
            $score = 0
            while ($stack.Count -gt 0) {
                $score *= 5
                $score += $pointValues[$stack.Pop()]
            }
            $scores.Add($score)
        }
    }
    end {
        ($scores | Sort-Object)[[Math]::Floor($scores.Count / 2)]
    }
}
