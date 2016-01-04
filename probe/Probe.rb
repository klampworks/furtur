require 'open3'
require 'uri'

# Some webpages return unicode data through wget.
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

class Probe
    
    def namify_cmd *args
        URI::encode_www_form [(args.join ' ')]
    end

    def log name, contents
        File.open(name, 'w') { |file| file.write(contents) }
    end

    def log_if name, io
        t = io.read
        log name, t if not t.empty?
        t
    end

    def log_cmd o, e, *args
        name = namify_cmd *args
        return (log_if "#{name}.out", o),
            (log_if "#{name}.err", e)
    end

    def run_silent(*args)
        (run_stdout *args)[1]
    end

    def run_stdout(*args)
        Open3.popen3 *args do |i, o, e, t|
            return o.read, t.value.success?
       end
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
        run_stdout "wget", "-O", "-", addr
    end

    def wget_tor(addr)
        return "", false unless start_tor
        run_stdout "torify", "wget", "-O", "-", addr
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

    def get_gw
        (/default\W+(?<gw>[0-9\.]+)/.match (run_stdout "route").first)[:gw]
    end
        
    def crawl_gw
        run_silent "wget", "--mirror", get_gw
    end
end
