module LayoutHelper

  def title(string)
    content_for(:title, string)
  end

  def title_tag(*args)
    options = args.extract_options!
    content = @content_for_title || args.first
    content_tag(:title, [options[:prefix], strip_tags(content), options[:suffix]].compact.join)
  end

  def description(string)
    content_for(:description, string)
  end

  def description_tag(default='')
    content = @content_for_description || default
    tag(:meta, :name => 'description', :content => content) unless content.blank?
  end

  def keywords(string)
    content_for(:keywords, string)
  end

  def keywords_tag(default='')
    content = @content_for_keywords || default
    tag(:meta, :name => 'keywords', :content => content) unless content.blank?
  end

  def copyright(string)
    content_for(:copyright, string)
  end

  def copyright_tag(default='')
    content = @content_for_copyright || default
    tag(:meta, :name => 'copyright', :content => content) unless content.blank?
  end

end

