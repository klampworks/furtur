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

    def test_host_valid_default()
        p = Probe.new
        assert(p.host("google.com"))
    end

    def test_host_valid_nondefault()
        p = Probe.new
        assert(p.host("google.com", "8.8.8.8"))
    end

    def test_host_invalid_default()
        p = Probe.new
        assert_equal(false, p.host("1"))
    end

    def test_host_invalid_nondefault()
        p = Probe.new
        assert_equal(false, p.host("google.com", "0"))
    end

    def test_http_google()
        p = Probe.new
        assert p.http_google
    end

    def test_http_wikipedia()
        p = Probe.new
        assert p.http_wikipedia
    end

    def test_tor_valid
        p = Probe.new
        assert (p.wget_tor "facebookcorewwwi.onion")[1]
    end

    def test_tor_invalid
        p = Probe.new

        # Cunts.
        assert_equal false, (p.wget_tor "forums.freebsd.org")[1]
    end

    def test_get_gw
        p = Probe.new
        assert_equal "192.168.100.1", p.get_gw
    end

    #def test_namify_cmd
    #    p = Probe.new
    #    assert_equal \
    #        'echo+bunnys+%3E%3E+%2Fvar%2Flib%2Fportage%2Fworld', 
    #        (p.namify_cmd "echo", "bunnys", ">>", "/var/lib/portage/world")
    #end
end
