require './Wifi_iw'
require 'test/unit'

class Test_wifi_iw < Test::Unit::TestCase

    def read(fn)
        return File.open(fn, 'rb') { |f| f.read }
    end

    def parse_scan(f)
        wifi = Wifi_iw.new

        s = read f

        aps = wifi.parse_networks(s)

        require "./#{f}.rb"
        assert_equal(aps, $exp)
    end

    def test_scan1()
        parse_scan "private/iw_wlan0_scan1"
    end

    def test_scan2()
        parse_scan "private/iw_wlan0_scan2"
    end
end
