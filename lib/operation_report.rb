# encoding: utf-8
class OperationReport < Prawn::Document  
  include ActionView::Helpers::NumberHelper 
  
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
  
  def to_pdf(operation)
    draw_borders
    2.times do
      write_title    
      write_receipt_and_date(operation) 
      write_account_number(operation)
      write_client_box(operation)
      write_address_box(operation)
      draw_data_table(operation)
      write_signatures
    end
    render
  end
  
  private
    
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
    
  def write_receipt_and_date(operation)
    move_down 10.mm    
    x_axe = bounds.left + 100.mm
    y_axe = cursor            
    bounding_box([x_axe, cursor], width: 20.mm ) do 
      pad(5) do        
        text I18n.t('receipt.receipt_nbr')                              
      end
    end      
    
    x_axe += (20.mm + FIELD_SPACE)
    bounding_box([x_axe, y_axe], width: 20.mm ) do 
      pad(5) do
        text operation.id.to_s, align: :center                  
        transparent(TRANSPARENT_LEVEL) { stroke_bounds }
      end
    end      
    
    x_axe += (20.mm + FIELD_SPACE)
    bounding_box([x_axe, y_axe], width: 15.mm ) do 
      pad(5) do
        text I18n.t('receipt.date'), align: :center                                
      end
    end      
    
    x_axe += (15.mm + FIELD_SPACE)
    bounding_box([x_axe, y_axe], width: 25.mm ) do 
      pad(5) do
        text I18n.l(operation.value_date), align: :center                  
        transparent(TRANSPARENT_LEVEL) { stroke_bounds }
      end
    end      
  end 
  
  def write_account_number(operation)    
    x_axe = bounds.left + 100.mm
    y_axe = cursor 
    bounding_box([x_axe, y_axe], width: 25.mm ) do 
      pad(5) do
        text I18n.t('receipt.account_number')
      end
    end  
    x_axe += (25.mm + FIELD_SPACE)
    bounding_box([x_axe, y_axe], width: 30.mm ) do 
      pad(5) do
        text operation.account.acc_number, align: :center                        
        transparent(TRANSPARENT_LEVEL) { stroke_bounds }
      end
    end  
  end
  
  def write_client_box(operation)    
    move_down 10.mm
    y_axe = cursor    
    x_axe = bounds.left + 10.mm
    bounding_box([x_axe, y_axe], width: 45.mm ) do 
      pad(5) do
        text I18n.t('receipt.issued_to')        
      end
    end  
    
    x_axe += (45.mm + FIELD_SPACE)
    bounding_box([x_axe, y_axe], width: (bounds.right - x_axe - RIGHT_BORDER_SPACE)) do
      pad(5) do
        text operation.account.client.full_name, indent_paragraphs: 10
        transparent(TRANSPARENT_LEVEL) { stroke_bounds }
      end
    end  
  end
  
  def write_address_box(operation)        
    y_axe = cursor    
    x_axe = bounds.left + 10.mm
    
    bounding_box([x_axe, y_axe], width: 20.mm ) do 
      pad(5) do
        text I18n.t('receipt.address')        
      end
    end  
    
    x_axe += (20.mm + FIELD_SPACE)
    x_address_line = x_axe
    bounding_box([x_axe, y_axe], width: 98.mm) do 
      pad(5) do
        text operation.account.client.street, indent_paragraphs: 10
        transparent(TRANSPARENT_LEVEL) { stroke_bounds }
      end
    end  
    
    x_axe += (98.mm + FIELD_SPACE)
    bounding_box([x_axe, y_axe], width: 10.mm) do 
      pad(5) do
        text I18n.t('receipt.house'), indent_paragraphs: 5        
      end
    end  
    
    x_axe += (10.mm + FIELD_SPACE)
    bounding_box([x_axe, y_axe], width: 15.mm) do 
      pad(5) do
        text operation.account.client.house, align: :center
        transparent(TRANSPARENT_LEVEL) { stroke_bounds }
      end
    end  
    
    x_axe += (15.mm + FIELD_SPACE)
    bounding_box([x_axe, y_axe], width: 10.mm) do 
      pad(5) do
        text I18n.t('receipt.box'), indent_paragraphs: 5        
      end
    end  
    
    x_axe += (10.mm + FIELD_SPACE)    
    bounding_box([x_axe, y_axe], width: (bounds.right - x_axe - RIGHT_BORDER_SPACE)) do
      pad(5) do
        text (operation.account.client.box.blank? ? ' ' : operation.account.client.box), align: :center 
        transparent(TRANSPARENT_LEVEL) { stroke_bounds }
      end
    end           
    
    y_axe -= 8.mm
    x_axe += (10.mm + FIELD_SPACE)    
    bounding_box([x_address_line, y_axe], width: (bounds.right - x_address_line - RIGHT_BORDER_SPACE)) do
      pad(5) do
        text operation.account.client.zip_city_country, indent_paragraphs: 10
        transparent(TRANSPARENT_LEVEL) { stroke_bounds }
      end
    end     
  end
  
  def draw_data_table(operation)    
    x_axe = bounds.left + 10.mm    
    header = []
    header << I18n.t('activerecord.models.operation')
    header << I18n.t('activerecord.attributes.operation.sum')
    header << I18n.t('activerecord.attributes.operation.rate')
    header << I18n.t('activerecord.attributes.operation.close_date')
    header << I18n.t('activerecord.attributes.operation.duration')
    header << I18n.t('activerecord.attributes.operation.interests')
    header << I18n.t('activerecord.attributes.operation.withholding')
    header << I18n.t('activerecord.attributes.operation.total')        
    
    data = [header,[operation.operation_type, number_to_currency(operation.sum), 
        operation.rate.blank? ? '-' : number_to_percentage(operation.rate, precision: 2), 
        operation.close_date.blank? ? '-' : I18n.l(operation.close_date), 
        operation.duration.blank? ? '-' : operation.duration, 
        operation.interests.blank? ? '-' : number_to_currency(operation.interests), 
        operation.withholding.blank? ? '-' : number_to_percentage(operation.withholding, precision: 2), 
        operation.total.blank? ? '-' : number_to_currency(operation.total)]]   
        
    table(data, :position => x_axe, :width => bounds.right - x_axe - RIGHT_BORDER_SPACE) do
      row(0).font_style = :bold
      row(0).size = 10
      row(0).align = :center
      row(1).columns(1..7).align = :center
      row(1).size = 10
    end    
  end
  
  def write_signatures     
    move_down 15.mm    
    x_axe = bounds.left + 15.mm
    draw_text I18n.t('receipt.client_signature'), at: [x_axe, cursor]
    x_axe += 120.mm
    draw_text I18n.t(:base_title), at: [x_axe, cursor]
    move_down 10.mm
    horizontal_line bounds.left + 10.mm, bounds.right - RIGHT_BORDER_SPACE, :at => cursor
  end
end
