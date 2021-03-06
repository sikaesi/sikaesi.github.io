require 'yaml'
require 'stringio'

begin

  files = Dir.glob("_drafts/*.md")
  
  files.each do | filename |
    sep_count = 0
    meta_str = ""
    body_str = ""
    prefix = ""
    p filename

    File.open(filename) do |file|
      file.each_line do |l|
        if l =~ /^---\n$/ 
          sep_count += 1
          next if sep_count <= 2
        end
        if l.start_with?("created_at: ")
          prefix = l.split(": ")[1][0,10]
        end 
        if sep_count <= 1
          meta_str += l
        else
          body_str += l
        end
      end
    end
    
    meta = YAML.load(meta_str)
    title = prefix + "-" + meta["title"]

    p title

    File.open("_posts/#{title}.md", "w") do |file|
      file.print(body_str)
    end

    File.unlink(filename)
  end

rescue
end
