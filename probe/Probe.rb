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

    def http_google()
        html, ex = wget "google.com"
        return false unless ex
        not (html =~ /value="I'm Feeling Lucky"/).nil?
    end

    def http_wikipedia()
        
        html, ex = wget \
            'https://en.wikipedia.org/w/index.php?title=Furtur&oldid=568297460'
        puts html
        return false unless ex
        not (html =~ /Furfur causes <a href="\/wiki\/Love" title="Love">love<\/a> between a man and a woman/).nil?
    end
end
