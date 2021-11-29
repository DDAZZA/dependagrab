module Dependagrab

  # For writing output in a human readable format in the terminal
  class ConsoleWriter

    def write!(result)
      puts ["SEVERITY".ljust(8), "PACKAGE".ljust(32), "SUMMARY"].join("\t")
      puts '-' * 120

      result.each do |line|
        attr = [
          line[:severity].ljust(8),
          "#{line[:package_name]} (#{line[:vulnerable_version_range]})".ljust(32),
          "#{line[:summary]} (#{line[:ghsa_id]})"
        ]
        puts(attr.join("\t"))
      end

      puts
      puts "Total: #{result.count}"
    end
  end
end
