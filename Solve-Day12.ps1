function Solve-Day12Part1 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $Current
    )
    begin {
        $nodes = @{}
    }
    process {
        $from, $to = $Current -split "-"
        $fromNode = $nodes[$from]
        if ($null -eq $fromNode) {
            $fromNode = @{
                IsBig       = $from -cmatch '^[A-Z]+$'
                Connections = [System.Collections.Generic.HashSet[string]]::new()
            }
            $nodes[$from] = $fromNode
        }
        $null = $fromNode.Connections.Add($to)
        $toNode = $nodes[$to]
        if ($null -eq $toNode) {
            $toNode = @{
                IsBig       = $to -cmatch '^[A-Z]+$'
                Connections = [System.Collections.Generic.HashSet[string]]::new()
            }
            $nodes[$to] = $toNode
        }
        $null = $toNode.Connections.Add($from)
    }
    end {
        $visited = [System.Collections.Generic.Stack[string]]::new()

        function VisitEach($currentName) {
            if ($currentName -ceq "end") {
                1
                return
            }
            $currentNode = $nodes[$currentName]
            if (-not $currentNode.IsBig -and $visited.Contains($currentName)) {
                0
                return
            }

            $count = 0
            $visited.Push($currentName)
            foreach ($nextName in $currentNode.Connections) {
                $count += VisitEach $nextName
            }
            $null = $visited.Pop()

            $count
        }

        VisitEach "start"
    }
}

function Solve-Day12Part2 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $Current
    )
    begin {
        $nodes = @{}
    }
    process {
        $from, $to = $Current -split "-"
        $fromNode = $nodes[$from]
        if ($null -eq $fromNode) {
            $fromNode = @{
                IsBig       = $from -cmatch '^[A-Z]+$'
                Connections = [System.Collections.Generic.HashSet[string]]::new()
            }
            $nodes[$from] = $fromNode
        }
        $null = $fromNode.Connections.Add($to)
        $toNode = $nodes[$to]
        if ($null -eq $toNode) {
            $toNode = @{
                IsBig       = $to -cmatch '^[A-Z]+$'
                Connections = [System.Collections.Generic.HashSet[string]]::new()
            }
            $nodes[$to] = $toNode
        }
        $null = $toNode.Connections.Add($from)
    }
    end {
        $visited = [System.Collections.Generic.Stack[string]]::new()
        $hasVisitedOneNodeTwice = $false

        function VisitEach($currentName) {
            if ($currentName -ceq "end") {
                1
                return
            }
            if ($visited.Count -gt 0 -and $currentName -ceq "start") {
                0
                return
            }
            $shouldUnsetHasVisitedOneNodeTwice = $false
            $currentNode = $nodes[$currentName]
            if (-not $currentNode.IsBig -and $visited.Contains($currentName)) {
                if (-not $hasVisitedOneNodeTwice) {
                    $hasVisitedOneNodeTwice = $true
                    $shouldUnsetHasVisitedOneNodeTwice = $true
                } else {
                    0
                    return
                }
            }

            $count = 0
            $visited.Push($currentName)
            foreach ($nextName in $currentNode.Connections) {
                $count += VisitEach $nextName
            }
            $null = $visited.Pop()

            if ($shouldUnsetHasVisitedOneNodeTwice -eq $true) {
                $hasVisitedOneNodeTwice = $false
            }

            $count
        }

        VisitEach "start"
    }
}
