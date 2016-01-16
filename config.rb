require './cmd/Cmd'

def which? b
    Cmd.new.run_silent "which", b    
end

$host = ["host-woods"]
$ping = ["ping", "-c", "1"]
$wget = ["wget", "-O", "-"]
$tor_wget = ["torify"] + $wget
$crawl = ["wget", "--mirror"]
$dhcp = ["dhclient"]

