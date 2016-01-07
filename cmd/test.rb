require './Cmd'
require 'test/unit'

class Test_cmd < Test::Unit::TestCase

    def test_namify_cmd
        c = Cmd.new
        assert_equal \
            'echo+bunnys+%3E%3E+%2Fvar%2Flib%2Fportage%2Fworld', 
            (c.namify_cmd "echo", "bunnys", ">>", "/var/lib/portage/world")
    end
end
