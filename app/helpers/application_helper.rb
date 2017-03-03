module ApplicationHelper
  def timeago time
    return unless time
    time.strftime("%y-%m-%d %H:%M")
  end

  def sidebar_li(li_title, options={})
    content_tag :li do
      link_to("#", :'aria-haspopup' => true, :'aria-expanded' => false, :'data-toggle' => 'dropdown') do
        "<i class='pe pe-box2'></i> <span>#{li_title}</span> <span class='fa arrow'></span>".html_safe
      end + 
      content_tag(:ul, class: 'dropdown-menu') do
        yield
      end
    end
  end

  def sidebar_child_li(text, link, active_links=[])
    if active_links.present?
      klass = ""
      active_links.each do |active_link|
        klass = "active" and break if request.path =~ %r{#{URI.escape(active_link)}}
      end
    else
      klass = request.path =~ %r{#{URI.escape(link)}} ? "active" : ""
    end
    content_tag :li, class: klass do
      content_tag :span do
        link_to text, link
      end
    end
  end
end
