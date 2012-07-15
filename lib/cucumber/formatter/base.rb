module Cucumber
  module Formatter
    class Base
      SUB_SECOND_PREVISION = 5
      DEFAULT_PRECISION = 2
      
      def format_time(duration)
        if duration > 60
          minutes = duration.to_i / 60
          seconds = duration - minutes * 60
  
          red "#{minutes}m #{format_seconds(seconds)}s"
        elsif duration > 10
          red "#{format_seconds(duration)}s"
        elsif duration > 3
          yellow "#{format_seconds(duration)}s"
        else
          "#{format_seconds(duration)}s"
        end
      end
  
      def format_seconds(float)
        precision ||= (float < 1) ? SUB_SECOND_PRECISION : DEFAULT_PRECISION
        sprintf("%.#{precision}f", float)
      end
  
      protected
  
      def color(text, color_code)
        color_enabled? ? "#{color_code}#{text}\e[0m" : text
      end
  
      def bold(text)
        color(text, "\e[1m")
      end
  
      def red(text)
        color(text, "\e[31m")
      end
  
      def green(text)
        color(text, "\e[32m")
      end
  
      def yellow(text)
        color(text, "\e[33m")
      end
  
      def blue(text)
        color(text, "\e[34m")
      end
  
      def magenta(text)
        color(text, "\e[35m")
      end
  
      def cyan(text)
        color(text, "\e[36m")
      end
  
      def white(text)
        color(text, "\e[37m")
      end
      
    end
  end
end
