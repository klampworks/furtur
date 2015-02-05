require './Probe'
require 'test/unit'

class Test_probe < Test::Unit::TestCase

    def test_ping_valid()
        p = Probe.new
        assert(p.ping "8.8.8.8")
    end

    def test_ping_invalid()
        p = Probe.new
        assert_equal(false, p.ping("192.168.100.200"))
    end
end
