function Solve-Day4Part1 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $Current
    )
    begin {
        $numbers = $null
        $boards = [System.Collections.Generic.List[System.Collections.Generic.List[string]]]::new()
    }
    process {
        if ($numbers -eq $null) {
            $numbers = $Current -split ","
        } elseif ($Current -eq "") {
            $boards.Add([System.Collections.Generic.List[string]]::new())
        } else {
            $boards[-1].AddRange(-split $Current)
        }
    }
    end {
        foreach ($currentNumber in $numbers) {
            foreach ($board in $boards) {
                Mark-Board $board $currentNumber
                if (Test-Board $board) {
                    $score = ($board -ne "x" | Measure-Object -Sum).Sum

                    $score * $currentNumber

                    return
                }
            }
        }
    }
}

function Solve-Day4Part2 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $Current
    )
    begin {
        $numbers = $null
        $boards = [System.Collections.Generic.List[System.Collections.Generic.List[string]]]::new()
    }
    process {
        if ($numbers -eq $null) {
            $numbers = $Current -split ","
        } elseif ($Current -eq "") {
            $boards.Add([System.Collections.Generic.List[string]]::new())
        } else {
            $boards[-1].AddRange(-split $Current)
        }
    }
    end {
        foreach ($currentNumber in $numbers) {
            foreach ($board in $boards) {
                for ($i = 0; $i -lt 25; $i++) {
                    if ($board[$i] -eq $currentNumber) {
                        $board[$i] = "X"

                        break
                    }
                }
            }
            for ($i = 0; $i -lt $boards.Count; $i++) {
                $board = $boards[$i]
                Mark-Board $board $currentNumber
                if (Test-Board $board) {
                    $lastScore = ($board -ne "x" | Measure-Object -Sum).Sum
                    $lastWinningNumber = $currentNumber

                    $boards.RemoveAt($i)
                    $i--
                }
            }
        }

        $lastScore * $lastWinningNumber
    }
}

function Mark-Board($Board, $Number) {
    for ($i = 0; $i -lt 25; $i++) {
        if ($Board[$i] -eq $Number) {
            $Board[$i] = "x"

            return
        }
    }
}

function Test-Board($Board) {
    ($board[0, 1, 2, 3, 4] -eq "x").Count -eq 5 `
        -or ($board[5, 6, 7, 8, 9] -eq "x").Count -eq 5 `
        -or ($board[10, 11, 12, 13, 14] -eq "x").Count -eq 5 `
        -or ($board[15, 16, 17, 18, 19] -eq "x").Count -eq 5 `
        -or ($board[20, 21, 22, 23, 24] -eq "x").Count -eq 5 `
        -or ($board[0, 5, 10, 15, 20] -eq "x").Count -eq 5 `
        -or ($board[1, 6, 11, 16, 21] -eq "x").Count -eq 5 `
        -or ($board[2, 7, 12, 17, 22] -eq "x").Count -eq 5 `
        -or ($board[3, 8, 13, 18, 23] -eq "x").Count -eq 5 `
        -or ($board[4, 9, 14, 19, 24] -eq "x").Count -eq 5
}
