require "./reddit_bot.rb"

class LUHGDFbot < RedditBot
  def initialize(username, password, element, seenfile, commentfile)
    @seen_filename = seenfile
    @comment_file = commentfile
    @username = username
    @seen = get_seen_hash(seenfile)
    super(username, password, element)
  end

  def run
    results = @r.browse @reddit, :limit => 1000
    return unless results

    comment = get_comment
    $logger.info "Looking for comments, #{results.length} found!..."
    results.each do |r|
      next if @seen.include? r.id
      @seen[r.id] = true
      
      next unless r.title =~ /(((girl)|(boy))friend)|(wife)|(husband)/
      $logger.info "Commenting on #{r.id} [#{r.title}]..."

       sleep(60 * $config[wait]) if($config[wait])
       r.add_comment(comment)
    end
    $logger.info "Done!"

  ensure
    save
  end

  private

  def get_seen_hash(filename)
    h = Hash.new
    if filename and File.exists?(filename) and File.readable?(filename)
      File.open(filename, 'r').each_line do |line|
        h[line.chomp] = true
      end
    end

    return h
  end

  def save
    File.open(@seen_filename, 'w') do |f|
      f.write @seen.keys.join("\n")
    end
  end

  def get_comment
    @comment ||= File.read(@comment_file)
  end
end
