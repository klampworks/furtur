require 'open3'

# Some webpages return unicode data through wget.
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

class Probe

    def run_silent(*args)
        _, _, _, t = Open3.popen3 *args
        t.value.success?

    end

    def ping(addr)
        run_silent "ping", "-c", "1", addr
    end

    def host(name, server="")
        if server.empty?
            run_silent "host-woods", name
        else
            run_silent "host-woods", name, server
        end
    end

    def wget(addr)
        _, sout, _, t = Open3.popen3 "wget", "-O", "-", addr
        return sout.read, t.value.success?
    end

    def wget_tor(addr)
        return "", false unless start_tor
        _, sout, _, t = Open3.popen3 "torify", "wget", "-O", "-", addr
        return sout.read, t.value.success?
    end

    def http_google()
        html, ex = wget "google.com"
        return false unless ex
        not (html =~ /value="I'm Feeling Lucky"/).nil?
    end

    def http_wikipedia()
        
        html, ex = wget \
            'https://en.wikipedia.org/w/index.php?title=Furtur&oldid=568297460'
        return false unless ex
        not (html =~ /Furfur causes <a href="\/wiki\/Love" title="Love">love<\/a> between a man and a woman/).nil?
    end

    def tor_running?
        run_silent "ps -e | grep tor"
    end

    def wait(o, re, to)
        while 1
            begin
                result = o.read_nonblock 1000
                return true if result =~ re
            rescue IO::WaitReadable
                os = IO.select([o], [], [], to)
                return false unless os
                retry
            end
        end
    end

    def start_tor
        unless tor_running?
            File.write('/tmp/torrc', "SocksPort 9050\nLog info stderr\n")
            _, _, e = Open3.popen3("tor", "-f", "/tmp/torrc")
            wait e, /Bootstrapped 100%: Done/, 10
        end

        true
    end
end
