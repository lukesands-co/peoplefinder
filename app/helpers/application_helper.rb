module ApplicationHelper
  def body_class
    Rails.configuration.phase + " " + Rails.configuration.product_type
  end

  def last_update
    if current_object = @person || @group
      unless current_object.updated_at.blank?
        "Last updated: #{ current_object.updated_at.strftime('%d %b %Y') }."
      end
    end
  end

  def govspeak(source)
    options = { header_offset: 2 }
    doc = Govspeak::Document.new(source, options)
    doc.to_html.html_safe
  end

  def group_breadcrumbs(group)
    render partial: "shared/breadcrumbs", locals: { items: group.with_ancestry }
  end
end
