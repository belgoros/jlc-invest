# encoding: utf-8
module Report
  COMPANY = 'J.L.C INVESTISSEMENT'
  STREET = 'Vieux Marché Aux Poteries, 5'
  ZIP = 'B-7500'
  CITY = 'Tournai'
  COUNTRY = 'BELGIQUE'
  PHONE = '+32-69-22.38.34'
  FAX = '+32-69-22.15.72'
  FIELD_SPACE = 2.mm
  RIGHT_BORDER_SPACE = 5.mm
  TRANSPARENT_LEVEL = 0.2

  def to_pdf(printable)

  end

  def draw_borders
    stroke do
      line(bounds.bottom_left, bounds.bottom_right)
      line(bounds.bottom_right, bounds.top_right)
      line(bounds.top_right, bounds.top_left)
      line(bounds.top_left, bounds.bottom_left)
    end
  end

  def write_title
    move_down 10.mm
    font_size(9) do
      text([COMPANY, STREET, ZIP, CITY, COUNTRY, PHONE, FAX].join(', '), align: :center)
    end
  end

  def write_account_number(account)
    x_axe = bounds.right - 55.mm
    y_axe = cursor

    bounding_box([x_axe, y_axe], width: 25.mm ) do
      pad(5) do
        text I18n.t('receipt.account_number')
      end
    end

    bounding_box([bounds.right - 84, y_axe], width: 25.mm ) do
      pad(5) do
        text account.acc_number, align: :right
        transparent(Report::TRANSPARENT_LEVEL) { stroke_bounds }
      end
    end
  end

  def write_client_box(client, opts = {})
    move_down 10.mm
    y_axe = cursor
    x_axe = bounds.left + 10.mm
    bounding_box([x_axe, y_axe], width: 45.mm ) do
      pad(5) do
        text opts[:title]    #I18n.t('receipt.title')
      end
    end
    title_pad = 45.mm
    title_pad = opts[:title_pad] if opts[:title_pad]
    x_axe += (title_pad + Report::FIELD_SPACE)
    bounding_box([x_axe, y_axe], width: (bounds.right - x_axe - Report::RIGHT_BORDER_SPACE)) do
      pad(5) do
        text client.full_name, indent_paragraphs: 10
        transparent(Report::TRANSPARENT_LEVEL) { stroke_bounds }
      end
    end
  end

  def write_address_box(client)
    y_axe = cursor
    x_axe = bounds.left + 10.mm

    bounding_box([x_axe, y_axe], width: 20.mm ) do
      pad(5) do
        text I18n.t('receipt.address')
      end
    end

    x_axe += (20.mm + Report::FIELD_SPACE)
    x_address_line = x_axe
    bounding_box([x_axe, y_axe], width: 98.mm) do
      pad(5) do
        text client.street, indent_paragraphs: 10
        transparent(Report::TRANSPARENT_LEVEL) { stroke_bounds }
      end
    end

    x_axe += (98.mm + Report::FIELD_SPACE)
    bounding_box([x_axe, y_axe], width: 10.mm) do
      pad(5) do
        text I18n.t('receipt.house'), indent_paragraphs: 5
      end
    end

    x_axe += (10.mm + Report::FIELD_SPACE)
    bounding_box([x_axe, y_axe], width: 15.mm) do
      pad(5) do
        text client.house, align: :center
        transparent(Report::TRANSPARENT_LEVEL) { stroke_bounds }
      end
    end

    x_axe += (15.mm + Report::FIELD_SPACE)
    bounding_box([x_axe, y_axe], width: 10.mm) do
      pad(5) do
        text I18n.t('receipt.box'), indent_paragraphs: 5
      end
    end

    x_axe += (10.mm + Report::FIELD_SPACE)
    bounding_box([x_axe, y_axe], width: (bounds.right - x_axe - Report::RIGHT_BORDER_SPACE)) do
      pad(5) do
        text (client.box.blank? ? ' ' : client.box), align: :center
        transparent(Report::TRANSPARENT_LEVEL) { stroke_bounds }
      end
    end

    y_axe -= 8.mm
    bounding_box([x_address_line, y_axe], width: (bounds.right - x_address_line - Report::RIGHT_BORDER_SPACE)) do
      pad(5) do
        text client.zip_city_country, indent_paragraphs: 10
        transparent(Report::TRANSPARENT_LEVEL) { stroke_bounds }
      end
    end
  end

  def draw_data_table(table_object)

  end

  def draw_table_header(*args)
    x_axe = bounds.left + 10.mm
    header = []
    args.each { |col| header << col}
    header
  end

  def write_signatures
    move_down 15.mm
    x_axe = bounds.left + 15.mm
    draw_text I18n.t('receipt.client_signature'), at: [x_axe, cursor]
    x_axe += 120.mm
    draw_text I18n.t(:base_title), at: [x_axe, cursor]
    move_down 10.mm
    horizontal_line bounds.left + 10.mm, bounds.right - Report::RIGHT_BORDER_SPACE, :at => cursor
  end

end