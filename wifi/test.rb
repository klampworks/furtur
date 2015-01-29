require './Wifi_iw'
require 'test/unit'

class Test_wifi_iw < Test::Unit::TestCase

    def read(fn)
        return File.open(fn, 'rb') { |f| f.read }
    end

    def test_yes()
        wifi = Wifi_iw.new

        s = File.open("private/iw_wlan0_scan1", 'rb') { |f| f.read }

        aps = wifi.parse_networks(s)

        require "./private/iw_wlan0_scan1.rb"
        assert_equal(aps, $exp)
    end
end
