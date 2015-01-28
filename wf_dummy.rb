

class Wifi_base

    def connect()
        return true
    end

    def disconnect()
        return true
    end

    def parse_networks(s)
        aps = Array.new
        i = -1

        s.each_line { |l|

            if m = /^BSS (?<bssid>[0-9a-f:]+)/.match(l) then
                i += 1
                aps[i] = Hash.new
                aps[i]['bssid'] = m.captures
                aps[i]['enc'] = false
            end

            if m = /^\W*SSID: ([^\n]+)/.match(l) then
                aps[i]['essid'] = m.captures
            end
                
            if /^\W*RSN:/.match(l) then
                aps[i]['enc'] = true
            end
        }

        return aps
    end
end 

wifi = Wifi_base.new

s = File.open("private/iw_wlan0_scan", 'rb') { |f| f.read }

aps = wifi.parse_networks(s)

aps.each do |ap|
    puts "#{ap['bssid']}\n\t#{ap['essid']}\n\t#{ap['enc']}"
end
