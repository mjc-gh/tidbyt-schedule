class TidbytApp
  def initialize(config, app)
    @config = config

    @path = app.fetch(:path)
    @name = app.fetch(:name)
    @every = app.fetch(:every, 15).to_i.minutes

    @install_id = name.tr('_', '')
  end

  def render
    system "pixlet render #{script_file}"

    @last_rendered = Time.current
  end

  def install
    system "pixlet push --installation-id #{@install_id} #{@config[:device_id]} #{webp_file}"

    @last_pushed = Time.current
  end

  def needs_update?
    @last_pushed.nil? || @last_pushed < (Time.current - @every)
  end

  attr_reader :name, :last_rendered, :last_pushed

  private

  def script_file
    File.join @path, "#{@name}.star"
  end

  def webp_file
    File.join @path, "#{@name}.webp"
  end
end
