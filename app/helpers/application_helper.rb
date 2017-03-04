module ApplicationHelper
  def timeago time
    return unless time
    time.strftime("%y-%m-%d %H:%M")
  end

  def sidebar_li(li_title, options={})
    @active_sidebar_li = nil
    child_lis = capture do
      yield
    end

    content_tag :li, class: @active_sidebar_li do
      link_to("#", :'aria-haspopup' => true, :'aria-expanded' => true, :'data-toggle' => 'dropdown') do
        "<i class='pe pe-box2'></i> <span>#{li_title}</span> <span class='fa arrow'></span>".html_safe
      end + 
      content_tag(:ul) do
        child_lis
      end
    end
  end

  def sidebar_child_li(text, link, active_links=[])
    if active_links.present?
      klass = ""
      active_links.each do |active_link|
        klass = "-active" and break if request.path =~ %r{#{URI.escape(active_link)}}
      end
    else

      klass = request.path =~ %r{#{URI.escape(link)}} ? "-active" : ""
    end
    @active_sidebar_li ||= "active" if klass == "-active"
    content_tag :li, class: klass do
      link_to text, link
    end
  end
end
