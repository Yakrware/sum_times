module ApplicationHelper
  def render_flash
    content = ""
    content << %Q{<div class="alert alert-danger">#{flash[:error]}</div>} unless flash[:error].blank?
    content << %Q{<div class="alert alert-info">#{flash[:notice]}</div>} unless flash[:notice].blank?
    content << %Q{<div class="alert alert-warning">#{flash[:warning]}</div>} unless flash[:warning].blank?
    content << %Q{<div class="alert alert-warning">#{flash[:alert]}</div>} unless flash[:alert].blank?
    content << %Q{<div class="alert alert-success">#{flash[:success]}</div>} unless flash[:success].blank?
    unless flash[:errors].blank?
      content << "<div class=\"alert alert-danger\"><ul class=\"unstyled\">"
      flash[:errors].each do |e| 
        content << "<li>#{e}</li>"
      end
      content << "</ul></div>"
    end
    content.html_safe
  end
end
