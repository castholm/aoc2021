function Solve-Day2Part1 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $CurrentCommand
    )
    begin {
        $Position = 0
        $Depth = 0
    }
    process {
        $Instruction, $Argument = Parse-Command $CurrentCommand
        switch ($Instruction) {
        "forward" {
            $Position += $Argument
        }
        "down" {
            $Depth += $Argument
        }
        "up" {
            $Depth -= $Argument
        }
        }
    }
    end {
        $Position * $Depth
    }
}

function Solve-Day2Part2 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $CurrentCommand
    )
    begin {
        $Aim = 0
        $Position = 0
        $Depth = 0
    }
    process {
        $Instruction, $Argument = Parse-Command $CurrentCommand
        switch ($Instruction) {
        "down" {
            $Aim += $Argument
        }
        "up" {
            $Aim -= $Argument
        }
        "forward" {
            $Position += $Argument
            $Depth += $Aim * $Argument
        }
        }
    }
    end {
        $Position * $Depth
    }
}

function Parse-Command($Command) {
    $null = $CurrentCommand -cmatch '^(forward|down|up) ([0-9])$'

    $Matches[1], $Matches[2]
}
