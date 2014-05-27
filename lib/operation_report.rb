# encoding: utf-8
require_relative 'report'

class OperationReport < Prawn::Document
  include ActionView::Helpers::NumberHelper
  include Report

  def to_pdf(operation)
    draw_borders
    2.times do
      write_title
      write_receipt_and_date(operation)
      write_account_number(operation.account)
      write_client_box(operation.account.client, title: I18n.t('receipt.issued_to'))
      write_address_box(operation.account.client)
      draw_data_table(operation)
      write_signatures
    end
    render
  end

  private

  def write_receipt_and_date(operation)
    move_down 10.mm
    x_axe = bounds.left + 100.mm
    y_axe = cursor
    bounding_box([x_axe, cursor], width: 20.mm ) do
      pad(5) do
        text I18n.t('receipt.receipt_nbr')
      end
    end

    x_axe += (20.mm + Report::FIELD_SPACE)
    bounding_box([x_axe, y_axe], width: 20.mm ) do
      pad(5) do
        text operation.id.to_s, align: :center
        transparent(Report::TRANSPARENT_LEVEL) { stroke_bounds }
      end
    end

    x_axe += (20.mm + Report::FIELD_SPACE)
    bounding_box([x_axe, y_axe], width: 15.mm ) do
      pad(5) do
        text I18n.t('receipt.date'), align: :center
      end
    end

    x_axe += (15.mm + Report::FIELD_SPACE)
    bounding_box([x_axe, y_axe], width: 25.mm ) do
      pad(5) do
        text I18n.l(operation.value_date), align: :center
        transparent(Report::TRANSPARENT_LEVEL) { stroke_bounds }
      end
    end
  end

  def draw_data_table(operation)
    x_axe = bounds.left + 10.mm
    header = draw_table_header(I18n.t('activerecord.models.operation'),
                               I18n.t('activerecord.attributes.operation.sum'),
                               I18n.t('activerecord.attributes.operation.rate'),
                               I18n.t('activerecord.attributes.operation.close_date'),
                               I18n.t('activerecord.attributes.operation.duration'),
                               I18n.t('activerecord.attributes.operation.interests'),
                               I18n.t('activerecord.attributes.operation.withholding'),
                               I18n.t('activerecord.attributes.operation.total')
    )

    data = [header, [operation.operation_type, number_to_currency(operation.sum),
        operation.rate.blank? ? '-' : number_to_percentage(operation.rate, precision: 2),
        operation.close_date.blank? ? '-' : I18n.l(operation.close_date),
        operation.duration.blank? ? '-' : operation.duration,
        operation.interests.blank? ? '-' : number_to_currency(operation.interests),
        operation.withholding.blank? ? '-' : number_to_percentage(operation.withholding, precision: 2),
        operation.total.blank? ? '-' : number_to_currency(operation.total)]]

    table(data,
          position: x_axe,
          width: (bounds.right - x_axe - Report::RIGHT_BORDER_SPACE)) do

      row(0).font_style = :bold
      row(0).size = 10
      row(0).align = :center
      row(1).columns(1..7).align = :center
      row(1).size = 10
    end
  end

end
