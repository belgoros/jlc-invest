# encoding: utf-8
require_relative 'report'

class AccountReport < Prawn::Document
  include ActionView::Helpers::NumberHelper
  include Report

  def to_pdf(account)
    draw_borders
    write_title
    write_account_number(account)
    write_date
    write_client_box(account.client, { title: I18n.t('receipt.title'), title_pad: 20.mm })
    write_address_box(account.client)
    write_total(account)
    draw_data_table(account)
    write_signatures
    render
  end

  private
  def write_account_number(account)
    move_down 10.mm
    x_axe = bounds.left + 120.mm
    y_axe = cursor
    bounding_box([x_axe, y_axe], width: 25.mm) do
      pad(5) do
        text I18n.t('receipt.account_number'), align: :right
      end
    end
    x_axe += (25.mm + Report::FIELD_SPACE)
    bounding_box([x_axe, y_axe], width: (bounds.right - x_axe - Report::RIGHT_BORDER_SPACE)) do
      pad(5) do
        text account.acc_number, align: :right
        transparent(Report::TRANSPARENT_LEVEL) { stroke_bounds }
      end
    end
  end

  def write_date
    x_axe = bounds.left + 120.mm
    y_axe = cursor
    bounding_box([x_axe, y_axe], width: 25.mm) do
      pad(5) do
        text I18n.t('receipt.date'),  align: :right
      end
    end

    x_axe += (25.mm + Report::FIELD_SPACE)
    bounding_box([x_axe, y_axe], width: (bounds.right - x_axe - Report::RIGHT_BORDER_SPACE)) do
      pad(5) do
        text I18n.l(Date.today), align: :right
        transparent(Report::TRANSPARENT_LEVEL) { stroke_bounds }
      end
    end
  end

  def write_total(account)
    x_axe = bounds.left + 120.mm
    y_axe = cursor

    bounding_box([x_axe, y_axe], width: 25.mm) do
      pad(5) do
        text I18n.t('account_balance'),  align: :right
      end
    end

    x_axe += (25.mm + Report::FIELD_SPACE)
    bounding_box([x_axe, y_axe], width: (bounds.right - x_axe - Report::RIGHT_BORDER_SPACE)) do
      pad(5) do
        text number_to_currency(account.balance), align: :center, style: :bold
        transparent(Report::TRANSPARENT_LEVEL) { stroke_bounds }
      end
    end

  end

  def draw_data_table(account)
    x_axe = bounds.left + 10.mm
    table_data = []
    table_data << draw_table_header(I18n.t('activerecord.attributes.operation.value_date'),
                               I18n.t('activerecord.models.operation'),
                               I18n.t('activerecord.attributes.operation.sum'),
                               I18n.t('activerecord.attributes.operation.rate'),
                               I18n.t('activerecord.attributes.operation.close_date'),
                               I18n.t('activerecord.attributes.operation.duration'),
                               I18n.t('activerecord.attributes.operation.interests'),
                               I18n.t('activerecord.attributes.operation.withholding'),
                               I18n.t('activerecord.attributes.operation.total')
    )



    account.operations.each do |operation|
      table_data << [I18n.l(operation.value_date),operation.operation_type, number_to_currency(operation.sum),
                    (operation.rate.blank? ? '-' : number_to_percentage(operation.rate, precision: 2)),
                    (operation.close_date.blank? ? '-' : I18n.l(operation.close_date)),
                    (operation.duration.blank? ? '-' : operation.duration),
                    (operation.interests.blank? ? '-' : number_to_currency(operation.interests)),
                    (operation.withholding.blank? ? '-' : number_to_percentage(operation.withholding, precision: 2)),
                    (operation.total.blank? ? '-' : number_to_currency(operation.total))]

    end

    table(table_data,
          header: true,
          position: x_axe,
          cell_style: { padding: [10, 5, 10, 5] },
          width: (bounds.right - x_axe - Report::RIGHT_BORDER_SPACE)) do

      row(0).font_style = :bold
      row(0).size = 8
      row(0).align = :center
      rows(1..account.operations.size).size = 8
      rows(1..account.operations.size).columns(2..8).align = :right
    end
  end


end
