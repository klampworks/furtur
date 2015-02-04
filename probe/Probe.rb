require 'open3'
class Probe

    def run_silent(*args)
        _, _, _, t = Open3.popen3 *args
        t.value.success?

    end

    def ping(addr)
        run_silent "ping", "-c", "1", addr
    end

    def host(name)
        run_silent "host-woods", name
    end
end

p = Probe.new
#puts p.ping "8.8.8.8"
#puts p.ping "192.168.0.200"

#puts p.host "google.com"
#puts p.host "192.168.0.200"
