require 'cucumber/formatter/io'
require 'cucumber/formatter/console'

module Math::Array
  def sum
    self.inject(0){ |accum, i| accum + i }
  end

  def mean
    self.sum/self.length.to_f
  end

  def sample_variance
    m = self.mean
    sum = self.inject(0) { |accum, i| accum + (i - m) ** 2 }
    sum / (self.length).to_f
  end

  def standard_deviation
    return Math.sqrt(self.sample_variance)
  end
end

module Cucumber
  module Ast
    module Benchmark
      attr_accessor :started_at, :finished_at, :run_time
    end
  end
  module Formatter
    class Profiler 
      include Console
      include Io

      attr_reader :step_mother

      def initialize(step_mother, path_or_io, options)
        @step_mother, @io, @options, @durations = step_mother, ensure_io(path_or_io, "fuubar"), options, []
        @timed_features = {}
      end
      

      def after_features(features)
        @io.puts
        @io.puts
        print_summary(features)
      end


      def before_feature_element(feature_element)
        feature_element.extend Cucumber::Ast::Benchmark
        feature_element.started_at = Time.now
        @exception_raised = false
      end

      def after_feature_element(feature_element)
        feature_element.finished_at = Time.now
        feature_element.run_time = feature_element.finished_at - feature_element.started_at
        key = feature_element.feature.title
        if @timed_features.has_key? key
          @timed_features[key] = @timed_features[key] << feature_element
        else
          @timed_features[key] = [feature_element]
        end

        progress(:failed) if @exception_raised
        @exception_raised = false
      end

      def before_steps(*args)
        progress(:failed) if @exception_raised
        @exception_raised = false
      end

      def after_steps(*args)
        @exception_raised = false
      end

      def after_step_result(keyword, step_match, multiline_arg, status, exception, source_indent, background, file_colon_line)
        progress(status)
        @status = status
      end

      def before_outline_table(outline_table)
        @outline_table = outline_table
      end

      def after_outline_table(outline_table)
        @outline_table = nil
      end

      def table_cell_value(value, status)
        return unless @outline_table
        status ||= @status
        progress(status) unless table_header_cell?(status)
      end
      
      def exception(*args)
        @exception_raised = true
      end

      private

      SUB_SECOND_PREVISION = 5
      DEFAULT_PRECISION = 2

      def print_summary(features)
        @timed_features.each_key do |feature_name|
          print_report(@timed_features[feature_name], feature_name)
        end

        @io.puts
        @io.puts
        print_steps(:pending)
        print_steps(:failed)
        print_status(features, @options)
      end

      def print_report(feature_elements, feature_name)
        features_elements = feature_elements.sort_by do |e|
          e.run_time
        end.reverse

        times = feature_elements.map { |e| e.run_time }
        times.extend Math::Array
        mean = times.mean
        stddev = times.standard_deviation
        k = 2
        feature_elements.reject! { |e| (e.run_time < (mean + k * stddev)) || (stddev == 0) }

        @io.puts "\n\nFeature: #{bold magenta(feature_name)}"
        @io.puts "#{bold red(grouped_examples.size)} of #{bold green(times.size)} scenarios(s) were 2 or greater standard deviations above the mean"
        @io.puts cyan "#{"Mean execution time:"} #{format_time(mean)}"
        @io.puts cyan "#{"Standard Deviation:"} #{"%.5f" % stddev}"
        @io.puts red "WARNING: Slow mean execution time!" if mean > 3

        feature_elements.each_with_index do |example, i|
          @io.puts cyan("#{i+1}.\t#{format_time(example.run_time)}") + white(" \t#{example.title}")
        end
      end

      CHARS = {
        :passed     => '.',
        :failed     => 'F',
        :undefined  => 'U',
        :pending    => 'P',
        :skipped    => '-'
      }

      def progress(status)
        char = CHARS[status]
        @io.print(format_string(char, status))
        @io.flush
      end

      def table_header_cell?(status)
        status == :skipped_param
      end

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

      def color(text, color_code)
        "#{color_code}#{text}\e[0m"
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
