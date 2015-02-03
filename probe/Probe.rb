require 'open3'
class Probe

    def ping(addr)
        _, _, _, t = Open3.popen3 "ping", "-c", "1", addr
        t.value.success?
    end
end

p = Probe.new
puts p.ping "8.8.8.8"
puts p.ping "192.168.0.200"
