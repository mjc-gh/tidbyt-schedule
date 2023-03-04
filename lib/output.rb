class Output
  include CommandLineReporter

  def initialize
    self.formatter = 'progress'
  end

  def run(apps)
    # Clear existing terminal output
    puts "\e[H\e[2J"

    # Build output report
    report do
      header title: 'Tidbyt Apps', width: 80, align: 'center', rule: true, color: 'green', bold: true, timestamp: true

      table border: true, width: 80 do
        row header: true, color: 'red' do
          column 'App Name', width: 30
          column 'Last Rendered', width: 20
          column 'Last Pushed', width: 20
        end

        apps.each do |app|
          row color: 'green' do
            column app.name
            column app.last_rendered.strftime "%I:%M%p %-m/%-d/%y"
            column app.last_pushed.strftime "%I:%M%p %-m/%-d/%y"
          end
        end
      end
    end
  end
end
