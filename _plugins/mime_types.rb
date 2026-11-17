# jekyll-serve (WEBrick) serves unrecognized extensions as text/plain, and its
# nosniff header makes browsers refuse to render them as images. Register the
# formats here so `jekyll serve` sends proper image content types.
require "webrick"

FORMATS = {
  "webp" => "image/webp",
  "avif" => "image/avif",
}.freeze

Jekyll::Hooks.register :site, :after_init do
  tables = []

  WEBrick::HTTPUtils.constants.each do |name|
    table = WEBrick::HTTPUtils.const_get(name, false)
    tables << table if table.is_a?(Hash) && table["png"].to_s.start_with?("image/")
  end

  if defined?(WEBrick::Config::FileHandler)
    table = WEBrick::Config::FileHandler[:MimeTypes]
    tables << table if table.is_a?(Hash)
  end

  if tables.empty?
    Jekyll.logger.warn "mime_types:", "no WEBrick mime table found; newer image formats may be served as text/plain"
    next
  end

  tables.each do |table|
    FORMATS.each { |extension, mime| table[extension] = mime }
  end
end

# Fallback: override the mime lookup itself, in case the FileHandler keeps its
# own private table that the hook above cannot reach.
if WEBrick::HTTPUtils.respond_to?(:mime_type, true)
  webrick_mime_type = WEBrick::HTTPUtils.method(:mime_type)

  WEBrick::HTTPUtils.define_singleton_method(:mime_type) do |filename, mime_table|
    extension = File.extname(filename).delete_prefix(".").downcase
    FORMATS[extension] || webrick_mime_type.call(filename, mime_table)
  end
end
