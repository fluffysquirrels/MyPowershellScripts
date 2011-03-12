# SSH Agent Functions
# Mark Embling (http://www.markembling.info/)
#
# How to use:
# - Place this file into %USERPROFILE%\Documents\WindowsPowershell (or location of choice)
# - Import into your profile.ps1:
#   e.g. ". (Resolve-Path ~/Documents/WindowsPowershell/ssh-agent-utils.ps1)" [without quotes]
# - Enjoy
#
# Note: ensure you have ssh and ssh-agent available on your path, from Git's Unix tools or Cygwin.

# Retrieve the current SSH agent PId (or zero). Can be used to determine if there
# is an agent already starting.
function Get-SshAgent() {
    $agentPid = [Environment]::GetEnvironmentVariable("SSH_AGENT_PID",  "User")
    if ([int]$agentPid -eq 0) {
        $agentPid = [Environment]::GetEnvironmentVariable("SSH_AGENT_PID", "Process")
    }
    
    if ([int]$agentPid -eq 0) {
        0
    } else {
        # Make sure the process is actually running
        $process = Get-Process -Id $agentPid -ErrorAction SilentlyContinue
		
        if(($process -eq $null) -or ($process.ProcessName -ne "ssh-agent")) {
            # It is not running (this is an error). Remove env vars and return 0 for no agent.
            [Environment]::SetEnvironmentVariable("SSH_AGENT_PID", $null, "Process")
            [Environment]::SetEnvironmentVariable("SSH_AGENT_PID", $null, "User")
            [Environment]::SetEnvironmentVariable("SSH_AUTH_SOCK", $null, "Process")
            [Environment]::SetEnvironmentVariable("SSH_AUTH_SOCK", $null, "User")
            0
        } else {
            # It is running. Return the PID.
            $agentPid
        }
    }
}

# Start the SSH agent.
function Start-SshAgent() {
    # Start the agent and gather its feedback info
    [string]$output = ssh-agent
    
    $lines = $output.Split(";")
    $agentPid = 0
    
    foreach ($line in $lines) {
        if (([string]$line).Trim() -match "(.+)=(.*)") {
            $envKey = $matches[1]
            $envValue = $matches[2]
            
            if($envKey -eq "SSH_AUTH_SOCK") {
                $envValue = $envValue.Replace("/tmp", (gc ENV:TEMP))
            }
            
            # Set environment variables for user and current process.            
            [Environment]::SetEnvironmentVariable($envKey, $envValue, "Process")
            [Environment]::SetEnvironmentVariable($envKey, $envValue, "User")
            
            if ($envKey -eq "SSH_AGENT_PID") {
                $agentPid = $envValue
            }
        }
	}
    
    # Show the agent's PID as expected.
    Write-Host "SSH agent PID:", $agentPid
}

# Stop a running SSH agent
function Stop-SshAgent() {
    Get-Process ssh-agent | %{$_.Kill()}
    
    # Remove all enviroment variables
    [Environment]::SetEnvironmentVariable("SSH_AGENT_PID", $null, "Process")
    [Environment]::SetEnvironmentVariable("SSH_AGENT_PID", $null, "User")
    [Environment]::SetEnvironmentVariable("SSH_AUTH_SOCK", $null, "Process")
    [Environment]::SetEnvironmentVariable("SSH_AUTH_SOCK", $null, "User")
}

# Add a key to the SSH agent
function Add-SshKey() {
    if ($args.Count -eq 0) {
        # Add the default key (~/id_rsa)
        ssh-add
    } else {
        foreach ($value in $args) {
            ssh-add $value
        }
    }
}

function Init-Ssh() {
    # ssh-agent.exe uses the environment variable 'HOME' to
    # find and load our default key. Set it.
    $env:HOME = (resolve-path ~)

    # Start the agent if not already running; provide feedback
    $agent = Get-SshAgent
    if ($agent -eq 0) {
        Write-Host "Starting SSH agent..."
        Start-SshAgent		# Start agent
        Add-SshKey			# Add my default key
    } else {
        Write-Host "SSH agent is running (PID $agent)"
    }
}