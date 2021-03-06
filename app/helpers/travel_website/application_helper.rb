#encoding: utf-8
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
    def type_text
      TypeText.instance
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
      title = tour.description.local_title(locale)
      if tour.days == 1
        if locale == :zh
          title += '1日游'
        else
          title += ' 1Day tour'
        end
      else
        if locale == :zh
           title += "#{tour.days}天#{tour.days - 1}夜"
        else
           title += " #{tour.days} Days #{tour.days - 1} Nights"
        end
      end
      title
    end
    def credit_card_number(number)
      if number.length > 8
        [number.first(4), 'X' * (number.length - 8), number.last(4)].join('-')
      else
        number
      end
    end
    def small_link(label_text, to_url, options = {})
      icon = options[:icon]
      options.delete(:icon)
      lb = label_text
      lb = "<i class='#{icon}'></i> " + label_text if icon
      unless options[:class]
        options[:class] = 'small-link'
      end
      if options[:class] && options[:class].include?('disabled')
        options.delete(:onclick)
        options.delete(:remote)
        options.delete(:method)
        options.delete(:confirm)
        link_to(raw(lb), '#', options)
      else
        link_to( raw(lb), to_url, options)
      end
    end
  end
end
