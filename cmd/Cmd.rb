require 'open3'
require 'uri'

class Cmd
    def log_time
        Time.new.strftime "%Y-%m-%d_%H:%M:%S_"
    end

    def namify_cmd *args
        URI::encode_www_form [(args.join ' ')]
    end

    def log_name *args
        log_time + (namify_cmd *args)
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
        name = log_name *args
        return (log_if "#{name}.out", o),
            (log_if "#{name}.err", e)
    end

    def run_silent(*args)
        (run_stdout *args)[1]
    end

    def run_stdout(*args)
        Open3.popen3 *args do |i, o, e, t|
            return (log_cmd o, e, *args).first, t.value.success?
       end
    end
end
