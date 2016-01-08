require './Wifi_base'
require '../cmd/Cmd'

class Wifi_iw < Wifi_base

    def initialize
        @cmd = Cmd.new
    end

    def connect()
        return true
    end

    def disconnect()
        return true
    end

    def scan dev
        @cmd.run_stdout "iw", dev, scan
    end

    def parse_networks(s)
        aps = Array.new
        i = -1

        s.each_line { |l|

            if m = /^BSS (?<bssid>[0-9a-f:]+)/.match(l) then
                i += 1
                aps[i] = Hash.new
                aps[i]['bssid'] = m.captures[0]
                aps[i]['enc'] = false
            end

            if m = /^\W*SSID: ([^\n]+)/.match(l) then
                aps[i]['essid'] = m.captures[0]
            end
                
            if /^\W*RSN:/.match(l) then
                aps[i]['enc'] = true
            end
        }

        return aps
    end
end 

