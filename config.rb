require './cmd/Cmd'

def cmd_exists? b
    Cmd.new.run_silent "which", b    
end

def any_cmd cs
    cs.each do |c| 
        return c if cmd_exists? c.first
    end

    ""
end

$host = any_cmd [["host-woods"], ["host"]]
$ping = any_cmd [["ping", "-c", "1"]]
$wget = any_cmd [["wget", "-O", "-"], ["curl"]]
$tor_wget = any_cmd [["torify"] + $wget ]
$crawl = any_cmd [["wget", "--mirror"]] 
$dhcp = any_cmd [["dhcpcd", "dhclient"]]
