module TravelWebsite
  module ApplicationHelper
    def flash_messages
      [:notice, :alert, :error].map do |msg_type|
        if flash[msg_type]
          content_tag :div, flash[msg_type], :class => "flash #{msg_type}"
        else
          ''
        end
      end.join("\n").html_safe
    end
    def cfg
      AppConfig.instance
    end
    def title
    end
    def add_object_js_link(name, form, method, partial, where)
      link_to_function name, %{
var new_object_id = new Date().getTime(); 
var html = $("#{generate_template(form, method, :partial => partial)}".replace(/NEW_RECORD/g, new_object_id)).hide();html.appendTo($("#{where}")).slideDown('slow')}
    end    
    def generate_html(form_builder, method, options = {})
      options[:object] ||= form_builder.object.class.reflect_on_association(method).klass.new
      options[:partial] ||= method.to_s.singularize
      options[:form_builder_local] ||= :f

      form_builder.fields_for(method, options[:object], :child_index => 'NEW_RECORD') do |f|
        render(:partial => options[:partial], :locals => { options[:form_builder_local] => f })
      end

    end
    def generate_template(form_builder, method, options = {})
      escape_javascript generate_html(form_builder, method, options)
    end
    def tour_full_name(tour)
      title = tour.description.title
      if tour.days == 1
        title += ' 1Day tour'
      else
        title += " #{tour.days} Days #{tour.days - 1} Nights"
      end
      title
    end
  end
end
